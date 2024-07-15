require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe  PrisonSearchScript, type: :model do
      before do
        ::Swars::User.create!(user_key: "alice", grade_key: "九段").ban!
        ::Swars::User.create!(user_key: "bob",   grade_key: "初段").ban!
        ::Swars::User.create!(user_key: "carol", grade_key: "初段")
      end

      def case1(query)
        PrisonSearchScript.new(query: query).as_json[:body][:rows].size
      end

      it "BANされた人だけを引く" do
        assert { case1("") == 2 }
      end

      it "名前への部分一致" do
        assert { case1("lic") == 1 }
      end

      it "段級位への部分一致" do
        assert { case1("初") == 1 }
      end
    end
  end
end
