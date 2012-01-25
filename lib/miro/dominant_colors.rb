module Miro
  class DominantColors
   attr_accessor :src_image_path
    def initialize(src_image_path)
      @src_image_path = src_image_path
    end

    def to_hex
      sorted_pixels.collect {|c| ChunkyPNG::Color.to_hex c, false }
    end

    def to_rgb
      sorted_pixels.collect {|c| ChunkyPNG::Color.to_truecolor_bytes c }
    end

    def to_rgba
      sorted_pixels.collect {|c| ChunkyPNG::Color.to_truecolor_alpha_bytes c }
    end

    def sorted_pixels
      @sorted_pixels ||= extract_colors_from_image
    end

  private
    def extract_colors_from_image
      downsample_colors_and_convert_to_png!
      sort_by_dominant_color
    end

    def remote_source_image?
      @src_image_path =~ /^https?:\/\//
    end

    def image_processed?
      (sorted_pixels && sorted_pixels.kind_of?(Array) && !sorted_pixels.empty?)
    end

    def downsample_colors_and_convert_to_png!
      prepare_source_image
      prepare_downsampled_image
      command.run
    end

    def command
      Cocaine::CommandLine.new(Miro.options[:image_magick_path], ":in -resize :resolution -colors :colors :out",
                              :in => File.expand_path(@source_image.path),
                              :resolution => Miro.options[:resolution],
                              :colors => Miro.options[:color_count].to_s,
                              :out => File.expand_path(@downsampled_image.path))
    end

    def prepare_source_image
      if remote_source_image?
        original_extension = URI.parse(@src_image_path).path.split('.').last

        @source_image = Tempfile.open(["#{Time.now.to_i.to_s}", ".#{original_extension}"])
        @source_image.write(open(@src_image_path).read.force_encoding("UTF-8"))
      else
        @source_image = File.open(@src_image_path)
      end
    end

    def prepare_downsampled_image
      @downsampled_image = Tempfile.open(["#{Time.now.to_i.to_s}", '.png'])
      @downsampled_image.binmode
    end

    def group_pixels_by_color
      chunky_png = ChunkyPNG::Image.from_file File.expand_path(@downsampled_image.path)
      chunky_png.pixels.group_by { |pixel| pixel }
    end

    def sort_by_dominant_color
      sorted_pixels = group_pixels_by_color.sort_by { |k,v| v.size }.reverse.flatten.uniq
      cleanup_temporary_files!
      return sorted_pixels
    end

    def cleanup_temporary_files!
      @source_image.close(true) if remote_source_image?
      @downsampled_image.close(true)
    end
  end
end
