// 未使用
export const SimpleStorage = {
  set(key, value) {
    localStorage.setItem(key, JSON.stringify(value))
  },

  get(key) {
    let v = {}
    const value = localStorage.getItem(key)
    if (value) {
      v = JSON.parse(value)
    }
    return v
  },

  delete(key) {
    localStorage.removeItem(key)
  },
}
