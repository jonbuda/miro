require 'spec_helper'

describe Miro do
  describe '.options' do
    it "has default options" do
      Miro.options[:image_magick_path].should eq(`which convert`.strip)
      Miro.options[:color_count].should eq(8)
      Miro.options[:resolution].should eq('150x150')
    end

    it "can override the default options" do
      Miro.options[:image_magick_path] = '/path/to/command'
      Miro.options[:image_magick_path].should == '/path/to/command'
    end
  end
end
