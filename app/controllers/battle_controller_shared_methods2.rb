module BattleControllerSharedMethods2
  extend ActiveSupport::Concern

  included do
    helper_method :current_query
    helper_method :current_per
    helper_method :modal_record_twitter_options
    helper_method :current_placeholder
    helper_method :current_mode
  end

  mlet :current_query do
    params[:query].presence
  end

  mlet :current_queries do
    if current_query
      current_query.scan(/\P{Space}+/)
    end
  end

  mlet :current_records do
    current_scope.tap do |s|
      s = s.select(current_model.column_names - exclude_column_names)
      if current_sort_column && current_sort_order
        s = s.order(current_sort_column => current_sort_order)
      end
      s = s.order(id: :desc)
      s.page(params[:page]).per(current_per)
    end
  end

  mlet :exclude_column_names do
    [
      "meta_info",
    ]
  end

  mlet :current_per do
    (params[:per].presence || current_per_default).to_i
  end

  mlet :current_per_default do
    Rails.env.production? ? 25 : 25
  end

  mlet :current_sort_column do
    params[:sort_column].presence || default_sort_column
  end

  mlet :default_sort_column do
    "created_at"
  end

  mlet :current_sort_order do
    params[:sort_order].presence || current_sort_order_default
  end

  mlet :current_sort_order_default do
    "desc"
  end

  mlet :current_placeholder do
    ""
  end

  mlet :pure_current_scope do
    current_model.all
  end

  mlet :current_scope do
    s = pure_current_scope

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

    if r = current_ransack
      s = s.merge(current_model.ransack(r).result)
    end

    # if current_user
    #   current_user
    # end

    s
  end

  mlet :current_ransack do
    if current_queries
      {
        title_or_description_cont_all: current_queries,
      }
    end
  end

  mlet :js_modal_record do
    if modal_record
      js_modal_record_for(modal_record)
    end
  end

  mlet :modal_record do
    if v = params[:modal_id]
      current_scope.find(v)
    end
  end

  mlet :js_table_columns_hash do
    table_columns_hash.inject({}) do |a, e|
      visible = e[:visible]
      if visible_columns
        visible = visible_columns.include?(e[:key].to_s)
      end
      visible ||= !Rails.env.production?
      a.merge(e[:key] => e.merge(visible: visible))
    end
  end

  mlet :visible_columns do
    if v = params[:visible_columns]
      v.scan(/\w+/).to_set
    end
  end

  mlet :js_show_options do
    js_modal_record_for(current_record)
  end

  mlet :js_edit_ogp_options do
    js_show_options
  end

  mlet :current_mode do
    (params[:mode].presence || :basic).to_sym
  end

  mlet :show_twitter_options do
    options = {}
    options[:title] = current_record.to_title
    options[:url] = current_record.tweet_modal_url
    options[:description] = current_record.description

    if twitter_staitc_image_url
      options[:image] = twitter_staitc_image_url
    else
      options[:card] = "summary"
    end

    options
  end

  mlet :modal_record_twitter_options do
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

      if e.thumbnail_image.attached?
        options[:image] = polymorphic_url([ns_prefix, e], format: "png", updated_at: e.updated_at.to_i)
      else
        options[:card] = "summary"
      end

      options
    end
  end

  mlet :current_search_scope_key do
    (params[:search_scope_key].presence || SearchScopeInfo.fetch(:ss_public).key).to_sym
  end

  mlet :js_index_options do
    {
      query: current_query || "",
      search_scope_key: current_search_scope_key,
      xhr_index_path: polymorphic_path([ns_prefix, current_plural_key]),
      total: current_records.total_count, # ここで事前にSQLが走るのは仕方ない
      page: current_records.current_page,
      per: current_per,
      sort_column: current_sort_column,
      sort_order: current_sort_order,
      sort_order_default: "desc", # カラムをクリックしたときの最初の向き
      records: [],                # JS側から最初のリクエストをしない場合は js_current_records を渡す
      table_columns_hash: js_table_columns_hash,
      modal_record: js_modal_record,
    }
  end

  mlet :twitter_staitc_image_url do
    # rails_representation_path(current_record.thumbnail_image.variant(resize: "1200x630!", type: :grayscale))
    # とした場合はリダイレクトするURLになってしまうため使えない
    # 固定URL化する
    polymorphic_url([ns_prefix, current_record], format: "png", updated_at: current_record.updated_at.to_i)
  end

  def show
    if request.xhr? && request.format.json?
      render json: { sfen_body: current_record.existing_sfen }
      return
    end

    super
  end

  def js_record_for(e)
    e.as_json(methods: [
        :sp_turn,
        :og_turn,
      ]).tap do |a|
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

  def js_modal_record_for(e)
    js_record_for(e).tap do |a|
      a[:sfen_body] ||= e.existing_sfen
      if v = current_force_turn
        a[:force_turn] = v
      end
    end
  end

  def current_force_turn
    if v = (params[:force_turn] || params[:turn]).presence
      v.to_i
    end
  end
end
