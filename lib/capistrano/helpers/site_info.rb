# 未使用

class SiteInfo
  include MemoryRecord
  memory_record [
    { key: :production, url: "https://www.shogi-extend.com/", },
    { key: :staging,    url: "https://shogi-flow.xyz/",       },
  ]
end
