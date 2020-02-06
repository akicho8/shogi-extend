class ZipKifuInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :kif,  },
    { key: :ki2,  },
    { key: :csa,  },
    { key: :sfen, },
  ]

  def name
    key.upcase
  end

  def as_json(*)
    super.merge(name: name)
  end
end
