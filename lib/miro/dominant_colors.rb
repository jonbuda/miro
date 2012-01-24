module Miro
  class DominantColors
    attr_accessor :src_image_path

    def initialize(src_image_path)
      @src_image_path = src_image_path
    end

    def remote_file?
      @src_image_path =~ /^https?:\/\//
    end
  end
end
