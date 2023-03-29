require "rails_helper"

module Talk
  RSpec.describe "読み上げ用テキスト正規化" do
    it "タグを除去している" do
      str = "A<b>B</b>C > D <br><br/>"
      obj = YomiageNormalizer.new(str)
      assert2 { obj.to_s == "ABC D" }
    end

    it "長いURLは適度に省略する" do
      str = "●https://www.xxx-yyy.com/path?x=1●"
      obj = YomiageNormalizer.new(str)
      assert2 { obj.to_s == "●xxx yyy com●" }
    end

    it "語尾の草" do
      str = "●wｗ"
      obj = YomiageNormalizer.new(str)
      assert2 { obj.to_s == "●わらわら" }
    end
  end
end
