require 'cabelhigh_spec_helper'

describe Miro::DominantColors do
  context "Old Miro wouldn't work with non-local files" do
    let(:online_image) {Miro::DominantColors.new('https://i.scdn.co/image/4c985df11e68ebe6453feea645cd5fa259e43333')}
    let(:expected_hexes) { ["#010101", "#e3e4e4", "#021f18", "#0e190e", "#59615d", "#067f5d", '#295521', '#0b4e24']}
    it "still successfully creates a new Miro object from an online image" do
      online_image.src_image_path.should eq("https://i.scdn.co/image/4c985df11e68ebe6453feea645cd5fa259e43333")
    end

    it "can get hex colors from an online image" do
      online_image.to_hex.should eq(expected_hexes)
    end
  end


end
