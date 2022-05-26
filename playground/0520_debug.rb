#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

r = FreeBattle.last
r.meta_info[:header]["棋戦"]    # => nil
