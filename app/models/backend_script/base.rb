module BackendScript
  class Base < EasyScript::Base
    class_attribute :category
    self.category = "その他"

    self.url_prefix = [:admin, :backend_script]
  end
end
