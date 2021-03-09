module PageMethods
  extend ActiveSupport::Concern

  def default_per
    Kaminari.config.default_per_page
  end

  def current_per
    [(params[:per].presence || default_per).to_i, 1].max
  end

  def current_page
    [params[:page].to_i, 1].max
  end

  def page_scope(s)
    s.page(current_page).per(current_per)
  end

  def page_info(s)
    {
      :total => s.total_count,
      :page  => s.current_page,
      :per   => current_per,
    }
  end
end
