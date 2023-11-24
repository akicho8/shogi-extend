module Swars
  class BanInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "OFF", select_option: false, name: "",                       },
      { key: "ON",  select_option: true,  name: "相手が牢獄に入っている", },
    ]
  end
end
