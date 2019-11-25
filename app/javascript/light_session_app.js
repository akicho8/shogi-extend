document.addEventListener('DOMContentLoaded', () => {
  App.cable.subscriptions.create({
    channel: "LightSessionChannel",
    custom_session_id: js_global.custom_session_id,
  }, {
    received(data) {
      if (tab_is_active_p()) {
        this[`__command_${data.command}`](data)
      }
    },

    // private

    // わざわざ JavaScript 側から発信したようにする場合
    __command_talk(data) {
      GVI.talk(data["message"], data)
      GVI.debug_alert(data["message"])
    },

    // Rails側で翻訳できている場合はショートカットして再生することもできる
    // TODO: こっちは使用禁止
    __command_direct_talk(data) {
      audio_queue.media_push(data["talk"]["service_path"])
    },

    __command_sound_play(data) {
      GVI.sound_play(data["key"], data)
    },

    __command_toast_message(data) {
      GVI.$buefy.toast.open(data)
    },
  })
})
