module MyScript
  class ExamplePostFormScript < Base
    self.label_name = "POSTフォーム"
    self.post_submit = true

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
