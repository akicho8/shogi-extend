require "./setup"

tp JSON.parse(URI("http://localhost:3000/api/kiwi/tops/index.json?_user_id=1").read)
# >> |-------+-------------------------------------------------------------------------------------------------------|
# >> | bananas | []                                                                                                    |
# >> |  meta | {"title"=>"動画ライブラリ", "description"=>"棋譜を動画にしたいときにどうぞ", "og_image_key"=>"video"} |
# >> |-------+-------------------------------------------------------------------------------------------------------|
