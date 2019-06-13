class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def setup(options = {})
    end

    def han(*args)
      human_attribute_name(*args)
    end
  end
end
