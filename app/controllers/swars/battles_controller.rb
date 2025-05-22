# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
# | name              | desc              | type        | opts                | refs              | index |
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |                   |       |
# | key               | 対局ユニークキー  | string(255) | NOT NULL            |                   | A!    |
# | battled_at        | 対局日時          | datetime    | NOT NULL            |                   | B     |
# | csa_seq           | 棋譜              | text(65535) | NOT NULL            |                   |       |
# | win_user_id       | 勝者              | integer(8)  |                     | => Swars::User#id | C     |
# | turn_max          | 手数              | integer(4)  | NOT NULL            |                   | D     |
# | meta_info         | メタ情報          | text(65535) | NOT NULL            |                   |       |
# | accessed_at       | 最終アクセス日時  | datetime    | NOT NULL            |                   | E     |
# | sfen_body         | SFEN形式棋譜      | text(65535) | NOT NULL            |                   |       |
# | sfen_hash         | Sfen hash         | string(255) | NOT NULL            |                   |       |
# | start_turn        | 開始局面          | integer(4)  |                     |                   | F     |
# | critical_turn     | 開戦              | integer(4)  |                     |                   | G     |
# | outbreak_turn     | Outbreak turn     | integer(4)  |                     |                   | H     |
# | image_turn        | OGP画像の局面     | integer(4)  |                     |                   |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |                   |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |                   |       |
# | xmode_id          | Xmode             | integer(8)  | NOT NULL            |                   | I     |
# | preset_id         | Preset            | integer(8)  | NOT NULL            | => Preset#id      | J     |
# | rule_id           | Rule              | integer(8)  | NOT NULL            |                   | K     |
# | final_id          | Final             | integer(8)  | NOT NULL            |                   | L     |
# | analysis_version  | Analysis version  | integer(4)  | DEFAULT(0) NOT NULL |                   |       |
# | starting_position | Starting position | string(255) |                     |                   |       |
# | imode_id          | Imode             | integer(8)  | NOT NULL            |                   | M     |
# |-------------------+-------------------+-------------+---------------------+-------------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
# --------------------------------------------------------------------------------

# http://localhost:3000/w.json?query=DevUser1
module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerBaseMethods
    include BattleControllerSharedMethods

    include ScopeMod
    include IndexMod
    include ShowMod
    include ExceptionCatchMod

    before_action do
      @xnotice = Xnotice.new
    end
  end
end
