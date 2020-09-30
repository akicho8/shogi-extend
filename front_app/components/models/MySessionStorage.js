import { MyLocalStorage } from "./MyLocalStorage.js"

export class MySessionStorage extends MyLocalStorage {
  static get core() {
    return sessionStorage
  }
}
