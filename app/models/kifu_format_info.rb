class KifuFormatInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "ki2", },
    {key: "kif", },
    {key: "csa", },
    {key: "sfen", },
  ]

  def name
    @name ||= key.to_s.upcase
  end
end
