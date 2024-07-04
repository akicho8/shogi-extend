module QuickScript
  module Main
    extend self

    def fetch(params, options = {})
      if params[:qs_page_key] == "__skey_is_blank__"
        return Chore::IndexScript.new(params.merge(qs_group_only: params[:qs_group_key]), options)
      end
      "quick_script/#{params[:qs_group_key]}/#{params[:qs_page_key]}_script".underscore.classify.constantize.new(params, options)
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
