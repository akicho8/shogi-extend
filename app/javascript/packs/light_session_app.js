// import * as AppHelper from "./app_helper.js"

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
})
