export const DotSfen = {
  escape(sfen) {
    if (sfen.startsWith("position ")) {
      sfen = sfen.replace(/\s+/g, ".")
    }
    return sfen
  },
  unescape(sfen) {
    if (sfen.startsWith("position.")) {
      sfen = sfen.replace(/\.+/g, " ")
    }
    return sfen
  }
}
