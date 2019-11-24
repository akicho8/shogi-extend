document.addEventListener('DOMContentLoaded', () => {
  App.cable.subscriptions.create({
    channel: "LightSessionChannel",
    custom_session_id: js_global.custom_session_id,
  }, {
    received(data) {
      // わざわざ JavaScript 側から発信したようにする場合
      if (data["yomiage"]) {
        GVI.talk(data["yomiage"], data)
        GVI.debug_alert(data["yomiage"])
      }

      // Rails側で翻訳できている場合はショートカットして再生することもできる
      // TODO: こっちは使用禁止
      if (data["talk"]) {
        audio_queue.media_push(data["talk"]["service_path"])
      }

      if (data["sound_key"]) {
        GVI.sound_play(data["sound_key"], data)
      }

      if (data["message"]) {
        GVI.$buefy.toast.open(data)
      }
    },
  })
})
