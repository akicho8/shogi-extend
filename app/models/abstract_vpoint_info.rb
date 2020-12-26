# |--------+-------+------+------+-------+--------------------------------------|
# | 手合   | 開始  | 手数 | 合計 | even? | 画像                                 |
# |--------+-------+------+------+-------+--------------------------------------|
# | 平手   | ▲(0) |    0 |    0 | true  | △が指したと見なして反転             |
# | 平手   | ▲(0) |    1 |    1 |       | ▲が指したことわかるように反転しない |
# | 平手   | ▲(0) |    2 |    2 | true  | △が指したので反転する               |
# | 駒落ち | △(1) |    0 |    1 |       | ▲が指したと見なして反転しない       |
# | 駒落ち | △(1) |    1 |    2 | true  | △が指したので反転する               |
# | 駒落ち | △(1) |    2 |    3 |       | ▲が指したので反転しない             |
# |--------+-------+------+------+-------+--------------------------------------|
class AbstractVpointInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :self,     name: "自分", image_vpoint: -> e { e.even? ? :white : :black }, board_vpoint: -> e { e.odd? ? :white : :black } },
    { key: :opponent, name: "相手", image_vpoint: -> e { e.odd? ? :white : :black  }, board_vpoint: -> e { e.odd? ? :white : :black } },
    { key: :black,    name: "☗",   image_vpoint: -> e { :black                    }, board_vpoint: -> e { :black                   } },
    { key: :white,    name: "☖",   image_vpoint: -> e { :white                    }, board_vpoint: -> e { :white                   } },
  ]
end
