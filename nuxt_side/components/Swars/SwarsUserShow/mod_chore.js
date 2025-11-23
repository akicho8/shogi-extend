export const mod_chore = {
  methods: {
    badge_click_handle(badge) {
      const message = badge.message
      if (message) {
        this.sfx_click()
        this.toast_primary(message)
      }
    },
  },

  computed: {
    google_search_url()     { return `https://www.google.co.jp/search?q=${this.info.user.key} 将棋`                   },
    twitter_search_url()    { return `https://twitter.com/search?q=${this.info.user.key} 将棋`                        },
    official_mypage_url()   { return `https://shogiwars.heroz.jp/users/mypage/${this.info.user.key}`                  },
    official_follow_url()   { return `https://shogiwars.heroz.jp/friends?type=follow&user_id=${this.info.user.key}`   },
    official_follower_url() { return `https://shogiwars.heroz.jp/friends?type=follower&user_id=${this.info.user.key}` },
  },
}
