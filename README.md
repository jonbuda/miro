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
Miro.options[:method] = 'histogram'
```
By default the method option is configured with 'pixel_group' to improve performance change to 'histogram', this will fetch directly from imagemagick the image histogram without any disk operation(read/write) but read the original file.

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
**Additional methods only available when histogram method is enabled**

```ruby
# HSL
  colors.to_hsl # => [[0.03846153846153848, 0.3170731707317073, 0.24117647058823527], [0.041666666666666664, 0.29411764705882354, 0.13333333333333333], [0.056603773584905634, 0.32515337423312884, 0.3196078431372549], [0.043209876543209826, 0.15428571428571422, 0.3431372549019608], [0.04999999999999999, 0.30701754385964913, 0.4470588235294118], [0.2727272727272729, 0.18644067796610145, 0.884313725490196], [0.030158730158730152, 0.47511312217194573, 0.4333333333333333], [0.17283950617283947, 0.22314049586776857, 0.5254901960784314]]
# CMYL
  colors.to_cmyk # => [[0.15772788927335635, 0.2753749480968858, 0.3106690657439446, 0.5246250519031143], [0.10680607458669744, 0.16562960399846216, 0.1852374471357171, 0.7206449058054594], [0.18404784313725486, 0.32130274509803924, 0.39189098039215686, 0.3924227450980392], [0.20410654363706265, 0.2825379161860822, 0.30998889657823897, 0.3998150249903884], [0.18299487889273353, 0.37515174163783166, 0.4575046828143022, 0.23269139561707036], [0.11147515570934258, 0.0840241753171857, 0.12716143021914644, 0.010093471741637827], [0.14225937716262976, 0.479514279123414, 0.5540240830449827, 0.21852493656286048], [0.23082082276047672, 0.22297768550557479, 0.43474239138792764, 0.1456497654748174]] 
# YIQ
  colors.to_yiq # =>  => [[0.23115294117647056, 0.08144705882352937, 0.013964705882352914], [0.129078431372549, 0.04135294117647058, 0.006372549019607841], [0.31926666666666664, 0.10446274509803921, 0.007145098039215689], [0.33796862745098033, 0.05555686274509804, 0.008090196078431366], [0.4402235294117646, 0.14096078431372547, 0.015125490196078437], [0.892756862745098, 0.0, 0.0], [0.3943058823529411, 0.2249215686274509, 0.0483254901960784], [0.6048862745098039, 0.06330196078431369, 0.0]]
```

Retrieving percentages of colors *disabled on histogram method*

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
