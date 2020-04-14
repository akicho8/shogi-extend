# app/javascript/acns2_sample.vue
# app/channels/acns2_sample_channel.rb
# app/models/backend_script/acns2_sample_script.rb
module BackendScript
  class Acns2SampleScript < ::BackendScript::Base
    include AtomicScript::AddJsonLinkMod

    self.script_name = "チャット (acns2)"

    def script_body
      Acns2.setup

      out = ""

      if !current_room
        out += Acns2::Room.order(:id).collect { |room|
          {
            "チャットルーム" => h.link_to(room.id, params.merge(room_id: room.id)),
          }
        }.to_html
      end

      if current_room
        messages = current_room.messages.order(:id).last(10)
        rendered_messages = messages.collect { |message|
          ApplicationController.renderer.render partial: 'acns2/messages/message', locals: { message: message }
        }

        info = {}
        info[:room] = current_room
        info[:messages] = rendered_messages
        if request.format.json?
          return info
        end

        out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        out += %(<div id="app"><acns2_sample :info='#{info.to_json}' /></div>)
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
        Acns2::Room.find_by(id: v)
      end
    end
  end
end
