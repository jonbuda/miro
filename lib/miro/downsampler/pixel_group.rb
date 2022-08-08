# frozen_string_literal: true

module Miro
  module Downsampler
    class PixelGroup < Default
      def by_percentage
        sorted_pixels.map { |pixel| grouped_pixels[pixel].size / pixel_count.to_f }
      end

      def sorted_pixels
        @sorted_pixels ||= grouped_pixels.sort_by { |_k, v| v.size }.reverse.flatten.uniq
      end

      def histogram
        @histogram ||= grouped_pixels.transform_values(&:size)
      end

      def grouped_pixels
        @grouped_pixels ||= pixels.group_by { |pixel| pixel }
      end

      def pixel_count
        @pixel_count ||= pixels.size
      end

      def pixels
        return @pixels if defined?(@pixels)

        @pixels = ChunkyPNG::Image.from_file(downsampled_path).pixels
        close_downsampled!
        @pixels
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
