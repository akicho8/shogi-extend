require "rails_helper"

module Talk
  RSpec.describe "読み上げ用テキスト正規化" do
    it "タグを除去している" do
      assert { YomiageNormalizer.normalize("A<b>B</b>C > D <br><br/>") == "ABC D" }
    end

    it "長いURLは適度に省略する" do
      assert { YomiageNormalizer.normalize("●https://www.xxx-yyy.com/path?x=1●") == "●xxx yyy com●" }
    end

    it "語尾の草" do
      assert { YomiageNormalizer.normalize("●wｗ") == "●わらわら" }
    end
  end
end
