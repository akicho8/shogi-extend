require "rails_helper"

RSpec.describe StringSupport do
  it "hankaku_format" do
    assert { StringSupport.hankaku_format(" ０-９Ａ-Ｚａ-ｚ　　＃ ") == "0-9A-Za-z #" }
  end

  it "strip_tags" do
    assert { StringSupport.strip_tags("<div>1</div>") == "1" }
  end

  it "script_tag_escape" do
    assert { StringSupport.script_tag_escape("<div>1</div><script>2</script>") == "<div>1</div>&lt;script&gt;2&lt;/script&gt;" }
  end

  it "double_blank_lines_to_one_line" do
    assert { StringSupport.double_blank_lines_to_one_line("a\n\n\nb") == "a\n\nb" }
  end

  it "secure_random_urlsafe_base64_token" do
    assert { StringSupport.secure_random_urlsafe_base64_token.length == 11 }
  end

  it "plus_minus_split" do
    assert { StringSupport.plus_minus_split("a -b c -d") == { true => ["a", "c"], false => ["b", "d"] } }
    assert { StringSupport.plus_minus_split("a")         == { true => ["a"], false => [] } }
    assert { StringSupport.plus_minus_split("-a")        == { true => [], false => ["a"] } }
    assert { StringSupport.plus_minus_split("")          == { true => [], false => [] } }
    assert { StringSupport.plus_minus_split("a b a")     == { true => ["a", "b"], false => [] } }
  end

  it "path_normalize" do
    assert { StringSupport.path_normalize("あ い A:1") == "あ_い_A_1" }
  end

  it "control_chars_remove" do
    assert { StringSupport.control_chars_remove("a\u0007b\u200Ec") == "abc" }
  end

  it "user_message_normalize" do
    assert { StringSupport.user_message_normalize(" a\u0007b\u200Ec <hr> ") == "abc" }
  end
end
