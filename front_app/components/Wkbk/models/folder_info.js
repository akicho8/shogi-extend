import MemoryRecord from 'js-memory-record'

export class FolderInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "private",  name: "非公開", icon: "eye-off", pulldown_name: "",        }, // 🔒 https://lets-emoji.com/emojilist/emojilist-7/
      { key: "public",   name: "公開",   icon: "eye",     pulldown_name: " (公開)", },
    ]
  }
}
