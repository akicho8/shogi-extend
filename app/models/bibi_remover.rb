# 双方向テキスト
# https://ja.wikipedia.org/wiki/%E5%8F%8C%E6%96%B9%E5%90%91%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88

module BibiRemover
  extend self

  def execute(s)
    s.gsub(/[\u{061C 200E 200F 202A 202B 202C 202D 202E 2066 2067 2068 2069}]/, "")
  end
end
