# frozen_string_literal: true

module SPCA
  class Scanner
    def initialize(cache:, fetcher: nil)
      @cache = cache
      @fetcher = fetcher || Fetcher.new(@cache)
    end

    def execute(category:)
      category = Category.from_id(category)

      response = @fetcher.fetch(category.uri)
      html = Nokogiri::HTML.parse(response)

      PetList.from_element(html).map do |item|
        next if @cache.exist? item.hash

        @cache.set item.hash, item
      end.compact
    end
  end
end
