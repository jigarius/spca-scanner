# frozen_string_literal: true

module SPCA
  class Scanner
    URI_CATS = URI.parse('https://www.spca.com/en/adoption/cats-for-adoption/')

    def initialize(cache:, fetcher: nil)
      @cache = cache
      @fetcher = fetcher || Fetcher.new(@cache)
    end

    def execute
      response = @fetcher.fetch(URI_CATS)
      html = Nokogiri::HTML.parse(response)

      PetList.from_element(html).map do |item|
        next if @cache.exist? item.hash

        @cache.set item.hash, item
      end.compact
    end
  end
end
