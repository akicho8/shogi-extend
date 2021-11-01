export const DotSfen = {
  // SFENの " " を "." に変更
  escape(sfen) {
    if (sfen.startsWith("position ")) {
      sfen = sfen.replace(/\s+/g, ".")
    }
    return sfen
  },

  // SFENの "." を " " に変更
  unescape(sfen) {
    if (sfen.startsWith("position.")) {
      sfen = sfen.replace(/\.+/, " ")
    }
    return sfen
  },
}
