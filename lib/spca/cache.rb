# frozen_string_literal: true

module SPCA
  class Cache
    DEFAULT_TTL = 365 * 24 * 60 # 1 year
    EXTENSION = 'cache'

    attr_reader :path

    def initialize(path)
      @path = path
    end

    # ttl: TTL in minutes.
    def get(key, ttl = DEFAULT_TTL)
      path = storage_path(key)
      return unless exist? key, ttl

      unserialize(File.read(path))
    end

    def set(key, data)
      path = storage_path(key)
      File.write(path, serialize(data))

      data
    end

    def remove(key)
      path = storage_path(key)
      File.unlink(path) if File.exist?(path)
    end

    def exist?(key, ttl = DEFAULT_TTL)
      path = storage_path(key)
      return false unless File.exist? path

      age = (Time.now - File.stat(path).mtime) / 60
      age < ttl
    end

    def clear
      Dir.glob("#{@path}/*.#{EXTENSION}").each do |file|
        File.unlink(file)
      end
    end

    private

    def serialize(object)
      Marshal.dump(object)
    end

    def unserialize(string)
      Marshal.load(string)
    end

    def storage_path(key)
      "#{@path}/#{key}.#{EXTENSION}"
    end
  end
end
