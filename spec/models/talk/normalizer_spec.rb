require "rails_helper"

RSpec.describe "読み上げ用テキスト正規化" do
  it "タグを除去している" do
    assert { Talk::Normalizer.normalize("A<b>B</b>C > D <br><br/>") == "ABC D" }
  end

  it "長いURLは適度に省略する" do
    assert { Talk::Normalizer.normalize("●https://www.xxx-yyy.com/path?x=1●") == "●xxx yyy com●" }
  end

  it "語尾の草" do
    assert { Talk::Normalizer.normalize("●wｗ") == "●わらわら" }
  end

  it "[BUGFIX] nil.remove でエラーにならない" do
    assert { Talk::Normalizer.normalize("http:/") == "" }
  end

  it "[BUGFIX] URL にタグがついているときに例外を出さない" do
    assert { Talk::Normalizer.normalize("http://www.example.com/foo<br>") == "example com" }
  end

  it "☗☖▲△" do
    assert { Talk::Normalizer.normalize("▲") == "くろ" }
    assert { Talk::Normalizer.normalize("△") == "しろ" }
    assert { Talk::Normalizer.normalize("☗") == "くろ" }
    assert { Talk::Normalizer.normalize("☖") == "しろ" }
  end
end
