module EasyScript
  class IndexScript < Base
    self.script_name = "スクリプト一覧"

    def script_body
      EasyScript.bundle_scripts.collect { |e|
        {
          "スクリプト" => script_link_to(e.script_name, :id => e.key),
          "キー"       => e.key,
        }
      }.to_html
    end
  end
end
