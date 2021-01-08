# frozen_string_literal: true

require 'spca/scanner'

module SPCA
  describe Scanner do
    before(:each) do
      @cache = SPCA::Cache.new('/tmp')
      @cache.clear
      @fetcher = Fetcher.new(@cache)
      @scanner = Scanner.new(fetcher: @fetcher, cache: @cache)

      @response =
        File.read(SPCA::ROOT_PATH + '/spec/fixtures/list.html')
    end

    it '.execute returns an Array of PetCards' do
      expect(@fetcher)
        .to receive(:fetch)
        .with(Scanner::URI_CATS)
        .and_return(@response)

      result = @scanner.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to be(2)

      result.each do |item|
        expect(item).to be_a_kind_of(PetCard)
      end
    end

    it '.execute only returns items that are not in cache' do
      ryder = PetCard.new(
        title: 'Ryder',
        image: Image.new(uri: 'http://ryder.com/avatar.png'),
        info: 'Dog | GSD | Male',
        uri: 'http://ryder.com/about'
      )
      daisy = PetCard.new(
        title: 'Daisy',
        image: Image.new(uri: 'http://daisy.com/avatar.png'),
        info: 'Dog | Dalmatian | Female',
        uri: 'http://daisy.com/about'
      )

      expect(PetList)
        .to receive(:from_element).twice
        .and_return([ryder, daisy])

      expect(@scanner.execute).to eq([ryder, daisy])

      # Remove Ryder from cache, while Daisy stays.
      @cache.remove(ryder.hash)

      expect(@scanner.execute).to eq([ryder])
    end
  end
end
