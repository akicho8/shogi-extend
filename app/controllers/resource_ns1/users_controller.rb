# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as User)
#
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照             | INDEX |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                  |       |
# | name                   | 名前                | string(255) | NOT NULL    |                  |       |
# | current_battle_room_id | Current battle room | integer(8)  |             | => BattleRoom#id | A     |
# | online_at              | Online at           | datetime    |             |                  |       |
# | fighting_now_at        | Fighting now at     | datetime    |             |                  |       |
# | matching_at            | Matching at         | datetime    |             |                  |       |
# | lifetime_key           | Lifetime key        | string(255) | NOT NULL    |                  | B     |
# | platoon_key            | Platoon key         | string(255) | NOT NULL    |                  | C     |
# | self_preset_key        | Self preset key     | string(255) | NOT NULL    |                  | D     |
# | oppo_preset_key        | Oppo preset key     | string(255) | NOT NULL    |                  | E     |
# | user_agent             | User agent          | string(255) | NOT NULL    |                  |       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                  |       |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                  |       |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・User モデルは BattleRoom モデルから has_many :current_users, :foreign_key => :current_battle_room_id されています。
#--------------------------------------------------------------------------------

module ResourceNs1
  class UsersController < ApplicationController
    include ModulableCrud::All

    def show
      @user_show_app_params = {
        :battle_rooms => ams_sr(current_record.battle_rooms.latest_list, include: {memberships: :user}, each_serializer: BattleRoomEachSerializer),
      }
    end

    def redirect_to_where
      # [:resource_ns1, :battle_rooms]
      # [:edit, :resource_ns1, current_record]
      # [:edit, :resource_ns1, current_record]
      [:resource_ns1, current_record]
    end
  end
end
