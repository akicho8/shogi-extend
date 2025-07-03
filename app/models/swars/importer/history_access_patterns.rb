# frozen-string-literal: true

module Swars
  module Importer
    HistoryAccessPatterns = [
      { imode_key: "通常",       xmode_key: "野良", rule_key: "10分", },
      { imode_key: "通常",       xmode_key: "野良", rule_key: "3分",  },
      { imode_key: "通常",       xmode_key: "野良", rule_key: "10秒", },

      { imode_key: "通常",       xmode_key: "友達", rule_key: "10分", },
      { imode_key: "通常",       xmode_key: "友達", rule_key: "3分",  },
      { imode_key: "通常",       xmode_key: "友達", rule_key: "10秒", },
      { imode_key: "通常",       xmode_key: "友達", rule_key: "カスタム", },

      { imode_key: "通常",       xmode_key: "指導", rule_key: "10分", },

      { imode_key: "通常",       xmode_key: "大会", rule_key: "10分", },
      { imode_key: "通常",       xmode_key: "大会", rule_key: "3分",  },
      { imode_key: "通常",       xmode_key: "大会", rule_key: "10秒", },

      { imode_key: "スプリント", xmode_key: "野良", rule_key: "3分",  },

      { imode_key: "スプリント", xmode_key: "友達", rule_key: "10分", },
      { imode_key: "スプリント", xmode_key: "友達", rule_key: "3分",  },
      { imode_key: "スプリント", xmode_key: "友達", rule_key: "10秒", },
      { imode_key: "スプリント", xmode_key: "友達", rule_key: "カスタム", },
    ]
  end
end
