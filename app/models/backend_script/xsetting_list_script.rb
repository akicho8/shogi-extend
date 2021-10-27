module BackendScript
  class XsettingListScript < ::BackendScript::Base
    self.category = "システム設定"
    self.script_name = "システム設定一覧"

    def script_body
      AvailableXsetting.collect {|e|
        {
          :name  => script_link_to(e.name, :id => "xsetting_edit", :xsetting_key => e.key),
          :key   => e.key,
          :value => Xsetting[e.key],
        }
      }
    end
  end
end
