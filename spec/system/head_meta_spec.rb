require "rails_helper"

RSpec.describe "head_meta", type: :system do
  it "引数で apple-mobile-web-app-capable の値を指定する" do
    visit_to("/", "apple-mobile-web-app-capable" => "value1")
    assert { doc.at(%(meta[name="apple-mobile-web-app-capable"]))[:content] == "value1" }
  end
end
