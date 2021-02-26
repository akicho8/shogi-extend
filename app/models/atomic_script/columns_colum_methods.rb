module AtomicScript
  concern :ColumnsColumMethods do
    included do
      class_attribute :column_wrapper_enable
      self.column_wrapper_enable = true
    end

    private

    def response_render_body(resp)
      if resp[:rows].present?
        if column_wrapper_enable
          columns_column_tag { super }
        else
          super
        end
      end
    end

    def columns_column_tag
      h.tag.div(:class => "columns") do
        h.tag.div(:class => "column is_scroll_x") do
          yield
        end
      end
    end
  end
end
