# frozen_string_literal: true

require "shellwords"

module Miro
  class DominantColors
    def initialize(source_image_path, image_type = nil)
      image_loader = ImageLoader.new(source_image_path, image_type: image_type)
      @downsampler = Downsampler.donwnsample!(image_loader.file)
    end

    def method_missing(method_name, *args, &block)
      if downsampler.respond_to?(method_name)
        downsampler.send(method_name, *args, &block)
      else
        super
      end
    end

    private

    attr_reader :downsampler
  end
end
