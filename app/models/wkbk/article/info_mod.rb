module Wkbk::Article::InfoMod
  extend ActiveSupport::Concern

  def info
    a = {}

    a["ID"]   = id
    a["タイトル"]   = title

    a["投稿者"]     = user.name
    a["作者"]       = source_about_unknown_name || source_author || user.name

    a["詳細URL"]    = page_url
    a["画像URL"]    = share_board_png_url
    a["共有将棋盤"] = share_board_url

    a["種類"]       = lineage.key
    a["フォルダ"]   = folder.pure_info.name

    if Wkbk::Config[:time_limit_sec_enable]
      a["制限時間"] = "#{time_limit_sec}秒"
    end

    if Wkbk::Config[:difficulty_level_enable]
      a["難易度"] = "★" * (difficulty_level || 0)
    end

    # a["出題回数"]   = histories_count

    # a["正解率"]     = ox_record.o_rate ? ("%.2f %%" % (ox_record.o_rate * 100)) : ""
    #
    # a["正解数"]     = ox_record.o_count
    # a["誤答数"]     = ox_record.x_count

    # a["高評価率"]   = good_rate ? ("%.2f %%" % (good_rate * 100)) : ""
    # a["高評価数"]   = good_marks_count
    # a["低評価数"]   = bad_marks_count

    # a["コメント数"] = messages_count

    a["出典"] = source_media_name
    a["出典年月日"] = source_published_on
    a["出典URL"] = source_media_url

    a["ヒント"] = hint_desc.presence
    a["メッセージ"] = direction_message.presence
    a["タグ"] = owner_tag_list.join(", ")
    a["作成日時"] = created_at.to_s(:ymdhm)
    a["SFEN"] = main_sfen
    a["解説"] = description.presence.to_s.squish
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
