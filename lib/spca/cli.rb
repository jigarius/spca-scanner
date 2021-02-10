# frozen_string_literal: true

module SPCA
  class Cli < Thor
    # Thor, by default, exits with 0 no matter what.
    def self.exit_on_failure?
      true
    end

    desc 'scan', 'Scan the SPCA website for new pets.'
    option :email,
           type: :boolean,
           default: false,
           desc: 'Send an email notification.'
    option :category,
           type: :string,
           enum: Category.all.keys,
           default: Category.all.keys.first,
           desc: 'Pet category.'
    option :interval,
           type: :numeric,
           default: 0,
           desc: 'Keep watching every X minute(s).'
    option :verbose,
           aliases: ['v'],
           type: :boolean,
           default: false,
           desc: 'Show verbose output in terminal.'
    def scan
      scanner = SPCA::Scanner.new(
        cache: SPCA::Cache.new("#{SPCA::ROOT_PATH}/cache")
      )

      while true
        pets = scanner.execute(category: options.category)

        unless pets
          echo 'Read failed.'
          exit(1)
        end

        puts "#{pets.length} new item(s) found."

        return if pets.empty?

        send_puts(pets) if options.verbose
        send_mail(pets) if options.email

        break unless options.interval.positive?

        sleep options.interval * 60
      end
    end

    default_command :scan

    private

    def send_puts(pets)
      puts '======'

      pets.each do |item|
        puts "#{item.title} | #{item.info}"
        puts "#{item.uri}"
        puts '------'
      end
    end

    def send_mail(pets)
      unless pets.empty?
        mail = SPCA::Mail.new(pets)
        mail.deliver
      end
    end
  end
end
