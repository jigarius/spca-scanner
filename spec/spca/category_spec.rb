# frozen_string_literal: true

require 'spca/cache'

module SPCA
  describe Category do
    it '.all' do
      expectation = {
        'cats' => Category::CATS,
        'dogs' => Category::DOGS,
        'rabbits' => Category::RABBITS,
        'birds' => Category::BIRDS,
        'other' => Category::OTHER
      }

      expect(Category.all).to eq(expectation)
    end

    it '.from_id returns a category for valid ID' do
      expect(Category.from_id('cats')).to be(Category::CATS)
      expect(Category.from_id('dogs')).to be(Category::DOGS)
    end

    it '.from_id raises ArgumentError for invalid ID' do
      expect { Category.from_id('dragon') }
        .to raise_error(ArgumentError, 'Unrecognized ID: dragon')
    end
  end
end
