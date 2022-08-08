# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::DominantColors do
  let(:filepath) { File.join(__dir__, "../fixtures/test.png") }
  let(:tempfile) { File.open(filepath) }

  it "must call image_loader" do
    expect(Miro::ImageLoader).to receive(:new).with(filepath, image_type: nil).and_call_original
    Miro::DominantColors.new(filepath)
  end

  it "must call downsampler" do
    image_loader = double(:image_loader, file: double(:file))
    expect(image_loader).to receive(:file).and_return(tempfile)
    expect(Miro::ImageLoader).to receive(:new).with(filepath, image_type: nil).and_return(image_loader)
    expect(Miro::Downsampler).to receive(:downsample!).with(tempfile).and_return(double(:downsampler))
    Miro::DominantColors.new(filepath)
  end
end
