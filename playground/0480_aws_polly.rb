#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# client = Aws::Polly::Client.new
# resp = client.synthesize_speech({
#     text: "こんにちは",
#     response_target: "_output.mp3",
#     output_format: "mp3",
#     sample_rate: "16000",
#     text_type: "text",
#     voice_id: "Mizuki",
#   })
# tp resp.to_h

obj = Talk.new(source_text: "あ")
obj.to_browser_path                # => "/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3"
obj.to_real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3>
