#!/usr/bin/env ruby
require "securerandom"
File.write(["0900", SecureRandom.hex, "実戦詰筋事典"].join("_") + ".kif", "")


