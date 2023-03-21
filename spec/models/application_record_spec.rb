require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  it "hankaku_format" do
    is_asserted_by { !ApplicationRecord.respond_to?(:hankaku_format) }
  end
end
