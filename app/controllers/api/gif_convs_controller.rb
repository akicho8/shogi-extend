# generator = BoardGifGenerator.new(current_record, params)
#
# # url = UrlProxy.wrap2(path: generator.to_browser_path)
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
# if henkan_record = HenkanRecord.find_by(recordable: current_record)
#   # render html: henkan_record.to_html
#   render html: [henkan_record.status_name, HenkanRecord.info.to_html].join.html_safe
#   return
# end
#
# henkan_record = HenkanRecord.create!(recordable: current_record, user: current_user, generator_params: params.to_unsafe_h)
# if false
#   henkan_record.main_process!
# else
#   HenkanRecord.background_job_kick
# end
#
# render html: "GIF#{henkan_record.status_name}<br>終わったら #{current_user.email} に通知します#{HenkanRecord.info.to_html}#{HenkanRecord.order(:id).to_html}".html_safe

module Api
  class GifConvsController < ::Api::ApplicationController
    SUGUYARU_MAX = nil

    # curl -d _method=post http://localhost:3000/api/gif_conv/record_create.json
    def record_create
      free_battle = FreeBattle.create!(kifu_body: params[:body], use_key: "adapter", user: current_user)

      if SUGUYARU_MAX && free_battle.turn_max <= SUGUYARU_MAX
        generator = BoardGifGenerator.new(free_battle, generator_params)
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

      # if henkan_record = HenkanRecord.find_by(recordable: current_record)
      #   # render html: henkan_record.to_html
      #   render html: [henkan_record.status_name, HenkanRecord.info.to_html].join.html_safe
      #   return
      # end

      henkan_record = HenkanRecord.create!(recordable: free_battle, user: current_user, generator_params: generator_params)
      if false
        henkan_record.main_process!
      else
        HenkanRecord.teiki_haisin_bc
        HenkanRecord.background_job_kick
        render json: {
          response_hash: {
            henkan_record: henkan_record.as_json,
            free_battle: free_battle.as_json,
            # teiki_haisin: HenkanRecord.teiki_haisin,
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
      # if henkan_record = HenkanRecord.find_by(recordable: free_battle)
      #   # render html: henkan_record.to_html
      #   render html: [henkan_record.status_name, HenkanRecord.info.to_html].join.html_safe
      #   return
      # end
      #
      # henkan_record = HenkanRecord.create!(recordable: free_battle, user: current_user, generator_params: params.to_unsafe_h)
      # if false
      #   henkan_record.main_process!
      # else
      #   HenkanRecord.background_job_kick
      # end
      #
      # render html: "GIF#{henkan_record.status_name}<br>終わったら #{current_user.email} に通知します#{HenkanRecord.info.to_html}#{HenkanRecord.order(:id).to_html}".html_safe

      # render json: { record: record.as_json(methods: [:all_kifs, :display_turn, :piyo_shogi_base_params]) }
    end

    def generator_params
      v = params.to_unsafe_h
      v.extract!(:controller, :action, :format) # TODO: format が BoardGifGenerator のオプションと干渉している
      v.extract!(:body)
      v
    end
  end
end
