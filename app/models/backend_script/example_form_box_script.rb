#
# フォームなし
#
# http://localhost:3000/admin/scripts/example_form_box_script
module BackendScript
  class ExampleFormBoxScript < ::BackendScript::Base
    self.category = "スクリプト例"
    self.script_name = "簡単フォーム例"

    def form_parts
      h.form_box_example_form_parts
    end

    def script_body
      [h.request.method, h.params].inspect
    end
  end
end
