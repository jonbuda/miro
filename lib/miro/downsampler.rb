# frozen_string_literal: true

require_relative "downsampler/default"
require_relative "downsampler/histogram"
require_relative "downsampler/pixel_group"

module Miro
  module Downsampler
    def self.build(tempfile)
      case Miro.configuration.method
      when :pixel_group
        PixelGroup
      when :histogram
        Histogram
      else
        raise ArgumentError, "Unknown method: #{Miro.configuration.method}"
      end.new(tempfile)
    end

    def self.downsample!(tempfile)
      build(tempfile).tap(&:downsample!)
    end
  end
end
