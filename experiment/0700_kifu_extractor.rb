#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

KifuExtractor.extract("http://example.com/#68S")  # => "68S"
KifuExtractor.extract("http://example.com/#76%E6%AD%A9") # => "76歩"
KifuExtractor.extract("http://example.com/?body=76%E6%AD%A9") # => "76歩"
KifuExtractor.extract("https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e&turn=3&abstract_viewpoint=black&color_theme_key=is_color_theme_groovy_board_texture1") # => "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
