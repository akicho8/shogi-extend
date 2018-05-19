export default {
  data: function() {
    return {
      room_name: chat_room_app_params.chat_room.name, // 部屋名
      room_name_before: null,                         // 部屋名を変更する前の名前
      room_name_edit_p: false,                        // 部屋名変更中？
    }
  },
  watch: {
    room_name_edit_p(value) {
      if (this.room_name === "") {
        this.room_name = chat_room_app_params.chat_room.name
      }
      if (value) {
        this.room_name_before = this.room_name
      } else  {
        if (this.room_name_before !== this.room_name) {
          App.chat_room.system_say(`部屋名を「${this.room_name}」に変更しました`)
          App.chat_room.room_name_changed(this.room_name)
        }
      }
    },
  },
  methods: {
    room_name_click() {
      this.room_name_edit_p = true
      this.$nextTick(() => this.$refs.room_name_input.focus())
    },
  },
}
