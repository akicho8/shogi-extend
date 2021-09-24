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
