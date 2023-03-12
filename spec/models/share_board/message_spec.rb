require "rails_helper"

RSpec.describe ShareBoard::Message do
  it "to_h" do
    object = ShareBoard::Message.new("user", "a/b/c")
    assert { object.to_h == { role: "user", content: "a/b/c" } }
  end

  it "to_gpt" do
    object = ShareBoard::Message.new("user", "a/b/c")
    assert { object.to_gpt == { role: "user", content: "a/b/c" } }
  end

  # it "to_redis_value" do
  #   object = ShareBoard::Message.new("user", "a/b/c")
  #   assert { object.to_redis_value == "user/a/b/c" }
  # end
  #
  # it ".from_redis_value" do
  #   object = ShareBoard::Message.from_redis_value("user/a/b/c")
  #   assert { object.to_h == { role: "user", content: "a/b/c" } }
  # end

  it "to_json" do
    object = ShareBoard::Message.new("user", "a/b/c")
    assert { JSON.parse(object.to_json) == {"role"=>"user", "content"=>"a/b/c"} }
  end

  # it "from_json" do
  #   object = ShareBoard::Message.new("user", "a/b/c")
  #   object = ShareBoard::Message.from_json(object.to_json)
  #   assert { object.to_h == { role: "user", content: "a/b/c" } }
  # end
end
