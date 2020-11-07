require 'rails_helper'

RSpec.describe SlackAgent do
  let(:user_agent_string) { "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5A345 Safari/525.20" }

  it do
    ret_hash = SlackAgent.message_send(key: "(key)", body: "(body)")
    assert { ret_hash[:text] == "[test]【(key)】(body)" }
  end

  it "OS不明の場合" do
    ret_hash = SlackAgent.message_send(key: "(key)", body: "(body)")
    assert { ret_hash[:text] == "[test]【(key)】(body)" }
  end
end
