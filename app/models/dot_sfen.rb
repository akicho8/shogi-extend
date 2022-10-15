module DotSfen
  extend self

  # SFENの " " を "." に変更
  def escape(sfen)
    if sfen.start_with?("position ")
      sfen = sfen.tr(" ", ".")
    end
    sfen
  end

  # SFENの "." を " " に変更
  def unescape(sfen)
    if sfen.start_with?("position.")
      sfen = sfen.tr(".", " ")
    end
    sfen
  end

  def space_to_dot_replace(sfen)
    sfen.gsub(/\s+/, ".")
  end
end
