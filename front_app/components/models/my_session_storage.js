import { MyLocalStorage } from "./my_local_storage.js"

export class MySessionStorage extends MyLocalStorage {
  static get storage() {
    return sessionStorage
  }
}
