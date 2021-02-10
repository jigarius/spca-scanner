# frozen_string_literal: true

module SPCA
  describe Mail do
    before :all do
      el = Nokogiri::HTML.parse(
        File.open(SPCA::ROOT_PATH + '/spec/fixtures/list.html')
      )
      @pets = PetList::from_element(el)

      @env = {
        MAILER_FROM: 'no-reply@example.com',
        MAILER_TO: 'john.doe@example.com,jenny.doe@example.com',
        SMTP_HOST: 'smtp.example.com',
        SMTP_PORT: '465',
        SMTP_DOMAIN: 'example.com',
        SMTP_USERNAME: 'smtp-user',
        SMTP_PASSWORD: 'smtp-pass'
      }

      ClimateControl.modify(@env) do
        @orig_mail = ::Mail.new
        @spca_mail = SPCA::Mail.new(@pets, mail: @orig_mail)
      end
    end

    it '.subject' do
      date = Time.now.localtime(SPCA::TIMEZONE).strftime('%b %d, %Y')
      expectation = "SPCA: 2 new pets (#{date})"

      expect(@orig_mail.subject).to eq(expectation)
    end

    it '.from' do
      expect(@orig_mail.from).to eq(['no-reply@example.com'])
    end

    it '.to' do
      expectation = ['john.doe@example.com', 'jenny.doe@example.com']
      expect(@orig_mail.to).to eq(expectation)
    end

    it '.body' do
      expectation = <<~BODY
      <div>
        <p>Here's a list of new pets that are available for adoption.</p>
        <div>
          <h2><a href="#{@pets[0].uri}">#{@pets[0].title}</a></h2>
          <p>#{@pets[0].info}</p>
          <div><img src="#{@pets[0].image.uri}" height="150" /></div>
          <hr />
        </div>
        <div>
          <h2><a href="#{@pets[1].uri}">#{@pets[1].title}</a></h2>
          <p>#{@pets[1].info}</p>
          <div><img src="#{@pets[1].image.uri}" height="150" /></div>
          <hr />
        </div>
        <p>If you like any of them, act now!</p>
        </div>
      BODY
      expectation = expectation.gsub(/\n/, '').gsub(/>\s+</, '><')

      expect(@orig_mail.body.to_s).to eq(expectation)
    end

    it '.delivery_method' do
      method = @orig_mail.delivery_method

      expect(method).to be_kind_of(::Mail::SMTP)

      expect(method.settings[:address]).to eq(@env[:SMTP_HOST])
      expect(method.settings[:port]).to eq(@env[:SMTP_PORT])
      expect(method.settings[:domain]).to eq(@env[:SMTP_DOMAIN])
      expect(method.settings[:user_name]).to eq(@env[:SMTP_USERNAME])
      expect(method.settings[:password]).to eq(@env[:SMTP_PASSWORD])
    end

    it '.deliver' do
      allow(@orig_mail).to receive(:deliver).and_return(true)

      expect(@spca_mail.deliver).to be(true)
    end
  end
end
