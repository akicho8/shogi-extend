export const mod_xtitle = {
  data() {
    return {
      current_title: this.config.record.title, // 現在のタイトル
    }
  },
  methods: {
    title_share() {
      this.ac_room_perform("title_share", this.current_xtitle)
    },
    title_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
      } else {
      }
      this.receive_xtitle(params)
      this.al_add({...params, label: "タイトル変更"})
      this.toast_ok(`${this.user_call_name(params.from_user_name)}がタイトルを${params.title}に変更しました`)
    },
    receive_xtitle(params) {
      this.__assert__(this.present_p(params), "this.present_p(params)")
      this.__assert__("title" in params, '"title" in params')
      this.current_title = params.title
      this.ac_log("タイ変更", `タイトル "${this.current_title}" を受信`)
    },
  },
  computed: {
    current_xtitle() { return { title: this.current_title } },
    page_title() {
      if (this.current_turn === 0) {
        return this.current_title
      } else {
        return `${this.current_title} ${this.current_turn}手目`
      }
    },
  },
}
