# frozen-string-literal: true

module QuickScript
  module Dispatcher
    extend self

    def dispatch(params, options = {})
      new_from(params, options).tap(&:render_all)
    end

    def new_from(params, options = {})
      params = prepare(params)
      klass_fetch(params).new(params, options)
    end

    def prepare(params)
      params = params.merge({
          :qs_group_key => params[:qs_group_key].to_s.underscore,
          :qs_page_key  => params[:qs_page_key].to_s.underscore,
        })
      if params[:qs_page_key] == "__qs_page_key_is_blank__"
        params = params.merge(qs_group_only: params[:qs_group_key], qs_group_key: "chore", qs_page_key: "index")
      end
      params
    end

    def klass_fetch(params)
      str = "quick_script/#{params[:qs_group_key]}/#{params[:qs_page_key]}_script"
      str.classify.safe_constantize || Chore::NotFoundScript
    end

    def all
      Rails.autoloaders.main.eager_load_namespace(QuickScript)
      Base.subclasses
    end

    def info
      all.collect do |e|
        {
          :model       => e,
          :qs_key      => e.qs_key,
          "OGP画像"    => e.og_card_path.exist? ? "○" : "",
          :title       => e.title,
          :description => e.description,
        }
      end
    end

    def path_prefix
      :lab
    end
  end
end
