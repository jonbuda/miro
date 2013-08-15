module Miro
  class DominantColors
    attr_accessor :src_image_path

    def initialize(src_image_path, image_type = nil)
      @src_image_path = src_image_path
      @image_type = image_type
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

    def by_percentage
      sorted_pixels
      pixel_count = @pixels.size
      sorted_pixels.collect { |pixel| @grouped_pixels[pixel].size / pixel_count.to_f }
    end

    def sorted_pixels
      @sorted_pixels ||= extract_colors_from_image
    end

  private
    def extract_colors_from_image
      downsample_colors_and_convert_to_png!
      colors = sort_by_dominant_color
      cleanup_temporary_files!
      return colors
    end

    def remote_source_image?
      @src_image_path =~ /^https?:\/\//
    end

    def downsample_colors_and_convert_to_png!
      @source_image = open_source_image
      @downsampled_image = open_downsampled_image

      Cocaine::CommandLine.new(Miro.options[:image_magick_path], "':in[0]' -resize :resolution -colors :colors -colorspace :quantize -quantize :quantize :out").
        run(:in => File.expand_path(@source_image.path),
            :resolution => Miro.options[:resolution],
            :colors => Miro.options[:color_count].to_s,
            :quantize => Miro.options[:quantize],
            :out => File.expand_path(@downsampled_image.path))
    end

    def open_source_image
      if remote_source_image?
        original_extension = @image_type || URI.parse(@src_image_path).path.split('.').last

        tempfile = Tempfile.open(["source", ".#{original_extension}"])
        remote_file_data = open(@src_image_path).read

        tempfile.write(should_force_encoding? ? remote_file_data.force_encoding("UTF-8") : remote_file_data)
        tempfile.close
        return tempfile
      else
        return File.open(@src_image_path)
      end
    end

    def should_force_encoding?
      Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('1.9')
    end

    def open_downsampled_image
      tempfile = Tempfile.open(["downsampled", '.png'])
      tempfile.binmode
      tempfile
    end

    def group_pixels_by_color
      @pixels ||= ChunkyPNG::Image.from_file(File.expand_path(@downsampled_image.path)).pixels
      @grouped_pixels ||= @pixels.group_by { |pixel| pixel }
    end

    def sort_by_dominant_color
      group_pixels_by_color.sort_by { |k,v| v.size }.reverse.flatten.uniq
    end

    def cleanup_temporary_files!
      @source_image.close(true) if remote_source_image?
      @downsampled_image.close(true)
    end
  end
end
