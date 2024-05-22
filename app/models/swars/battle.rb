# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | name          | desc             | type        | opts        | refs              | index |
# |---------------+------------------+-------------+-------------+-------------------+-------|
# | id            | ID               | integer(8)  | NOT NULL PK |                   |       |
# | key           | 対局ユニークキー | string(255) | NOT NULL    |                   | A!    |
# | battled_at    | 対局日時         | datetime    | NOT NULL    |                   | B     |
# | csa_seq       | 棋譜             | text(65535) | NOT NULL    |                   |       |
# | win_user_id   | 勝者             | integer(8)  |             | => Swars::User#id | C     |
# | turn_max      | 手数             | integer(4)  | NOT NULL    |                   | D     |
# | meta_info     | メタ情報         | text(65535) | NOT NULL    |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime    | NOT NULL    |                   | E     |
# | sfen_body     | SFEN形式棋譜     | text(65535) | NOT NULL    |                   |       |
# | sfen_hash     | Sfen hash        | string(255) | NOT NULL    |                   |       |
# | start_turn    | 開始局面         | integer(4)  |             |                   | F     |
# | critical_turn | 開戦             | integer(4)  |             |                   | G     |
# | outbreak_turn | Outbreak turn    | integer(4)  |             |                   | H     |
# | image_turn    | OGP画像の局面    | integer(4)  |             |                   |       |
# | created_at    | 作成日時         | datetime    | NOT NULL    |                   |       |
# | updated_at    | 更新日時         | datetime    | NOT NULL    |                   |       |
# | xmode_id      | Xmode            | integer(8)  | NOT NULL    |                   | I     |
# | preset_id     | Preset           | integer(8)  | NOT NULL    | => Preset#id      | J     |
# | rule_id       | Rule             | integer(8)  | NOT NULL    |                   | K     |
# | final_id      | Final            | integer(8)  | NOT NULL    |                   | L     |
# |---------------+------------------+-------------+-------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

module Swars
  class Battle < ApplicationRecord
    include BattleModelMethods
    include ViewHelperMethods
    include PresetMethods
    include ImportMethods
    include CleanupMethods
    include CoreMethods
    include BasicMethods
    include StatMethods
    include Stat2Methods
    include HelperMethods
    include SearchMethods
  end
end
