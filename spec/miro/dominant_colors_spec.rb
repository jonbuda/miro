require 'spec_helper'

describe Miro::DominantColors do
  let(:subject) { Miro::DominantColors.new('/path/to/file') }
  let(:mock_source_image) { double('file', :path => '/path/to/source_image').as_null_object }
  let(:mock_downsampled_image) { double('file', :path => '/path/to/downsampled_image').as_null_object }
  let(:pixel_data) { 
    [ 2678156287,
      1362307839, 1362307839, 1362307839, 1362307839, 1362307839, 1362307839, 1362307839, 1362307839,
      2506379263, 2506379263, 2506379263, 2506379263,
      2739747583, 2739747583,
      1816737791, 1816737791, 1816737791, 1816737791, 1816737791, 1816737791,
      1699826431, 1699826431, 1699826431, 1699826431, 1699826431,
      3773291775, 3773291775, 3773291775,
      740104447, 740104447, 740104447, 740104447, 740104447, 740104447, 740104447 ] }
  let(:chunky_png_results) { double('chunkypng', :pixels => pixel_data) }
  let(:expected_pixels) { [1362307839, 740104447, 1816737791, 1699826431, 2506379263, 3773291775, 2739747583, 2678156287] }
  let(:expected_hex_values) { ["#51332a", "#2c1d18", "#6c4937", "#65514a", "#95644f", "#e0e7dc", "#a34d3a", "#9fa16b"] }
  let(:expected_rgba_values) { [[81, 51, 42, 255], [44, 29, 24, 255], [108, 73, 55, 255], [101, 81, 74, 255], [149, 100, 79, 255], [224, 231, 220, 255], [163, 77, 58, 255], [159, 161, 107, 255]] }
  let(:expected_rgb_values) { [[81, 51, 42], [44, 29, 24], [108, 73, 55], [101, 81, 74], [149, 100, 79], [224, 231, 220], [163, 77, 58], [159, 161, 107]] }

  before do
    Cocaine::CommandLine.stub(:new).and_return(double('command', :run => true))
    ChunkyPNG::Image.stub(:from_file).and_return(chunky_png_results)
  end

  it "takes a paramter and sets the source image path" do
    miro = Miro::DominantColors.new('path/to/file')
    miro.src_image_path.should eq('path/to/file')
  end

  describe "#sorted_pixels" do
    before { subject.stub(:extract_colors_from_image).and_return(expected_pixels) }

    it "extracts colors from the image the first time it's called" do
      subject.should_receive(:extract_colors_from_image).and_return(expected_pixels)
      subject.sorted_pixels
    end

    it "returns previously extracted colors on subsequent calls" do
      subject.should_receive(:extract_colors_from_image).once
      subject.sorted_pixels
      subject.sorted_pixels
    end
  end

  context "when extracting colors" do
    before do
      File.stub(:open).and_return(mock_source_image)
    end

    it "opens the tempfile for the downsampled image" do
      Tempfile.should_receive(:open).with(['downsampled', '.png']).and_return(mock_downsampled_image)
      subject.sorted_pixels
    end

    it "runs the imagemagick command line with the correct arguments" do
      subject.stub(:open_downsampled_image).and_return(mock_downsampled_image)
      line = double('line')
      Cocaine::CommandLine.should_receive(:new).with(Miro.options[:image_magick_path],
                                                     "':in[0]' -resize :resolution -colors :colors -colorspace :quantize -quantize :quantize :out").and_return(line)

      line.should_receive(:run).with(:in => '/path/to/source_image',
                                     :resolution => Miro.options[:resolution],
                                     :colors => Miro.options[:color_count].to_s,
                                     :quantize => Miro.options[:quantize],
                                     :out => '/path/to/downsampled_image')
      subject.sorted_pixels
    end

    it "sorts the colors from most dominant to least" do
      subject.stub(:open_downsampled_image).and_return(mock_downsampled_image)
      subject.sorted_pixels.should eq(expected_pixels)
    end
  end

  context "when the source image is a local image file" do
    let(:subject) { Miro::DominantColors.new('/path/to/image.jpg') }

    before do
      File.stub(:open).and_return(mock_source_image)
      subject.stub(:open_downsampled_image).and_return(mock_downsampled_image)
    end

    it "opens for the file resource" do
      File.should_receive(:open).with(subject.src_image_path)
      subject.sorted_pixels
    end

    it "deletes only temporary downsampled file when finished" do
       mock_downsampled_image.should_receive(:close).with(true)
       mock_source_image.should_not_receive(:close)
       subject.sorted_pixels
     end
  end

  context "when the source image is a remote image" do
    let(:subject) { Miro::DominantColors.new('http://domain.com/to/image.jpg') }

    before do
      subject.stub(:open_downsampled_image).and_return(mock_downsampled_image)
      Tempfile.stub(:open).and_return(mock_source_image)
    end

    it "opens for the file resource" do
      Tempfile.should_receive(:open).with(['source','.jpg']).and_return(mock_source_image)
      subject.sorted_pixels
    end

    it "deletes the temporary source file when finished" do
       mock_source_image.should_receive(:close).with(true)
       subject.sorted_pixels
     end
  end

  context "when retrieving various color values" do
    before { subject.stub(:sorted_pixels).and_return(expected_pixels) }

    describe "#to_hex" do
      it "converts sorted pixel data into hex color values" do
        subject.to_hex.should eq(expected_hex_values)
      end
    end

    describe "#to_rgb" do
      it "converts sorted pixel data into rgb color values" do
        subject.to_rgb.should eq(expected_rgb_values)
      end
    end

    describe "#to_rgba" do
      it "converts sorted pixel data into rgba color values" do
        subject.to_rgba.should eq(expected_rgba_values)
      end
    end

  end

  context "when find percentages of each color" do
    let(:pixel_data) {
        [ 2678156287,
          1362307839, 1362307839,
          2506379263, 2506379263, 2506379263, 2506379263,
          2739747583, 2739747583, 2739747583
        ] }

    describe "#by_percentage" do
      before do
        File.stub(:open).and_return(mock_source_image)
        subject.stub(:open_downsampled_image).and_return(mock_downsampled_image)
      end

      it "returns an array of percents" do
        subject.by_percentage.should == [0.4, 0.3, 0.2, 0.1]
      end
    end
  end
  
end
