import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class SearchPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "新着",     login_required_p: false, },
      { key: "視聴数",   login_required_p: false, },
      { key: "居飛車",   login_required_p: false, },
      { key: "振り飛車", login_required_p: false, },
      { key: "右玉",     login_required_p: false, },
      { key: "履歴",     login_required_p: true,  },
      { key: "公開",     login_required_p: true,  },
      { key: "限定公開", login_required_p: true,  },
      { key: "非公開",   login_required_p: true,  },
    ]
  }

  showable_p(g_current_user) {
    if (this.login_required_p) {
      if (g_current_user) {
        return true
      } else {
        return false
      }
    } else {
      return true
    }
  }
}
