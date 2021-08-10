class XconvsController < ApplicationController
  before_action :authenticate_xuser!

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
    xconv_record = current_user.xconv_records.find(params[:id])
    generator = xconv_record.generator
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
        render json: xconv_record.as_json
      }
      format.all {
        unless generator.real_path.exist?
          raise ActionController::RoutingError, "ファイルが生成されていません"
        end
        send_file generator.real_path, type: Mime[generator.xout_format_info.real_ext], disposition: :disposition, filename: generator.filename
      }
    end
  end
end
