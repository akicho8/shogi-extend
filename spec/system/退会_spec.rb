require "rails_helper"

RSpec.describe type: :system, login_spec: true do
  it "works" do
    hex = SecureRandom.hex
    eval_code %(User.create!(key: "#{hex}", name: "退会者の名前"))
    login_by hex

    visit_to "/lab/account/destroy"
    find("#form_part-username").set("退会者の名前")
    find(:button, text: /退会する/).click
    assert_text "退会しました", wait: 5
  end
end
