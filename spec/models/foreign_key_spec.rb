require "rails_helper"

RSpec.describe ForeignKey, type: :model do
  it "value" do
    ForeignKey.new_context do
      ForeignKey.value = false
      assert { !ForeignKey.value }

      ForeignKey.value = true
      assert { ForeignKey.value }
    end
  end

  it "disabled, enabled" do
    ForeignKey.new_context do
      assert { ForeignKey.disabled { ForeignKey.disabled? } }
      assert { ForeignKey.enabled { ForeignKey.enabled? } }
    end
  end
end
