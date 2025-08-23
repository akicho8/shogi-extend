# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
# | name              | desc              | type           | opts                | refs              | index |
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
# | id                | ID                | integer(8)     | NOT NULL PK         |                   |       |
# | key               | 対局ユニークキー  | string(255)    | NOT NULL            |                   | A!    |
# | battled_at        | 対局日時          | datetime       | NOT NULL            |                   | C     |
# | csa_seq           | 棋譜              | text(16777215) | NOT NULL            |                   |       |
# | win_user_id       | 勝者              | integer(8)     |                     | => Swars::User#id | B     |
# | turn_max          | 手数              | integer(4)     | NOT NULL            |                   | D     |
# | meta_info         | メタ情報          | text(16777215) | NOT NULL            |                   |       |
# | created_at        | 作成日時          | datetime       | NOT NULL            |                   | M     |
# | updated_at        | 更新日時          | datetime       | NOT NULL            |                   |       |
# | start_turn        | 開始局面          | integer(4)     |                     |                   |       |
# | critical_turn     | 開戦              | integer(4)     |                     |                   | E     |
# | sfen_body         | SFEN形式棋譜      | text(65535)    | NOT NULL            |                   |       |
# | image_turn        | OGP画像の局面     | integer(4)     |                     |                   |       |
# | outbreak_turn     | Outbreak turn     | integer(4)     |                     |                   | F     |
# | accessed_at       | 最終アクセス日時  | datetime       | NOT NULL            |                   | G     |
# | sfen_hash         | Sfen hash         | string(255)    |                     |                   |       |
# | xmode_id          | Xmode             | integer(8)     | NOT NULL            |                   | H     |
# | preset_id         | Preset            | integer(8)     | NOT NULL            | => Preset#id      | I     |
# | rule_id           | Rule              | integer(8)     | NOT NULL            |                   | J     |
# | final_id          | Final             | integer(8)     | NOT NULL            |                   | K     |
# | analysis_version  | Analysis version  | integer(4)     | DEFAULT(0) NOT NULL |                   |       |
# | starting_position | Starting position | string(255)    |                     |                   |       |
# | imode_id          | Imode             | integer(8)     | NOT NULL            |                   | L     |
# |-------------------+-------------------+----------------+---------------------+-------------------+-------|
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
    include Kento::Controller
    include ShowMod
    include RescueMod

    before_action do
      @xnotice = Xnotice.new
    end
  end
end
