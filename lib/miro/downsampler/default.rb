# frozen_string_literal: true

module Miro
  module Downsampler
    class Default
      attr_reader :source, :downsampled

      def initialize(tempfile)
        @source = tempfile
        @downsampled = downsampled_tempfile
      end

      def downsample!
        @command_output = run_convert_command
      end

      def to_hex
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_hex(pixel, false) }
      end

      def to_rgb
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_truecolor_bytes(pixel) }
      end

      def to_rgba
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_truecolor_alpha_bytes(pixel) }
      end

      def sorted_pixels
        raise NotImplementedError, "You must implement #sorted_pixels in a subclass"
      end

      protected

      def close_downsampled!
        downsampled.close!
      end

      def source_path
        File.expand_path(source.path)
      end

      def downsampled_path
        File.expand_path(downsampled.path)
      end

      def run_convert_command
        raise NotImplementedError, "Subclasses must implement #image_magick_params"
      end

      def downsampled_tempfile
        tempfile = Tempfile.open([SecureRandom.uuid, ".png"])
        tempfile.binmode
        tempfile
      end
    end
  end
end
