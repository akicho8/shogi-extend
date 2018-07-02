# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (fanta_users as Fanta::User)
#
# |-------------------+------------------+-------------+-------------+------+-------|
# | カラム名          | 意味             | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+------------------+-------------+-------------+------+-------|
# | id                | ID               | integer(8)  | NOT NULL PK |      |       |
# | key               | Key              | string(255) | NOT NULL    |      | A!    |
# | name              | Name             | string(255) | NOT NULL    |      |       |
# | current_battle_id | Current battle   | integer(8)  |             |      | B     |
# | online_at         | Online at        | datetime    |             |      |       |
# | fighting_at       | Fighting at      | datetime    |             |      |       |
# | matching_at       | Matching at      | datetime    |             |      |       |
# | cpu_brain_key     | Cpu brain key    | string(255) |             |      |       |
# | user_agent        | User agent       | string(255) | NOT NULL    |      |       |
# | lifetime_key      | Lifetime key     | string(255) | NOT NULL    |      | C     |
# | platoon_key       | Platoon key      | string(255) | NOT NULL    |      | D     |
# | self_preset_key   | Self preset key  | string(255) | NOT NULL    |      | E     |
# | oppo_preset_key   | Oppo preset key  | string(255) | NOT NULL    |      | F     |
# | robot_accept_key  | Robot accept key | string(255) | NOT NULL    |      | G     |
# | race_key          | Race key         | string(255) | NOT NULL    |      | H     |
# | created_at        | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime    | NOT NULL    |      |       |
# |-------------------+------------------+-------------+-------------+------+-------|

module Fanta
  class UsersController < ApplicationController
    include ModulableCrud::All

    before_action only: [:edit, :update, :destroy] do
      unless current_user == current_record
        unless Rails.env.test?
          redirect_to :root, alert: "アクセス権限がありません"
        end
      end
    end

    def show
      @js_user_profile = ams_sr(current_record, serializer: UserProfileSerializer, include: {battles: {memberships: :user}})
    end

    def redirect_to_where
      # [:fanta, :battles]
      # [:edit, :fanta, current_record]
      # [:edit, :fanta, current_record]
      current_record
    end
  end
end
