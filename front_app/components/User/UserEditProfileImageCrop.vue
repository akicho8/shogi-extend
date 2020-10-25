<template lang="pug">
.UserEditProfileImageCrop.has-background-black
  MainNavbar(type="is-dark")
    //- template(slot="brand")
    //-   b-navbar-item キャンセル
    template(slot="start")
      //- b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
      //-   .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
      b-navbar-item(v-if="development_p") {{draw_count}}

    template(slot="end")
      //- b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
      //-   .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
      b-navbar-item.has-text-weight-bold(@click="clop_handle") 決定

  .columns.is-vcentered
    .column
      .canvas_container.is-flex
        canvas(ref="my_canvas" :width="canvas_size" :height="canvas_size")

  MainNavbar(type="is-dark" fixed-bottom centered)
    template(slot="start")
      b-navbar-item(@click="rotate_handle")
        b-icon(icon="format-rotate-90 mdi-flip-h")
</template>

<script>
const IMAGE_SIZE         = 400                     // プロフィール画像直径
const CANVAS_PADDING     = 96                      // canvasの隙間
const CIRCLE_OUTER_COLOR = "hsla(0, 0%,  0%, 0.5)" // canvas内の円の色(外)
const CIRCLE_INNER_COLOR = "hsla(0, 0%,100%, 0.5)" // canvas内の円の色(内)
const CIRCLE_OUTER_WIDTH = IMAGE_SIZE              // canvas内の円の太さ(外)
const CIRCLE_INNER_WIDTH = 2                       // canvas内の円の太さ(内)
const ROTATE_ONE         = 360 / 4                 // 一度で回転する角度

import PaletteInfo from "@/components/models/PaletteInfo.js"

const CANVAS_OPTIONS = {
  // 何もないところをマウスでクリックして動かすとオブジェクトを選択できる(selection機能)
  // が、このとき after:render だけが作動して半透明で描画しているのが連続して黒で塗り潰してしまう
  // それを防ぐため、selection を無効にする
  // もともとオブジェクトは1つしかないので外から囲んで選択する機能は不要
  // http://fabricjs.com/docs/fabric.Canvas.html#selection
  selection: false,
}

// 動かすコントローラーを調整
// http://fabricjs.com/docs/fabric.Object.html#borderScaleFactor
const IMAGE_CONTROLLER_PARAMS = {
  borderColor: PaletteInfo.fetch("info").alpha(0.6),
  cornerColor: PaletteInfo.fetch("info").alpha(0.6),

  borderScaleFactor: 3,      // 線の太さ
  cornerSize: 12,            // 角の四角の大きさ
  cornerStyle: "circle",     // 角の形状
  transparentCorners: false, // 角を塗り潰す
  rotatingPointOffset: 32,   // 回転棒の長さ
  padding: 12,               // 矢印にボーダーが重なるので若干離す
}

import { fabric }  from "fabric"

export default {
  name: "UserEditProfileImageCrop",
  props: {
    base: { type: Object, required: true },
  },
  data() {
    return {
      fcanvas:      null, // fabric.Canvas インスタンス
      uploaded_src: null,
      image_obj:    null,
    }
  },
  beforeDestroy() {
    this.fabric_destroy()
  },
  mounted() {
    this.canvas_setup()

    if (this.base.upload_file_info) {
      this.input_file_to_canvas()
    } else if (this.uploaded_src) {
      this.image_url_to_canvas()
    }
  },
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.base.current_component = "UserEditProfileForm"
    },

    canvas_setup() {
      this.fcanvas = new fabric.Canvas(this.$refs.my_canvas, CANVAS_OPTIONS)
      this.fcanvas.on('after:render', () => {
        this.circle_stroke({strokeStyle: CIRCLE_OUTER_COLOR, lineWidth: CIRCLE_OUTER_WIDTH}) // 巨大なドーナツの描画
        this.circle_stroke({strokeStyle: CIRCLE_INNER_COLOR, lineWidth: CIRCLE_INNER_WIDTH}) // ドーナツの内側の縁取り
      })

      // http://fabricjs.com/events
      // this.fcanvas.on("object:moving", (e) => {})
      // this.fcanvas.on("object:moved", (e) => {})

      this.fcanvas.renderAll()
    },

    // ドーナツ描画
    circle_stroke(params) {
      const c = this.fcanvas.contextContainer
      c.beginPath()
      c.strokeStyle = params.strokeStyle
      c.lineWidth = params.lineWidth

      // https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arc
      c.arc(
        this.canvas_size / 2,                    // x
        this.canvas_size / 2,                    // y
        (IMAGE_SIZE / 2) + params.lineWidth / 2, // r + ペンの太さ/2 で直径 image_size の円にする
        0, Math.PI*2)                            // 1周

      c.closePath()      // 閉じないとオブジェクトに繋がってしまうため
      c.stroke()
    },

    input_file_to_canvas() {
      const reader = new FileReader()
      reader.addEventListener("load", () => {
        this.uploaded_src = reader.result
        this.image_url_to_canvas()
      }, false)
      reader.readAsDataURL(this.base.upload_file_info)
    },

    image_url_to_canvas() {
      // http://fabricjs.com/docs/fabric.Image.html#.fromURL
      fabric.Image.fromURL(this.uploaded_src, e => {
        this.fcanvas.add(e)                                              // canvasに設置
        this.fcanvas.setActiveObject(e)                                  // タップした状態にする
        this.image_obj = e                                               // オブジェクトを直接操作するために保持しておく

        if (true) {                                                      // 以下はなくてもよい
          e.scale(Math.max(IMAGE_SIZE / e.width, IMAGE_SIZE / e.height)) // 円の中に隙間ができない最小の倍率に調整
          e.center()                                                     // 中央配置
          e.set(IMAGE_CONTROLLER_PARAMS)                                 // コントローラーの微調整
        }
      })
    },

    // 切り抜く
    clop_handle() {
      this.sound_play("click")

      // http://fabricjs.com/docs/fabric.Canvas.html#toDataURL
      this.__assert__(this.fcanvas, "this.fcanvas")
      this.base.croped_image = this.fcanvas.toDataURL({
        top:    CANVAS_PADDING,
        left:   CANVAS_PADDING,
        width:  IMAGE_SIZE,
        height: IMAGE_SIZE,
      })

      // toDataURL で after:render が呼ばれて半透明で描画した部分だけがさらに濃くなるため再描画で無かったことにする
      // が、どうせ戻るので意味ない
      this.fcanvas.renderAll()

      this.base.current_component = "UserEditProfileForm"
    },

    // 少しずつ回転
    rotate_handle() {
      this.sound_play("click")
      // http://fabricjs.com/docs/fabric.Object.html#rotate
      this.image_obj.rotate(this.rotate_next())
      this.fcanvas.renderAll()
    },

    // 次の角度
    rotate_next() {
      return Math.trunc((this.image_obj.angle + ROTATE_ONE) / ROTATE_ONE) * ROTATE_ONE
    },

    // この方法で解放されているのかは不明
    // そもそも自分で解放する必要はないのかもしれない
    fabric_destroy() {
      // http://fabricjs.com/docs/fabric.Canvas.html#getObjects
      this.__assert__(this.fcanvas.getObjects().length >= 1, "[fabric] オブジェクトが生成されていないのに解放しようとしている")
      // http://fabricjs.com/docs/fabric.StaticCanvas.html#dispose
      this.fcanvas.dispose()
      this.__assert__(this.fcanvas.getObjects().length === 0, "[fabric] オブジェクトが解放できていない")
    },
  },
  computed: {
    // キャンバスの1辺のサイズ
    canvas_size() {
      return IMAGE_SIZE + CANVAS_PADDING * 2
    },
  },
}
</script>

<style lang="sass">
.UserEditProfileImageCrop
  min-height: 100vh

  .canvas_container
    flex-direction: column
    align-items: center
    .button
     margin-top: 1.5rem
</style>
