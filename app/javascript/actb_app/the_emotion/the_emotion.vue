<template lang="pug">
.the_emotion
  the_footer
  component(:is="current_component")
  pre(v-if="development_p") {{$data}}
</template>

<script>
import { support } from "../support.js"
import the_footer from "../the_footer.vue"

import the_emotion_index from "./the_emotion_index.vue"
import the_emotion_edit from "./the_emotion_edit.vue"

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
      current_record:   null, // 編集中のレコード
      current_component: null, // コンポーネント切り替え用
      tab_index:         null, // 一覧での現在のタブ
    }
  },

  created() {
    this.sound_play("click")

    const key = this.app.EmotionFolderInfo.fetch(0).key
    this.tab_select(key)

    if (this.app.info.warp_to) {
      if (this.app.info.warp_to === "emotion_index") {
        this.current_component = "the_emotion_index"
      }
      if (this.app.info.warp_to === "emotion_edit") {
        this.edit_handle(this.app.current_user.emotions[0])
      }
      return
    }

    this.current_component = "the_emotion_index"
  },
  methods: {
    tab_select(key) {
      this.tab_index = this.app.EmotionFolderInfo.fetch(key).code
    },
    play_handle(record) {
      this.app.emotion_play(record)
    },
    edit_handle(record) {
      this.__assert__(record, "record")
      this.current_record = record
      this.current_component = "the_emotion_edit"
    },
    new_handle() {
      this.edit_handle(this.default_attributes_clone())
    },
    default_attributes_clone() {
      return Object.assign({}, this.default_attributes)
    },
  },
  computed: {
    current_folder() {
      return this.app.EmotionFolderInfo.fetch(this.tab_index)
    },
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
