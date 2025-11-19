# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 動画 (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+--------------------------+-------------+-------------+------+-------|
# | name             | desc                     | type        | opts        | refs | index |
# |------------------+--------------------------+-------------+-------------+------+-------|
# | id               | ID                       | integer(8)  | NOT NULL PK |      |       |
# | user_id          | 所有者                   | integer(8)  | NOT NULL    |      | A     |
# | recordable_type  | 棋譜情報(クラス名)       | string(255) | NOT NULL    |      | B     |
# | recordable_id    | 棋譜情報                 | integer(8)  | NOT NULL    |      | B     |
# | all_params       | 変換用全パラメータ       | text(65535) | NOT NULL    |      |       |
# | process_begin_at | 開始日時                 | datetime    |             |      | C     |
# | process_end_at   | 終了日時(失敗時も入る)   | datetime    |             |      | D     |
# | successed_at     | 正常終了日時             | datetime    |             |      | E     |
# | errored_at       | 失敗終了日時             | datetime    |             |      | F     |
# | error_message    | エラー文言               | text(65535) |             |      |       |
# | content_type     | 動画タイプ               | string(255) |             |      |       |
# | file_size        | 動画サイズ               | integer(4)  |             |      |       |
# | ffprobe_info     | ffprobeの内容            | text(65535) |             |      |       |
# | browser_path     | 動画WEBパス              | string(255) |             |      |       |
# | filename_human   | 動画の人間向けファイル名 | string(255) |             |      |       |
# | created_at       | 作成日時                 | datetime    | NOT NULL    |      | G     |
# | updated_at       | 更新日時                 | datetime    | NOT NULL    |      |       |
# |------------------+--------------------------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :recordable, polymorphic: true を追加しよう
# [Warning: Need to add relation] Kiwi::Lemon モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

module Kiwi
  class LemonsController < ApplicationController
    LOGIN_REQUIRED = true

    if LOGIN_REQUIRED
      if false
        before_action :authenticate_xuser! # 使用禁止。これは current_user の管理と異なる
      else
        before_action do
          if !current_user
            redirect_to :login
          end
        end
      end
    end

    # ダウンロードさせるためにいったんRails側から送信している
    # が、system下のファイルに直リンクできるので不要かもしれない
    #
    # ファイルが生成されていません の確認用
    # http://localhost:3000/animation-files/148?cache_delete=1
    #
    # ここで生成する
    # http://localhost:3000/animation-files/148?cache_delete=1&not_exist_then_build=1
    #
    # JSON確認
    # http://localhost:3000/animation-files/148.json
    def show
      if LOGIN_REQUIRED
        scope = current_user.kiwi_lemons
      else
        scope = Kiwi::Lemon.all
      end
      lemon = Kiwi::Lemon.find(params[:id])
      media_builder = lemon.media_builder
      if Rails.env.development?
        if params[:cache_delete]
          media_builder.cache_delete
        end
        if params[:not_exist_then_build]
          media_builder.not_exist_then_build
        end
      end
      respond_to do |format|
        format.json {
          render json: lemon.as_json(Kiwi::Lemon.json_struct_for_done_record)
        }
        format.all {
          if !lemon.real_path.exist?
            raise ActionController::RoutingError, "ファイルが生成されていません"
          end
          send_file_with_range lemon.real_path, type: Mime[media_builder.recipe_info.real_ext], disposition: params[:disposition] || "inline", filename: lemon.filename_human
        }
      end
    end
  end
end
