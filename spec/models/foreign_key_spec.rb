require "rails_helper"

RSpec.describe ForeignKey, type: :model do
  it "value" do
    ForeignKey.new_context do
      ForeignKey.value = false
      assert2 { !ForeignKey.value }

      ForeignKey.value = true
      assert2 { ForeignKey.value }
    end
  end

  it "disabled, enabled" do
    ForeignKey.new_context do
      assert2 { ForeignKey.disabled { ForeignKey.disabled? } }
      assert2 { ForeignKey.enabled { ForeignKey.enabled? } }
    end
  end
end
