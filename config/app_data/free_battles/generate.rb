#!/usr/bin/env ruby
require "securerandom"
File.write(["0900", SecureRandom.hex, ""].join("_") + ".kif", "")


