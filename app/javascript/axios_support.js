import axios from "axios"

function csrf_token_get() {
  const el = document.querySelector('meta[name="csrf-token"]')
  if (el) {
    return el.getAttribute('content')
  } else {
    return ""
  }
}

export default axios.create({
  // baseURL: process.env.NODE_ENV === "production" ? "https://www.shogi-extend.com/" : null,
  // baseURL: process.env.NODE_ENV === "development" ? "http://localhost:3000" : null,
  timeout: 1000 * 60 * 3,      // 3min
  headers: {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": csrf_token_get(),
  },
})
