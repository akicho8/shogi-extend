module SfenGenerator
  extend self

  def start_from(location)
    location = Bioshogi::Location.fetch(location)
    # board = "9/9/9/9/9/9/9/9/9"
    board = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
    sfen = "position sfen #{board} #{location.to_sfen} - 1"
    DotSfen.space_to_dot_replace(sfen)
  end
end
