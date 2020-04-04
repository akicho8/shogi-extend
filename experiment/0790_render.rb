#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

renderer = FreeBattlesController.renderer.new(method: "get")
puts renderer.show
# ~> -:5:in `<main>': undefined method `show' for #<ActionController::Renderer:0x00007fad7f1fb3f8> (NoMethodError)
