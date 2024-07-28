require "rails_helper"

module QuickScript
  module Account
    RSpec.describe KentoProDestroyScript, type: :model do
      it "works" do
        assert { NameEditScript.new({}, {_method: :get}).as_json  }
        assert { NameEditScript.new({}, {_method: :post}).as_json }
      end
    end
  end
end
