# frozen_string_literal: true

require 'bundler'
require 'digest'
require 'net/http'

Bundler.require(:default, :development)

require_relative '../lib/spca'
require_relative '../lib/spca/cache'
require_relative '../lib/spca/fetcher'
require_relative '../lib/spca/category'
require_relative '../lib/spca/pet_card'
require_relative '../lib/spca/pet_list'
require_relative '../lib/spca/image'
require_relative '../lib/spca/mail'
require_relative '../lib/spca/scanner'
require_relative '../lib/spca/cli'

# Configuration
Pry.config.pager = false

ENV.merge! Dotenv.load("#{SPCA::ROOT_PATH}/.env")
