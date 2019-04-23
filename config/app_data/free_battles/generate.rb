#!/usr/bin/env ruby
require "securerandom"
File.write(["0900", SecureRandom.hex, "棋譜"].join("_") + ".kif", "")


