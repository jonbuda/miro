# Miro

Extract the dominant colors from an image.

## Feedback

Questions, Comments, Concerns, or Bugs?

[GitHub Issues For All!](https://github.com/jonbuda/miro/issues)

## Installation

Add this line to your application's Gemfile:

    gem 'miro'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install miro

## Usage

Configuration

```ruby
# Defaults
Miro.options # => {:image_magick_path  => "/usr/bin/convert", :resolution => "150x150", :color_count => 8}

# Setting new options
Miro.options[:image_magick_path] = '/usr/local/bin/convert'
Miro.options[:resolution] = '100x100'
Miro.options[:color_count] = 4
```

Initializing an image

```ruby
# Initialize with a local image
colors = Miro::DominantColors.new('/path/to/local/image.jpg')

# or Initialize with a remote image
colors = Miro::DominantColors.new('http://domain.com/path/to/image.jpg')
```

Retrieving colors from an image

```ruby
# Hex
colors.to_hex # => ["#51332a", "#2c1d18", "#6c4937", "#65514a", "#95644f", "#e0e7dc", "#a34d3a", "#9fa16b"]

# RGB
colors.to_rgb # => [[81, 51, 42], [44, 29, 24], [108, 73, 55], [101, 81, 74], [149, 100, 79], [224, 231, 220], [163, 77, 58], [159, 161, 107]]

# RGB with Alpha channels
colors.to_rgba # => [[82, 37, 40, 255], [48, 17, 19, 255], [109, 70, 71, 255], [221, 158, 48, 255], [168, 103, 48, 255], [226, 178, 79, 255], [191, 146, 65, 255], [199, 165, 150, 255]]
```

Retrieving percentages of colors

```ruby
# percentage of each color in an image. matches sorting from to_hex,
# to_rgb and to_rgba.

colors.by_percentage # => [0.50, 0.25, 0.15, 0.10]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright 2012 Jon Buda. This is free software, and may be redistributed under the terms specified in the LICENSE file.
