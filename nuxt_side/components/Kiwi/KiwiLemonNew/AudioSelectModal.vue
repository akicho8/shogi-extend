<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | BGM選択
    .delete(@click="close_handle")
  .modal-card-body
    .columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop
      template(v-for="e in base.AudioThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="!e.separator")
            .column.is-6-tablet
              a.box(@click="click_handle(e)" :class="{'has-background-warning-light': e.key === new_key}")
                .media
                  .media-left(v-if="e.sample_source")
                    KiwiLemonNewAudioPlay(:base="base" :src="e.sample_source" :volume="base.main_volume" @play="e => base.current_play_instance = e")
                  .media-content
                    template(v-if="e.source_url")
                      a(@click.stop="jump_to_source_url_handle(e)") {{e.name}}
                    template(v-else)
                      | {{e.name}}
                    .audio_desc(v-if="e.audio_part_a_duration")
                      .audio_desc_item(v-if="e.author_raw") {{e.author_raw}}
                      .audio_desc_item(v-if="e.author") 作曲: {{e.author}}
                      .audio_desc_item
                        span 長さ: {{e.duration_mmss}}
                        span.ml-1(v-if="e.duration_sec >= 60") ({{e.duration_sec}}s)
                      .audio_desc_item(v-if="e.bpm")
                        span 速度: {{e.bpm}}BPM
                      .audio_desc_item(v-if="e.loop_support_p") ループ対応
                    p.is-size-7.is_line_break_on(v-if="e.desc") {{e.desc}}
                  .media-right(v-if="false")
                    a(:href="e.source_url" v-if="e.source_url" target="_blank")
                      b-icon(icon="open-in-new" size="is-small")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.submit_handle(@click="submit_handle" type="is-primary" v-if="!ONE_CLICK_MODE_P") 適用
</template>

<script>
import { support_child   } from "./support_child.js"

export default {
  name: "AudioSelectModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      new_key: this.base.audio_theme_key,
      ONE_CLICK_MODE_P: true,
    }
  },

  methods: {
    close_handle() {
      this.sfx_play_click()
      this.$emit("close")
    },
    click_handle(e) {
      if (this.ONE_CLICK_MODE_P) {
        this.new_key = e.key
        this.submit_handle()
      } else {
        if (this.new_key === e.key) {
          // this.submit_handle()
        } else {
          this.sfx_play_click()
          this.new_key = e.key
        }
      }
    },
    submit_handle() {
      this.sfx_play_click()
      this.base.audio_theme_key = this.new_key
      this.talk(this.base.audio_theme_info.introduction)
      this.$emit("close")
    },
    jump_to_source_url_handle(e) {
      this.sfx_play_click()
      this.$buefy.dialog.confirm({
        message: `本家に飛びますか？`,
        cancelText: "キャンセル",
        confirmText: `飛ぶ`,
        focusOn: "confirm", // confirm or cancel
        animation: "",
        onCancel: () => this.sfx_play_click(),
        onConfirm: () => {
          this.base.current_play_instance_stop() // 本家でBGMを聞くのだろうからこちらは消音
          this.sfx_play_click()
          this.other_window_open(e.source_url)
        },
      })
    },
  },
}
</script>

<style lang="sass">
@import "all_support.sass"
.AudioSelectModal
  +modal_width_auto

  .modal-card-body
    padding: 1.0rem
    white-space: pre-wrap
    word-break: break-all

  .audio_desc
    font-size: $size-7
    color: $grey
</style>
