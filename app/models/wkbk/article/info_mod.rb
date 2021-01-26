module Wkbk::Article::InfoMod
  extend ActiveSupport::Concern

  def info
    a = {}
    a["ID"]             = id
    a["タイトル"]       = title
    a["投稿者"]         = user.name
    a["詳細URL"]        = page_url
    a["画像URL"]        = share_board_png_url
    a["共有将棋盤"]     = share_board_url
    a["種類"]           = lineage.key
    a["フォルダ"]       = folder.pure_info.name
    a["メッセージ"]     = direction_message
    a["タグ"]           = owner_tag_list.join(", ")
    a["作成日時"]       = created_at.to_s(:ymdhm)
    a["SFEN"]           = main_sfen
    a["解説"]           = description.presence.to_s.squish
    a["人間向けの解答"] = moves_answers.first&.moves_human_str
    a
  end

  def to_kif
    str = Wkbk::Converter.sfen_to_kif_str(main_sfen)

    str = str.gsub(/^.*の備考.*\n/, "")
    str = str.gsub(/^まで.*\n/, "")

    info.collect { |k, v| "#{k}：#{v}\n" }.join + str
  end
end
