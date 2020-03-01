module FrontScript
  class ProfessionalScript < Base
    self.script_name = "指導対局の棋譜"

    class ProfessionalInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "Yorimoto_Nana",    name: "頼本奈菜 女流初段", },
        { key: "Yamamoto_Hiroshi", name: "山本博志 四段",     },
      ]
    end

    def script_body
      ProfessionalInfo.collect do |e|
        row = {}

        row["指導棋士"] = h.link_to(e.name, [:swars, :battles, query: e.key])

        count = 0
        if user = Swars::User.find_by(key: e.key)
          count = Swars::Membership.where(user: user).count
        end
        row["棋譜数"] = count

        row
      end
    end
  end
end
