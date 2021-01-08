# frozen_string_literal: true

require 'spca/fetcher'

module SPCA
  describe Fetcher do
    class MockNetHttpResponse
      attr_reader :body

      def initialize(body)
        @body = body
      end
    end

    before(:each) do
      @cache = Cache.new('/tmp')
      @fetcher = Fetcher.new(@cache)
      @uri = URI.parse('http://example.com/path/to/resource')
      @response = MockNetHttpResponse.new(
        '<html><title>Title</title><body>Hello world</body></html>'
      )
    end

    it '.fetch gets data with HTTP request when URI is not cached' do
      expect_any_instance_of(Net::HTTP)
        .to receive(:get)
        .with(@uri.request_uri)
        .and_return(@response)

      expect(@cache)
        .to receive(:set)
        .with("#{@uri.hash}.uri", @response.body)

      expect(@fetcher.fetch(@uri)).to eq(@response.body)
    end

    it '.fetch gets data from cache when URI is cached' do
      expect_any_instance_of(Net::HTTP)
        .not_to receive(:get)

      expect(@cache)
        .to receive(:get)
        .with("#{@uri.hash}.uri", Fetcher::CACHE_TTL)
        .and_return(@response.body)

      expect(@fetcher.fetch(@uri)).to eq(@response.body)
    end
  end
end
