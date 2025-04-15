require "rails_helper"

RSpec.describe SystemMailer, type: :mailer do
  describe "notify" do
    let(:mail) do
      SystemMailer.notify(fixed: true, subject: "(subject)", body: {foo: 1}, table_format: true)
    end

    it "送信元と送信先が正しい" do
      assert { mail.from == ["shogi.extend@gmail.com"] }
      assert { mail.to   == ["shogi.extend@gmail.com"] }
    end

    it "subject" do
      assert { mail.subject == "[test] (subject)" }
    end

    it "table_format オプションがあると本文がハッシュだった場合に to_t する" do
      assert { mail.body.include?("| foo | 1 |") }
    end

    it "固定幅にするため pre タグで囲んでいる" do
      assert { mail.body.to_s.match?(%r{<pre.*</pre>}) }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> SystemMailer
# >>   notify
# >>     送信元と送信先が正しい
# >>     subject
# >>     table_format オプションがあると本文がハッシュだった場合に to_t する
# >>     固定幅にするため pre タグで囲んでいる
# >> 
# >> Top 4 slowest examples (0.12886 seconds, 6.0% of total time):
# >>   SystemMailer notify 送信元と送信先が正しい
# >>     0.10341 seconds -:9
# >>   SystemMailer notify subject
# >>     0.00894 seconds -:14
# >>   SystemMailer notify table_format オプションがあると本文がハッシュだった場合に to_t する
# >>     0.00826 seconds -:18
# >>   SystemMailer notify 固定幅にするため pre タグで囲んでいる
# >>     0.00824 seconds -:22
# >> 
# >> Finished in 2.16 seconds (files took 1.62 seconds to load)
# >> 4 examples, 0 failures
# >> 
