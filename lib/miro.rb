# frozen_string_literal: true

require "terrapin"
require "color"
require "tempfile"
require "open-uri"
require "securerandom"
# Load the C extension oily_png unless jruby is the platform in use.
if RUBY_ENGINE == "jruby"
  require "chunky_png"
else
  require "oily_png"
end

require_relative "miro/version"
require_relative "miro/configuration"
require_relative "miro/image_loader"
require_relative "miro/downsampler"
require_relative "miro/dominant_colors"

module Miro
  class Error < StandardError; end
end
