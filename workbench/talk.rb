require File.expand_path('../../config/environment', __FILE__)

Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

tp Talk.create(source_text: "こんにちは").as_json
# >> [ExclusiveAccess][talk_mp3][1][権利を獲得したのでAPIを実行する]
# >> [talk_mp3][2023-03-27 20:21:59 352][25738][2d45ea9c174788782caf5227713a1c9f][][再入:1][begin]
# >> |-----------------+---------------------------------------------------------------------------------------------|
# >> |   output_format | mp3                                                                                         |
# >> |     sample_rate | 16000                                                                                       |
# >> |       text_type | text                                                                                        |
# >> |        voice_id | Mizuki                                                                                      |
# >> |            text | こんにちは                                                                                  |
# >> | response_target | /Users/ikeda/src/shogi/shogi-extend/public/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3 |
# >> |-----------------+---------------------------------------------------------------------------------------------|
# >>
# >> [talk_mp3][2023-03-27 20:23:01 570][25738][2d45ea9c174788782caf5227713a1c9f][][再入:1][end][62184.86 ms]
# >> |--------------+---------------------------------------------------------|
# >> | browser_path | /system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3 |
# >> |--------------+---------------------------------------------------------|
