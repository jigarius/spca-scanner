# frozen_string_literal: true

require_relative 'app/bootstrap'

scanner = SPCA::Scanner.new(
  cache: SPCA::Cache.new(SPCA::CACHE_PATH)
)

result = scanner.execute
unless result
  echo 'Read failed.'
  exit(1)
end

puts "#{result.length} new item(s) found."
puts '======'

result.each do |item|
  puts "#{item.title} | #{item.info}"
  puts "#{item.uri}"
  puts '------'
end

exit(0)
