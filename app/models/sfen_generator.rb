module SfenGenerator
  extend self

  def start_from(location)
    location = Bioshogi::Location.fetch(location)
    "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL #{location.to_sfen} - 1"
    # "position sfen 9/9/9/9/9/9/9/9/9 #{location.to_sfen} - 1"
  end
end
