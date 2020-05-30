# frozen_string_literal: true

require 'openssl'
require 'rack/file_encryptor/middleware'

module Rack
  class FileEncryptor
    def initialize(algorithm: 'aes-256-cbc', encryption_key: ENV['ENCRYPTION_KEY'], encryption_iv: nil)
      @cipher = setup_cipher(algorithm, encryption_key, encryption_iv)
    end

    def binmode
      @outfile.binmode
    end

    def call(filename, _content_type)
      @outfile = create_tempfile(filename)
      self
    end

    def close!
      @outfile.close
    end

    def <<(contents)
      @outfile << @cipher.update(contents)
      @outfile << @cipher.final
    end

    private

    def create_tempfile(filename)
      original_extension = ::File.extname(filename)
      ::Tempfile.new(["RackEncryptedFile-#{filename}", "#{original_extension}.enc"])
    end

    def setup_cipher(algorithm, key, iv)
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv if iv

      cipher
    end
  end
end