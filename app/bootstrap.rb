# frozen_string_literal: true

require 'pry'
require 'json'
require 'nokogiri'
require 'net/http'

require_relative '../lib/spca'
require_relative '../lib/spca/cache'
require_relative '../lib/spca/fetcher'
require_relative '../lib/spca/pet_card'
require_relative '../lib/spca/pet_list'
require_relative '../lib/spca/image'

# Configuration
Pry.config.pager = false
