class PaletteInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :primary, css_color: "hsl(171, 100%, 41%)", },
    { key: :info,    css_color: "hsl(204, 86%, 53%)",  },
    { key: :link,    css_color: "hsl(217, 71%, 53%)",  },
    { key: :success, css_color: "hsl(141, 71%, 48%)",  },
    { key: :warning, css_color: "hsl(48, 100%, 67%)",  },
    { key: :danger,  css_color: "hsl(348, 100%, 61%)", },
  ]
end
