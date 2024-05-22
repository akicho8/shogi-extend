require "./setup"
obj = Talk.create(source_text: "こんにちは")
tp obj.to_h
# >> |-------------------+---------------------------------------------------------------------------------------------|
# >> | disk_cache_enable | true                                                                                        |
# >> |        unique_key | 2d45ea9c174788782caf5227713a1c9f                                                            |
# >> |   to_browser_path | /system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3                                     |
# >> |      to_real_path | /Users/ikeda/src/shogi-extend/public/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3 |
# >> |-------------------+---------------------------------------------------------------------------------------------|
