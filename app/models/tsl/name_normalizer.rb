module Tsl
  module NameNormalizer
    extend self

    # 連盟の表記がバラバラ
    def normalize(str)
      str = str.gsub("小髙", "小高")
      str = str.gsub("泰煕", "泰熙")
      str = str.gsub("廣瀬章人", "広瀬章人")
      str = str.gsub(/[斉齋齊]藤/, "斎藤")
    end
  end
end
