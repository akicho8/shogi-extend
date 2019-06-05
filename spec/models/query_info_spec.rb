require 'rails_helper'

RSpec.describe QueryInfo, type: :model do
  it do
    assert { QueryInfo.parse("foo:a foo:b,c").attributes == {foo: ["a", "b", "c"]} }
    assert { QueryInfo.parse("foo:a foo:a").attributes == {foo: ["a"]} }
  end
end
