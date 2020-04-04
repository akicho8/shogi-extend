module AtomicScript
  module ExampleScript
    class JsRunScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "Vue.js + shogi_player"

      def script_body
        if request.format.json?
          return {:a => 1}.as_json
        end

        out = ""
        out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        out += %(<div id="app"><shogi_player/></div>)
        out
      end
    end
  end
end
