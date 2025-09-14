module SortMethods
  extend ActiveSupport::Concern

  def sort_scope(s)
    if sort_column && sort_order
      s = s.order(sort_column => sort_order)
      s = s.order(id: :desc) # 順序揺れ防止策
    end
    s
  end

  def sort_column
    params[:sort_column].presence || sort_column_default
  end

  def sort_column_default
    "created_at"
  end

  def sort_order
    params[:sort_order].presence || sort_order_default
  end

  def sort_order_default
    "desc"
  end

  def sort_info
    {
      :sort_column        => sort_column,
      :sort_order         => sort_order,
      :sort_order_default => sort_order_default,
    }
  end
end
