require "rails_helper"

RSpec.describe ShareBoard::ChatAi::Responder::Base do
  def case1(s)
    ShareBoard::ChatAi::Responder::Base.new(content: s).normalized_message_content
  end

  it "大文字小文字を区別しない" do
    assert { case1("@gpt hello")     == "hello"  }
    assert { case1("@GPT hello")     == "hello"  }
    assert { case1("＠ＧＰＴ hello") == "hello"  }
    assert { case1("＠ｇｐｔ hello") == "hello"  }
  end

  it "gptのあとに半角アルファベットが来ても解釈する" do
    assert { case1("@gpthello")     == "hello"  }
    assert { case1("@gpt hello")    == "hello"  }
    assert { case1("＠ＧＰＴhello") == "hello"  }
  end

  it "リダイレクト表記" do
    assert { case1("hello>gpt")    == "hello"  }
    assert { case1("hello > gpt ") == "hello"  }
    assert { case1("hello ＞ gpt ") == "hello" }
  end

  it "空" do
    assert { case1("@gpt") == "" }
  end

  it "@gpt なし" do
    assert { case1("hello") == "hello"  }
  end

  it "@gpt の直後に全角" do
    assert { case1("@gptあ")   == "あ" }
    assert { case1("@gpt　あ") == "あ" }
  end
end
