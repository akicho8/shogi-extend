require "rails_helper"

module Talk
  RSpec.describe Main do
    it "to_browser_path" do
      Timecop.return do
        obj = Main.new(source_text: "あ")
        is_asserted_by { obj.to_browser_path.match?(%r{\A/system/talk/../../.{32}\.mp3\z}) }
        is_asserted_by { obj.to_real_path.to_s.match?(/public/) }
      end
    end

    it "as_json" do
      Timecop.return do
        obj = Main.new(source_text: "こんにちは")
        is_asserted_by { obj.as_json }
      end
    end

    it "キャッシュOFFなら必ず生成する" do
      Timecop.return do
        obj = Main.new(source_text: "こんにちは", disk_cache_enable: false)
        is_asserted_by { obj.as_json }
      end
    end

    it "cache_delete" do
      obj = Main.new(source_text: "こんにちは")
      obj.to_browser_path     # => "/system/talk/9e/f6/9ef638a57701331482ac4cc52e05795b.mp3"
      obj.cache_delete
    end
  end
end
