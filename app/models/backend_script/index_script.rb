module BackendScript
  class IndexScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "スクリプト一覧"

    def script_body
      BackendScript.bundle_scripts.group_by{|e|e.category}.values.flatten.collect do |e|
        {
          "スクリプト" => script_link_to(e.script_name, :id => e.key),
          "キー"       => e.key,
          "カテゴリー" => e.category,
        }
      end
    end
  end
end
