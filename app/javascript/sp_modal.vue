<template lang="pug">
  // https://buefy.org/documentation/modal
  b-modal.sp_modal(:active.sync="current_modal_p" trap-focus animation="zoom-in" :full-screen="true" :can-cancel="['escape', 'outside']" :has-modal-card="true")
    template(v-if="record")
      .modal-card.is-shogi-player-modal-card(style="width:auto")
        .modal-card-body
          .delete.is-medium(aria-label="close" @click="current_modal_p = false" v-if="true")
          // button.modal-close.is-large(class="delete" aria-label="close" @click="current_modal_p = false" v-if="true")

          template(v-if="record.title")
            .title.is-5.yumincho.has-text-centered
              template(v-if="record.saturn_key === 'private'")
                b-icon.has-text-grey-light(icon="lock" size="is-small")
                | &nbsp;
              | {{record.title}}

          template(v-if="!record.sfen_body")
            .modal_loading_content
              b-loading(:is-full-page="false" :active="!record.sfen_body" :can-cancel="true")

          template(v-if="record.sfen_body")
            shogi_player(
              :run_mode.sync="sp_run_mode"
              :debug_mode="false"
              :start_turn="start_turn"
              :kifu_body="record.sfen_body"
              :key_event_capture="true"
              :slider_show="true"
              :sfen_show="false"
              :controller_show="true"
              :theme="'simple'"
              :size="'default'"
              :sound_effect="true"
              :volume="0.2"
              :setting_button_show="false"
              :flip="record.fliped"
              :player_info="record.player_info"
              @update:start_turn="real_turn_update"
              ref="sp_modal"
            )

            .sp_modal_branch.has-text-centered
              b-switch(v-model="sp_run_mode" true-value="play_mode" false-value="view_mode") 継盤

            template(v-if="record.description")
              .sp_modal_desc.has-text-centered.is-size-7.has-text-grey
                | {{record.description}}

            pre(v-if="development_p")
              | start_turn: {{start_turn}}
              | real_turn: {{real_turn}}
              | record.force_turn: {{record.force_turn}}
              | record.sp_turn: {{record.sp_turn}}
              | record.critical_turn: {{record.critical_turn}}

        footer.modal-card-foot
          a.button.piyo_button.is-small(@click.stop="" type="button" :href="record.piyo_shogi_app_url")
            span.icon
              img(:src="piyo_shogi_icon")
            span ぴよ将棋

          b-button.kento_app_button(tag="a" size="is-small" @click.stop="" :href="`${record.kento_app_url}#${real_turn}`")
            | ☗ KENTO \#{{real_turn}}

          template(v-if="record.kifu_copy_params")
            a.button.is-small(@click.stop.prevent="kif_clipboard_copy(record.kifu_copy_params)")
              b 棋譜コピー

          template(v-if="pulldown_menu_p")
            pulldown_menu(:record="record" :in_modal_p="true" :real_turn="real_turn")

          template(v-if="false")
            a.button.is-small(@click="current_modal_p = false") 閉じる
</template>

<script>

import piyo_shogi_icon from "piyo_shogi_icon.png"

export default {
  name: "sp_modal",

  props: {
    record:          { required: false                  }, // モーダルに表示するバトル情報
    sp_modal_p:      { required: false                  }, // モーダルを表示する？
    pulldown_menu_p: { required: false, default: true,  }, // 右のプルダウンを表示する？
    end_show:        { required: false, default: false, }, // 終局図を表示する？
  },

  data() {
    return {
      current_modal_p: null,
      sp_run_mode: "view_mode",
      real_turn: null,
    }
  },

  watch: {
    sp_modal_p: { immediate: true, handler(v) { this.current_modal_p = v }, }, // 外→内 sp_modal_p --> current_modal_p
    current_modal_p(v) {
      if (v) {
        this.turn_slider_focus_delay() // 開き直したときに反応させるため record.sfen_body の watch にフックするのではだめ
      }
      this.$emit("update:sp_modal_p", v)
    },                 // 外←内 sp_modal_p <-- current_modal_p

    record() { this.real_turn = this.start_turn },                        // record がセットされた瞬間に開始手数を保存 (KENTOに渡すためでもある)

    sp_run_mode(v) {
      if (v === "play_mode") {
        this.$buefy.toast.open({message: "駒を操作できます", position: "is-top", type: "is-info", duration: 1000 * 1, queue: false})
      } else {
        this.$buefy.toast.open({message: "元に戻しました", position: "is-top", type: "is-info", duration: 1000 * 1, queue: false})
      }
      this.turn_slider_focus()
    },
  },

  methods: {
    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn_for(record) {
      if (record) {
        if (this.end_show) {
          return record.turn_max
        }

        if ("force_turn" in record) {
          return record.force_turn
        }

        return record.sp_turn
      }
    },

    real_turn_update(pos) {
      this.real_turn = pos
    },

    kif_clipboard_copy(params) {
      this.kif_clipboard_copy(params)
    },

    // this.$nextTick(() => this.turn_slider_focus()) の方法だと失敗する
    turn_slider_focus_delay() {
      setTimeout(() => this.turn_slider_focus(), 1)
    },

    turn_slider_focus() {
      const dom = document.querySelector(".turn_slider")
      if (dom) {
        dom.focus()
      }
    },
  },

  computed: {
    piyo_shogi_icon() { return piyo_shogi_icon }, // TODO: Vue.js の重複強制どうにかならんの？

    start_turn() {
      return this.start_turn_for(this.record)
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.sp_modal
</style>
