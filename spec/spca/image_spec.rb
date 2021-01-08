# frozen_string_literal: true

require 'spca/cache'

module SPCA
  describe Image do
    subject { Image.new(uri: 'http://example.com/image.png') }

    it '.uri' do
      expect(subject.uri).to be('http://example.com/image.png')
    end

    it '.== checks equality correctly' do
      o1 = Image.new(uri: 'http://example.com/image.png')
      expect(subject == o1).to be(true)

      o2 = Image.new(uri: 'http://example.com/image.jpg')
      expect(subject == o2).to be(false)
    end
  end
end
