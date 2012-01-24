require "miro/version"
require "oily_png"
require "cocaine"
require "tempfile"
require "open-uri"

require "miro/dominant_colors"

module Miro
  class << self
    def options
      @options ||= {
        :image_magick_path  => "/usr/bin/convert",
        :resolution         => "150x150",
        :color_count        => 8
      }
    end
  end
end
