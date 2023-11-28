require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  it "hankaku_format" do
    assert { !ApplicationRecord.respond_to?(:hankaku_format) }
  end
end
