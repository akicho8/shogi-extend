module BattleControllerSharedMethods
  extend ActiveSupport::Concern

  include ShogiErrorRescueMethods
  include EncodeMethods
  include KifShowMethods
  include SortMethods
  include PageMethods

  concerning :IndexMethods do
    def current_records
      @current_records ||= yield_self do
        s = current_index_scope
        s = s.select(current_model.column_names - exclude_column_names)
        s = sort_scope(s)
        s = page_scope(s)
      end
    end

    def exclude_column_names
      ["meta_info"]
    end

    def js_index_options
      {
        :query   => current_query || "",
        :records => js_current_records,                  # JS側から最初のリクエストをしない場合は js_current_records を渡す
      }.merge(page_info(current_records), sort_info)
    end

    private

    # FIXME: flashが動作しない
    def behavior_after_rescue(message)
      redirect_to [:swars, :battles], danger: message
    end
  end

  concerning :QueryMethods do
    def current_query
      params[:query].presence
    end

    def query_info
      @query_info ||= QueryInfo.parse(current_query)
    end
  end

  concerning :ShowMethods do
    included do
      before_action only: [:edit, :update, :destroy] do
        if request.format.html?
          if !editable_record?(current_record)
            message = ["アクセス権限がありません"]
            if Rails.env.development?
              message << "(フッターのデバッグリンクから任意のユーザーまたは admin でログインしよう)"
            end
            if Rails.env.test?
            else
              redirect_to :root, alert: message.join
            end
          end
        end
      end
    end

    def show
      access_log_create(current_record)

      if request.format.json?
        if params[:formal_sheet]
          render json: decorator.as_json
          return
        end

        if params[:basic_fetch]
          render json: js_record_for(current_record)
          return
        end

        if params[:basic_and_time_chart_fetch]
          render json: {
            **js_record_for(current_record),
            time_chart_params: current_record.time_chart_params,
          }
          return
        end

        render json: { sfen_body: current_record.sfen_body }
        return
      end

      respond_to do |format|
        format.html
        format.png {
          # params2 = params.slice(*Bioshogi::BinaryFormatter.all_options.keys)
          media_builder = MediaBuilder.new(current_record, params.merge(recipe_key: :is_recipe_png))
          send_file_or_redirect(media_builder)
        }
        # if Rails.env.development?
        #   format.gif {
        #     media_builder = MediaBuilder.new(current_record, params.merge(recipe_key: :is_recipe_gif))
        #
        #     # FIXME: リダイレクト
        #
        #     # url = UrlProxy.full_url_for(path: media_builder.to_browser_path)
        #     # render html: url
        #     # return
        #
        #     if media_builder.file_exist?
        #       send_file_or_redirect(media_builder)
        #       return
        #     end
        #
        #     if !current_user
        #       render html: "ログインしよう"
        #       return
        #     end
        #
        #     if lemon = Kiwi::Lemon.find_by(recordable: current_record)
        #       # render html: lemon.to_html
        #       render html: [lemon.status_key, Kiwi::Lemon.info.to_html].join.html_safe
        #       return
        #     end
        #
        #     lemon = Kiwi::Lemon.create!(recordable: current_record, user: current_user, all_params: params.to_unsafe_h)
        #     if false
        #       lemon.main_process
        #     else
        #       Kiwi::Lemon.background_job_kick_if_period
        #     end
        #
        #     render html: "GIF#{lemon.status_key}<br>終わったら #{current_user.email} に通知します#{Kiwi::Lemon.info.to_html}#{Kiwi::Lemon.order(:id).to_html}".html_safe
        #   }
        # end
        format.any { kif_data_send }
      end
    end

    def send_file_or_redirect(media_builder)
      if current_disposition == :attachment
        send_file media_builder.to_real_path, type: Mime[media_builder.recipe_info.real_ext], disposition: current_disposition, filename: current_filename
      else
        redirect_to media_builder.to_browser_path
      end
    end

    def access_log_create(record)
      if from_crawl_bot?
        return
      end
      record.update_columns(:accessed_at => Time.current)
    end

    def decorator
      @decorator ||= current_record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
    end

    def js_record_for(e)
      e.as_json(
        only: [
          :id,
          :key,
          :sfen_body,

          :turn_max,
          :image_turn,
          :start_turn,
          :critical_turn,
          :outbreak_turn,
          :battled_at,
        ],
        methods: [
          :display_turn,
          :player_info,
          :title,
          :description,
          :piyo_shogi_base_params,
        ],
        ).tap do |a|
        a[:show_path] = polymorphic_path([ns_prefix, e])
      end
    end
  end

  concerning :EditMethods do
    def current_edit_mode
      @current_edit_mode ||= (params[:edit_mode].presence || :basic).to_sym
    end
  end
end
