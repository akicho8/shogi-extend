class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def setup(options = {})
    end
  end
end
