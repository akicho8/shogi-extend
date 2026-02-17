require "./setup"
instance = Talk::Main.new(source_text: "こんにちは")
instance.to_browser_path        # => "/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3"
instance.file_exist?            # => true
tp instance.to_h

instance = Talk::Main.new(source_text: "こんにちは")
instance.real_path              # => #<Pathname:/Users/ikeda/src/shogi/shogi-extend/public/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3>
instance.file_exist?            # => true
instance.cache_delete           # => ["/Users/ikeda/src/shogi/shogi-extend/public/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3"]
instance.file_exist?            # => false

Talk::Main.output_root_dir      # => #<Pathname:/Users/ikeda/src/shogi/shogi-extend/public/system/talk>
# >> |-----------------+---------------------------------------------------------------------------------------------|
# >> |   cache_feature | true                                                                                        |
# >> |      unique_key | 2d45ea9c174788782caf5227713a1c9f                                                            |
# >> | to_browser_path | /system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3                                     |
# >> |    to_real_path | /Users/ikeda/src/shogi/shogi-extend/public/system/talk/2d/45/2d45ea9c174788782caf5227713a1c9f.mp3 |
# >> |-----------------+---------------------------------------------------------------------------------------------|
