# frozen_string_literal: true

require 'bundler'
require 'digest'
require 'net/http'

Bundler.require(:default, :development)

require_relative '../lib/spca'

# Configuration
Pry.config.pager = false

ENV.merge! Dotenv.load("#{SPCA::ROOT_PATH}/.env")
