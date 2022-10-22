export class WinMark {
  constructor(counts_hash, user_name) {
    this.counts_hash = counts_hash
    this.user_name = user_name
  }

  get text() {
    const max = 5
    const medal = "⭐"
    const count = this.counts_hash[this.user_name]
    if (count != null) {
      if (count <= max) {
        return medal.repeat(count)
      } else {
        return `${medal} ${count}`
      }
    }
  }

  get display_p() {
    const count = this.counts_hash[this.user_name] ?? 0
    return count > 0
  }
}
