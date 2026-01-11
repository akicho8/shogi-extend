require "rails_helper"

RSpec.describe "読み上げ用テキスト正規化" do
  it "タグを除去している" do
    assert { Talk::YomiageNormalizer.normalize("A<b>B</b>C > D <br><br/>") == "ABC D" }
  end

  it "長いURLは適度に省略する" do
    assert { Talk::YomiageNormalizer.normalize("●https://www.xxx-yyy.com/path?x=1●") == "●xxx yyy com●" }
  end

  it "語尾の草" do
    assert { Talk::YomiageNormalizer.normalize("●wｗ") == "●わらわら" }
  end

  it "[BUGFIX] nil.remove でエラーにならない" do
    assert { Talk::YomiageNormalizer.normalize("http:/") == "" }
  end

  it "☗☖▲△" do
    assert { Talk::YomiageNormalizer.normalize("▲") == "くろ" }
    assert { Talk::YomiageNormalizer.normalize("△") == "しろ" }
    assert { Talk::YomiageNormalizer.normalize("☗") == "くろ" }
    assert { Talk::YomiageNormalizer.normalize("☖") == "しろ" }
  end
end
