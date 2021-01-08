# frozen_string_literal: true

module SPCA
  class Image
    attr_reader :uri

    def initialize(uri:)
      @uri = uri
    end

    def ==(other)
      Image === other &&
        @uri == other.uri
    end
  end
end
