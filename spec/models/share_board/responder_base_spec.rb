require "rails_helper"

RSpec.describe ShareBoard::ResponderBase do
  it "works" do
    is_asserted_by { ShareBoard::ResponderBase.new(message: "foo").normalized_user_message == "foo"       }
    is_asserted_by { ShareBoard::ResponderBase.new(message: "@gpt").normalized_user_message == ""         }
    is_asserted_by { ShareBoard::ResponderBase.new(message: "@gptあ").normalized_user_message == "あ"     }
    is_asserted_by { ShareBoard::ResponderBase.new(message: "@gpt　あ").normalized_user_message == "　あ" }
  end
end
