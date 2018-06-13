# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局情報テーブル (general_battles as GeneralBattle)
#
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | カラム名                 | 意味            | タイプ      | 属性        | 参照 | INDEX |
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | id                       | ID              | integer(8)  | NOT NULL PK |      |       |
# | battle_key               | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at               | 対局日          | datetime    |             |      |       |
# | kifu_body                | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | general_battle_state_key | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max                 | 手数            | integer(4)  | NOT NULL    |      |       |
# | meta_info                | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | mountain_url             | 将棋山脈URL     | string(255) |             |      |       |
# | last_accessd_at          | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at               | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at               | 更新日時        | datetime    | NOT NULL    |      |       |
# |--------------------------+-----------------+-------------+-------------+------+-------|

module GeneralBattlesHelper
  def general_user_link2(general_membership)
    meta_info = general_membership.general_battle.meta_info
    names = meta_info[:detail_names][general_membership.location.code]

    # 詳細になかったら「先手」「後手」のところから探す
    if names.blank?
      names = meta_info[:simple_names][general_membership.location.code].flatten
    end

    if names.blank?
      return "不明"
    end
    names.collect {|e|
      link_to(e, resource_ns1_general_search_path(e))
    }.join(" ").html_safe
  end
end
