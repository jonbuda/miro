# frozen_string_literal: true

require "shellwords"

module Miro
  class DominantColors
    def initialize(source_image_path, image_type = nil)
      image_loader = ImageLoader.new(source_image_path, image_type: image_type)
      @downsampler = Downsampler.downsample!(image_loader.file)
    end

    def method_missing(method_name, *args, &block)
      if downsampler.respond_to?(method_name)
        downsampler.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      downsampler.respond_to?(method_name) || super
    end

    private

    attr_reader :downsampler
  end
end
