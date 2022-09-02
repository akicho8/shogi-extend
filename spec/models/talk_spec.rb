require "rails_helper"

RSpec.describe Talk do
  it "to_browser_path" do
    Timecop.return do
      obj = Talk.new(source_text: "あ")
      assert { obj.to_browser_path.match?(/system.*talk.*mp3/) }
      assert { obj.to_real_path.to_s.match?(/public/) }
    end
  end

  it "as_json" do
    Timecop.return do
      obj = Talk.new(source_text: "こんにちは")
      assert { obj.as_json }
    end
  end

  it "キャッシュOFFで生成" do
    Timecop.return do
      obj = Talk.new(source_text: "こんにちは", disk_cache_enable: false)
      assert { obj.as_json }
    end
  end

  it "cache_delete" do
    obj = Talk.new(source_text: "こんにちは")
    obj.to_browser_path     # => "/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3"
    obj.cache_delete
  end

  describe "読み上げ用テキスト正規化" do
    it "タグを除去している" do
      str = "A<b>B</b>C > D <br><br/>"
      obj = Talk::TextNormalizer.new(str)
      assert { obj.to_s == "ABC D" }
    end

    it "長いURLは適度に省略する" do
      str = "●https://www.xxx-yyy.com/path?x=1●"
      obj = Talk::TextNormalizer.new(str)
      assert { obj.to_s == "●xxx yyy com●" }
    end

    it "語尾の草" do
      str = "●wｗ"
      obj = Talk::TextNormalizer.new(str)
      assert { obj.to_s == "●わらわら" }
    end
  end
end
