module BattleControllerSharedMethods
  extend ActiveSupport::Concern

  include ShogiErrorRescueMod
  include KifShowMod
  include KentoJsonMod

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
        s = s.order(sort_column => sort_order)
      end
      s = s.order(id: :desc)
      s.page(params[:page]).per(current_per)
    end

    let :exclude_column_names do
      [
        "meta_info",
      ]
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
        query: current_query || "",
        search_scope_key: current_search_scope_key,
        board_show_type: params[:board_show_type].presence || "none",
        xhr_index_path: polymorphic_path([ns_prefix, current_plural_key]),
        total: current_records.total_count, # ここで事前にSQLが走るのは仕方ない
        page: current_records.current_page,
        per: current_per,
        sort_column: sort_column,
        sort_order: sort_order,
        sort_order_default: "desc", # カラムをクリックしたときの最初の向き
        records: [],                # JS側から最初のリクエストをしない場合は js_current_records を渡す
        table_columns_hash: table_columns_hash,
        modal_record: js_modal_record,
        table_column_storage_prefix_key: controller_path,
        zip_kifu_info: ZipKifuInfo.as_json,
      }
    end

    private

    def behavior_after_rescue(message)
      redirect_to :root, danger: message
    end

    def as_b(v)
      v.to_s == "true" || v.to_s == "1"
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

    let :current_query_info do
      QueryInfo.parse(current_query)
    end

    let :query_hash do
      current_query_info.attributes
    end

    let :current_scope do
      s = current_model.all
      s = s.public_send("with_attached_#{'thumbnail_image'}")
      s = tag_scope_add(s)
      s = search_scope_add(s)
      s = other_scope_add(s)
      if v = query_hash.dig(:ids)
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
      if v = query_hash.dig(:tag)
        s = s.tagged_with(v)
      end

      if v = query_hash.dig(:or_tag)
        s = s.tagged_with(v, any: true)
      end

      if v = query_hash.dig(:exclude_tag)
        s = s.tagged_with(v, exclude: true)
      end

      s
    end

    def other_scope_add(s)
      if v = query_hash.dig(:turn_max_gteq)&.first
        s = s.where(current_model.arel_table[:turn_max].gteq(v))
      end

      if v = query_hash.dig(:turn_max_lt)&.first
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

  concerning :ModalMethods do
    included do
      helper_method :modal_record_twitter_options
    end

    let :modal_record_twitter_options do
      if e = modal_record
        options = {}

        if v = current_force_turn
          options[:title] = "#{e.title}【#{v}手目】"
        else
          options[:title] = e.title
        end

        if v = current_force_turn
          options[:url] = e.modal_on_index_url(turn: v)
        else
          options[:url] = e.modal_on_index_url
        end

        options[:description] = e.description
        options[:image] = twitter_staitc_image_url(e)

        options
      end
    end

    let :js_modal_record do
      if modal_record
        js_modal_record_for(modal_record)
      end
    end

    let :modal_record do
      if v = params[:modal_id]
        # record = current_scope.find_by(key: v) || current_scope.find_by(id: v)

        s = current_model

        record = s.find_by(key: v) # スコープを無視すること

        unless record
          # 元々公開しているものは id にアクセスできる
          record = s.where(saturn_key: :public).find_by(id: v)
        end

        if record
          access_log_create(record)
          record
        end
      end
    end

    def js_modal_record_for(e)
      js_record_for(e).tap do |a|
        a[:sfen_body] ||= e.existing_sfen
        if v = current_force_turn
          a[:force_turn] = v
        end
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
      if request.xhr? && request.format.json?
        render json: { sfen_body: current_record.existing_sfen }
        return
      end

      access_log_create(current_record)

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

    let :js_show_options do
      a = {}
      a[:record] = js_modal_record_for(current_record)
      a[:formal_sheet] = !!params[:formal_sheet]
      a[:decorator] = decorator.as_json
      a
    end

    let :decorator do
      current_record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
    end

    let :show_twitter_options do
      options = {}
      options[:title] = current_record.title
      options[:url] = current_record.modal_on_index_url
      options[:description] = current_record.description
      options[:image] = twitter_staitc_image_url(current_record)
      options
    end

    def twitter_staitc_image_url(record)
      # rails_representation_path(current_record.thumbnail_image.variant(resize: "1200x630!", type: :grayscale))
      # とした場合はリダイレクトするURLになってしまうため使えない
      # 固定URL化する
      polymorphic_url([ns_prefix, record], format: "png", updated_at: record.updated_at.to_i)
    end

    def js_record_for(e)
      # e.attributes は継承しない

      e.as_json(
        only: [
          :id,
          :key,
          # :battled_at,
          :turn_max,
          # :preset_key,
          # :start_turn,
          :critical_turn,
          :saturn_key,
          :sfen_body,
          :image_turn,
          :sp_turn,
          :og_turn,
        ],
        methods: [
          :sp_turn,
          :og_turn,
          :player_info,
        ],
        ).tap do |a|

        a[:fliped] = false      # free_battles の方では設定してないので初期値を入れとく

        a[:title] = e.title
        a[:description] = e.description
        a[:twitter_staitc_image_url] = twitter_staitc_image_url(e)
        a[:kifu_copy_params] = e.to_kifu_copy_params(view_context)
        a[:sp_sfen_get_path] = polymorphic_path([ns_prefix, e], format: "json")
        a[:xhr_put_path] = url_for([ns_prefix, e, format: "json"]) # FIXME: ↑とおなじ
        a[:piyo_shogi_app_url] = piyo_shogi_app_url(full_url_for([e, format: "kif"]))
        a[:kento_app_url] = kento_app_url_switch(e)
        a[:battled_at] = e.battled_at.to_s(:battle_time)
        a[:show_path] = polymorphic_path([ns_prefix, e])
        a[:formal_sheet_path] = polymorphic_path([ns_prefix, e], formal_sheet: true)
        a[:modal_on_index_url] = e.modal_on_index_url
        a[:kifu_canvas_image_attached] = e.thumbnail_image.attached?
        if editable_record?(e) || Rails.env.development?
          a[:edit_path] = polymorphic_path([:edit, ns_prefix, e])
        end
      end
    end

    def access_log_create(record)
    end

    private

    # KENTOに何を渡すか
    def kento_app_url_switch(record)
      # KIFを渡す
      if AppConfig[:kento_params_use_kifu_param_only]
        return kento_app_url(kifu: full_url_for([record, format: "kif"]))
      end

      # 平手から始まっているなら kif を渡す
      if false
        if record.sfen_body.start_with?("position startpos")
          args = { kifu: full_url_for([record, format: "kif"]) }
        else
          args = record.sfen_info.kento_app_query_hash
        end
        return kento_app_url(args)
      end

      # 常にSFENをURLパラメータとして生める
      kento_app_url(record.sfen_info.kento_app_query_hash)
    end

    def png_file_send
      disposition = params[:disposition] || :inline

      # 手数の指定があればリアルタイムに作成
      if current_force_turn && params[:dynamic]
        options = current_record.param_as_to_png_options(params.to_unsafe_h)
        png = Rails.cache.fetch(options, expires_in: (Rails.env.production? || Rails.env.staging?) ? 1.days : 0) do
          parser = Bioshogi::Parser.parse(current_record.existing_sfen, typical_error_case: :embed, turn_limit: current_force_turn)
          parser.to_png(options)
        end
        send_data png, type: Mime[:png], disposition: disposition, filename: "#{current_record.to_param}-#{current_force_turn}.png"
        return
      end

      # 画像がなければ1回だけ作る
      current_record.image_auto_cerate_onece(params.to_unsafe_h)
      if AppConfig[:force_convert_for_twitter_image]
        key = current_record.tweet_image.processed.key
      else
        key = current_record.thumbnail_image.key
      end
      path = ActiveStorage::Blob.service.path_for(key)
      send_file path, type: current_record.thumbnail_image.content_type, disposition: disposition, filename: "#{current_record.to_param}.png"
    end
  end

  concerning :EditMethods do
    included do
      helper_method :js_edit_ogp_options
      helper_method :current_edit_mode
    end

    let :current_edit_mode do
      (params[:edit_mode].presence || :basic).to_sym
    end

    let :js_edit_ogp_options do
      js_show_options.merge({
          index_path: polymorphic_path([ns_prefix, current_plural_key]),
        })
    end

    def update
      if v = params[:image_turn]
        current_record.update!(image_turn: v)
      end

      if params[:create_by_rmagick]
        render json: current_record.canvas_data_save_by_rmagick(params)
        return
      end

      if params[:og_image_destroy]
        render json: current_record.canvas_data_destroy(params)
        return
      end

      super
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
        xhr_put_path: url_for([ns_prefix, current_record, format: "json"]),

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
