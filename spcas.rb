# frozen_string_literal: true

require_relative 'app/bootstrap'

cache = SPCA::Cache.new(SPCA::CACHE_PATH)
scanner = SPCA::Scanner.new(cache: cache)
result = scanner.execute

unless result
  echo 'Read failed.'
  exit(1)
end

# Send email notification.
unless result.empty?
  mail = SPCA::Mail.new(result)
  mail.deliver
end

# Display output.
puts "#{result.length} new item(s) found."
puts '======'

result.each do |item|
  puts "#{item.title} | #{item.info}"
  puts "#{item.uri}"
  puts '------'
end

exit(0)
