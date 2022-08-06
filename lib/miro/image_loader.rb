# frozen_string_literal: true

module Miro
  class ImageLoader
    attr_reader :source_path

    def initialize(filepath, image_type: nil)
      @filepath = filepath
      @image_type = image_type
    end

    def file
      @file ||= open_or_download_file
    end

    def close!
      file.close! if remote?
    end

    private

    attr_reader :image_type

    def open_or_download_file
      return File.open(filepath) unless remote?

      original_extension = image_type || URI.parse(filepath).path.split(".").last

      tempfile = Tempfile.open(["source", ".#{original_extension}"])
      remote_file_data = open(filepath).read

      tempfile.write(force_encoding? ? remote_file_data.force_encoding("UTF-8") : remote_file_data)
      tempfile.close
      tempfile
    end

    def remote?
      filepath.start_with?("http")
    end

    def force_encoding?
      Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new("1.9")
    end
  end
end
