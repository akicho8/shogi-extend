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
  iOS() {
    return (
      typeof window !== 'undefined' &&
        window.navigator.userAgent.match(/iPhone|iPad|iPod/i)
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
