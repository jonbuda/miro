# frozen_string_literal: true

module Miro
  module Downsampler
    class PixelGroup < Default
      def to_hex
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_hex(pixel, false) }
      end

      def to_rgb
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_truecolor_bytes(pixel) }
      end

      def to_rgba
        sorted_pixels.map { |pixel| ChunkyPNG::Color.to_truecolor_alpha_bytes(pixel) }
      end

      def by_percentage
        sorted_pixels.map { |pixel| grouped_pixels[pixel].size / pixel_count.to_f }
      end

      def histogram
        grouped_pixels.to_h { |pixel, group| [pixel, group.size] } 
      end

      def sorted_pixels
        @sorted_pixels ||= grouped_pixels.sort_by { |_k, v| v.size }.reverse.flatten.uniq
      end

      def grouped_pixels
        @grouped_pixels ||= pixels.group_by { |pixel| pixel }
      end

      def pixel_count
        @pixel_count ||= pixels.size
      end

      def pixels
        @pixels ||= ChunkyPNG::Image.from_file(downsampled_path).pixels
      end

      protected

      def run_convert_command
        Terrapin::CommandLine.new(
          Miro.configuration.image_magick_path,
          "':in[0]' -resize :resolution -colors :colors -colorspace :quantize -quantize :quantize :out"
        ).run(
          in: Shellwords.escape(source_path),
          resolution: Miro.configuration.resolution,
          colors: Miro.configuration.color_count.to_s,
          quantize: Miro.configuration.quantize,
          out: downsampled_path
        )
      end
    end
  end
end
