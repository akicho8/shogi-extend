class KifuFormatInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "kif", },
    {key: "csa", },
    {key: "ki2", },
  ]

  def name
    @name ||= key.to_s.upcase
  end
end
