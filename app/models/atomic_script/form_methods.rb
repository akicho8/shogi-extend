module AtomicScript
  concern :FormMethods do
    included do
      class_attribute :form_position
      self.form_position = :top
    end

    def render_in_view
      if form_position == :top
        to_form_html + super
      else
        super + to_form_html
      end
    end

    def to_form_html
      out = []
      if form_enable?
        out << h.tag.div(:class => "columns") do
          h.tag.div(:class => "column") do
            out << h.form_with(url: submit_path, method: form_action_method, multipart: multipart?, skip_enforcing_utf8: true) do |;out|
              out = []
              out << FormBox::InputsBuilder::Default.inputs_render(form_parts)
              out << h.tag.div(:class => "field is-grouped") do
                h.tag.div(:class => "control") do
                  h.submit_tag(buttun_name, :class => form_submit_button_class, name: "_submit")
                end
              end
              out.join.html_safe
            end
          end
        end
      end
      out.join.html_safe
    end

    def form_enable?
      form_parts.present?
    end

    # オーバーライド
    def form_parts
      []
    end

    def multipart?
      Array.wrap(form_parts).any? { |e| e[:type] == :file }
    end

    def form_action_method
      :get
    end

    def submit_path
      [*url_prefix, id: key]
    end

    def buttun_name
      "実行"
    end

    def form_submit_button_class
      ["button", "is-small", *form_submit_button_color]
    end

    def form_submit_button_color
      "is-primary"
    end

    def submitted?
      @params[:_submit].present?
    end
  end
end
