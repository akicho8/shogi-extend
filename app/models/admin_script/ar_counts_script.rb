module AdminScript
  class ArCountsScript < Base
    self.category = "その他"
    self.label_name = "データ数"

    def script_body
      ApplicationRecord.subclasses.sort_by(&:count).reverse.collect do |e|
        {
          name: e.model_name.human,
          model: e.name,
          count: e.count,
        }
      end
    end
  end
end
