# frozen_string_literal: true

require 'spca/cache'

describe SPCA do
  it '::ROOT_PATH' do
    expected = File.dirname(File.dirname(__FILE__))
    expect(SPCA::ROOT_PATH).to eq(expected)
  end
end
