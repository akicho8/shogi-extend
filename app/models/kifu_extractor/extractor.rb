# テキストから推測して棋譜を抽出する
#
# 使い方
#
#   KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d") # => "開始日時：2021/12/06 04:37:40..."
#
# 抽出する必要がなければ何も返さない
#
#   KifuExtractor.extract("76歩") # => nil
#
# Bioshogiの方に入れない？
#
#   サイトに依存の泥臭いハードコーディングだらけなのでコアライブラリの方には入れない方針
#
module KifuExtractor
  class Extractor
    EXTRACTORS = [
      # Url
      CaseUrlTrustworthyFile,
      CaseUrlLishogiEditor,
      CaseUrlLishogiBattle,
      CaseUrlKento,
      CaseUrlShogidb2Show,
      CaseUrlShogidb2Board,
      CaseUrlHerozSwarsGames,
      CaseUrlShogiQuestUrl,
      CaseUrlShogiExtendSwarsBattle,
      CaseUrlLiveShogiOrJp,
      CaseUrlOushosen,
      CaseUrlSponichi,
      CaseUrlParams,
      CaseUrlTrustworthyFileSearchInHtml,
      CaseUrlUnknown,
      # Content
      CaseContentSponichi,
      CaseContentTactic,
      CaseContentPreset,
    ]
    private_constant :EXTRACTORS

    def initialize(source, options = {})
      @source = source
      @options = options
    end

    def extract
      body = nil
      EXTRACTORS.each do |e|
        e = e.new(item, options)
        e.resolve
        if e.body
          body = e.body
          break
        end
      end
      body
    end

    def item
      Item.new(@source)
    end

    private

    attr_reader :source
    attr_reader :options
  end
end
