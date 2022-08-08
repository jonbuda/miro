# frozen_string_literal: true

RSpec.shared_examples "downsampler" do |_parameter|
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

  before { subject.downsample! }

  describe "#histogram" do
    it { expect(subject.histogram).to eq(colors_histogram) }
  end

  describe "#sorted_pixels" do
    let(:colors) { [16_712_447, 65_535, 4_278_229_759, 1_027_489_498, 4_194_304_255, 1_731_583, 2_399_171_839] }

    it { expect(subject.sorted_pixels).to eq(colors) }
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
