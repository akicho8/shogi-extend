export class KentoUrlParser {
  static parse(...args) {
    return new this(...args)
  }

  constructor(url) {
    this.url = url
  }

  get turn_guess() {
    const md = this.url.match(/http.*kento.*#(\d+)/)
    if (md) {
      return parseInt(md[1])
    }
  }
}
