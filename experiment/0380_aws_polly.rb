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

obj = Talkman.new("あ")
obj.service_path                # => "/system/talkman/8c/0c/8c0c3027e3cfc3d644caab3847a505b0.mp3"
obj.real_path                   # => #<Pathname:/Users/ikeda/src/shogi_web/public/system/talkman/8c/0c/8c0c3027e3cfc3d644caab3847a505b0.mp3>
# >> |--------------------+-----------------------------------------------------|
# >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007f9b335cb608> |
# >> |       content_type | audio/mpeg                                          |
# >> | request_characters | 1                                                   |
# >> |--------------------+-----------------------------------------------------|
# >> |--------------------+-----------------------------------------------------|
# >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007f9b337f34a8> |
# >> |       content_type | audio/mpeg                                          |
# >> | request_characters | 1                                                   |
# >> |--------------------+-----------------------------------------------------|
