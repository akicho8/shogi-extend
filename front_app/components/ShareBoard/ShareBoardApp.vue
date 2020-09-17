<template lang="pug">
.ShareBoardApp
  DebugBox
    p 手数: {{turn_offset}} / {{turn_offset_max}}
    p SFEN: {{current_sfen}}
    p タイトル: {{current_title}}
    p 視点: {{image_view_point}}
    p モード: {{run_mode}}
    p 反転: {{board_flip}}
    p URL: {{current_url}}

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(@click="title_edit")
        | {{current_title}}
    template(slot="end")
      template(v-if="run_mode === 'play_mode'")
        b-navbar-item(@click="reset_handle") 盤面リセット
        b-navbar-item(@click="any_source_read_handle") 棋譜の読み込み
        b-navbar-item(@click="kifu_copy_handle('kif')") 棋譜コピー
        b-navbar-item(@click="mode_toggle_handle") 局面編集
        b-navbar-item(@click="image_view_point_setting_handle") 視点設定
        b-navbar-dropdown(hoverable arrowless right label="その他")
          b-navbar-item(:href="piyo_shogi_app_with_params_url" :target="target_default") ぴよ将棋
          b-navbar-item(:href="kento_app_with_params_url" :target="target_default") KENTO
          b-navbar-item(:href="snapshot_image_url" @click="sound_play('click')") 局面画像の取得
          b-navbar-item(:href="kif_download_url" @click="sound_play('click')") 棋譜ダウンロード
          b-navbar-item(@click="title_edit") タイトル編集
          b-navbar-item(@click="kifu_copy_handle('sfen')") SFENコピー
          template(v-if="run_mode === 'play_mode'")
            b-navbar-item(@click="room_code_edit")
              | リアルタイム共有
              .has-text-danger.ml-1(v-if="room_code") {{room_code}}
      b-navbar-item(tag="a" href="/") TOP

  b-navbar(type="is-dark" fixed-bottom v-if="development_p")
    template(slot="start")
      b-navbar-item(@click="reset_handle") 盤面リセット

  .section
    .columns
      .column.is_shogi_player
        //- the_pulldown_menu

        .turn_container.has-text-centered(v-if="run_mode === 'play_mode'")
          span.turn_offset.has-text-weight-bold {{turn_offset}}
          template(v-if="turn_offset_max && (turn_offset < turn_offset_max)")
            span.mx-1.has-text-grey /
            span.has-text-grey {{turn_offset_max}}

        .sp_container
          shogi_player(
            ref="main_sp"
            :run_mode="run_mode"
            :debug_mode="debug_mode"
            :start_turn="turn_offset"
            :kifu_body="current_sfen"
            :summary_show="false"
            :slider_show="true"
            :setting_button_show="development_p"
            :size="'large'"
            :sound_effect="true"
            :controller_show="true"
            :human_side_key="'both'"
            :theme="'real'"
            :flip.sync="board_flip"
            @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
            @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
            @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
            @update:turn_offset="v => turn_offset = v"
            @update:turn_offset_max="v => turn_offset_max = v"
          )

        .tweet_button_container
          .buttons.is-centered
            b-button.has-text-weight-bold(@click="tweet_handle" icon-left="twitter" :type="advanced_p ? 'is-info' : ''" v-if="run_mode === 'play_mode'")
            b-button(@click="mode_toggle_handle" v-if="run_mode === 'edit_mode'") 編集完了

        .room_code.is_clickable(@click="room_code_edit" v-if="false")
          | {{room_code}}

    .columns(v-if="development_p")
      .column
        .box
          .buttons
            b-button(tag="a" :href="json_debug_url") JSON
            b-button(tag="a" :href="twitter_card_url") Twitter画像
          .content
            p
              b Twitter画像
            p
              img(:src="twitter_card_url" width="256")
            p {{twitter_card_url}}
          pre {{JSON.stringify(record, null, 4)}}
</template>

<script>
const RUN_MODE_DEFAULT = "play_mode"

import { store }   from "./store.js"
import { support } from "./support.js"

import { app_room      } from "./app_room.js"
import { app_room_init } from "./app_room_init.js"

import the_pulldown_menu                  from "./the_pulldown_menu.vue"
import the_image_view_point_setting_modal from "./the_image_view_point_setting_modal.vue"
import the_any_source_read_modal          from "./the_any_source_read_modal.vue"

import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"

export default {
  store,
  name: "ShareBoardApp",
  mixins: [
    support,
    app_room,
    app_room_init,
  ],
  components: {
    shogi_player,
    the_pulldown_menu,
    the_image_view_point_setting_modal,
    the_any_source_read_modal,
  },
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      // watch して url に反映するもの
      current_sfen:     this.config.record.sfen_body,        // 渡している棋譜
      current_title:    this.config.record.title,            // 現在のタイトル
      turn_offset:      this.config.record.initial_turn,     // 現在の手数
      image_view_point: this.config.record.image_view_point, // Twitter画像の向き

      // urlには反映しない
      board_flip: this.config.record.board_flip,       // 反転用
      turn_offset_max: null,                         // 最後の手数

      record: this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      run_mode: this.defval(this.$route.query.run_mode, RUN_MODE_DEFAULT),  // 操作モードと局面編集モードの切り替え用
      edit_mode_sfen: null,     // 局面編集モードの局面
    }
  },
  beforeCreate() {
    this.$store.state.app = this
  },
  created() {
    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.run_mode,
      this.current_sfen,
      this.edit_mode_sfen,      // 編集モード中でもURLを変更したいため
      this.turn_offset,
      this.current_title,
      this.image_view_point,
      this.room_code,
    ], () => {
      if (true) {
        // 両方エラーになってしまう
        // this.$router.replace({name: "share-board", query: this.current_url_params})
        // this.$router.replace({query: this.current_url_params})

        // パラメータだけ変更するときは変更してくれるけどエラーになるっぽいのでエラーにぎりつぶす(いいのか？)
        this.$router.replace({query: this.current_url_params}).catch(() => {})
      } else {
        window.history.replaceState("", null, this.current_url)
      }
    })
  },
  methods: {
    // 再生モードで指したときmovesあり棋譜(URLに反映する)
    play_mode_advanced_full_moves_sfen_set(v) {
      this.current_sfen = v
      this.sfen_share(this.current_sfen)
    },

    // デバッグ用
    mediator_snapshot_sfen_set(sfen) {
      if (this.development_p) {
        // this.$buefy.toast.open({message: `mediator_snapshot_sfen -> ${sfen}`, queue: false})
      }
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_sfen に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうから
    edit_mode_snapshot_sfen_set(v) {
      if (this.run_mode === "edit_mode") { // 操作モードでも呼ばれるから
        this.edit_mode_sfen = v
      }
    },

    // 棋譜コピー
    kifu_copy_handle(fomrat) {
      this.sound_play("click")
      this.general_kifu_copy(this.current_body, {to_format: fomrat})
    },

    // ツイートする
    tweet_handle() {
      this.tweet_share_open({url: this.current_url, text: this.tweet_hash_tag})
    },

    // 操作←→編集 切り替え
    mode_toggle_handle() {
      if (this.run_mode === "play_mode") {
        this.run_mode = "edit_mode"
        if (true) {
          this.board_flip = false // ▲視点にしておく(お好み)
        }
      } else {
        this.run_mode = "play_mode"

        // 局面編集から操作モードに戻した瞬間に局面編集モードでの局面を反映しURLを更新する
        // 局面編集モードでの変化をそのまま current_sfen に反映しない理由は駒箱の駒が消えるため
        // 消えるのはsfenに駒箱の情報が含まれないから
        if (this.edit_mode_sfen) {
          this.current_sfen = this.edit_mode_sfen
          this.edit_mode_sfen = null
        }
      }
      this.sound_play("click")
    },

    // private

    url_replace() {
      this.$router.replace({query: this.current_url_params})
    },

    // タイトル編集
    title_edit() {
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.current_title_set(value)
        },
      })
    },

    current_title_set(title) {
      this.current_title = _.trim(title)
      this.title_share(this.current_title)
    },

    room_code_edit() {
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "リアルタイム共有",
        size: "is-small",
        message: `
          <div class="content">
            <ul>
              <li>同じ合言葉を設定した人とリアルタイムに盤を共有できます</li>
              <li>合言葉を設定したら同じ合言葉を相手に伝えてください</li>
              <li>合言葉はURLにも付加するのでURLを伝えてもかまいません</li>
            </ul>
          </div>`,
        confirmText: "設定",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.room_code, required: false },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.room_code_set(value)
        },
      })
    },

    // 視点設定変更
    image_view_point_setting_handle() {
      this.sound_play("click")
      this.$buefy.modal.open({
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: {
          image_view_point: this.image_view_point,
          permalink_for: this.permalink_for,
        },
        component: the_image_view_point_setting_modal,
        onCancel: () => this.sound_play("click"),
        events: {
          "update:image_view_point": v => {
            this.image_view_point = v
          }
        },
      })
    },

    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: the_any_source_read_modal,
        events: {
          "update:any_source": any_source => {
            this.$axios.$post("/api/general/any_source_to", {any_source: any_source, to_format: "sfen"}).then(e => {
              if (e.bs_error) {
                this.bs_error_message_dialog(e.bs_error)
              }
              if (e.body) {
                this.general_ok_notice("正常に読み込みました")
                this.current_sfen = e.body
                this.turn_offset = e.turn_max
                this.board_flip = false
                modal_instance.close()
              }
            })
          },
        },
      })
    },

    permalink_for(params = {}) {
      let url = null
      if (params.format) {
        url = new URL(this.$config.BASE_URL + `/share-board.${params.format}`)
      } else {
        url = new URL(location)
      }

      params = {...params, ...this.current_url_params}

      _.each(params, (v, k) => {
        if (k !== "format") {
          if (v) {
            url.searchParams.set(k, v)
          }
        }
      })

      return url.toString()
    },

    // 盤面のみ最初の状態に戻す
    reset_handle() {
      this.sound_play("click")
      this.current_sfen = this.config.record.sfen_body        // 渡している棋譜
      this.turn_offset  = this.config.record.initial_turn     // 現在の手数
      this.general_ok_notice("URLを最初に開いたときの状態に盤面を戻しました")
    },
  },

  computed: {
    current_url_params() {
      const params = {
        body:             this.current_body, // 編集モードでもURLを更新するため
        turn:             this.turn_offset,
        title:            this.current_title,
        image_view_point: this.image_view_point,
      }

      if (this.room_code) {
        params["room_code"] = this.room_code
      }

      // 編集モードでの状態を維持したいのでURLに含めておく
      if (this.run_mode !== "play_mode") {
        params["run_mode"] = this.run_mode
      }

      return params
    },

    // URL
    current_url()        { return this.permalink_for()                                                                        },
    json_debug_url()     { return this.permalink_for({format: "json"})                                                        },
    twitter_card_url()   { return this.permalink_for({format: "png"})                                                         },
    snapshot_image_url() { return this.permalink_for({format: "png", image_flip: this.board_flip, disposition: "attachment"}) },
    kif_download_url()   { return this.permalink_for({format: "kif", disposition: "attachment"})                              },

    // 外部アプリ
    piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({path: this.current_url, sfen: this.current_sfen, turn: this.turn_offset, flip: this.board_flip, game_name: this.current_title}) },
    kento_app_with_params_url()      { return this.kento_full_url({sfen: this.current_sfen, turn: this.turn_offset, flip: this.board_flip})   },

    ////////////////////////////////////////////////////////////////////////////////

    // 最初に表示した手数より進めたか？
    advanced_p() { return this.turn_offset > this.config.record.initial_turn },

    // 常に画面上の盤面と一致している
    current_body() { return this.edit_mode_sfen || this.current_sfen },

    tweet_hash_tag() {
      if (this.current_title) {
        return "#" + this.current_title
      }
    },

    debug_mode() { return this.$route.query.debug_mode === "true" },
  },
}
</script>

<style lang="sass">
.ShareBoardApp
  +mobile
    .section
      padding: 2.8rem 0.5rem 0
    .column
      padding: 0
      margin: 1.25rem
      &.is_shogi_player
        padding: 0
        margin: 0

  ////////////////////////////////////////////////////////////////////////////////
  .turn_container

  ////////////////////////////////////////////////////////////////////////////////
  // position: relative
  // .dropdown_menu
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1

  ////////////////////////////////////////////////////////////////////////////////
  .sp_container
    margin-top: 0.8rem

  ////////////////////////////////////////////////////////////////////////////////
  .tweet_button_container
    margin-top: 1.5rem
</style>
