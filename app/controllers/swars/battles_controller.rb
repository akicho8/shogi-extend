# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+-------------+---------------------+-------------------+-------|
# | name          | desc             | type        | opts                | refs              | index |
# |---------------+------------------+-------------+---------------------+-------------------+-------|
# | id            | ID               | integer(8)  | NOT NULL PK         |                   |       |
# | key           | 対局ユニークキー | string(255) | NOT NULL            |                   | A!    |
# | battled_at    | 対局日時         | datetime    | NOT NULL            |                   | B     |
# | rule_key      | ルール           | string(255) | NOT NULL            |                   | C     |
# | csa_seq       | 棋譜             | text(65535) | NOT NULL            |                   |       |
# | final_key     | 結末             | string(255) | NOT NULL            |                   | D     |
# | win_user_id   | 勝者             | integer(8)  |                     | => Swars::User#id | E     |
# | turn_max      | 手数             | integer(4)  | NOT NULL            |                   | F     |
# | meta_info     | メタ情報         | text(65535) | NOT NULL            |                   |       |
# | accessed_at   | 最終アクセス日時 | datetime    | NOT NULL            |                   | G     |
# | preset_key    | 手合割           | string(255) | NOT NULL            |                   | H     |
# | sfen_body     | SFEN形式棋譜     | text(65535) | NOT NULL            |                   |       |
# | sfen_hash     | Sfen hash        | string(255) | NOT NULL            |                   |       |
# | start_turn    | 開始局面         | integer(4)  |                     |                   | I     |
# | critical_turn | 開戦             | integer(4)  |                     |                   | J     |
# | outbreak_turn | Outbreak turn    | integer(4)  |                     |                   | K     |
# | image_turn    | OGP画像の局面    | integer(4)  |                     |                   |       |
# | created_at    | 作成日時         | datetime    | NOT NULL            |                   |       |
# | updated_at    | 更新日時         | datetime    | NOT NULL            |                   |       |
# | xmode_id      | Xmode            | integer(8)  | DEFAULT(1) NOT NULL |                   | L     |
# | preset_id     | Preset           | integer(8)  |                     | => Preset#id      | M     |
# | rule_id       | Rule             | integer(8)  |                     |                   | N     |
# | final_id      | Final            | integer(8)  |                     |                   | O     |
# |---------------+------------------+-------------+---------------------+-------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# 【警告:リレーション欠如】Swars::Userモデルで has_many :swars/battles されていません
#--------------------------------------------------------------------------------

# http://localhost:3000/w.json?query=devuser1
module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerBaseMethods
    include BattleControllerSharedMethods
    include ZipDlMethods
    include RememberSwarsUserKeysMethods
    include IndexMethods
    include ShowMethods
  end
end
