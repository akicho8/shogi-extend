require 'rails_helper'

RSpec.describe QueryInfo do
  let :query_info do
    QueryInfo.parse("foo:a foo:a foo:b,c https://example.com/")
  end

  it "lookup" do
    assert { query_info.lookup("foo") == ["a", "b", "c"] }
  end

  it "lookup_one" do
    assert { query_info.lookup_one("foo") == "a" }
  end

  it "urls" do
    assert { query_info.urls == ["https://example.com/"] }
  end
end
