# ActsAsTaggableOn.setup do |config|
#   config.delimiter = " "
# end

# 独自のパーサーを使うようにする
ActsAsTaggableOn.setup do |c|
  c.remove_unused_tags = true
  # c.default_parser = SoftParser
  # さらに tag_list.to_s のときのセパレーターを設定する
  # 次のようにすると警告を出そうとして「それが原因」で転ける
  c.delimiter = " "
  # なので instance_variable_set で代わす
  # c.instance_variable_set(:@delimiter, " ")
  # バージョン 4 からは delimiter はなくなるらしい
end
# # ActsAsTaggableOn.default_parser = ActsAsTaggableOn::PickUpParser

# ActsAsTaggableOn.force_binary_collation = true
