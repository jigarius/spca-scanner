# frozen_string_literal: true

module SPCA
  class Fetcher
    CACHE_TTL = 15

    def initialize(cache)
      @cache = cache
    end

    def fetch(uri)
      key = "#{uri.hash}.uri"
      html = @cache.get(key, CACHE_TTL)

      unless html
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        data = http.get(uri.request_uri)

        # TODO: Handle non-200 response.

        html = data.body.gsub(/[[:space:]]+/, ' ')
        @cache.set key, html
      end

      html
    end
  end
end
