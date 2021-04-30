# frozen_string_literal: true

require_relative 'spca/cache'
require_relative 'spca/fetcher'
require_relative 'spca/category'
require_relative 'spca/pet_card'
require_relative 'spca/pet_list'
require_relative 'spca/image'
require_relative 'spca/mail'
require_relative 'spca/scanner'
require_relative 'spca/cli'

module SPCA
  ROOT_PATH = File.expand_path(File.dirname(File.dirname(__FILE__)))

  TIMEZONE = '-05:00'
end
