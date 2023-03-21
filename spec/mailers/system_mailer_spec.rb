require "rails_helper"

RSpec.describe SystemMailer, type: :mailer do
  describe "notify" do
    def mail
      SystemMailer.notify(fixed: true, subject: "(subject)")
    end
    it "works" do
      is_asserted_by { mail.from    == ["shogi.extend@gmail.com"]       }
      is_asserted_by { mail.to      == ["shogi.extend@gmail.com"]       }
      is_asserted_by { mail.subject == "[test] (subject)" }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.14285 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
