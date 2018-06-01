module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def sres(*args)
      ActiveModelSerializers::SerializableResource.new(*args)
    end
  end
end
