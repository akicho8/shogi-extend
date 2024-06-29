module QuickScriptNs
  module QuickScript
    extend self

    def all_by(params)
      {
        :meta => {
          :title        => "(title)",
          :description  => "(description)",
          :og_image_key => "(og_image_key)",
        },
        :rows => [
          { key: "calc", name: "計算機", },
        ],
      }
    end

    def fetch(params)
      "QuickScriptNs::#{params[:id].classify}_script".classify.constantize.new(params)
    end

    def keys
      @keys ||= Pathname(__dir__).glob("*_#{name_prefix}.rb").collect { |e| e.basename(".*").to_s.remove(/_#{name_prefix}\z/) }
    end

    def name_prefix
      :script
    end
  end
end
