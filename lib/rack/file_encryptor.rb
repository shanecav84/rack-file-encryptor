# frozen_string_literal: true

require 'rack/file_encryptor/middleware'

module Rack
  module FileEncryptor
    DEFAULT_ALGORITHM = 'aes-256-cbc'
  end
end