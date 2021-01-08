# frozen_string_literal: true

require 'net/http'
require 'nokogiri'

require_relative 'pet_list'
require_relative 'pet_card'

module SPCA
  class Scanner
    def execute
      list = get_list
    end

    private

    def get_list
      uri = URI.parse('https://www.spca.com/adoption/chats-en-adoption/')

      PetList.from_element(get_html(uri))
    end

    def get_html(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      data = http.get(uri.request_uri)

      html = data.body.gsub!(/[[:space:]]+/, ' ')

      # TODO: Handle non-200 response.

      Nokogiri::HTML.parse(html)
    end
  end
end
