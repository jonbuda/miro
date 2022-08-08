# frozen_string_literal: true

module Miro
  module Downsampler
    class Histogram < Default
      def sorted_pixels
        @sorted_pixels ||= histogram.sort_by { |_pixel, count| count }.reverse.map(&:first)
      end

      def histogram
        @histogram ||= parse_result(@command_output)
      end

      protected

      def run_convert_command
        Terrapin::CommandLine.new(
          Miro.configuration.image_magick_path,
          "':in[0]' -resize :resolution -colors :colors -colorspace :quantize -quantize :quantize -format %c histogram:info:"
        ).run(
          in: Shellwords.escape(File.expand_path(source.path)),
          resolution: Miro.configuration.resolution,
          colors: Miro.configuration.color_count.to_s,
          quantize: Miro.configuration.quantize
        )
      end

      private

      def parse_result(hstring)
        return nil if hstring.nil?

        hstring.scan(/(\d*):.*#([0-9A-Fa-f]*)/).to_h do |match|
          [match[1].to_i(16), match[0].to_i]
        end
      end
    end
  end
end
