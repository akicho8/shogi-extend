import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class FolderInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "public",   name: "公開",     icon: "eye-outline",  type: null, message: {article: "Googleに存在がばれる",                                                                  book: "トップに表示して誰でも参照できる"}, },
      { key: "limited",  name: "限定公開", icon: "link",         type: null, message: {article: "リンクを伝えた人だけ参照できる (ただし公開した問題集に入れるとリンクがばれるので注意)", book: "リンクを伝えた人だけ参照できる"}, },
      { key: "private",  name: "非公開",   icon: "lock",         type: null, message: {article: "本人だけ参照できる",                                                                    book: "本人だけ参照できる"}, },
    ]
  }
}
