# -*- compile-command: "ruby card_generator.rb" -*-

if $0 == __FILE__
  require "bundler/inline"

  gemfile do
    gem "color"
    gem "rmagick"
    gem "bioshogi", github: "akicho8/bioshogi"
  end

  require "rmagick"
  require "rmagick/version"

  Magick::VERSION                 # => "4.1.2"

  require "./card_generator/base"
  require "./card_generator/simple_generator"
end

module CardGenerator
  extend self

  def to_blob(*args)
    SimpleGenerator.to_blob(*args)
  end

  def render(*args)
    SimpleGenerator.render(*args)
  end

  def display(*args)
    SimpleGenerator.display(*args)
  end
end

if $0 == __FILE__
  CardGenerator.display(base_color: [0, 0.5, 0.5], hue: 0, font_luminance: 0.98, stroke_darker: 0.05, stroke_width: 4, body: "終盤の手筋123")
end
