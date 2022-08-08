# frozen_string_literal: true

module Miro
  class ImageLoader
    attr_reader :filepath

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

    def image_type
      @image_type ||= URI.parse(filepath).path.split(".").last
    end

    private

    def open_or_download_file
      if remote?
        download_file(filepath)
      else
        File.open(filepath)
      end
    end

    def download_file(url)
      remote_file_data = URI.parse(url).open.read
      tempfile = Tempfile.open(["source", ".#{image_type}"])
      tempfile.write(force_encoding? ? remote_file_data.force_encoding("UTF-8") : remote_file_data)
      tempfile.close
      tempfile
    end

    def force_encoding?
      Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new("1.9")
    end
  end
end
