# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+--------------+-------------+------+-------|
# | name          | desc             | type         | opts        | refs | index |
# |---------------+------------------+--------------+-------------+------+-------|
# | id            | ID               | integer(8)   | NOT NULL PK |      |       |
# | key           | 対局ユニークキー | string(255)  | NOT NULL    |      | A!    |
# | battled_at    | 対局日時         | datetime     | NOT NULL    |      | F     |
# | rule_key      | ルール           | string(255)  | NOT NULL    |      | B     |
# | csa_seq       | 棋譜             | text(65535)  | NOT NULL    |      |       |
# | final_key     | 結末             | string(255)  | NOT NULL    |      | C     |
# | win_user_id   | 勝者             | integer(8)   |             |      | D     |
# | turn_max      | 手数             | integer(4)   | NOT NULL    |      | G     |
# | meta_info     | メタ情報         | text(65535)  | NOT NULL    |      |       |
# | accessed_at   | 最終アクセス日時 | datetime     | NOT NULL    |      |       |
# | outbreak_turn | Outbreak turn    | integer(4)   |             |      | E     |
# | created_at    | 作成日時         | datetime     | NOT NULL    |      |       |
# | updated_at    | 更新日時         | datetime     | NOT NULL    |      |       |
# | preset_key    | 手合割           | string(255)  | NOT NULL    |      |       |
# | start_turn    | 開始局面         | integer(4)   |             |      |       |
# | critical_turn | 開戦             | integer(4)   |             |      | H     |
# | saturn_key    | 公開範囲         | string(255)  | NOT NULL    |      | I     |
# | sfen_body     | SFEN形式棋譜     | string(8192) |             |      |       |
# | image_turn    | OGP画像の局面    | integer(4)   |             |      |       |
# |---------------+------------------+--------------+-------------+------+-------|

module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerBaseMethods
    include BattleControllerSharedMethods
    include ExternalAppMod
    include ZipDlMod
    include RememberSwarsUserKeysMod
    include IndexMod
    include ShowMod

    def create
      import_process(flash)     # これはなに……？？？
      flash[:import_skip] = true
      redirect_to [:swars, :battles, query: current_swars_user]
    end

    concerning :EditCustomMethods do
      def js_edit_options
        super.merge({
            run_mode: "view_mode",
          })
      end
    end
  end
end
