# frozen_string_literal: true

module SPCA
  class PetCard
    attr_reader :title, :uri, :image, :info

    def initialize(
      title:,
      uri:,
      image:,
      info:
    )
      @title = title
      @uri = uri
      @image = image
      @info = info
    end

    def hash
      Digest::MD5.hexdigest(Marshal.dump(self))
    end

    def ==(other)
      PetCard === other &&
        @title == other.title &&
        @image == other.image &&
        @uri == other.uri &&
        @info == other.info
    end

    # Create from Nokogiri::XML::Element for .pet--card.
    def self.from_element(el)
      title = el.at_css('.card--title').content.strip
      uri = el.at_css('.card--link').attributes['href'].value
      info = el.at_css('.pet--infos').content.strip

      image = Image.new(
        uri: el.at_css('img').attributes['src'].value
      )

      new(
        title: title,
        uri: uri,
        image: image,
        info: info
      )
    end
  end
end
