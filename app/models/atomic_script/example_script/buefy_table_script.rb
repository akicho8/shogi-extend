module AtomicScript
  module ExampleScript
    class BuefyTableScript < ::AtomicScript::ExampleScript::Base
      self.script_name = "Vue.js + b-table"

      def script_body
        info = {
          columns: [
            { field: "id",   label: "#",    sortable: true, numeric: true,  },
            { field: "name", label: "名前", sortable: true, numeric: false, },
          ],
          rows: [
            { "id" => 1, "name" => "alice", },
            { "id" => 2, "name" => "bob",   },
          ],
        }

        if request.format.json?
          return info.as_json
        end

        out = ""
        out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        out += %(<div id="app"><buefy_table_wrapper :info='#{info.to_json}' /></div>)
        out
      end
    end
  end
end
