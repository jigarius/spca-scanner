# frozen_string_literal: true

require 'spca/cache'

describe SPCA do
  it '::ROOT_PATH' do
    expected = File.dirname(File.dirname(__FILE__))
    expect(SPCA::ROOT_PATH).to eq(expected)
  end

  it '::CACHE_PATH' do
    expect(SPCA::CACHE_PATH).to eq(SPCA::ROOT_PATH + '/cache')
  end
end
