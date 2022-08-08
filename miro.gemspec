# frozen_string_literal: true

require File.expand_path("lib/miro/version", __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jon Buda"]
  gem.email         = ["jon.buda@gmail.com"]
  gem.description   = "Extract the dominant colors from an image."
  gem.summary       = "Extract the dominant colors from an image."
  gem.homepage      = "https://github.com/jonbuda/miro"

  gem.requirements  = "ImageMagick"
  gem.required_ruby_version = ">= 2.6.0"

  gem.add_dependency "chunky_png"
  gem.add_dependency "terrapin"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "miro"
  gem.require_paths = ["lib"]
  gem.version       = Miro::VERSION
  gem.license       = "MIT"
  gem.metadata["rubygems_mfa_required"] = "true"
end
