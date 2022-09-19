export const Xstring = {
  // 文字列をクラス化
  // ただし window に結び付いてないと取得できない
  str_constantize(str) {
    return Function(`return ${str}`)()
  },
}
