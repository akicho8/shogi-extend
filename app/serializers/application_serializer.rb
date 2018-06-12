class ApplicationSerializer < ActiveModel::Serializer
  # ネストの差でデータの有無が決まる曖昧な状況を解決する方法
  # https://github.com/rails-api/active_model_serializers/pull/1845#issuecomment-268725267
  # https://github.com/rails-api/active_model_serializers/pull/1845#issuecomment-247843653
  #
  # なにが問題か？
  # - シリアライズ化する部分を疎結合化したにもかかわらずコントローラーで重要な部分を書かないといけない
  # - リファクタリングの際に1段目だったものが2段目になりそれでデータが取れなくなることが多々ある(しかもその原因が非常にわかりにくい)
  #
  # usage: always_include :image
  # def self.always_include(name, options = {})
  # attribute(name, options)
  # obj = respond_to?(name) ? send(name) : object.send(name)
  # define_method(name) do
  #   if obj
  #     resource = ams_sr(obj)
  #     resource.serialization_scope = instance_options[:scope]
  #     resource.serialization_scope_name = instance_options[:scope_name]
  #     resource.serializable_hash
  #   end
  # end

  # usage: always_include :image
  def self.always_include(name, options = {})
    # options[:key] ||= name
    # method_name = name.to_s + '_serialized'
    # define_method method_name do
    #   data = respond_to?(name) ? send(name) : object.send(name)
    #   if data
    #     options = instance_options.dup
    #     options.delete(:serializer)
    #     options.delete(:each_serializer)
    #
    #     # use Attributes adapter here instead of Json as we dont want a root object
    #     options[:adapter] = ActiveModelSerializers::Adapter::Attributes
    #
    #     resource = ams_sr(data, options)
    #     resource.serializable_hash
    #   end
    # end
    #
    # attribute(method_name, options)
  end

  attributes :id

  private
end
