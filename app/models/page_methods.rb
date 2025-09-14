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

  def xpage_info(s)
    {
      :total_count    => s.total_count,
      :current_page   => s.current_page,
      :limit_value    => s.limit_value,
      :total_pages    => s.total_pages,
      :next_page      => s.next_page,
      :prev_page      => s.prev_page,
      :first_page_p   => s.first_page?,
      :last_page_p    => s.last_page?,
      :out_of_range_p => s.out_of_range?,
    }
  end
end
