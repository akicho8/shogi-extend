require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  describe "developer_notice" do
    def mail
      ApplicationMailer.developer_notice(subject: "(subject)")
    end
    it do
      assert { mail.from    == ["shogi.extend@gmail.com"]       }
      assert { mail.to      == ["shogi.extend@gmail.com"]       }
      assert { mail.subject == "[SHOGI-EXTEND][test] (subject)" }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.14285 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
