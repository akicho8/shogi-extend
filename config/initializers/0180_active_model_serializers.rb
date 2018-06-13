# "**" を指定すると2段以上を含めてくれるメリットがあるが、無限ループになりやすいためやめておいたほうがいいかもしれない
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/active_model_serializers-0.10.7/lib/active_model_serializers.rb:38:in `default_include_directive': stack level too deep (SystemStackError)
# ActiveModelSerializers.config.default_includes = '**'

# xmpfilter
if $0 == "-"
  ActiveModelSerializers.logger = Logger.new(STDOUT)
end

Kernel.module_eval do
  p ["#{__FILE__}:#{__LINE__}", __method__, :ams_sr]
  def ams_sr(*args)
    ActiveModelSerializers::SerializableResource.new(*args).as_json
  end
end

