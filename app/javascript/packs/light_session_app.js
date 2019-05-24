document.addEventListener('DOMContentLoaded', () => {
  App.cable.subscriptions.create({
    channel: "LightSessionChannel",
    custom_session_id: js_global.custom_session_id,
  }, {
    received(data) {
      // わざわざ JavaScript 側から発信したようにする場合
      if (data["yomiage"]) {
        GVI.talk(data["yomiage"])
        GVI.debug_alert(data["yomiage"])
      }

      // Rails側で翻訳できている場合はショートカットして再生することもできる
      if (data["talk"]) {
        audio_queue.media_push(data["talk"]["service_path"])
      }
    },
  })
})
