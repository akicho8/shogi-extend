module QuickScript
  module Main
    extend self

    def dispatch(params, options = {})
      if params[:qs_page_key] == "__qs_page_key_is_blank__"
        params = params.merge(qs_group_only: params[:qs_group_key], qs_group_key: "chore", qs_page_key: "index")
      end
      klass = klass_fetch(params)
      instance = klass.new(params, options)
      if params[:__FOR_ASYNC_DATA__]
        AppLog.info(subject: "[#{klass.name}][__FOR_ASYNC_DATA__]", body: params.to_t)
        instance.meta_render
        return
      end
      AppLog.info(subject: "[#{klass.name}][content]", body: params.to_t)
      instance.all_content_render
    end

    def klass_fetch(params)
      klass = "quick_script/#{params[:qs_group_key]}/#{params[:qs_page_key]}_script".underscore.classify.safe_constantize
      klass || Chore::NotFoundScript
    end

    def all
      Rails.autoloaders.main.eager_load_namespace(QuickScript)
      Base.subclasses
    end

    def info
      all.collect { |e| { model: e, title: e.title, path: e.link_path } }
    end

    def name_prefix
      :bin
    end

    def root_dir
      Pathname(__dir__)
    end
  end
end
