# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as User)
#
# |----------------------+-------------------+-------------+-------------+----------------+-------|
# | カラム名             | 意味              | タイプ      | 属性        | 参照           | INDEX |
# |----------------------+-------------------+-------------+-------------+----------------+-------|
# | id                   | ID                | integer(8)  | NOT NULL PK |                |       |
# | name                 | 名前              | string(255) | NOT NULL    |                |       |
# | current_chat_room_id | Current chat room | integer(8)  |             | => ChatRoom#id | A     |
# | online_at            | Online at         | datetime    |             |                |       |
# | fighting_now_at      | Fighting now at   | datetime    |             |                |       |
# | matching_at          | Matching at       | datetime    |             |                |       |
# | lifetime_key         | Lifetime key      | string(255) | NOT NULL    |                | B     |
# | ps_preset_key        | Ps preset key     | string(255) | NOT NULL    |                | C     |
# | po_preset_key        | Po preset key     | string(255) | NOT NULL    |                | D     |
# | created_at           | 作成日時          | datetime    | NOT NULL    |                |       |
# | updated_at           | 更新日時          | datetime    | NOT NULL    |                |       |
# |----------------------+-------------------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・User モデルは ChatRoom モデルから has_many :current_users, :foreign_key => :current_chat_room_id されています。
#--------------------------------------------------------------------------------

module ResourceNs1
  class UsersController < ApplicationController
    include ModulableCrud::All

    def show
      @user_show_app_params = {
        chat_rooms: current_record.chat_rooms.as_json({
            include: {
              :users => nil,
              :watch_users => nil,
              :chat_memberships => {
                include: :user,
              },
            }, methods: [
              :show_path,
              :handicap,
              :human_kifu_text,
            ],
          })

      }
    end

    def redirect_to_where
      # [:resource_ns1, :chat_rooms]
      # [:edit, :resource_ns1, current_record]
      [:edit, :resource_ns1, current_record]
    end
  end
end
