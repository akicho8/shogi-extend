# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対戦部屋テーブル (battles as Fanta::Battle)
#
# |-------------------------+-------------------------+-------------+---------------------+------+-------|
# | カラム名                | 意味                    | タイプ      | 属性                | 参照 | INDEX |
# |-------------------------+-------------------------+-------------+---------------------+------+-------|
# | id                      | ID                      | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key        | Black preset key        | string(255) | NOT NULL            |      |       |
# | white_preset_key        | White preset key        | string(255) | NOT NULL            |      |       |
# | lifetime_key            | Lifetime key            | string(255) | NOT NULL            |      |       |
# | team_key             | Team key             | string(255) | NOT NULL            |      |       |
# | full_sfen          | Kifu body sfen          | text(65535) | NOT NULL            |      |       |
# | clock_counts            | Clock counts            | text(65535) | NOT NULL            |      |       |
# | countdown_flags     | Countdown mode hash     | text(65535) | NOT NULL            |      |       |
# | turn_max                | Turn max                | integer(4)  | NOT NULL            |      |       |
# | battle_request_at       | Battle request at       | datetime    |                     |      |       |
# | auto_matched_at         | Auto matched at         | datetime    |                     |      |       |
# | begin_at                | Begin at                | datetime    |                     |      |       |
# | end_at                  | End at                  | datetime    |                     |      |       |
# | last_action_key         | Last action key         | string(255) |                     |      |       |
# | win_location_key        | Win location key        | string(255) |                     |      |       |
# | current_users_count     | Current users count     | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count | Watch memberships count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at              | 作成日時                | datetime    | NOT NULL            |      |       |
# | updated_at              | 更新日時                | datetime    | NOT NULL            |      |       |
# |-------------------------+-------------------------+-------------+---------------------+------+-------|

class CreateFanta < ActiveRecord::Migration[5.1]
  def change
    # ユーザー
    create_table :fanta_users, force: true do |t|
      t.string :key,                null: false, index: {unique: true}, comment: "キー"
      t.string :name,               null: false,              comment: "名前"
      t.datetime :online_at,        null: true,               comment: "オンラインになった日時"
      t.datetime :fighting_at,      null: true,               comment: "memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる"
      t.datetime :matching_at,      null: true,               comment: "マッチング中(開始日時)"
      t.string :cpu_brain_key,      null: true,               comment: "CPUだったときの挙動"
      t.string :user_agent,         null: false,              comment: "ブラウザ情報"
      t.string :race_key,           null: false, index: true, comment: "種族"
      t.timestamps                  null: false
    end

    # プロフィール
    create_table :fanta_profiles, force: true do |t|
      t.belongs_to :user,        null: false, comment: "ユーザー"
      t.text :begin_greeting_message,  null: false, comment: "対局開始時のあいさつ"
      t.text :end_greeting_message, null: false, comment: "対局終了時のあいさつ"
      t.timestamps               null: false
    end

    # 希望ルール
    create_table :fanta_rules, force: true do |t|
      t.belongs_to :user,         null: false,              comment: "ユーザー"
      t.string :lifetime_key,     null: false, index: true, comment: "ルール・持ち時間"
      t.string :team_key,      null: false, index: true, comment: "ルール・人数"
      t.string :self_preset_key,  null: false, index: true, comment: "ルール・自分の手合割"
      t.string :oppo_preset_key,  null: false, index: true, comment: "ルール・相手の手合割"
      t.string :robot_accept_key, null: false, index: true, comment: "CPUと対戦するかどうか"
      t.timestamps                null: false
    end

    # 部屋
    create_table :fanta_battles, force: true do |t|
      t.string :black_preset_key,                 null: false, comment: "▲手合割"
      t.string :white_preset_key,                 null: false, comment: "△手合割"
      t.string :lifetime_key,                     null: false, comment: "時間"
      t.string :team_key,                      null: false, comment: "人数"
      t.text :full_sfen,                          null: false, comment: "USI形式棋譜"
      t.text :clock_counts,                       null: false, comment: "対局時計情報"
      t.text :countdown_flags,                    null: false, comment: "秒読み状態"
      t.integer :turn_max,                        null: false, comment: "手番数"
      t.datetime :battle_request_at,              null: true,  comment: "対局申し込みによる成立日時"
      t.datetime :auto_matched_at,                null: true,  comment: "自動マッチングによる成立日時"
      t.datetime :begin_at,                       null: true,  comment: "メンバーたち部屋に入って対局開始になった日時"
      t.datetime :end_at,                         null: true,  comment: "バトル終了日時"
      t.string :last_action_key,                  null: true,  comment: "最後の状態"
      t.string :win_location_key,                 null: true,  comment: "勝った方の先後"
      t.integer :memberships_count, default: 0,   null: false, comment: "対局者総数"
      t.integer :watch_ships_count, default: 0,   null: false, comment: "観戦者数"
      t.timestamps                                null: false
    end

    # 対局者
    create_table :fanta_memberships, force: true do |t|
      t.belongs_to :battle,   null: false,               comment: "部屋"
      t.belongs_to :user,     null: false,               comment: "ユーザー"
      t.string :preset_key,   null: false,               comment: "手合割"
      t.string :location_key, null: false, index: true,  comment: "先後"
      t.integer :position,                  index: true, comment: "入室順序"
      t.datetime :standby_at,                            comment: "準備完了日時"
      t.datetime :fighting_at,                           comment: "部屋に入った日時で抜けたり切断すると空"
      t.datetime :time_up_at,                            comment: "タイムアップしたのを検知した日時"
      t.timestamps            null: false
    end

    # 観戦者
    create_table :fanta_watch_ships, force: true do |t|
      t.belongs_to :battle, null: false, comment: "部屋"
      t.belongs_to :user,   null: false, comment: "ユーザー"
      t.timestamps          null: false
    end

    # 対局部屋のチャット発言
    create_table :fanta_chat_messages, force: true do |t|
      t.belongs_to :battle, null: false, comment: "部屋"
      t.belongs_to :user,   null: false, comment: "ユーザー"
      t.text :message,      null: false, comment: "発言"
      t.text :msg_options,     null: false
      t.timestamps          null: false
    end

    # ロビーチャット発言
    create_table :fanta_lobby_messages, force: true do |t|
      t.belongs_to :user,   null: false, comment: "ユーザー"
      t.text :message,      null: false, comment: "発言"
      t.text :msg_options,     null: false
      t.timestamps          null: false
    end
  end
end
