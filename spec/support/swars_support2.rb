module SwarsSupport2
  extend ActiveSupport::Concern

  included do
    before do
      Swars.setup
    end
  end
end

RSpec.configure do |config|
  config.include(SwarsSupport2, type: :model, swars_spec: true)
end
