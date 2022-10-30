# 勝ち負けの色

class WinLosePaletteInfo
  include ApplicationMemoryRecord
  memory_record [
    # https://bulma.io/documentation/modifiers/color-helpers/
    { key: :win,  hsl: [204 / 360.0, 0.86, 0.53], },
    { key: :lose, hsl: [348 / 360.0, 0,    0.61], },
  ]

  include PaletteMethods
end
