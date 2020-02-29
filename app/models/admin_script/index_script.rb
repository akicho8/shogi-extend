module AdminScript
  class IndexScript < Base
    self.category = "その他"
    self.label_name = "スクリプト一覧"
    self.icon_key = :list

    def script_body
      AdminScript.bundle_classes.group_by{|e|e.category}.values.flatten.collect do |e|
        {
          "スクリプト" => script_link_to(e.label_name, :id => e.key),
          "キー"       => e.key,
          "カテゴリー" => e.category,
        }
      end
    end
  end
end
