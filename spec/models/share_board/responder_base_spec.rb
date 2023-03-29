require "rails_helper"

RSpec.describe ShareBoard::ResponderBase do
  it "works" do
    def case1(s)
      ShareBoard::ResponderBase.new(message: s).normalized_user_message
    end
    assert2 { case1("foo")          == "foo"    }
    assert2 { case1("@gpt")         == ""       }
    assert2 { case1("@gptあ")       == "あ"     }
    assert2 { case1("@gpt　あ")     == "　あ"   }
    assert2 { case1("hello>gpt")    == "hello"  }
    assert2 { case1("hello > gpt ") == "hello"  }
    assert2 { case1("hello ＞ gpt ") == "hello" }
  end
end
