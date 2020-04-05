require 'rails_helper'

module Tsl
  RSpec.describe League, type: :model do
    before do
      Tsl.setup
    end

    let :record do
      League.first
    end

    it do
      assert { record.valid? }
    end
  end
end
