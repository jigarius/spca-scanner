# frozen_string_literal: true

module SPCA
  class PetList
    SELECTOR = '#page-main .section--grid .pet--card'
    private_constant(:SELECTOR)

    # Create from Nokogiri::XML::Element for an SPCA list page.
    # E.g. HTML for a page containing a list of cats.
    def self.from_element(element)
      element.search(SELECTOR)
        .map do |item|
          PetCard.from_element(item)
        end
    end
  end
end
