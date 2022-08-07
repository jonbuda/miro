# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::ImageLoader do
  it "must take a paramter and sets the filepath" do
    miro = Miro::ImageLoader.new("path/to/file")
    expect(miro.filepath).to eq("path/to/file")
  end

  it "must take a paramter and sets the image type" do
    miro = Miro::ImageLoader.new("path/to/file", image_type: "jpg")
    expect(miro.image_type).to eq("jpg")
  end

  context "when the source image is a remote image" do
    let(:subject) { Miro::ImageLoader.new("http://domain.com/to/image.jpg") }
    let(:mock_source_image) { double("file", path: "/path/to/source_image").as_null_object }

    before do
      stub_request(:get, "http://domain.com/to/image.jpg")
        .to_return(body: File.new(File.join(__dir__, "../data/test.png")), status: 200)
      allow(Tempfile).to receive(:open).and_return(mock_source_image)
    end

    it "must be remote" do
      expect(subject).to be_remote
    end

    it "opens for the file resource" do
      expect(Tempfile).to receive(:open).with(["source", ".jpg"]).and_return(mock_source_image)
      subject.file
    end
  end
end
