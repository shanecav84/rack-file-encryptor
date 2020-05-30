# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rack-file-encryptor'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Encrypt multipart file uploads'
  s.authors     = ['Shane Cavanaugh']
  s.email       = 'shane@shanecav.net'
  s.files       = ['README.md'] + Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/shanecav84/rack-file-encryptor'
  s.metadata    = { 'source_code_uri' => 'https://github.com/shanecav84/rack-file-encryptor' }
  s.require_paths = ['lib']

  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
end