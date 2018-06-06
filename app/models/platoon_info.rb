class PlatoonInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :versus_p1,  name: "タイマン", count: 1, },
    {key: :number_of_people2,  name: "ダブルス", count: 2, },
    {key: :number_of_people4,  name: "チーム戦", count: 4, },
  ]
end
