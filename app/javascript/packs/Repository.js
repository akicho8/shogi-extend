import axios from "axios"

export default axios.create({
  baseURL: process.env.NODE_ENV === "development" ? "" : "http://tk2-221-20341.vs.sakura.ne.jp/shogi",
  timeout: 1000 * 60 * 10,
  headers: {
    "X-Requested-With": "XMLHttpRequest",
  },
})
