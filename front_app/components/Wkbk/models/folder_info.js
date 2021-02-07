import MemoryRecord from 'js-memory-record'

export class FolderInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "public",   name: "公開",     icon: "eye-outline",     },
      { key: "limited",  name: "限定公開", icon: "eye-outline",     },
      { key: "private",  name: "非公開",   icon: "eye-off-outline", },
    ]
  }
}
