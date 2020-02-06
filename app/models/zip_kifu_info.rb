class ZipKifuInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :kif, },
    { key: :ki2, },
  ]

  def name
    key.upcase
  end

  def as_json(*)
    super.merge(name: name)
  end
end
