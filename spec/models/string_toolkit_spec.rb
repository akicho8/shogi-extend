require "rails_helper"

RSpec.describe StringToolkit do
  it "hankaku_format" do
    assert { StringToolkit.hankaku_format(" ０-９Ａ-Ｚａ-ｚ　　＃ ") == "0-9A-Za-z #" }
  end

  it "strip_tags" do
    assert { StringToolkit.strip_tags("<div>1</div>") == "1" }
  end

  it "script_tag_escape" do
    assert { StringToolkit.script_tag_escape("<div>1</div><script>2</script>") == "<div>1</div>&lt;script&gt;2&lt;/script&gt;" }
  end

  it "double_blank_lines_to_one_line" do
    assert { StringToolkit.double_blank_lines_to_one_line("a\n\n\nb") == "a\n\nb" }
  end

  it "secure_random_urlsafe_base64_token" do
    assert { StringToolkit.secure_random_urlsafe_base64_token.length == 11 }
  end

  it "plus_minus_split" do
    assert { StringToolkit.plus_minus_split("a -b c -d") == { true => ["a", "c"], false => ["b", "d"] } }
    assert { StringToolkit.plus_minus_split("a")         == { true => ["a"], false => [] } }
    assert { StringToolkit.plus_minus_split("-a")        == { true => [], false => ["a"] } }
    assert { StringToolkit.plus_minus_split("")          == { true => [], false => [] } }
    assert { StringToolkit.plus_minus_split("a b a")     == { true => ["a", "b"], false => [] } }
  end

  it "path_normalize" do
    assert { StringToolkit.path_normalize("あ い A:1") == "あ_い_A_1" }
  end

  it "control_chars_remove" do
    assert { StringToolkit.control_chars_remove("a\u0007b\u200Ec") == "abc" }
  end

  it "user_message_normalize" do
    assert { StringToolkit.user_message_normalize(" a\u0007b\u200Ec <hr> ") == "abc" }
  end
end
