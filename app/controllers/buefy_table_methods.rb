module BuefyTableMethods
  extend ActiveSupport::Concern

  included do
    let :current_query do
      params[:query].presence
    end

    let :current_records do
      current_scope.select(current_model.column_names - exclude_column_names).page(params[:page]).per(current_per)
    end

    let :exclude_column_names do
      ["meta_info"]
    end

    let :current_per do
      (params[:per].presence || (Rails.env.production? ? 25 : 25)).to_i
    end

    let :current_sort_column do
      params[:sort_column].presence || default_sort_column
    end

    let :default_sort_column do
      "created_at"
    end

    let :current_sort_order do
      params[:sort_order].presence || "desc"
    end

    let :current_placeholder do
      ""
    end

    let :pure_current_scope do
      current_model.all
    end

    let :current_scope do
      s = pure_current_scope
      if r = current_ransack
        s = s.merge(r.result)
      end
      if current_sort_column && current_sort_order
        s = s.order(current_sort_column => current_sort_order)
      end
      s = s.order(id: :desc)
      s
    end

    let :current_ransack do
      if current_query
        current_model.ransack(title_or_description_cont: current_query)
      end
    end

    let :js_index_options do
      {
        query: current_query || "",
        xhr_index_path: polymorphic_path([ns_prefix, current_plural_key], format: "json"),
        total: current_records.total_count,
        page: current_records.current_page,
        per: current_per,
        sort_column: current_sort_column,
        sort_order: current_sort_order,
        sort_order_default: "desc", # カラムをクリックしたときの最初の向き
        # records: js_current_records,
        records: [],
        table_columns_hash: Rails.env.production? ? table_columns_hash : table_columns_hash.transform_values { |e| e.merge(visible: true) },
      }
    end
  end

  def show
    if request.xhr? && request.format.json?
      render json: { sp_sfen: current_record.sfen }
      return
    end

    super
  end
end
