import MemoryRecord from 'js-memory-record'

export class FolderInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "public",   name: "公開",     icon: "eye-outline",  type: null, message: {article: "Googleに存在がばれる",                                                           book: "トップに表示して誰でも見れる"}, },
      { key: "limited",  name: "限定公開", icon: "link",         type: null, message: {article: "リンクを知っている人だけ見れる (公開した問題集に入れるとリンクがばれるので注意)", book: "リンクを知っている人だけ見れる"}, },
      { key: "private",  name: "非公開",   icon: "lock",         type: null, message: {article: "直リンクされても見れない",                                                       book: "直リンクされても見れない"}, },
    ]
  }
}
