module EasyScript
  class ExampleTableCheckboxScript < Base
    self.script_name = "チェックボックスのテスト"

    def script_body
      list = 3.times.collect do |e|
        str = h.check_box_tag("ids[]", e, false)
        # content_tag(:td, str, "data-checkbox-td" => true)
        {
          :cb => str,
          :id => params.inspect,
        }
      end

      form_parts2 = [
        {
          :label   => "モード選択",
          :key     => :mode_key,
          :type    => :radio,
          :elems   => ["a", "b"],
          :default => "a",
        },
      ]

      out = []
      out << h.form_tag(submit_path, :method => form_action_method, :class => "form-horizontal") do |;out|
        out = []
        out << list.to_html
        out << FormBox::InputsBuilder::Default.inputs_render(form_parts2)
        out << h.bootstrap_form_actions do
          h.submit_tag(buttun_label, :class => form_submit_button_class, :name => "_submit")
        end
        out.join.html_safe
      end
      out.join.html_safe
    end
  end
end
