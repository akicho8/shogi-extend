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
    },
  })

  // const audio = new Audio()
  // audio.src = no_sound
  // audio.play()
})
