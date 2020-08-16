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
      current_emotion:            null, // 編集中のレコード
      current_component:          null, // コンポーネント切り替え用
      emotion_folder_tab_index: null, // 一覧での現在のタブ
    }
  },

  created() {
    this.sound_play("click")

    const key = this.app.EmotionFolderInfo.fetch(0).key
    this.emotion_mode_select(key)

    if (this.app.info.warp_to) {
      if (this.app.info.warp_to === "emotion_index") {
        this.current_component = "the_emotion_index"
      }
      if (this.app.info.warp_to === "emotion_edit") {
        this.emotion_edit_handle(this.app.current_user.emotions[0])
      }
      return
    }

    this.current_component = "the_emotion_index"
  },
  methods: {
    emotion_mode_select(key) {
      this.emotion_folder_tab_index = this.app.EmotionFolderInfo.fetch(key).code
    },

    emotion_test_handle(emotion) {
      this.app.emotion_call(emotion)
    },

    emotion_edit_handle(emotion) {
      this.__assert__(emotion, "emotion")
      this.current_emotion = emotion
      this.current_component = "the_emotion_edit"
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_emotion
</style>
