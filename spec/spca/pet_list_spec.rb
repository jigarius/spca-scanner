# frozen_string_literal: true

require 'spca/pet_list'

module SPCA
  describe PetList do
    SAMPLE_FILE = SPCA::ROOT_PATH + '/spec/fixtures/list.html'

    it '.from_element creates a PetList' do
      el = Nokogiri::HTML.parse(File.open(SAMPLE_FILE))
      list = PetList.from_element(el)

      expect(list).to be_a_kind_of(Array)
      expect(list.length).to be(2)
    end
  end
end
