# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lemon (kiwi_lemons as Kiwi::Lemon)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | all_params       | All params       | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
# | file_size        | File size        | integer(4)  |             |                            |       |
# | ffprobe_info     | Ffprobe info     | text(65535) |             |                            |       |
# | browser_path     | Browser path     | string(255) |             |                            |       |
# | filename_human   | Filename human   | string(255) |             |                            |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Kiwi
  class LemonsController < ApplicationController
    LOGIN_REQUIRED = true

    if LOGIN_REQUIRED
      if false
        before_action :authenticate_xuser! # 使用禁止。これは current_user の管理と異なる
      else
        before_action do
          unless current_user
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
          unless media_builder.real_path.exist?
            raise ActionController::RoutingError, "ファイルが生成されていません"
          end
          send_file_with_range media_builder.real_path, type: Mime[media_builder.recipe_info.real_ext], disposition: params[:disposition] || "inline", filename: lemon.filename_human
        }
      end
    end
  end
end
