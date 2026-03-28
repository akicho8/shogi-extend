// 全体で overscroll-behavior: none すると Mac PC では左フリックが効かなくなるため共有将棋盤内でのみ左右も禁止する

export const mod_screen_flick_disable = {
  // mounted() {
  //   document.querySelector("html").setAttribute("style", "overscroll-behavior: none")
  //   document.querySelector("body").setAttribute("style", "overscroll-behavior: none")
  // },
  // beforeDestroy() {
  //   document.querySelector("html").setAttribute("style", "")
  //   document.querySelector("body").setAttribute("style", "")
  // },
}
