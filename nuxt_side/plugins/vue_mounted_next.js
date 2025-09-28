// mounted でコンポーネントが起動し、そこで @input などが発動する場合があるため、mounted の次のタイミングになったかどうかの判定が欲しい

export const vue_mounted_next = {
  data() {
    return {
      mounted_next: 0,          // コンポーネント毎に存在する点に注意すること
    }
  },
  mounted() {
    // this.clog("[mounted]")
    this.$nextTick(() => {
      this.mounted_next += 1
      // this.clog("[mounted_next]")
      if (this.mounted_next_hook) {
        this.mounted_next_hook()
      }
    })
  },
  computed: {
    mounted_next_p() {
      return this.mounted_next >= 1
    },
  },
}
