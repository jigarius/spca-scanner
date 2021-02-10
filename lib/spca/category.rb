# frozen_string_literal: true

module SPCA
  class Category
    attr_reader :id, :uri

    def initialize(id:, uri:)
      @id = id
      @uri = uri
    end
    private_methods(:initialize)

    CATS = Category.new(
      id: 'cats',
      uri: URI.parse('https://www.spca.com/en/adoption/cats-for-adoption/')
    )
    DOGS = Category.new(
      id: 'dogs',
      uri: URI.parse('https://www.spca.com/en/adoption/dogs-for-adoption/')
    )
    RABBITS = Category.new(
      id: 'rabbits',
      uri: URI.parse('https://www.spca.com/en/adoption/rabbits-for-adoption/')
    )
    BIRDS = Category.new(
      id: 'birds',
      uri: URI.parse('https://www.spca.com/en/adoption/birds-for-adoption/')
    )
    OTHER = Category.new(
      id: 'other',
      uri: URI.parse('https://www.spca.com/en/adoption/small-animals-for-adoption/')
    )

    def self.all
      {
        CATS.id => CATS,
        DOGS.id => DOGS,
        RABBITS.id => RABBITS,
        BIRDS.id => BIRDS,
        OTHER.id => OTHER,
      }
    end

    def self.from_id(id)
      Category.all.each { |k, c| return c if k == id }

      raise ArgumentError, "Unrecognized ID: #{id}"
    end
  end
end
