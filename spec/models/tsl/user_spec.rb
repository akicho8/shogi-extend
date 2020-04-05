require 'rails_helper'

module Tsl
  RSpec.describe User, type: :model do
    before do
      Tsl.setup
    end

    let :record do
      User.first
    end

    it do
      assert { record.valid? }
    end
  end
end
