# app/javascript/acns1_sample.vue
# app/channels/acns1_sample_channel.rb
# app/models/backend_script/acns1_sample_script.rb
module BackendScript
  class Acns1SampleScript < ::BackendScript::Base
    include AtomicScript::AddJsonLinkMod

    self.script_name = "チャット (acns1)"

    def script_body
      Acns1.setup

      out = ""

      if !current_room
        out += Acns1::Room.order(:id).collect { |room|
          {
            "チャットルーム" => h.link_to(room.id, params.merge(room_id: room.id)),
          }
        }.to_html
      end

      if current_room
        messages = current_room.messages.order(:id).last(10)
        rendered_messages = messages.collect { |message|
          ApplicationController.renderer.render partial: 'acns1/messages/message', locals: { message: message }
        }

        info = {}
        info[:room] = current_room
        info[:messages] = rendered_messages
        if request.format.json?
          return info
        end

        out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        out += %(<div id="app"><acns1_sample :info='#{info.to_json}' /></div>)
        out += h.tag.br
        out += h.link_to("ロビー", params.merge(room_id: nil), :class => "button is-small")
      end

      out
    end

    def current_room_id
      params[:room_id].presence
    end

    def current_room
      if v = current_room_id
        Acns1::Room.find_by(id: v)
      end
    end
  end
end
