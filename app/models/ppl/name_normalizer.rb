module Ppl
  module NameNormalizer
    extend self

    # 連盟の表記がバラバラなため
    def normalize(str)
      str = str.gsub(/\A杉本\z/, "杉本昌")
      str = str.gsub(/\A森安\z/, "森安正")
      str = str.gsub(/\A石田\z/, "石田和")
      str = str.gsub(/\A廣瀬章人\z/, "広瀬章人")
      str = str.gsub(/\A木村\z/, "木村一")

      str = str.gsub("泰煕", "泰熙")
      str = str.gsub(/[剣劔]持/, "剱持")
      str = str.gsub(/[斉齋齊]/, "斎")
      str = str.gsub(/[髙]/, "高")
      str = str.gsub(/[埼]/, "崎")
    end
  end
end
