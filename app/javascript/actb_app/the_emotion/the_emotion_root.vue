<template lang="pug">
.the_emotion_root
  the_footer
  component(:is="current_component")
  pre(v-if="development_p") {{$data}}
</template>

<script>
import { support } from "../support.js"
import the_footer from "../the_footer.vue"

import the_emotion_root_index from "./the_emotion_root_index.vue"
import the_emotion_root_edit from "./the_emotion_root_edit.vue"

export default {
  name: "the_emotion_root",
  mixins: [
    support,
  ],
  components: {
    the_footer,
    the_emotion_root_index,
    the_emotion_root_edit,
  },
  data() {
    return {
      current_emotion:            null, // 編集中のレコード
      current_component:          null, // コンポーネント切り替え用
      emotion_category_tab_index: null, // 一覧での現在のタブ
    }
  },

  created() {
    this.sound_play("click")
    this.app.lobby_unsubscribe()

    const key = this.app.EmotionCategoryInfo.fetch(0).key
    this.emotion_mode_select(key)

    if (this.app.info.warp_to) {
      if (this.app.info.warp_to === "emotion_root_index") {
        this.current_component = "the_emotion_root_index"
      }
      if (this.app.info.warp_to === "emotion_root_edit") {
        this.emotion_edit_handle(this.app.current_user.emotions[0])
      }
      return
    }

    this.current_component = "the_emotion_root_index"
  },
  methods: {
    emotion_mode_select(key) {
      this.emotion_category_tab_index = this.app.EmotionCategoryInfo.fetch(key).code
    },

    emotion_edit_handle(emotion) {
      this.__assert__(emotion, "emotion")
      this.current_emotion = emotion
      this.current_component = "the_emotion_root_edit"
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_emotion_root
</style>
