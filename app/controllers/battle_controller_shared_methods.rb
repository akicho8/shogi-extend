module BattleControllerSharedMethods
  extend ActiveSupport::Concern

  include ShogiErrorRescueMod
  include EncodeMod
  include KifShowMod
  include PngShowMod
  include KentoJsonMod
  include ModalMod

  concerning :IndexMethods do
    included do
      helper_method :current_per
      helper_method :current_placeholder
      helper_method :js_index_options

      before_action do
        if params[:modal_id] && !modal_record
          flash.now[:alert] = "#{params[:modal_id]} に対応するレコードが見つかりませんでした"
        end
      end
    end

    let :current_records do
      s = current_index_scope
      s = s.select(current_model.column_names - exclude_column_names)
      if sort_column && sort_order
        s = s.order(sort_column => sort_order) # 1番目 order(battled_at: :desc)
      end
      s = s.order(id: :desc)                   # 2番目 order(id: desc)
      s.page(params[:page]).per(current_per)
    end

    def exclude_column_names
      ["meta_info"]
    end

    let :current_per do
      (params[:per].presence || default_per).to_i
    end

    def default_per
      Kaminari.config.default_per_page
    end

    def sort_column
      params[:sort_column].presence || default_sort_column
    end

    def default_sort_column
      "created_at"
    end

    def sort_order
      params[:sort_order].presence || sort_order_default
    end

    def sort_order_default
      "desc"
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
        :query                           => current_query || "",
        :modal_record                    => js_modal_record,
        :search_scope_key                => current_search_scope_key,
        :board_show_type                 => params[:board_show_type].presence || "none",
        :xhr_index_path                  => polymorphic_path([ns_prefix, current_plural_key]),
        :total                           => current_records.total_count, # ここで事前にSQLが走るのは仕方ない
        :page                            => current_records.current_page,
        :per                             => current_per,
        :sort_column                     => sort_column,
        :sort_order                      => sort_order,
        :sort_order_default              => "desc",                      # カラムをクリックしたときの最初の向き
        :records                         => [],                          # JS側から最初のリクエストをしない場合は js_current_records を渡す
        :table_columns_hash              => table_columns_hash,
        :table_column_storage_prefix_key => controller_path,
        :zip_kifu_info                   => ZipKifuInfo.as_json,
      }
    end

    private

    def behavior_after_rescue(message)
      redirect_to :root, danger: message
    end
  end

  concerning :QueryMethods do
    included do
      helper_method :current_query
      helper_method :current_search_scope_key
    end

    let :current_search_scope_key do
      (params[:search_scope_key].presence || SearchScopeInfo.fetch(:ss_public).key).to_sym
    end

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

      s = search_scope_add(s)
      s = other_scope_add(s)
      if v = query_info.lookup(:ids)
        s = s.where(id: v)
      end
      if v = ransack_params
        if true
          s = s.merge(current_model.ransack(v).result)
        else
          # current_queries.each do |e|
          #   m = current_model
          #   w = m.where(["title LIKE BINARY ?", "%#{e}%"])
          #   w = w.or(m.where(["description LIKE BINARY ?", "%#{e}%"]))
          #   s = s.merge(w)
          # end
          # # raise s.to_sql.inspect
        end
      end
      s
    end

    def search_scope_add(s)
      case current_search_scope_key
      when :ss_public
        s = s.where(saturn_key: :public)
      when :ss_my_public
        s = s.where(saturn_key: :public)
        s = s.where(owner_user: current_user)
        unless current_user
          s = s.none
        end
      when :ss_my_private
        s = s.where(saturn_key: :private)
        s = s.where(owner_user: current_user)
        unless current_user
          s = s.none
        end
      when :ss_my_all
        s = s.where(owner_user: current_user)
        unless current_user
          s = s.none
        end
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

    def other_scope_add(s)
      if v = query_info.lookup_one(:turn_max_gteq)
        s = s.where(current_model.arel_table[:turn_max].gteq(v))
      end

      if v = query_info.lookup_one(:turn_max_lt)
        s = s.where(current_model.arel_table[:turn_max].lt(v))
      end

      s
    end

    def ransack_params
      if current_queries
        {
          title_or_description_cont_all: current_queries,
        }
      end
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
      helper_method :js_show_options
      helper_method :decorator
      helper_method :show_twitter_options

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
        if params[:time_chart_fetch]
          slack_message(key: "時間チャート", body: current_record.title)
          # Rails.logger.debug(current_record.time_chart_params)
          render json: { time_chart_params: current_record.time_chart_params }
          return
        end

        render json: { sfen_body: current_record.sfen_body }
        return
      end

      if params[:formal_sheet]
        if (Rails.env.production? || Rails.env.staging?) && !bot_agent?
          slack_message(key: "棋譜用紙", body: current_record.title)
        end

        # if !request.user_agent.to_s.match?(/\b(Chrome)\b/) || params[:formal_sheet_debug]
        #   flash.now[:warning] = "Safari では正しくレイアウトできてないので Google Chrome で開いてください"
        # end
      end

      respond_to do |format|
        format.html
        format.png { png_file_send }
        format.any { kif_data_send }
      end
    end

    def access_log_create(record)
      record.update_columns(accessed_at: Time.current)
    end

    let :js_show_options do
      a = {}
      a[:iframe_p]        = iframe_p
      a[:formal_sheet]    = !!params[:formal_sheet]
      a[:record]          = js_modal_record_for(current_record)

      if Rails.env.production? || Rails.env.staging?
        a[:close_back_path] = polymorphic_path([ns_prefix, current_plural_key])
      end

      # 重いので印刷するときだけ入れる
      if params[:formal_sheet]
        a[:decorator] = decorator.as_json
      end

      a
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
          :kento_app_path,
        ],
        ).tap do |a|

        a[:show_path]          = polymorphic_path([ns_prefix, e])
        if editable_record?(e) || Rails.env.development?
          a[:edit_path] = polymorphic_path([:edit, ns_prefix, e])
        end
      end
    end
  end

  concerning :EditMethods do
    included do
      helper_method :current_edit_mode
    end

    let :current_edit_mode do
      (params[:edit_mode].presence || :basic).to_sym
    end
  end

  concerning :EditCustomMethods do
    included do
      helper_method :js_edit_options
    end

    # free_battle_edit.js の引数用
    def js_edit_options
      {
        record_attributes: current_record.as_json,
        output_kifs: output_kifs,

        post_path: url_for([ns_prefix, current_plural_key, format: "json"]),
        new_path: polymorphic_path([:new, ns_prefix, current_single_key]),
        show_path: polymorphic_path([ns_prefix, current_record]),

        saturn_info: SaturnInfo.inject({}) { |a, e| a.merge(e.key => e.attributes) },
        free_battles_pro_mode: AppConfig[:free_battles_pro_mode],
        current_edit_mode: current_edit_mode,
      }
    end

    private

    # FIXME: これはやめて FreeBattle をつかうべき

    def output_kifs
      @output_kifs ||= KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => { key: e.key, name: e.name, value: heavy_parsed_info.public_send("to_#{e.key}", compact: true, no_embed_if_time_blank: true) }) }
    end

    def turn_max
      @turn_max ||= heavy_parsed_info.mediator.turn_info.turn_offset
    end

    def heavy_parsed_info
      @heavy_parsed_info ||= Bioshogi::Parser.parse(current_input_text, typical_error_case: :embed, support_for_piyo_shogi_v4_1_5: false)
    end

    def current_input_text
      params[:input_text] || current_record.sfen_body || ""
    end
  end
end
