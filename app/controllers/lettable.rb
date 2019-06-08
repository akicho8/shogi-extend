module Lettable
  module ModuleMethods
    private

    # https://gist.github.com/eric1234/375ad4a79972467d6f30af3bd0146584
    def let(name, **options, &block)
      options = {
        # as_helper_method: true,
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

      # if options[:as_helper_method]
      #   helper_method name
      # end

      unless reader_only
        define_method(:"#{name}=") do |value|
          instance_variable_set(iv, value)
        end
        private :"#{name}="
      end
    end

    # def let(name, **options, &block)
    #   let(name, options.merge(as_helper_method: false), &block)
    # end
  end

  module ObjectMethods
    private

    def unlet(name)
      iv = "@" + name.to_s.sub(/\?\z/, "_p")
      if instance_variable_defined?(iv)
        remove_instance_variable(iv)
      end
    end
  end
end
