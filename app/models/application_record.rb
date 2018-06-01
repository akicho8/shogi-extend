class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include TimeRangable

  def ams_sr(*args)
    ActiveModelSerializers::SerializableResource.new(*args)
  end
end
