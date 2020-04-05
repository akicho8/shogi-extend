require 'rails_helper'

module Tsl
  RSpec.describe Membership, type: :model do
    before do
      Tsl.setup
    end

    let :record do
      Membership.first
    end

    it do
      assert { record.valid? }
    end
  end
end
