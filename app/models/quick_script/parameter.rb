# frozen-string-literal: true

module QuickScript
  class Parameter
    def initialize(original_params)
      original_params[:qs_group_key].present? or raise QuickScriptError
      original_params[:qs_page_key].present? or raise QuickScriptError

      @original_params = original_params
    end

    def receiver_klass
      path = "quick_script/#{qs_group_key}/#{qs_page_key}_script"
      path.classify.safe_constantize || Chore::NotFoundScript
    end

    def params
      @params ||= yield_self do
        hv = @original_params
        hv = hv.merge(qs_group_key: hv[:qs_group_key].to_s.underscore, qs_page_key: hv[:qs_page_key].to_s.underscore)
        if hv[:qs_page_key] == "__qs_page_key_is_blank__"
          hv = hv.merge(qs_group_key: "chore", qs_page_key: "index", qs_group_only: hv[:qs_group_key])
        end
        hv
      end
    end

    private

    def qs_group_key
      params[:qs_group_key]
    end

    def qs_page_key
      params[:qs_page_key]
    end
  end
end
