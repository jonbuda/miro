require "miro/version"
require "oily_png"
require "tempfile"
require "open-uri"

module Miro
  class << self
    def options
      @options ||= {
        :image_magick_path  => "/usr/bin/convert",
        :color_count        => 8
      }
    end
  end
end
