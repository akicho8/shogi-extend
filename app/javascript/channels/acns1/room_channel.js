// import consumer from '../consumer'
//
//   const chatChannel = consumer.subscriptions.create({ channel: 'Acns1::RoomChannel', room_id: $('#messages').data('room_id') }, {
//     connected() {
//       // Called when the subscription is ready for use on the server
//     },
//
//     disconnected() {
//       // Called when the subscription has been terminated by the server
//     },
//
//     received(data) {
//       return $('#messages').append(data['message'])
//     },
//
//     speak(message) {
//       return this.perform('speak', { message: message })
//     }
//   })
//
//   $(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
//     if (event.keyCode === 13) {
//       chatChannel.speak(event.target.value)
//       event.target.value = ''
//       return event.preventDefault()
//     }
//   })
// })
