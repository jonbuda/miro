# frozen_string_literal: true

module Miro
  class ImageLoader
    attr_reader :filepath, :image_type

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

    def remote?
      filepath.start_with?("http")
    end

    private

    def open_or_download_file
      return File.open(filepath) unless remote?

      original_extension = image_type || URI.parse(filepath).path.split(".").last

      tempfile = Tempfile.open(["source", ".#{original_extension}"])
      remote_file_data = URI.parse(filepath).open.read

      tempfile.write(force_encoding? ? remote_file_data.force_encoding("UTF-8") : remote_file_data)
      tempfile.close
      tempfile
    end

    def force_encoding?
      Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new("1.9")
    end
  end
end
