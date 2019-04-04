class PaletteInfo
  include ApplicationMemoryRecord
  memory_record [
    # https://bulma.io/documentation/modifiers/color-helpers/
    { key: :primary, hsl: [171 / 360.0, 1.00, 0.41], },
    { key: :danger,  hsl: [348 / 360.0, 1.00, 0.61], },
    { key: :link,    hsl: [217 / 360.0, 0.71, 0.53], },
    { key: :warning, hsl: [ 48 / 360.0, 1.00, 0.67], },
    { key: :info,    hsl: [204 / 360.0, 0.86, 0.53], },
    { key: :success, hsl: [141 / 360.0, 0.71, 0.48], },
  ]

  def pie_color
    @pie_color ||= color.css_rgba(0.6)
  end

  def border_color
    @border_color ||= color.css_rgba(0.5)
  end

  def background_color
    @background_color ||= color.css_rgba(0.1)
  end

  private

  def color
    @color ||= Color::HSL.from_fraction(*hsl)
  end
end
