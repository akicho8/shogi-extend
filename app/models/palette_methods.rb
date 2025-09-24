module PaletteMethods
  extend ActiveSupport::Concern

  def border_color
    @border_color ||= color.css(alpha: 0.6)
  end

  def background_color
    @background_color ||= color.css(alpha: 0.1)
  end

  private

  def color
    @color ||= Color::HSL.new(*hsl)
  end
end
