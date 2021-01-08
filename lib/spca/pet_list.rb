# frozen_string_literal: true

require_relative 'image'

module SPCA
  class PetList

    # Create from Nokogiri::XML::Element for an SPCA list page.
    # E.g. HTML for a page containing a list of cats.
    def self.from_element(el)
      el.at_css('#page-main .section--grid')
        .search('.pet--card')
        .map do |item|
          PetCard.from_element(item)
        end
    end
  end
end
