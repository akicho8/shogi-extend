module SfenGenerator
  extend self

  def start_from(location)
    location = Bioshogi::Location.fetch(location)
    # board = "9/9/9/9/9/9/9/9/9"
    board = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
    "position sfen #{board} #{location.to_sfen} - 1"
  end

  def santeme_kakunari
    "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+"
  end
end
