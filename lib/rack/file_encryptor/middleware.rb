# frozen_string_literal: true

module Rack
  class FileEncryptor
    class Middleware
      def initialize(app, **options)
        @app = app
        @options = options
      end

      def call(env)
        iv = find_iv(env['rack.input'])

        # Set our Tempfile factory
        env['rack.multipart.tempfile_factory'] = Rack::FileEncryptor.new(
          encryption_key: key,
          encryption_iv: iv == '' ? nil : iv
        )

        @app.call(env)
      end

      private

      def find_iv(input)
        found_iv = false
        iv = []
        input.each do |line|
          break if found_iv && line.match?(/^-+\w+/)

          iv << line if found_iv

          found_iv = true if line.match?(/^Content-Disposition: form-data; name="iv"\s*$/)
        end

        iv.join('').strip
      end

      def key
        @options[:key] || raise('Encryption key not found')
      end
    end
  end
end