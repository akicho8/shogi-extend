# app/javascript/chat_sample1.vue
# app/channels/chat_sample1_channel.rb
# app/models/backend_script/chat_sample1_script.rb
module BackendScript
  class ChatSample1Script < ::BackendScript::Base
    include AtomicScript::AddJsonLinkMod

    self.script_name = "チャット1"

    def script_body
      if Tsume::Room.count.zero?
        Tsume::Room.destroy_all
        Tsume::Message.destroy_all
        3.times do |i|
          Tsume::Room.create!
        end
      end

      out = ""

      if !current_room
        out += Tsume::Room.order(:id).collect { |room|
          {
            name: h.link_to(room.id, params.merge(room_id: room.id)),
          }
        }.to_html
      end

      if current_room
        messages = current_room.messages.order(:id).last(10)
        rendered_messages = messages.collect { |message|
          ApplicationController.renderer.render partial: 'tsume/messages/message', locals: { message: message }
        }

        info = {}
        info[:room] = current_room
        info[:messages] = rendered_messages
        if request.format.json?
          return info
        end

        out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        out += %(<div id="app"><chat_sample1 :info='#{info.to_json}' /></div>)
        out += h.tag.br
        out += h.link_to("抜ける", params.merge(room_id: nil), :class => "button is-small")
      end

      out
    end

    def current_room_id
      params[:room_id].presence
    end

    def current_room
      if v = current_room_id
        Tsume::Room.find_by(id: v)
      end
    end
  end
end
