require 'spec_helper'

describe Miro::DominantColors do
  it "take a paramter and sets the source image path" do
    miro = Miro::DominantColors.new('path/to/file')
    miro.src_image_path.should eq('path/to/file')
  end
end
