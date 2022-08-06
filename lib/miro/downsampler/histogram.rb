# frozen_string_literal: true

module Miro
  module Downsampler
    class Histogram < Default
      def to_hex
        histogram.map { |item| item[1].html } 
      end
  
      def to_rgb
        histogram.map { |item| item[1].to_rgb.to_a } 
      end
  
      def to_rgba
        histogram.map { |item| item[1].css_rgba } 
      end

      def to_hsl
        histogram.map { |item| item[1].to_hsl.to_a }
      end
  
      def to_cmyk
        histogram.map { |item| item[1].to_cmyk.to_a }
      end
  
      def to_yiq
        histogram.map { |item| item[1].to_yiq.to_a }
      end
  
      def histogram
        @histogram ||= parse_result(@command_output)&.sort_by { |item| item[0] }&.reverse
      end

      private

      def run_convert_command
        Terrapin::CommandLine.new(
          Miro.configuration.image_magick_path,
          "':in[0]' -resize :resolution -colors :colors -colorspace :quantize -quantize :quantize -alpha remove -format %c histogram:info:"
        ).run(in:
          Shellwords.escape(File.expand_path(source.path)),
          resolution: Miro.configuration.resolution,
          colors: Miro.configuration.color_count.to_s,
          quantize: Miro.configuration.quantize
        )
      end

      def parse_result(hstring)
        return nil if hstring.nil?

        hstring.scan(/(\d*):.*(#[0-9A-Fa-f]*)/).collect do |match|
          [match[0].to_i, Color.const_get(Miro.configuration.quantize.upcase).from_html(match[1])]
        end
      end
    end
  end
end