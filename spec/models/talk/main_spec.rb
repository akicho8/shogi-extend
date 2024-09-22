require "rails_helper"

module Talk
  RSpec.describe Main do
    it "生成してブラウザ用のURLパスを取得する" do
      Timecop.return do
        obj = Main.new(source_text: "あ")
        assert { obj.to_browser_path.match?(%r{\A/system/talk/../../.{32}\.mp3\z}) }
        assert { obj.to_real_path.to_s.match?(/public/) }
      end
    end

    it "as_json" do
      Timecop.return do
        assert { Main.new(source_text: "こんにちは").as_json }
      end
    end

    it "キャッシュOFFなら必ず生成する" do
      Timecop.return do
        obj = Main.new(source_text: "こんにちは", cache_feature: false)
        assert { obj.as_json }
      end
    end

    it "特定の文章のキャッシュを削除する" do
      obj = Main.new(source_text: "こんにちは")
      obj.to_browser_path
      assert { obj.file_exist? }
      obj.cache_delete
      assert { !obj.file_exist? }
    end
  end
end
