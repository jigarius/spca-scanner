# frozen_string_literal: true

require 'spca/pet_list'

module SPCA
  describe PetList do
    it '.from_element creates a PetList' do
      el = Nokogiri::HTML.parse(
        File.open(SPCA::ROOT_PATH + '/spec/fixtures/list.html')
      )
      list = PetList.from_element(el)

      expect(list).to be_a_kind_of(Array)
      expect(list.length).to be(2)

      list.each do |item|
        expect(item).to be_a_kind_of(SPCA::PetCard)
      end
    end
  end
end
