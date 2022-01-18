# テキストから推測して棋譜を抽出する
#
#  KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d") # => "開始日時：2021/12/06 04:37:40..."
#
#  与えられたテキスト自体が棋譜の場合はそれを返さないので注意
#  KifuExtractor.extract("76歩") # => nil
#
#  サイトに依存の泥臭いハードコーディングだらけなのでコアライブラリの方には入れない方針
#
module KifuExtractor
  EXTRACTORS = [
    CaseLishogiEditorUrl,
    CaseLishogiBattleUrl,
    CaseKentoUrl,
    CaseShogidb2Show,
    CaseShogidb2Board,
    CaseSwarsGamesUrl,
    CaseShogiExtendSwarsBattleUrl,
    CaseLiveShogiOrJp,
    CaseOushosenUrl,
    CaseDirectFileUrl,
    CaseUrlParams,
    CaseSponichiUrl,
    CaseTactic,
    CasePreset,
    CaseDirectFileUrlInHtml,
    CaseSponichiContent,
    CaseUnknownUrl,
  ]

  def self.extract(source, options = {})
    body = nil
    item = Item.new(source)
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
end
