module Fanta
  class BehaviorInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :yowai_cpu,  name: "弱いCPU", auto_kotaeru: true,  auto_kangaeru: true,  auto_iku: true,  auto_sasu: true, },
      {key: :ningen,     name: "人間",    auto_kotaeru: false, auto_kangaeru: false, auto_iku: false, auto_sasu: false, },
    ]
  end
end
