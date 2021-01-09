# frozen_string_literal: true

module SPCA
  class Mail
    # pets: PetList
    def initialize(pets)
      raise ArgumentError, 'Pets cannot be empty' if pets.empty?

      @pets = pets

      @mail = ::Mail.new
      build_from
      build_to
      build_subject
      build_body
      build_delivery_method
    end

    def deliver
      @mail.deliver
    end

    private

    def build_delivery_method
      options = {
        address: env('SMTP_HOST'),
        port: env('SMTP_PORT', 465),
        domain: env('SMTP_DOMAIN'),
        user_name: env('SMTP_USERNAME'),
        password: env('SMTP_PASSWORD'),
        authentication: :login,
        ssl: true,
        openssl_verify_mode: 'none'
      }
      @mail.delivery_method(:smtp, options)
    end

    def build_from
      @mail.from = @mail.reply_to = ENV.fetch('MAILER_FROM') do
        raise RuntimeError, 'MAILER_FROM env var is not set.'
      end
    end

    def build_to
      @mail.to = ENV.fetch('MAILER_TO') do
        raise RuntimeError, 'MAILER_TO env var is not set.'
      end.split(',')
    end

    def build_subject
      # TODO: Use local timezone.
      date = Time.now.strftime('%b %d, %Y')

      @mail.subject = "SPCA: #{@pets.length} new pets (#{date})"
    end

    def build_body
      @mail.content_type = 'text/html'
      @mail.charset = 'UTF-8'

      list =
        @pets.map do |p|
          <<~ITEM
            <div>
              <h2><a href="#{p.uri}">#{p.title}</a></h2>
              <p>#{p.info}</p>
              <div><img src="#{p.image.uri}" height="150" /></div>
              <hr />
            </div>
          ITEM
        end

      body =
        <<~BODY
          <div>
          <p>Here's a list of new pets that are available for adoption.</p>
          #{list.join}
          <p>If you like any of them, act now!</p>
          </div>
        BODY

      @mail.body = body.gsub(/\n/, '').gsub(/>\s+</, '><')
    end

    def env(key, default = nil)
      ENV.fetch(key) do
        raise RuntimeError, "ENV.#{key} must be defined." if default.nil?

        default
      end
    end
  end
end
