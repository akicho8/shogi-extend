class PaletteInfo
  include PaletteMethods
  include ApplicationMemoryRecord
  memory_record [
    # https://bulma.io/documentation/modifiers/color-helpers/
    { key: :info,    hsl: [204 / 360.0, 0.86, 0.53], },
    { key: :danger,  hsl: [348 / 360.0, 1.00, 0.61], },
    { key: :primary, hsl: [171 / 360.0, 1.00, 0.41], },
    { key: :warning, hsl: [ 48 / 360.0, 1.00, 0.67], },
    { key: :success, hsl: [141 / 360.0, 0.71, 0.48], },
    { key: :link,    hsl: [217 / 360.0, 0.71, 0.53], },
  ]
end
