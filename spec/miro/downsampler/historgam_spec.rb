# frozen_string_literal: true

require "spec_helper"

RSpec.describe Miro::Downsampler::Histogram do
  let(:filepath) { File.join(__dir__, "../../fixtures/test.png") }
  let(:tempfile) { File.open(filepath) }
  let(:subject) { described_class.new(tempfile) }
  it_behaves_like "downsampler"
end
