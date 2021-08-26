class XmoviesController < ApplicationController
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
  # http://localhost:3000/animation-files/148?cache_delete=1&generate_unless_exist=1
  #
  # JSON確認
  # http://localhost:3000/animation-files/148.json
  def show
    if LOGIN_REQUIRED
      scope = current_user.xmovie_records
    else
      scope = XmovieRecord.all
    end
    xmovie_record = XmovieRecord.find(params[:id])
    generator = xmovie_record.generator
    if Rails.env.development?
      if params[:cache_delete]
        generator.cache_delete
      end
      if params[:generate_unless_exist]
        generator.generate_unless_exist
      end
    end
    respond_to do |format|
      format.json {
        render json: xmovie_record.as_json(XmovieRecord.json_struct_for_done_record)
      }
      format.all {
        unless generator.real_path.exist?
          raise ActionController::RoutingError, "ファイルが生成されていません"
        end
        send_file_with_range generator.real_path, type: Mime[generator.recipe_info.real_ext], disposition: params[:disposition] || "inline", filename: xmovie_record.filename_human
      }
    end
  end
end
