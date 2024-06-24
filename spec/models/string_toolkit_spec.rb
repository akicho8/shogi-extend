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
end
