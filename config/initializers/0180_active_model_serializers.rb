# "**" を指定すると2段以上を含めてくれるメリットがあるが、無限ループになりやすいためやめておいたほうがいいかもしれない
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers.rb:38:in `default_include_directive': stack level too deep (SystemStackError)
# ActiveModelSerializers.config.default_includes = '**'

if defined?(ActiveModelSerializers)
  # xmpfilter 使用時はログに出さない
  if $0 == "-"
    if ENV["ACTIVE_MODEL_SERIALIZERS_LOGGER_STDOUT"]
      ActiveModelSerializers.logger = Logger.new(STDOUT)
    end
  end

  Kernel.module_eval do
    def ams_sr(...)
      ActiveModelSerializers::SerializableResource.new(...).as_json
    end
  end
end
