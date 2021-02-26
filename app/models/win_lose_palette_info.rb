class WinLosePaletteInfo
  include PaletteMethods
  include ApplicationMemoryRecord
  memory_record [
    # https://bulma.io/documentation/modifiers/color-helpers/
    # { key: :win,    hsl: [217 / 360.0, 0.71, 0.53], },
    { key: :win,    hsl: [204 / 360.0, 0.86, 0.53], },
    # { key: :win,  hsl: [171 / 360.0, 1.00, 0.41], },
    { key: :lose, hsl: [348 / 360.0, 0,    0.61], },
  ]
end
