module Api
  class XconvsController < ::Api::ApplicationController
    FAST_RESPONSE = nil

    # curl -d _method=post http://localhost:3000/api/xconv/record_create.json
    def record_create
      free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "adapter", user: current_user)

      if FAST_RESPONSE && free_battle.turn_max <= FAST_RESPONSE
        generator = BoardImageGenerator.new(free_battle, convert_params)
        generator.not_found_then_generate
        url = UrlProxy.wrap2(path: generator.to_browser_path)
        render json: {
          response_hash: {
            url: url,
            free_battle: free_battle.as_json,
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

      xconv_record = XconvRecord.create!(recordable: free_battle, user: current_user, convert_params: convert_params)
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
      # if !current_user
      #   render html: "ログインしてください"
      #   return
      # end
      #
      # if xconv_record = XconvRecord.find_by(recordable: free_battle)
      #   # render html: xconv_record.to_html
      #   render html: [xconv_record.status_info, XconvRecord.info.to_html].join.html_safe
      #   return
      # end
      #
      # xconv_record = XconvRecord.create!(recordable: free_battle, user: current_user, convert_params: params.to_unsafe_h)
      # if false
      #   xconv_record.main_process!
      # else
      #   XconvRecord.background_job_kick
      # end
      #
      # render html: "GIF#{xconv_record.status_info}<br>終わったら #{current_user.email} に通知します#{XconvRecord.info.to_html}#{XconvRecord.order(:id).to_html}".html_safe

      # render json: { record: record.as_json(methods: [:all_kifs, :display_turn, :piyo_shogi_base_params]) }
    end

    def convert_params
      v = params.to_unsafe_h
      v.extract!(:controller, :action, :format) # TODO: format が BoardGifGenerator のオプションと干渉している
      v.extract!(:body)
      v
    end
  end
end
