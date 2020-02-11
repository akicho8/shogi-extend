<template lang="pug">
  // https://buefy.org/documentation/modal
  b-modal.sp_modal(:active.sync="current_modal_p" trap-focus animation="zoom-in" :full-screen="true" :can-cancel="false" :has-modal-card="true")
    template(v-if="modal_record")
      .modal-card.is-shogi-player-modal-card(style="width:auto")
        .modal-card-body
          .delete.is-medium(aria-label="close" @click="current_modal_p = false" v-if="true")
          // button.modal-close.is-large(class="delete" aria-label="close" @click="current_modal_p = false" v-if="true")

          template(v-if="modal_record.title")
            .title.is-5.yumincho.has-text-centered
              template(v-if="modal_record.saturn_key === 'private'")
                b-icon.has-text-grey-light(icon="lock" size="is-small")
                | &nbsp;
              | {{modal_record.title}}

          template(v-if="!modal_record.sfen_body")
            .modal_loading_content
              b-loading(:is-full-page="false" :active="!modal_record.sfen_body" :can-cancel="true")

          template(v-if="modal_record.sfen_body")
            shogi_player(
              :run_mode.sync="sp_run_mode"
              :debug_mode="false"
              :start_turn="start_turn"
              :kifu_body="modal_record.sfen_body"
              :key_event_capture="true"
              :slider_show="true"
              :sfen_show="false"
              :controller_show="true"
              :theme="'simple'"
              :size="'default'"
              :sound_effect="true"
              :volume="0.2"
              :setting_button_show="false"
              :flip="modal_record.fliped"
              :player_info="modal_record.player_info"
              @update:start_turn="seek_to"
              ref="sp_modal"
            )

            .sp_modal_branch.has-text-centered
              b-switch(v-model="sp_run_mode" true-value="play_mode" false-value="view_mode") 継盤

            template(v-if="modal_record.description")
              .sp_modal_desc.has-text-centered.is-size-7.has-text-grey
                | {{modal_record.description}}

        footer.modal-card-foot
          a.button.piyo_button.is-small(@click.stop="" type="button" :href="modal_record.piyo_shogi_app_url")
            span.icon
              img(:src="piyo_shogi_icon")
            span ぴよ将棋

          b-button.kento_app_button(tag="a" size="is-small" @click.stop="" :href="`${modal_record.kento_app_url}#${real_pos}`")
            | ☗ KENTO \#{{real_pos}}

          template(v-if="modal_record.kifu_copy_params")
            a.button.is-small(@click.stop.prevent="kifu_copy_handle(modal_record.kifu_copy_params)")
              b 棋譜コピー

          template(v-if="pulldown_menu_p")
            pulldown_menu(:record="modal_record" :in_modal="true")

          template(v-if="false")
            a.button.is-small(@click="current_modal_p = false") 閉じる
</template>

<script>

import piyo_shogi_icon from "piyo_shogi_icon.png"

export default {
  name: "sp_modal",
  mixins: [
  ],

  props: {
    modal_record:    { required: false },
    sp_modal_p:      { required: false },
    pulldown_menu_p: { required: false, default: true, },
    end_show:        { required: false, default: true, },
  },

  data() {
    return {
      current_modal_p: null,
      sp_run_mode: "view_mode",
      real_pos: null,
    }
  },

  created() {
  },

  mounted() {
  },

  watch: {
    sp_modal_p: { immediate: true, handler(v) { this.current_modal_p = v }, }, // 外→内 sp_modal_p --> current_modal_p
    current_modal_p(v) { this.$emit("update:sp_modal_p", v) },                 // 外←内 sp_modal_p <-- current_modal_p

    modal_record() { this.real_pos = this.start_turn },                        // modal_record がセットされた瞬間に開始手数を保存 (KENTOに渡すためでもある)
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
        } else {
          return record.sp_turn
        }
      }
    },

    seek_to(pos) {
      this.real_pos = pos
    },

    kifu_copy_handle(params) {
      this.kif_clipboard_copy(params)
    },

    modal_url_with_turn_copy() {
      if (this.modal_record) {
        this.clipboard_copy({text: `${this.modal_record.modal_on_index_url}&turn=${this.real_pos}` })
      }
    },
  },

  computed: {
    piyo_shogi_icon() {
      return piyo_shogi_icon
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn() {
      return this.start_turn_for(this.modal_record)
    },
  },
}
</script>

<style lang="sass">
@import "./bulma_init.scss"
.sp_modal
</style>
