require "rails_helper"

RSpec.describe "head_meta", type: :system do
  it "引数で apple-mobile-web-app-capable の値を指定する" do
    visit2("/", "apple-mobile-web-app-capable" => "value1")
    is_asserted_by { doc.at(%(meta[name="apple-mobile-web-app-capable"]))[:content] == "value1" }
  end
end
