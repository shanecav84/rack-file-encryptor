# frozen_string_literal: true

require 'bundler/setup'
require 'rack'
require 'rack/file_encryptor'

use Rack::Lint
use Rack::FileEncryptor::Middleware, key: ENV.fetch('ENCRYPTION_KEY')
run ->(_env) { [200, {}, []] }