module Api
  class XmoviesController < ::Api::ApplicationController
    FAST_RESPONSE = nil
    VALIDATE_TURN_MAX = 1525

    # curl http://localhost:3000/api/xmovie/latest_info_reload.json
    # ../../../nuxt_side/components/Xmovie/XmovieApp.vue
    def latest_info_reload
      if !current_user
        render json: {}
        return
      end

      render json: {}
      return
    end

    # curl -d _method=post http://localhost:3000/api/xmovie/record_create.json
    # ../../../nuxt_side/components/Xmovie/app_form.js
    def record_create
      if !current_user
        render html: "ログインしてください"
        return
      end

      # 予約数制限
      if c = current_reserve_limit
        if current_user.xmovie_records.not_done_only.count > c
          render json: { error_message: "投入しすぎです" }
          return
        end
      end

      free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "adapter", user: current_user)

      if free_battle.turn_max > VALIDATE_TURN_MAX
        render json: { error_message: "手数が長すぎます" }
        return
      end

      # 将来的には KIF などはここですぐ返したらいいんでは？
      if FAST_RESPONSE && free_battle.turn_max <= FAST_RESPONSE
        generator = BoardFileGenerator.new(free_battle, params[:convert_params])
        generator.generate_unless_exist
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

      # if xmovie_record = XmovieRecord.find_by(recordable: current_record)
      #   # render html: xmovie_record.to_html
      #   render html: [xmovie_record.status_key, XmovieRecord.info.to_html].join.html_safe
      #   return
      # end

      xmovie_record = current_user.xmovie_records.create!(recordable: free_battle, convert_params: params.to_unsafe_h[:xmovie_record_params])
      if false
        xmovie_record.main_process!
      else
        current_user.my_records_singlecast
        XmovieRecord.everyone_broadcast
        XmovieRecord.zombie_kill # ゾンビを成仏させる
        XmovieRecord.background_job_kick
        render json: {
          response_hash: {
            xmovie_record: xmovie_record.as_json,
            free_battle: free_battle.as_json,
            # xmovie_info: XmovieRecord.xmovie_info,
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
      (params[:reserve_limit].presence || XmovieRecord.user_queue_max).to_i
    end
  end
end
