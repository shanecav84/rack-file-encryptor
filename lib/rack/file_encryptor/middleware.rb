# frozen_string_literal: true

require 'openssl'
require 'rack/file_encryptor/uploaded_file'

module Rack
  module FileEncryptor
    class Middleware
      def initialize(app, **options)
        @app = app
        setup_cipher(options[:algorithm], options[:key])
      end

      def call(env)
        iv = find_iv(env['rack.input'])

        @cipher.iv = iv unless iv.nil? || iv == ''

        # Set our Tempfile factory
        env['rack.multipart.tempfile_factory'] = tempfile_factory

        @app.call(env)
      end

      private

      def tempfile_factory
        ->(filename, _content_type) { Rack::FileEncryptor::UploadedFile.new(filename, @cipher) }
      end

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

      def setup_cipher(algorithm, key)
        @cipher ||= begin
          cipher = OpenSSL::Cipher.new(algorithm || Rack::FileEncryptor::DEFAULT_ALGORITHM)
          cipher.encrypt
          cipher.key = key

          cipher
        end
      end
    end
  end
end