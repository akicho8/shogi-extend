require "rails_helper"

RSpec.describe LocationInfo, type: :model do
  it "[fix] nameが上書きされていないこと" do
    assert2 { LocationInfo.fetch(:black).name == "▲" }
  end

  it "[fix] ▲をキーにできる" do
    assert2 { LocationInfo.fetch("▲") }
  end
end
