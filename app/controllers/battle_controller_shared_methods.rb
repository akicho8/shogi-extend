module BattleControllerSharedMethods
  extend ActiveSupport::Concern

  concerning :IndexMethods do
    included do
      helper_method :current_per
      helper_method :current_placeholder
      helper_method :current_mode
      helper_method :js_index_options

      rescue_from "Bioshogi::BioshogiError" do |exception|
        if request.format.json?
          render json: {error_message: exception.message.lines.first.strip}
        else
          h = ApplicationController.helpers
          lines = exception.message.lines
          message = lines.first.strip.html_safe
          if field = lines.drop(1).presence
            message += h.tag.div(field.join.html_safe, :class => "error_message_pre").html_safe
          end
          if v = exception.backtrace
            message += h.tag.div(v.first(8).join("\n").html_safe, :class => "error_message_pre").html_safe
          end
          behavior_after_rescue(message)
        end
      end

      before_action do
        if params[:modal_id] && !modal_record
          flash.now[:alert] = "#{params[:modal_id]} に対応するレコードが見つかりませんでした"
        end
      end
    end

    let :current_records do
      s = current_scope
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
      Rails.env.production? ? 25 : 25
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

    let :visible_columns do
      if v = params[:visible_columns]
        v.scan(/\w+/).to_set
      end
    end

    let :current_mode do
      (params[:mode].presence || :basic).to_sym
    end

    def js_index_options
      {
        query: current_query || "",
        search_scope_key: current_search_scope_key,
        xhr_index_path: polymorphic_path([ns_prefix, current_plural_key]),
        total: current_records.total_count, # ここで事前にSQLが走るのは仕方ない
        page: current_records.current_page,
        per: current_per,
        sort_column: sort_column,
        sort_order: sort_order,
        sort_order_default: "desc", # カラムをクリックしたときの最初の向き
        records: [],                # JS側から最初のリクエストをしない場合は js_current_records を渡す
        table_columns_hash: js_table_columns_hash,
        modal_record: js_modal_record,
      }
    end

    private

    def zip_download_limit
      (params[:limit].presence || AppConfig[:zip_download_limit_default]).to_i.clamp(0, AppConfig[:zip_download_limit_max])
    end

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
      if r = ransack_params
        s = s.merge(current_model.ransack(r).result)
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
        s = s.where(Battle.arel_table[:turn_max].gteq(v))
      end

      if v = query_hash.dig(:turn_max_lt)&.first
        s = s.where(Battle.arel_table[:turn_max].lt(v))
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

    def js_table_columns_hash
      table_columns_hash.inject({}) do |a, e|
        visible = e[:visible]
        if visible_columns
          visible = visible_columns.include?(e[:key].to_s)
        end
        visible ||= !Rails.env.production?
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
          options[:title] = "#{e.to_title}【#{v}手目】"
        else
          options[:title] = e.to_title
        end

        if v = current_force_turn
          options[:url] = e.tweet_modal_url(turn: v)
        else
          options[:url] = e.tweet_modal_url
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
        if record = current_scope.find_by(id: v)
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

    private

    def current_force_turn
      if v = (params[:force_turn] || params[:turn]).presence
        v.to_i
      end
    end
  end

  concerning :ShowMethods do
    included do
      helper_method :js_show_options
      helper_method :show_twitter_options

      before_action only: [:edit, :update, :destroy] do
        if request.format.html?
          unless editable_record?(current_record)
            message = ["アクセス権限がありません"]
            if Rails.env.development?
              message << "(フッターのデバッグリンクから任意のユーザーまたは sysop でログインしてください)"
            end
            redirect_to :root, alert: message
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

      respond_to do |format|
        format.html
        format.png { png_file_send }
        format.any { kif_data_send }
      end
    end

    let :js_show_options do
      js_modal_record_for(current_record)
    end

    let :show_twitter_options do
      options = {}
      options[:title] = current_record.to_title
      options[:url] = current_record.tweet_modal_url
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
      e.as_json(
        only: [
          :id,
          :key,
          # :battled_at,
          :turn_max,
          # :preset_key,
          # :start_turn,
          # :critical_turn,
          :saturn_key,
          :sfen_body,
          :image_turn,
          :sp_turn,
          :og_turn,
        ],
        methods: [
          :sp_turn,
          :og_turn,
        ],
        ).tap do |a|

        a[:kifu_copy_params] = e.to_kifu_copy_params(view_context)
        a[:sp_sfen_get_path] = polymorphic_path([ns_prefix, e], format: "json")
        a[:xhr_put_path] = url_for([ns_prefix, e, format: "json"]) # FIXME: ↑とおなじ
        a[:piyo_shogi_app_url] = piyo_shogi_app_url(full_url_for([e, format: "kif"]))
        a[:battled_at] = e.battled_at.to_s(:battle_time)
        a[:show_path] = polymorphic_path([ns_prefix, e])
        a[:tweet_origin_image_path] = e.tweet_origin_image_path
        a[:tweet_window_url] = e.tweet_window_url
        a[:tweet_modal_url] = e.tweet_modal_url
        a[:kifu_canvas_image_attached] = e.thumbnail_image.attached?
        if editable_record?(e) || Rails.env.development?
          a[:edit_path] = polymorphic_path([:edit, ns_prefix, e])
        end
      end
    end

    def access_log_create(record)
    end

    private

    def png_file_send
      # 手数の指定があればリアルタイムに作成
      if current_force_turn
        user_params = params.to_unsafe_h.symbolize_keys.transform_values { |e| Float(e) rescue e }
        options = current_record.image_default_options.merge(user_params)
        png = Rails.cache.fetch(options, expires_in: Rails.env.production? ? 1.days : 0) do
          parser = Bioshogi::Parser.parse(current_record.existing_sfen, typical_error_case: :embed, turn_limit: current_force_turn)
          parser.to_png(options)
        end
        send_data png, type: Mime[:png], disposition: :inline, filename: "#{current_record.id}-#{current_force_turn}.png"
        return
      end

      # 画像がなければ作る
      current_record.image_auto_cerate_onece
      key = current_record.tweet_image.processed.key
      path = ActiveStorage::Blob.service.path_for(key)
      send_file path, type: current_record.thumbnail_image.content_type, disposition: :inline, filename: "#{current_record.id}.png"
    end

    concerning :KifDataSendMethods do
      private

      # curl -I http://localhost:3000/x/1.kif?inline=1
      # curl -I http://localhost:3000/x/1.kif?plain=1
      def kif_data_send
        require "kconv"

        text_body = current_record.to_cached_kifu(params[:format])

        if params[:copy_trigger]
          SlackAgent.message_send(key: "#{params[:format]}コピー", body: current_record.to_title)
        end

        # 激指ではクリップボードは UTF8 でないと読めない
        # if sjis_p?
        #   text_body = text_body.tosjis
        # end

        if params[:plain].present?
          render plain: text_body
          return
        end

        if params[:inline].present?
          disposition = "inline"
        else
          disposition = "attachment"

          # ↓これをやるとコピーのときに sjis 化されてぴよで読み込めなくなる
          #
          # iPhone で「ダウンロード」としたときだけ文字化けする対策(sjisなら文字化けない)
          # if mobile_agent?
          #   text_body = text_body.tosjis
          # end
        end

        send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{current_encode}"), disposition: disposition)
      end

      def current_filename
        "#{current_record.key}.#{params[:format]}"
      end

      def current_encode
        params[:encode].presence || current_encode_default
      end

      def current_encode_default
        if sjis_p?
          "sjis"
        else
          "utf8"
        end
      end

      def sjis_p?
        request.user_agent.to_s.match(/Windows/i) || params[:shift_jis].present? || params[:sjis].present?
      end
    end
  end

  concerning :EditMethods do
    let :js_edit_ogp_options do
      js_show_options
    end

    def update
      if v = params[:image_turn]
        current_record.update!(image_turn: v)
      end

      if params[:canvas_image_base64_data_url]
        render json: current_record.canvas_data_save(params)
        return
      end

      if params[:gazodetukuru]
        render json: current_record.canvas_data_save2(params)
        return
      end

      if params[:og_image_destroy]
        render json: current_record.canvas_data_destroy(params)
        return
      end

      super
    end
  end
end
