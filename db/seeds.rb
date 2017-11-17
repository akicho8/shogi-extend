unless KifuConvertInfo.exists?
  60.times { KifuConvertInfo.create!(kifu_body: "") }
end
