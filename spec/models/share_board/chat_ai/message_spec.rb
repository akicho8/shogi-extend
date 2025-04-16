require "rails_helper"

RSpec.describe ShareBoard::ChatAi::Message do
  it "to_h" do
    object = ShareBoard::ChatAi::Message.new(:user, "a/b/c")
    assert { object.to_h == { role: "user", content: "a/b/c" } }
  end

  it "to_api" do
    object = ShareBoard::ChatAi::Message.new(:user, "a/b/c")
    assert { object.to_api == { role: "user", content: "a/b/c" } }
  end

  # it "to_redis_value" do
  #   object = ShareBoard::ChatAi::Message.new("user", "a/b/c")
  #   assert { object.to_redis_value == "user/a/b/c" }
  # end
  #
  # it ".from_redis_value" do
  #   object = ShareBoard::ChatAi::Message.from_redis_value("user/a/b/c")
  #   assert { object.to_h == { role: "user", content: "a/b/c" } }
  # end

  it "to_json" do
    object = ShareBoard::ChatAi::Message.new(:user, "a/b/c")
    assert { JSON.parse(object.to_json) == { "role"=>"user", "content"=>"a/b/c" } }
  end

  # it "from_json" do
  #   object = ShareBoard::ChatAi::Message.new("user", "a/b/c")
  #   object = ShareBoard::ChatAi::Message.from_json(object.to_json)
  #   assert { object.to_h == { role: "user", content: "a/b/c" } }
  # end
end
