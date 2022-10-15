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

  def urlsafe_escape(sfen)
    Base64.urlsafe_encode64(sfen)
  end

  def urlsafe_unescape(sfen)
    Base64.urlsafe_decode64(sfen)
  end
end
