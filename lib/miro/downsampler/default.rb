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

      def close!
        downsampled.close!
      end

      protected

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