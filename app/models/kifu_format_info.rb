class KifuFormatInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "ki2", },
    {key: "kif", },
    {key: "csa", },
  ]

  def name
    @name ||= key.to_s.upcase
  end
end
