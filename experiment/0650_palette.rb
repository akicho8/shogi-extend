#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

pp PaletteInfo.as_json
# >> [{:key=>:info, :hsl=>[0.5666666666666667, 0.86, 0.53], :code=>0},
# >>  {:key=>:danger, :hsl=>[0.9666666666666667, 1.0, 0.61], :code=>1},
# >>  {:key=>:primary, :hsl=>[0.475, 1.0, 0.41], :code=>2},
# >>  {:key=>:warning, :hsl=>[0.13333333333333333, 1.0, 0.67], :code=>3},
# >>  {:key=>:success, :hsl=>[0.39166666666666666, 0.71, 0.48], :code=>4},
# >>  {:key=>:link, :hsl=>[0.6027777777777777, 0.71, 0.53], :code=>5}]
