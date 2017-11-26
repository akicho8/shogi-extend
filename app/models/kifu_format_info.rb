class KifuFormatInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "csa", },
    {key: "kif", },
    {key: "ki2", },
  ]

  def name
    key.to_s
  end
end
