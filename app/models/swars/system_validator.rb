module Swars
  class SystemValidator
    def call
      hv = {
        "membership.battle が引けない membership 数" => Membership.where.missing(:battle).count,
      }
      AppLog.important(subject: "DB不整合", body: hv.to_t)
    end
  end
end
