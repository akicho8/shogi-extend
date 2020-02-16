<template lang="pug">
  b-modal.sp_modal(:active.sync="new_modal_p" trap-focus animation="zoom-in" :full-screen="true" :can-cancel="['escape', 'outside']" :has-modal-card="true" v-if="record && record.sfen_body")
    .modal-card.is-shogi-player-modal-card
      .modal-card-body
        // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
        .delete.is-medium(aria-label="close" @click="new_modal_p = false" v-if="true")

        template(v-if="record.title")
          .title.is-5.yumincho.has-text-centered
            template(v-if="record.saturn_key === 'private'")
              b-icon.has-text-grey-light(icon="lock" size="is-small")
              | &nbsp;
            | {{record.title}}

        shogi_player(
          :run_mode.sync="run_mode"
          :debug_mode="false"
          :start_turn="start_turn"
          :kifu_body="record.sfen_body"
          :key_event_capture="true"
          :slider_show="true"
          :sfen_show="false"
          :controller_show="true"
          :theme="'simple'"
          :size="'medium'"
          :sound_effect="true"
          :volume="0.2"
          :setting_button_show="false"
          :flip="record.fliped"
          :player_info="record.player_info"
          @update:start_turn="real_turn_set"
          ref="sp_modal"
        )

        .sp_modal_branch.has-text-centered
          b-switch(v-model="run_mode" true-value="play_mode" false-value="view_mode") 継盤

        template(v-if="record.description")
          .sp_modal_desc.has-text-centered.is-size-7.has-text-grey
            | {{record.description}}

        pre(v-if="development_p")
          | start_turn: {{start_turn}}
          | real_turn: {{real_turn}}
          | record.force_turn: {{record.force_turn}}
          | record.sp_turn: {{record.sp_turn}}
          | record.critical_turn: {{record.critical_turn}}
          | record.turn_max: {{record.turn_max}}

      footer.modal-card-foot
        piyo_shogi_button(@click.stop="" type="button" :href="record.piyo_shogi_app_url")
        kento_button(tag="a" size="is-small" @click.stop="" :href="`${record.kento_app_url}#${real_turn}`" :turn="real_turn")
        kif_copy_button(@click="kif_clipboard_copy(record.kifu_copy_params)" v-if="record.kifu_copy_params")
        pulldown_menu(:record="record" :in_modal_p="true" :real_turn="real_turn" v-if="pulldown_menu_p")
        a.button.is-small(@click="new_modal_p = false" v-if="false") 閉じる
</template>

<script>

export default {
  name: "sp_modal",

  props: {
    record:          {                 }, // バトル情報
    sp_modal_p:      {                 }, // 表示する？
    pulldown_menu_p: { default: true,  }, // 右のプルダウンを表示する？
    end_show:        { default: false, }, // 終局図から始める？
  },

  data() {
    return {
      new_modal_p: this.sp_modal_p,    // sp_modal_p の内部の値
      run_mode: "view_mode",           // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      real_turn: null,
    }
  },

  watch: {
    sp_modal_p(v)  { this.new_modal_p = v }, // 外→内 sp_modal_p --> new_modal_p
    new_modal_p(v) {                         // 外←内 sp_modal_p <-- new_modal_p
      if (v) {
        this.slider_focus_delay() // 開き直したときに反応させるため record.sfen_body の watch にフックするのではだめ
      }
      this.$emit("update:sp_modal_p", v)
    },

    record() { this.real_turn = this.start_turn },  // record がセットされた瞬間に開始手数を保存 (KENTOに渡すためでもある)

    run_mode(v) {
      let message = null
      if (v === "play_mode") {
        message = "駒を操作できます"
      } else {
        message = "元に戻しました"
      }
      this.talk(message, {rate: 1.5})
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-info", duration: 1000 * 1, queue: false})
      this.slider_focus()
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

    // shogi-player の局面が変化したときの手数を取り出す
    real_turn_set(v) {
      this.real_turn = v
    },

    // this.$nextTick(() => this.slider_focus()) の方法だと失敗する
    slider_focus_delay() {
      setTimeout(() => this.slider_focus(), 1)
    },

    slider_focus() {
      const dom = this.$el.querySelector(".turn_slider")
      if (dom) {
        dom.focus()
      }
    },
  },

  computed: {
    start_turn() {
      return this.start_turn_for(this.record)
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.sp_modal
  .is-shogi-player-modal-card
    width: auto

  // 閉じボタン
  .delete
    position: absolute
    top: 0.6rem
    left: 0.6rem

  // 上のスペース
  .modal-card-body
    padding-top: 3em

  // 継盤
  .sp_modal_branch
    margin-top: 0.5rem

  // 説明分
  .sp_modal_desc
    margin-top: 0.8rem

  //////////////////////////////////////////////////////////////////////////////// フッターの色を取る場合
  .modal-card-foot
    border: none
    background-color: $scheme-main

  //////////////////////////////////////////////////////////////////////////////// フッターのボタンの配置(is-shogi-player-modal-card の方で指定あり)
  // .modal-card-foot
  //   justify-content: space-around

  ////////////////////////////////////////////////////////////////////////////// _sp_modal
  .modal_loading_content
    width: 40vmin
    height: 40vmin
</style>
