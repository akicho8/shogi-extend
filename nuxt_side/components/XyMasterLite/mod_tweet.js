import dayjs from "dayjs"

export const mod_tweet = {
  data() {
    return {
      micro_seconds: null, // 経過時間
    }
  },
  computed: {
    spent_sec() {
      return this.micro_seconds / 1000
    },
  },
}
