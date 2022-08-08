# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::Downsampler::PixelGroup do
  let(:filepath) { File.join(__dir__, "../../fixtures/test.png") }
  let(:tempfile) { File.open(filepath) }
  let(:subject) { described_class.new(tempfile) }

  it_behaves_like "downsampler" do
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

    describe "#by_percentage" do
      let(:percentages) { [0.39, 0.23, 0.15, 0.10, 0.09, 0.03, 0.01] }

      it { expect(subject.by_percentage.map { |x| x.round(2) }).to eq(percentages) }
    end
  end
end
