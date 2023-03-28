require "rails_helper"

RSpec.describe ShareBoard::ResponderBase do
  it "works" do
    def case1(s)
      ShareBoard::ResponderBase.new(message: s).normalized_user_message
    end
    is_asserted_by { case1("foo")          == "foo"    }
    is_asserted_by { case1("@gpt")         == ""       }
    is_asserted_by { case1("@gptあ")       == "あ"     }
    is_asserted_by { case1("@gpt　あ")     == "　あ"   }
    is_asserted_by { case1("hello>gpt")    == "hello"  }
    is_asserted_by { case1("hello > gpt ") == "hello"  }
    is_asserted_by { case1("hello ＞ gpt ") == "hello" }
  end
end
