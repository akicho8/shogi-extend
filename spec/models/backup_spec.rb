require "rails_helper"

RSpec.describe Backup, type: :model do
  it "works" do
    quietly { Backup.call }
  end
end
