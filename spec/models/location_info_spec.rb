require "rails_helper"

RSpec.describe LocationInfo, type: :model do
  it "[fix] nameが上書きされていないこと" do
    is_asserted_by { LocationInfo.fetch(:black).name == "▲" }
  end

  it "[fix] ▲をキーにできる" do
    is_asserted_by { LocationInfo.fetch("▲") }
  end
end
