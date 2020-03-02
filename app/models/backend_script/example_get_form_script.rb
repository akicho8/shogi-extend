# http://localhost:3000/admin/scripts/example_get_form_page
module BackendScript
  class ExampleGetFormScript < ::BackendScript::Base
    self.category = "スクリプト例"
    self.script_name = "GETフォーム"

    def form_parts
      {
        :label   => "値",
        :key     => :foo,
        :type    => :string,
        :default => params[:foo],
      }
    end

    def script_body
      params
    end
  end
end
