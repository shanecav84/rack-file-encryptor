# frozen_string_literal: true

require 'tempfile'

module Rack
  module FileEncryptor
    class UploadedFile
      def initialize(filename, cipher)
        @filename = filename
        @cipher = cipher
      end

      def <<(contents)
        tempfile << @cipher.update(contents) if !['', nil].include?(contents)
        tempfile << @cipher.final
      end

      def close
        tempfile.close
      end
      alias_method :close!, :close

      def method_missing(method_name, *args, &block)
        tempfile.__send__(method_name, *args, &block)
      end

      def original_filename
        @filename
      end

      def respond_to?(*args)
        super or tempfile.respond_to?(*args)
      end

      def tempfile
        @tempfile ||= begin
          original_extension = ::File.extname(@filename)
          ::Tempfile.new(["RackEncryptedFile-#{@filename}", "#{original_extension}.enc"])
        end
      end
    end
  end
end