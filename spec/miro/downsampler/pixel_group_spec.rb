# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::Downsampler::PixelGroup do
  let(:filepath) { File.join(__dir__, "../../data/test.png") }
  let(:tempfile) { File.open(filepath) }
  let(:subject) { Miro::Downsampler::PixelGroup.new(tempfile) }
  let(:colors_histogram) do
    {
      1_027_489_498 => 47,
      1_731_583 => 13,
      4_194_304_255 => 42,
      4_278_229_759 => 66,
      2_399_171_839 => 3,
      65_535 => 105,
      16_712_447 => 174
    }
  end

  before do
    subject.downsample!
  end

  describe "#pixels" do
    it "must count pixels" do
      expect(subject.pixel_count).to eq(450)
    end

    it "must return an array" do
      expect(subject.pixels).to be_an_instance_of(Array)
    end

    it "must closde the downsampled tempfile" do
      expect(subject).to receive(:close_downsampled!)
      subject.pixels
      subject.pixels
    end
  end

  describe "#grouped_pixels" do
    it { expect(subject.grouped_pixels.keys).to eq(colors_histogram.keys) }
    it "must have the correct number of pixels" do
      colors_histogram.each do |color, size|
        expect(subject.grouped_pixels[color].size).to eq(size)
      end
    end
  end

  describe "#sorted_pixels" do
    let(:colors) { [16_712_447, 65_535, 4_278_229_759, 1_027_489_498, 4_194_304_255, 1_731_583, 2_399_171_839] }

    it { expect(subject.sorted_pixels).to eq(colors) }
  end

  describe "#by_percentage" do
    let(:percentages) { [0.3867, 0.2333, 0.1467, 0.1044, 0.0933, 0.0289, 0.0067] }

    it { expect(subject.by_percentage.map { |x| x.round(4) }).to eq(percentages) }
  end

  describe "#histogram" do
    it { expect(subject.histogram).to eq(colors_histogram) }
  end

  describe "#to_hex" do
    let(:hex_colors) { ["#00ff02", "#0000ff", "#ff009a", "#3d3e3e", "#fa0000", "#001a6b", "#8f0074"] }

    it { expect(subject.to_hex).to eq(hex_colors) }
  end

  describe "#to_rgb" do
    let(:rgb_colors) do
      [
        [0, 255, 2],
        [0, 0, 255],
        [255, 0, 154],
        [61, 62, 62],
        [250, 0, 0],
        [0, 26, 107],
        [143, 0, 116]
      ]
    end

    it { expect(subject.to_rgb).to eq(rgb_colors) }
  end

  describe "#to_rgba" do
    let(:rgba_colors) do
      [
        [0, 255, 2, 255],
        [0, 0, 255, 255],
        [255, 0, 154, 255],
        [61, 62, 62, 218],
        [250, 0, 0, 255],
        [0, 26, 107, 255],
        [143, 0, 116, 255]
      ]
    end

    it { expect(subject.to_rgba).to eq(rgba_colors) }
  end
end
