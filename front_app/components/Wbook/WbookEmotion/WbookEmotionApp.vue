<template lang="pug">
.WbookEmotionApp
  WbookFooter(:base="base")
  WbookEmotionIndex(:base="base" v-if="current_component === 'WbookEmotionIndex'")
  WbookEmotionEdit( :base="base" v-if="current_component === 'WbookEmotionEdit'")
  DebugPre {{$data}}
</template>

<script>
import { support_child }       from "../support_child.js"

export default {
  name: "WbookEmotionApp",
  mixins: [
    support_child,
  ],

  data() {
    return {
      current_record:    null, // 編集中のレコード
      current_component: null, // コンポーネント切り替え用
      current_tabpos:    null, // 一覧での現在のタブ
    }
  },

  created() {
    const key = this.base.EmotionFolderInfo.fetch(0).key
    this.tab_select(key)

    this.current_component = "WbookEmotionIndex"
    if (this.base.current_user.emotions.length === 0) {
      this.ok_notice("既存のエモーションを編集するには左上のメニューからインポートしてください")
    }

    if (this.base.info.warp_to) {
      if (this.base.info.warp_to === "emotion_index") {
        this.current_component = "WbookEmotionIndex"
      }
      if (this.base.info.warp_to === "emotion_edit") {
        this.edit_handle(this.base.current_user.emotions[0])
      }
      return
    }
  },
  methods: {
    // 指定のタブを選択
    tab_select(key) {
      this.current_tabpos = this.base.EmotionFolderInfo.fetch(key).code
    },
    // エモーションの再生
    play_handle(record) {
      this.base.emotion_play(record)
    },
    // 指定レコードの編集
    edit_handle(record) {
      this.__assert__(record, "record")
      this.current_record = record
      this.current_component = "WbookEmotionEdit"
      this.sound_play("click")
    },
    // 新規編集
    new_handle() {
      this.edit_handle(this.default_attributes_clone())
    },
    // 新規用のレコード
    default_attributes_clone() {
      return _.cloneDeep(this.default_attributes)
    },
  },
  computed: {
    // 現在のタブに対応するフォルダ
    current_folder() {
      return this.base.EmotionFolderInfo.fetch(this.current_tabpos)
    },
    // 新規用のレコードの初期値(これをそのまま使うと破壊してしまうのでcloneすること)
    default_attributes() {
      return {
        name: "",
        message: "",
        voice: "",
        folder_key: this.current_folder.key,
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookEmotionApp
</style>
