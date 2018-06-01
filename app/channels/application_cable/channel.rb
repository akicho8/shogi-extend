module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def ams_sr(*args)
      ActiveModelSerializers::SerializableResource.new(*args)
    end
  end
end
