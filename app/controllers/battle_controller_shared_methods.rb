module BattleControllerSharedMethods
  extend ActiveSupport::Concern

  include ShogiErrorRescueMethods
  include EncodeMethods
  include KifShowMethods
  include KentoJsonMethods
  include SortMethods
  include PageMethods

  concerning :IndexMethods do
    let :current_records do
      s = current_index_scope
      s = s.select(current_model.column_names - exclude_column_names)
      s = sort_scope(s)
      s = page_scope(s)
    end

    def exclude_column_names
      ["meta_info"]
    end

    def current_placeholder
      ""
    end

    let :visible_only_keys do
      if v = params[:visible_only_keys]
        v.scan(/\w+/).to_set
      end
    end

    def js_index_options
      {
        :query              => current_query || "",
        :display_key        => params[:display_key].presence || "table",
        :table_columns_hash => table_columns_hash,
        :records            => js_current_records,                  # JS側から最初のリクエストをしない場合は js_current_records を渡す
      }.merge(page_info(current_records), sort_info)
    end

    private

    # FIXME: flashが動作しない
    def behavior_after_rescue(message)
      redirect_to [:swars, :battles], danger: message
    end
  end

  concerning :QueryMethods do
    let :current_query do
      params[:query].presence
    end

    let :current_queries do
      if current_query
        current_query.scan(/\P{Space}+/)
      end
    end

    let :query_info do
      QueryInfo.parse(current_query)
    end

    let :query_hash do
      query_info.attributes
    end

    let :current_scope do
      s = current_model.all
      s = tag_scope_add(s)

      if v = query_info.lookup_one(:date)
        v = v.to_time.midnight
        s = s.where(battled_at: v...v.tomorrow)
      end

      if v = query_info.lookup(:ids)
        s = s.where(id: v)
      end
      s
    end

    def tag_scope_add(s)
      if v = query_info.lookup(:tag)
        s = s.tagged_with(v)
      end

      if v = query_info.lookup(:or_tag)
        s = s.tagged_with(v, any: true)
      end

      if v = query_info.lookup(:exclude_tag)
        s = s.tagged_with(v, exclude: true)
      end

      s
    end

    def table_columns_hash
      v = table_column_list.inject({}) do |a, e|
        visible = e[:visible]   # nil の場合もある
        if visible_only_keys
          visible = visible_only_keys.include?(e[:key].to_s)
        end
        if Rails.env.development? || Rails.env.test?
          visible = true
        end
        a.merge(e[:key] => e.merge(visible: visible))
      end
    end
  end

  concerning :ShowMethods do
    included do
      before_action only: [:edit, :update, :destroy] do
        if request.format.html?
          unless editable_record?(current_record)
            message = ["アクセス権限がありません"]
            if Rails.env.development?
              message << "(フッターのデバッグリンクから任意のユーザーまたは sysop でログインしてください)"
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
      end

      if request.format.json?
        if params[:basic_fetch]
          render json: js_record_for(current_record)
          return
        end
      end

      if request.format.json?
        if params[:time_chart_fetch]
          render json: { time_chart_params: current_record.time_chart_params }
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
        #       render html: "ログインしてください"
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
      if from_googlebot?
        return
      end
      record.update_columns(accessed_at: Time.current)
    end

    let :decorator do
      current_record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
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
        a[:show_path] = polymorphic_path([ns_prefix, e]) # ← これはとりあえずいる kc_path などに渡している
      end
    end
  end

  concerning :EditMethods do
    let :current_edit_mode do
      (params[:edit_mode].presence || :basic).to_sym
    end
  end
end
