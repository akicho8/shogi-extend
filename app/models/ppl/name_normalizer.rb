module Ppl
  module NameNormalizer
    extend self

    # 連盟の表記がバラバラなため
    def normalize(str)
      str = str.gsub("泰煕", "泰熙")
      str = str.gsub("廣瀬章人", "広瀬章人")
      str = str.gsub(/[斉齋齊]/, "斎")
      str = str.gsub(/[髙]/, "高")
      str = str.gsub(/[埼]/, "崎")
    end
  end
end
