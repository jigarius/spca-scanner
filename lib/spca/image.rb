# frozen_string_literal: true

module SPCA
  class Image
    attr_reader :uri

    def initialize(uri:)
      @uri = uri
    end
  end
end
