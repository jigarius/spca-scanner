# frozen_string_literal: true

require_relative 'app/bootstrap'

scanner = SPCA::Scanner.new
result = scanner.execute

puts result.to_json
