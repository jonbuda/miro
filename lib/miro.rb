# frozen_string_literal: true

require "miro/version"
require "terrapin"
require "color"
require "tempfile"
require "open-uri"
require png_lib = (RUBY_ENGINE == "jruby" ? "chunky_png" : "oily_png") # Load the C extension oily_png unless jruby is the platform in use.

require_relative "miro/dominant_colors"
require_relative "miro/configuration"

module Miro
end
