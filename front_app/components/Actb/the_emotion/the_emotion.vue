<template lang="pug">
.the_emotion
  the_footer
  component(:is="current_component")
  DebugPre {{$data}}
</template>

<script>
import { support }       from "../support.js"
import the_footer        from "../the_footer.vue"
import the_emotion_index from "./the_emotion_index.vue"
import the_emotion_edit  from "./the_emotion_edit.vue"

export default {
  name: "the_emotion",
  mixins: [
    support,
  ],
  components: {
    the_footer,
    the_emotion_index,
    the_emotion_edit,
  },
  data() {
    return {
      current_record:    null, // 編集中のレコード
      current_component: null, // コンポーネント切り替え用
      current_tabpos:    null, // 一覧での現在のタブ
    }
  },

  created() {
    this.sound_play("click")

    const key = this.app.EmotionFolderInfo.fetch(0).key
    this.tab_select(key)

    this.current_component = "the_emotion_index"
    if (this.app.current_user.emotions.length === 0) {
      this.ok_notice("既存のエモーションを編集するには左上のメニューからインポートしてください")
    }

    if (this.app.info.warp_to) {
      if (this.app.info.warp_to === "emotion_index") {
        this.current_component = "the_emotion_index"
      }
      if (this.app.info.warp_to === "emotion_edit") {
        this.edit_handle(this.app.current_user.emotions[0])
      }
      return
    }
  },
  methods: {
    // 指定のタブを選択
    tab_select(key) {
      this.current_tabpos = this.app.EmotionFolderInfo.fetch(key).code
    },
    // エモーションの再生
    play_handle(record) {
      this.app.emotion_play(record)
    },
    // 指定レコードの編集
    edit_handle(record) {
      this.__assert__(record, "record")
      this.current_record = record
      this.current_component = "the_emotion_edit"
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
      return this.app.EmotionFolderInfo.fetch(this.current_tabpos)
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
.the_emotion
</style>
