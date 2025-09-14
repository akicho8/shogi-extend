module PaletteMethods
  extend ActiveSupport::Concern

  def pie_color
    @pie_color ||= color.css_rgba(0.6)
  end

  def border_color
    @border_color ||= color.css_rgba(0.6)
  end

  def background_color
    @background_color ||= color.css_rgba(0.1)
  end

  private

  def color
    @color ||= Color::HSL.from_fraction(*hsl)
  end
end
