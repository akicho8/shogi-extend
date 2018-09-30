// import no_sound from "./no_sound.mp3"

document.addEventListener('DOMContentLoaded', () => {
  App.cable.subscriptions.create({
    channel: "LightSessionChannel",
    session_hash: js_global.session_hash,
  }, {
    received(data) {
      if (data["yomiage"]) {
        AppHelper.talk(data["yomiage"])
      }
      // Rails側で翻訳できている場合はショートカットして再生することもできる
      if (data["talk"]) {
        audio_queue.media_push(data["talk"]["service_path"])
      }
    },
  })

  // const audio = new Audio()
  // audio.src = no_sound
  // audio.play()
})
