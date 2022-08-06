# frozen_string_literal: true

module Miro
  class Configuration
    attr_accessor :image_magick_path, :resolution, :color_count, :quantize, :method

    def initialize
      convert = `which convert`.strip
      @image_magick_path = convert.length.positive? ? convert : "/usr/bin/convert"
      @resolution = "150x150"
      @color_count = 8
      @quantize = "RGB"
      @method = "pixel_group"
    end

    def pixel_group?
      method == "pixel_group"
    end

    def histogram?
      method == "histogram"
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def pixel_group?
      configuration.pixel_group?
    end

    def histogram?
      configuration.histogram?
    end
  end

  def self.configure
    yield(configuration)
  end
end
