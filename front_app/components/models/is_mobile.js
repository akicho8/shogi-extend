/**
 * Mobile detection
 * https://www.abeautifulsite.net/detecting-mobile-devices-with-javascript
 */
export const isMobile = {
  Android() {
    return (
      typeof window !== 'undefined' &&
        window.navigator.userAgent.match(/Android/i)
    )
  },
  BlackBerry() {
    return (
      typeof window !== 'undefined' &&
        window.navigator.userAgent.match(/BlackBerry/i)
    )
  },
  // https://www.qam-web.com/?p=15115
  // Safari on iPad + iPad OS13(デスクトップ用Webサイトを表示:On設定時 ← デフォルト)
  // Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15
  iOS() {
    return (
      typeof window !== 'undefined' &&
        (window.navigator.userAgent.match(/iPhone|iPad|iPod/i) ||
         (window.navigator.userAgent.match(/Macintosh/i) && 'ontouchend' in document))
    )
  },
  Opera() {
    return (
      typeof window !== 'undefined' &&
        window.navigator.userAgent.match(/Opera Mini/i)
    )
  },
  Windows() {
    return (
      typeof window !== 'undefined' &&
        window.navigator.userAgent.match(/IEMobile/i)
    )
  },
  any() {
    return (
      isMobile.Android() ||
        isMobile.BlackBerry() ||
        isMobile.iOS() ||
        isMobile.Opera() ||
        isMobile.Windows()
    )
  }
}
