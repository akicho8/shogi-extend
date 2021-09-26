module Kiwi
  class BookMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(book_message)
      ActionCable.server.broadcast("kiwi/book_room_channel/#{book_message.book_id}", bc_action: :speak_broadcasted, bc_params: {book_message: render_message(book_message)})
    end

    private

    def render_message(book_message)
      # ApplicationController.renderer.render(partial: 'kiwi/messages/book_message', locals: { book_message: book_message })
      book_message.as_json_type8
    end
  end
end
