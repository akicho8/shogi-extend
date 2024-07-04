module QuickScript
  module Main
    extend self

    def fetch(params, options = {})
      if params[:qs_page_key] == "__qs_page_key_is_blank__"
        return Chore::IndexScript.new(params.merge(qs_group_only: params[:qs_group_key]), options)
      end
      klass = "quick_script/#{params[:qs_group_key]}/#{params[:qs_page_key]}_script".underscore.classify.safe_constantize
      unless klass
        return Chore::NotFoundScript.new(params, options)
      end
      klass.new(params, options)
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
