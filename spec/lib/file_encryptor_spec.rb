# frozen_string_literal: true

require 'securerandom'
require 'spec_helper'


module Rack
  RSpec.describe FileEncryptor do
    include Rack::Test::Methods

    let(:encryption_key) { SecureRandom.hex(16) }
    let(:app) {
      ENV['ENCRYPTION_KEY'] = encryption_key
      Rack::Builder.parse_file('config.ru').first
    }

    it 'encrypts a multipart file' do
      unencrypted_contents = 'beepboop'
      uploaded_file = Tempfile.new('unencrypted')
      uploaded_file.write(unencrypted_contents)
      uploaded_file.rewind

      encrypted_file = Tempfile.new('encrypted')
      allow_any_instance_of(Rack::FileEncryptor::UploadedFile).
        to receive(:tempfile).
        and_return(encrypted_file)

      post '/', file: Rack::Test::UploadedFile.new(uploaded_file.path)

      Rack::Multipart.parse_multipart(last_request.env)

      encrypted_file.rewind
      encrypted_contents = encrypted_file.read

      decryption_cipher = OpenSSL::Cipher.new(Rack::FileEncryptor::DEFAULT_ALGORITHM)
      decryption_cipher.key = encryption_key
      decryption_cipher.update(encrypted_contents)

      expect(encrypted_contents).not_to eq(unencrypted_contents)
      expect(decryption_cipher.final).to eq(unencrypted_contents)
    end
  end
end