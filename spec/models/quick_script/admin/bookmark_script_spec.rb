require "rails_helper"

RSpec.describe QuickScript::Admin::BookmarkScript, type: :model do
  it "works" do
    assert { QuickScript::Admin::BookmarkScript.new.call }
  end
end
