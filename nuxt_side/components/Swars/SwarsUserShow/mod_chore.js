export const mod_chore = {
  methods: {
    badge_click_handle(badge) {
      const message = badge.message
      if (message) {
        this.$sound.play_click()
        this.toast_ok(message)
      }
    },
  },

  computed: {
    google_search_url()  { return `https://www.google.co.jp/search?q=${this.info.user.key} 将棋`  },
    twitter_search_url() { return `https://twitter.com/search?q=${this.info.user.key} 将棋`       },
    swars_player_url()   { return `https://shogiwars.heroz.jp/users/mypage/${this.info.user.key}` },
    swars_player_follow_url()   { return `https://shogiwars.heroz.jp/friends?type=follow&user_id=${this.info.user.key}` },
    swars_player_follower_url()   { return `https://shogiwars.heroz.jp/friends?type=follower&user_id=${this.info.user.key}` },
  },
}
