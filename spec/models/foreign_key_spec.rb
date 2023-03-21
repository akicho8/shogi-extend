require "rails_helper"

RSpec.describe ForeignKey, type: :model do
  it "value" do
    ForeignKey.new_context do
      ForeignKey.value = false
      is_asserted_by { !ForeignKey.value }

      ForeignKey.value = true
      is_asserted_by { ForeignKey.value }
    end
  end

  it "disabled, enabled" do
    ForeignKey.new_context do
      is_asserted_by { ForeignKey.disabled { ForeignKey.disabled? } }
      is_asserted_by { ForeignKey.enabled { ForeignKey.enabled? } }
    end
  end
end
