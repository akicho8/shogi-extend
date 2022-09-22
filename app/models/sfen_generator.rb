module SfenGenerator
  extend self

  def start_from(location)
    location = Bioshogi::Location.fetch(location)
    "position sfen 9/9/9/9/9/9/9/9/9 #{location.to_sfen} - 1"
  end
end
