# kifu_extractor/* のファイルを検証
#
# ▼これだけ実行
# rake spec:kifu_extractor
#
# ▼比較するファイルをいったん生成
# KIFU_EXTRACTOR_OUTPUT=1 rake spec:kifu_extractor
#
require "rails_helper"

RSpec.describe KifuExtractor, type: :model, kifu_extractor: true do
  Pathname(__dir__).join("kifu_extractor").children.each do |e|
    if e.basename.to_s.start_with?("__skip__")
      next
    end
    describe e.basename do
      e.children.each do |e|
        if e.basename.to_s.start_with?("__skip__")
          next
        end
        it e.basename do
          source = e.join("source.txt").read
          actual = KifuExtractor.extract(source)
          actual ||= ""
          e.join("actual.txt").write(actual)
          expected_file = e.join("expected.txt")
          if ENV["KIFU_EXTRACTOR_OUTPUT"]
            expected_file.write(actual)
          end
          expect(actual).to eq(expected_file.read)
        end
      end
    end
  end

  def case1(text)
    KifuExtractor.extract(text)
  end

  it "URL引数" do
    assert { case1("https://example.com/?body=76%E6%AD%A9")    == "76歩" }
    assert { case1("https://example.com/?sfen=76%E6%AD%A9")    == "76歩" }
    assert { case1("https://example.com/?csa=76%E6%AD%A9")     == "76歩" }
    assert { case1("https://example.com/?kif=76%E6%AD%A9")     == "76歩" }
    assert { case1("https://example.com/?ki2=76%E6%AD%A9")     == "76歩" }
    assert { case1("https://example.com/?content=76%E6%AD%A9") == "76歩" }
    assert { case1("https://example.com/?text=76%E6%AD%A9")    == "76歩" }
    assert { case1("https://example.com/#76%E6%AD%A9")         == "76歩" }
    assert { case1("https://example.com/?xbody=Nzbmrak")       == "76歩" }
  end

  it "URIではパースできるがhostがnilになる不正なURLの場合でも落ちない" do
    assert { case1("http:/http://example.com/") == nil }
  end
end
