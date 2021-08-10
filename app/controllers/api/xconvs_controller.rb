module Api
  class XconvsController < ::Api::ApplicationController
    FAST_RESPONSE = nil

    # curl -d _method=post http://localhost:3000/api/xconv/record_create.json
    # ../../../front_app/components/Xconv/app_form.js
    def record_create
      if !current_user
        render html: "ログインしてください"
        return
      end

      # 予約数制限
      if c = current_reserve_limit
        if current_user.xconv_records.not_done_only.count > c
          render json: { error_message: "投入しすぎ" }
          return
        end
      end

      free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "adapter", user: current_user)

      # 将来的には KIF などはここですぐ返したらいいんでは？
      if FAST_RESPONSE && free_battle.turn_max <= FAST_RESPONSE
        generator = BoardBinaryGenerator.new(free_battle, params[:convert_params])
        generator.not_found_then_generate
        render json: {
          response_hash: {
            url: generator.browser_url,
            free_battle: free_battle.as_json, # フロント側では未使用
          }
        }
        return
      end

      # if !current_user
      #   render html: "ログインしてください"
      #   return
      # end

      # if xconv_record = XconvRecord.find_by(recordable: current_record)
      #   # render html: xconv_record.to_html
      #   render html: [xconv_record.status_info, XconvRecord.info.to_html].join.html_safe
      #   return
      # end

      xconv_record = current_user.xconv_records.create!(recordable: free_battle, convert_params: params.to_unsafe_h[:xconv_record_params])
      if false
        xconv_record.main_process!
      else
        XconvRecord.xconv_info_broadcast
        XconvRecord.background_job_kick
        render json: {
          response_hash: {
            xconv_record: xconv_record.as_json,
            free_battle: free_battle.as_json,
            # xconv_info: XconvRecord.xconv_info,
          }
        }
        return
      end

      # # render html: url
      # # return
      #
      # if generator.file_exist?
      #   send_file_or_redirect(generator)
      #   return
      # end
      #
    end

    def current_reserve_limit
      if current_user
        if current_user.permit_tag_list.include?("staff") && false
          nil
        else
          reserve_limit_default
        end
      else
        0
      end
    end

    # 予約可能な数(処理中を含む)
    def reserve_limit_default
      (params[:reserve_limit].presence || 3).to_i
    end
  end
end
