#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Rails.cache.write("foo", "あいうえお".force_encoding("Windows-31J"))
