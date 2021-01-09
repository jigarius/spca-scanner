# frozen_string_literal: true

require 'dotenv'
require 'pry'
require 'digest'
require 'mail'
require 'nokogiri'
require 'net/http'

require_relative '../lib/spca'
require_relative '../lib/spca/cache'
require_relative '../lib/spca/fetcher'
require_relative '../lib/spca/pet_card'
require_relative '../lib/spca/pet_list'
require_relative '../lib/spca/image'
require_relative '../lib/spca/mail'
require_relative '../lib/spca/scanner'

# Configuration
Pry.config.pager = false

ENV.merge! Dotenv.load("#{SPCA::ROOT_PATH}/.env")
