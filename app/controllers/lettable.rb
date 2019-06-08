module Lettable
  extend ActiveSupport::Concern

  class_methods do
    # https://gist.github.com/eric1234/375ad4a79972467d6f30af3bd0146584
    def legacy_let(name, **options, &block)
      options = {
        return_value_if_exist: false,
      }.merge(options)

      var_key = (options[:key] || name).to_s
      reader_only = var_key.end_with?("?")
      var_key.sub!(/\?\z/, "_p")

      iv = "@#{var_key}"

      define_method(name) do
        if options[:return_value_if_exist]
          if v = instance_variable_get(iv)
            return v
          end
        else
          if instance_variable_defined?(iv)
            return instance_variable_get(iv)
          end
        end
        instance_variable_set(iv, instance_eval(&block))
      end

      helper_method name

      unless reader_only
        define_method(:"#{name}=") do |value|
          instance_variable_set(iv, value)
        end
        private :"#{name}="
      end
    end
  end

  def let_cache_remove(name)
    iv = "@" + name.to_s.sub(/\?\z/, "_p")
    if instance_variable_defined?(iv)
      remove_instance_variable(iv)
    end
  end
end
