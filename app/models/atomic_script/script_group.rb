# 使い方
#
#   module FrontendScript
#     extend AtomicScript::ScriptGroup
#   end
#
#   app/models/frontend_script/*_script.rb
#
module AtomicScript
  concern :ScriptGroup do
    # 保持しているスクリプトクラスたちを返す
    # [Frontend::FooScript, Frontend::BarScript, ...]
    def bundle_scripts
      @bundle_scripts ||= keys.collect(&method(:find)).sort_by { |e|
        [
          e.respond_to?(:category) ? e.category : "",
          e.name,
        ]
      }
    end

    # キーからクラスへの変換
    # find("foo-bar") => "Frontend::FooBarScript"
    def find(key)
      "#{name}/#{key}_#{name_prefix}".underscore.classify.safe_constantize
    end

    private

    # このクラス名が FooBar なら app/models/foo_bar/*_script.rb がある想定
    def keys
      @keys ||= Pathname("app/models/#{name.underscore}").glob("[^_]*_#{name_prefix}.rb").collect { |e| e.basename(".rb").to_s.remove(/_#{name_prefix}\z/) }
    end

    def name_prefix
      :script
    end
  end
end
