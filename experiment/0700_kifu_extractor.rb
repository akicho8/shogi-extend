#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

KifuExtractor.extract("http://example.com/#68S")  # => "68S"
KifuExtractor.extract("http://example.com/#76%E6%AD%A9") # => "76歩"
KifuExtractor.extract("http://example.com/?body=76%E6%AD%A9") # => "76歩"
