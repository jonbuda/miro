# frozen_string_literal: true

require "terrapin"
require "tempfile"
require "open-uri"
require "securerandom"
require "chunky_png"

require_relative "miro/version"
require_relative "miro/configuration"
require_relative "miro/image_loader"
require_relative "miro/downsampler"
require_relative "miro/dominant_colors"

module Miro
  class Error < StandardError; end
end
