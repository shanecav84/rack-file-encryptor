# rack-file-encryptor

Encrypt multipart file uploads.

By default, Rack will cache multipart file uploads on disk. rack-file-encryptor encrypts
multipart file uploads before saving them to disk.

## Usage

```ruby
# config.ru

options = { 
  algorithm: 'aes-256-cbc', # Defaults to 'aes-256-cbc'
  key: File.open('key.txt').read # Defaults to `ENV['ENCRYPTION_KEY']` 
}

app = Rack::Builder.new do
  use Rack::FileEncryptor::Middleware, **options
end


run app
```

You can pass an initialization vector (IV) in the multipart body using the `iv` field name:

`HTTP.post('localhost:3000', form: { _rack_file_encryptor: [{ iv: '', file: File.open }] })`


## Limitations

* Not currently able to use separate IVs to encrypt separate files 