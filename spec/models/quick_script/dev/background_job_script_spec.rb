require "rails_helper"

module QuickScript
  RSpec.describe Dev::BackgroundJobScript, type: :model do
    it "works" do
      assert { Dev::BackgroundJobScript.new.call == nil }
      assert { Dev::BackgroundJobScript.new({qs_group_key: "dev", qs_page_key: "background_job"}, {_method: "post"}).call == {:_autolink=>nil} }
      assert { Dev::BackgroundJobScript.new({qs_group_key: "dev", qs_page_key: "background_job"}, {background_mode: true}).call.kind_of?(AppLog) }
    end
  end
end
