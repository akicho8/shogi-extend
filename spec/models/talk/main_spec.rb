require "rails_helper"

RSpec.describe Talk::Main do
  around { |e| Timecop.return { e.run } }

  it "生成してブラウザ用のURLパスを取得する" do
    obj = Talk::Main.new(source_text: "あ")
    assert { obj.to_browser_path.match?(%r{\A/system/talk/../../.{32}\.mp3\z}) }
    assert { obj.to_real_path.to_s.match?(/public/) }
  end

  it "as_json" do
    assert { Talk::Main.new(source_text: "こんにちは").as_json }
  end

  it "キャッシュOFFなら必ず生成する" do
    obj = Talk::Main.new(source_text: "こんにちは", cache_feature: false)
    assert { obj.as_json }
  end

  it "特定の文章のキャッシュを削除する" do
    obj = Talk::Main.new(source_text: SecureRandom.hex)
    obj.to_browser_path
    assert { obj.file_exist? }
    obj.cache_delete
    assert { !obj.file_exist? }
  end
end
