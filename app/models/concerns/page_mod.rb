module PageMod
  extend ActiveSupport::Concern

  def default_per
    Kaminari.config.default_per_page
  end

  def current_per
    v = (params[:per].presence || default_per).to_i
    if v.positive?
      v
    end
  end

  def current_page
    params[:page].presence.to_i
  end

  def page_scope(s)
    if v = current_per.presence
      s = s.page(current_page).per(v)
    end
    s
  end

  def page_info(s)
    {
      :total => s.total_count,
      :page  => s.current_page,
      :per   => current_per,
    }
  end
end
