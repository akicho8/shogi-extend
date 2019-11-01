require 'rails_helper'

RSpec.describe SlackAgent do
  let(:user_agent_string) { "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5A345 Safari/525.20" }
  let(:user_agent_info) { UserAgent.parse(user_agent_string) }

  it do
    ret_hash = SlackAgent.message_send(key: "(key)", body: "(body)", ua: user_agent_info)
    assert { ret_hash[:text] == ":iphone:【(key)】(body) (Safari iPhone iOS 2.0)" }
  end
end
