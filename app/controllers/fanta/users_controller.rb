# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (fanta_users as Fanta::User)
#
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|
# | カラム名      | 意味                                                                     | タイプ      | 属性        | 参照 | INDEX |
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|
# | id            | ID                                                                       | integer(8)  | NOT NULL PK |      |       |
# | key           | Key                                                                      | string(255) | NOT NULL    |      | A!    |
# | name          | 名前                                                                     | string(255) | NOT NULL    |      |       |
# | online_at     | オンラインになった日時                                                   | datetime    |             |      |       |
# | fighting_at   | memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる | datetime    |             |      |       |
# | matching_at   | マッチング中(開始日時)                                                   | datetime    |             |      |       |
# | cpu_brain_key | Cpu brain key                                                            | string(255) |             |      |       |
# | user_agent    | ブラウザ情報                                                             | string(255) | NOT NULL    |      |       |
# | race_key      | Race key                                                                 | string(255) | NOT NULL    |      | B     |
# | created_at    | 作成日時                                                                 | datetime    | NOT NULL    |      |       |
# | updated_at    | 更新日時                                                                 | datetime    | NOT NULL    |      |       |
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|

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
