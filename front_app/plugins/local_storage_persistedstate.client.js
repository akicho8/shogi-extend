import createPersistedState from 'vuex-persistedstate'

import SecureLS from "secure-ls"
const ls = new SecureLS({ isCompression: false })

export default ({ store }) => {
  createPersistedState({
    key: "store",
    paths: [
      'g_counter',
      // ▼ネームスペースがある場合はドットで繋ぐ
      // https://qiita.com/y-miine/items/028c73aa3f87e983ed4c#vuex-persistedstate%E3%81%A7%E3%81%AE%E6%9B%B8%E3%81%8D%E6%96%B9
      // 'user.current_user',
    ],
    // 暗号化して読み書きする
    // もともと current_user を保存するために設定したけど
    // current_user は nuxtServerInit から初回に読むようにしたので下のは不要になった
    storage: {
      getItem: (key)        => ls.get(key),
      setItem: (key, value) => ls.set(key, value),
      removeItem: (key)     => ls.remove(key),
    },
  })(store)
}

