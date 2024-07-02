module QuickScript
  module Main
    extend self

    def fetch(params, options = {})
      if params[:qs_key] == "__skey_is_blank__"
        return Chore::IndexScript.new(params.merge(sgroup_only: params[:qs_group]), options)
      end
      "quick_script/#{params[:qs_group]}/#{params[:qs_key]}_script".classify.constantize.new(params, options)
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
