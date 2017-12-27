# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | カラム名          | 意味              | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | battle_key        | Battle key        | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    |             |      |       |
# | kifu_body         | 棋譜内容          | text(65535) | NOT NULL    |      |       |
# | battle2_state_key | Battle2 state key | string(255) | NOT NULL    |      | B     |
# | turn_max          | 手数              | integer(4)  | NOT NULL    |      |       |
# | meta_info         | 棋譜ヘッダー      | text(65535) | NOT NULL    |      |       |
# | mountain_url      | 将棋山脈URL       | string(255) |             |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

module Battle2RecordsHelper
  def battle2_user_link2(battle2_ship)
    meta_info = battle2_ship.battle2_record.meta_info
    names = meta_info[:detail_names][battle2_ship.location.code]

    # 詳細になかったら「先手」「後手」のところから探す
    if names.blank?
      names = meta_info[:simple_names][battle2_ship.location.code].flatten
    end

    if names.blank?
      return "不明"
    end
    names.collect {|e|
      link_to(e, kifu_query_search_path(e))
    }.join(" ").html_safe
  end
end
