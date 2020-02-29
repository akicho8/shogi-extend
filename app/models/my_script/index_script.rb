module MyScript
  class IndexScript < Base
    self.label_name = "スクリプト一覧"

    def script_body
      MyScript.bundle_classes.collect { |e|
        {
          "スクリプト" => script_link_to(e.label_name, :id => e.key),
          "キー"       => e.key,
        }
      }.to_html
    end
  end
end
