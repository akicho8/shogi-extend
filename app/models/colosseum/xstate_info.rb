module Colosseum
  class XstateInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :st_before,     name: "開始前", color: "has-text-success", },
      { key: :st_battle_now, name: "対局中", color: "has-text-danger",  },
      { key: :st_done,       name: "終局",   color: "",                 },
    ]
  end
end
