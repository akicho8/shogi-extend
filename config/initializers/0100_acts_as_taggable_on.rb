# ActsAsTaggableOn.setup do |config|
#   config.delimiter = " "
# end

# 独自のパーサーを使うようにする
ActsAsTaggableOn.setup do |c|
  c.remove_unused_tags = false  # true すると FreeBattle.setup の更新でこける
  # c.default_parser = SoftParser
  # さらに tag_list.to_s のときのセパレーターを設定する
  # 次のようにすると警告を出そうとして「それが原因」で転ける
  c.delimiter = " "
  # なので instance_variable_set で代わす
  # c.instance_variable_set(:@delimiter, " ")
  # バージョン 4 からは delimiter はなくなるらしい

  # 最速にするか？
  #
  # - メリット
  #   - 速くなる
  #   - 強制的に strict_case_match = true になる (LOWERが使われなくなる)
  # - デメリット
  #   - 絵文字や特殊文字が入らなくなる
  # - 問題点
  #   - すでにDBに特殊文字が入っているため ALTER が通らない
  #
  if false
    c.force_binary_collation = true
  end

  # 最速にはできないが、せめて LOWER を使わないようにする？
  #
  # |--------+-------------------------------------|
  # |        | 速度                                |
  # |--------+-------------------------------------|
  # | 適用前 | Swars::Membership Count (15659.9ms) |
  # | 適用後 | Swars::Membership Count ( 1229.9ms) |
  # |--------+-------------------------------------|
  #
  if true
    c.strict_case_match = true
  end
end
# ActsAsTaggableOn.default_parser = ActsAsTaggableOn::PickUpParser
