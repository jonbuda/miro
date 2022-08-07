# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::Downsampler::PixelGroup do
  let(:filepath) { File.join(__dir__, '../../data/test.png') }
  let(:tempfile) { File.open(filepath) }
  let(:subject) { Miro::Downsampler::PixelGroup.new(tempfile) }
  let(:colors_histogram) { { 1027489498 => 47, 1731583 => 13, 4194304255 => 42, 4278229759 => 66, 2399171839 => 3, 65535 => 105, 16712447 => 174} }

  before do
    subject.downsample!
  end

  it "must count pixels" do
    expect(subject.pixel_count).to eq(450)
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
    let(:colors) { [16712447, 65535, 4278229759, 1027489498, 4194304255, 1731583, 2399171839] }

    it { expect(subject.sorted_pixels).to eq(colors) }
  end

  describe "#by_percentage" do
    let(:percentages) { [0.3867, 0.2333, 0.1467, 0.1044, 0.0933, 0.0289, 0.0067] }

    it { expect(subject.by_percentage.map{ |x| x.round(4) }).to eq(percentages) }
  end

  describe "#histogram" do
    it { expect(subject.histogram).to eq(colors_histogram) }
  end

  describe "#to_hex" do
    let(:hex_colors) { ["#00ff02", "#0000ff", "#ff009a", "#3d3e3e", "#fa0000", "#001a6b", "#8f0074"] }

    it { expect(subject.to_hex).to eq(hex_colors) }
  end

  describe "#to_rgb" do
    let(:rgb_colors) { [[0, 255, 2], [0, 0, 255], [255, 0, 154], [61, 62, 62], [250, 0, 0], [0, 26, 107], [143, 0, 116]] }

    it { expect(subject.to_rgb).to eq(rgb_colors) }
  end

  describe "#to_rgba" do
    let(:rgba_colors) { [[0, 255, 2, 255], [0, 0, 255, 255], [255, 0, 154, 255], [61, 62, 62, 218], [250, 0, 0, 255], [0, 26, 107, 255], [143, 0, 116, 255]] }

    it { expect(subject.to_rgba).to eq(rgba_colors) }
  end
end