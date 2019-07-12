import ActionCable from "actioncable"

// このような書き方でいいのかどうかはわからない
window.App = {}
window.App.cable = ActionCable.createConsumer()

ActionCable.startDebugging()
