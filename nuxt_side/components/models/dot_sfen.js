export const DotSfen = {
  // SFENの " " を "." に変更
  escape(sfen) {
    return this.space_to_dot_replace(sfen)
  },

  space_to_dot_replace(sfen) {
    return sfen.replace(/\s+/g, ".")
  },

  // SFENの "." を " " に変更
  // unescape(sfen) {
  //   if (sfen.startsWith("position.")) {
  //     sfen = sfen.replace(/\.+/, " ")
  //   }
  //   return sfen
  // },
}
