import MemoryRecord from 'js-memory-record'

export class FolderInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "public",   name: "公開",   pulldown_name: "",  },
      { key: "private",  name: "非公開", pulldown_name: "🔒", }, // https://lets-emoji.com/emojilist/emojilist-7/
    ]
  }
}
