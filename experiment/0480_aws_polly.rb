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
obj.mp3_path                # => "/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3"
obj.real_path                   # => #<Pathname:/Users/ikeda/src/shogi_web/public/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3>
# >> |-----------------+------------------------------------------------------------------------------------------|
# >> |   output_format | mp3                                                                                      |
# >> |     sample_rate | 16000                                                                                    |
# >> |       text_type | text                                                                                     |
# >> |        voice_id | Mizuki                                                                                   |
# >> |            text | あ                                                                                       |
# >> | response_target | /Users/ikeda/src/shogi_web/public/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3 |
# >> |-----------------+------------------------------------------------------------------------------------------|
# >> |--------------------+-----------------------------------------------------|
# >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007fa2b9c35f88> |
# >> |       content_type | audio/mpeg                                          |
# >> | request_characters | 1                                                   |
# >> |--------------------+-----------------------------------------------------|
# >> |-----------------+------------------------------------------------------------------------------------------|
# >> |   output_format | mp3                                                                                      |
# >> |     sample_rate | 16000                                                                                    |
# >> |       text_type | text                                                                                     |
# >> |        voice_id | Mizuki                                                                                   |
# >> |            text | あ                                                                                       |
# >> | response_target | /Users/ikeda/src/shogi_web/public/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3 |
# >> |-----------------+------------------------------------------------------------------------------------------|
# >> |--------------------+-----------------------------------------------------|
# >> |       audio_stream | #<Seahorse::Client::ManagedFile:0x00007fa2bd92d2d8> |
# >> |       content_type | audio/mpeg                                          |
# >> | request_characters | 1                                                   |
# >> |--------------------+-----------------------------------------------------|
