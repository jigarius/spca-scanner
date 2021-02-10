# frozen_string_literal: true

module SPCA
  describe PetCard do
    subject do
      PetCard.new(
        title: 'Ryder',
        image: Image.new(uri: 'http://ryder.com/avatar.png'),
        info: 'Dog | Baby | Male',
        uri: 'http://ryder.com/about'
      )
    end

    it '.title' do
      expect(subject.title).to eq('Ryder')
    end

    it '.image' do
      expected_image = Image.new(uri: 'http://ryder.com/avatar.png')
      expect(subject.image).to eq(expected_image)
    end

    it '.uri' do
      expect(subject.uri).to eq('http://ryder.com/about')
    end

    it '.info' do
      expect(subject.info).to eq('Dog | Baby | Male')
    end

    it '.== checks equality correctly' do
      o1 = PetCard.new(
        title: 'Ryder',
        image: Image.new(uri: 'http://ryder.com/avatar.png'),
        info: 'Dog | Baby | Male',
        uri: 'http://ryder.com/about'
      )
      expect(subject == o1).to be true

      o2 = PetCard.new(
        title: 'Daisy',
        image: Image.new(uri: 'http://ryder.com/avatar.png'),
        info: 'Dog | Adult | Male',
        uri: 'http://daisy.com/about'
      )

      expect(subject == o2).to be false
    end

    it '.create_from_element creates PetCard' do
      html = File.open("#{SPCA::ROOT_PATH}/spec/fixtures/list.html")
      el =
        Nokogiri::HTML
          .parse(html)
          .search('#page-main .pet--card')
          .first

      item = PetCard.from_element(el)

      expect(item.title).to eq('Twila')
      expect(item.uri)
        .to eq('https://www.spca.com/en/animal/twila-cat-46339884')
      expect(item.info).to eq('Cat ● Senior ● Male ● M')

      expected_image =
        Image.new(uri: './list_files/2001de94-346a-4a5e-86a8-2623509acceb.jpg')
      expect(item.image).to eq(expected_image)
    end
  end
end
