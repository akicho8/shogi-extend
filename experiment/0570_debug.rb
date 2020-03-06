#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# http://localhost:3000/x/2b54c8042947332f051bcbf061ac9c0b.png?turn=2&updated_at=1583470107

r = FreeBattle.find_by(key: "8452d6171728a6ca1a2fbfbbc3aea23d")
r.id                            # => 4973
puts r.kifu_body
puts r.existing_sfen            # => nil
# >> 76歩 34歩
# >> position startpos moves 7g7f 3c3d
