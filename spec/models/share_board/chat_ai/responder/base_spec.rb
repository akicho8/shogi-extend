require "rails_helper"

module ShareBoard
  RSpec.describe ChatAi::Responder::Base do
    it "works" do
      def case1(s)
        ChatAi::Responder::Base.new(content: s).normalized_message_content
      end
      assert { case1("foo")          == "foo"    }
      assert { case1("@gpt")         == ""       }
      assert { case1("@gptあ")       == "あ"     }
      assert { case1("@gpt　あ")     == "　あ"   }
      assert { case1("hello>gpt")    == "hello"  }
      assert { case1("hello > gpt ") == "hello"  }
      assert { case1("hello ＞ gpt ") == "hello" }
    end
  end
end
