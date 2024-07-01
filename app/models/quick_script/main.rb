module QuickScript
  module Main
    extend self

    def fetch(params, options = {})
      if params[:skey] == "__skey_is_blank__"
        return Chore::IndexScript.new(params.merge(sgroup_only: params[:sgroup]), options)
      end
      "quick_script/#{params[:sgroup]}/#{params[:skey]}_script".classify.constantize.new(params, options)
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
