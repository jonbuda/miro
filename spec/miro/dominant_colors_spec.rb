require 'spec_helper'

describe Miro::DominantColors do
  it "take a paramter and sets the source image path" do
    miro = Miro::DominantColors.new('path/to/file')
    miro.src_image_path.should eq('path/to/file')
  end

  describe "#remote_file?" do
    it "knows if an http:// request is a remote file" do
      Miro::DominantColors.new('http://remote.com/file.jpg').send(:remote_source_image?).should be_true
    end

    it "knows if an http:// request is a remote file" do
      Miro::DominantColors.new('https://remote.com/file.jpg').send(:remote_source_image?).should be_true
    end

    it "knows if an system path is not a remote file" do
      Miro::DominantColors.new('/path/to/file').send(:remote_source_image?).should be_false
    end
  end

  describe "#extract_from_image" do
    context "when you want hex values" do
      
    end

    context "when you want RGB values" do

    end
  end
  
end

