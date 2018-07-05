module Lettable
  # https://gist.github.com/eric1234/375ad4a79972467d6f30af3bd0146584
  def let(name, **options, &block)
    options = {

    }.merge(options)

    var_key = (options[:key] || name).to_s
    reader_only = var_key.end_with?("?")
    var_key.gsub!(/\?\z/, "_p")

    iv = "@#{var_key}"

    define_method(name) do
      if instance_variable_defined?(iv)
        return instance_variable_get(iv)
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
