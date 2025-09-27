<template lang="pug">
.KiwiBananaEditForm
  .columns.is-centered.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd.form_block
    //- .columns.is-variable.is-0-mobile.is-5-tablet.is-6-desktop
    //- .column.is-6
    //-   b-field.field_block(label="ソース")
    //-     .control
    //-       template(v-if="base.banana.lemon.content_type.startsWith('video')")
    //-         .image
    //-           video.is-block(:src="base.banana.lemon.browser_path" :poster="base.banana.lemon.thumbnail_browser_path" controls :autoplay="false" :loop="false")
    //-       template(v-else-if="base.banana.lemon.content_type.startsWith('image')")
    //-         .image
    //-           img(:src="base.banana.lemon.browser_path")
    //-       template(v-else-if="base.banana.lemon.content_type === 'application/zip'")
    //-         b-icon(icon="zip-box-outline" size="is-large")
    //-       template(v-else)
    //-         p base.banana.lemon.content_type: {{base.banana.lemon.content_type}}
    //-         p browser_path: {{base.banana.lemon.browser_path}}

    .column.is-12-tablet.is-3-desktop
      .field_block(v-if="base.banana.lemon.recipe_info.thumbnail_p")
        b-field(label="サムネ位置" :message="`${base.banana.thumbnail_pos}`")
          .control
            .image
              video.is-block(:src="base.banana.lemon.browser_path" controls :autoplay="false" :loop="false" ref="video_tag")
        //- b-field.mt-3(label="")
        //-   //- .control(v-if="development_p")
        //-   //-   b-button(@click="thumbnail_pos_set_handle") 反映
        //-   //- b-input(v-model.trim="base.banana.thumbnail_pos" readonly expanded)
        //-   .control
        //-     p {{base.banana.thumbnail_pos}}

        //- .image.mt-4(v-if="development_p")
        //-   img(:src="base.banana.lemon.thumbnail_browser_path")

      b-field.field_block(label="ソース" v-if="!base.banana.lemon.recipe_info.thumbnail_p")
        .control
          template(v-if="base.banana.lemon.content_type.startsWith('image')")
            .image
              img(:src="base.banana.lemon.browser_path")
          template(v-else-if="base.banana.lemon.content_type === 'application/zip'")
            b-icon(icon="zip-box-outline" size="is-large")
          template(v-else)
            p base.banana.lemon.content_type: {{base.banana.lemon.content_type}}
            p browser_path: {{base.banana.lemon.browser_path}}

    .column.is-12-tablet.is-5-desktop

      b-field.field_block(label="タイトル")
        b-input(v-model.trim="base.banana.title" required :maxlength="100" placeholder="動画について説明するタイトルを追加しよう")

      b-field.field_block(label="説明")
        b-input(v-model.trim="base.banana.description" type="textarea" rows="5" :maxlength="5000" placeholder="動画の内容を紹介しよう")

    .column.is-12-tablet.is-4-desktop
      b-field.field_block(label="タグ")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.banana.tag_list" rounded :on-paste-separators="[',', ' ']" :confirm-keys="[',', 'Tab', 'Enter']")

      b-field.field_block(label="公開設定" :message="FolderInfo.fetch(base.banana.folder_key).message")
        b-field.is-marginless
          template(v-for="e in FolderInfo.values")
            b-radio-button(v-model="base.banana.folder_key" :native-value="e.key" @input="folder_key_input_handle")
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
    .column.is-12
      b-field.submit_field
        .control
          b-button.has-text-weight-bold.banana_save_handle(@click="base.banana_save_handle" type="is-primary" :class="{disabled: !base.save_button_enabled}") {{base.save_button_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaEditForm",
  mixins: [support_child],
  mounted() {
    if (this.$refs.video_tag) {
      this.$refs.video_tag.currentTime = this.base.banana.thumbnail_pos
      this.$refs.video_tag.addEventListener("timeupdate", this.timeupdate_hook)
    }
  },
  beforeDestroy() {
    if (this.$refs.video_tag) {
      this.$refs.video_tag.removeEventListener("timeupdate", this.timeupdate_hook)
    }
  },
  methods: {
    timeupdate_hook(e) {
      this.base.banana.thumbnail_pos = e.target.currentTime
    },
    thumbnail_pos_set_handle() {
      this.sfx_play_click()
      this.base.banana.thumbnail_pos = this.$refs.video_tag.currentTime
    },
    folder_key_input_handle(e) {
      this.sfx_play_click()
      const folder_info = this.FolderInfo.fetch(e)
      this.talk(folder_info.name)
    },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaEditForm
  // +tablet
  //   .image
  //     max-width: 320px
</style>
