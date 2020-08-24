<template lang="pug">
.the_profile_edit_image_crop
  .primary_header
    .header_lr_text_button(@click="cancel_handle") キャンセル
    .header_lr_text_button.has-text-weight-bold(@click="clop_handle") 適用

  .canvas_container.is-flex
    canvas(ref="my_canvas" :width="canvas_size" :height="canvas_size")

  .footer_nav.is-flex
    .header_lr_text_button(@click="rotate_handle")
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

import PaletteInfo from "../../../../app/javascript/palette_info.js"

// 動かすレイヤー調整
// http://fabricjs.com/docs/fabric.Object.html#borderScaleFactor
const CONTROLLER_PARAMS = {
  borderColor: PaletteInfo.fetch("info").alpha(0.6),
  cornerColor: PaletteInfo.fetch("info").alpha(0.6),

  borderScaleFactor: 3,      // 線の太さ
  cornerSize: 12,            // 角の四角の大きさ
  cornerStyle: "circle",     // 角の形状
  transparentCorners: false, // 角を塗り潰す
  rotatingPointOffset: 32,   // 回転棒の長さ
  padding: 12,               // 矢印にボーダーが重なるので若干離す
}

import { support } from "../support.js"
import { fabric }  from "fabric"

export default {
  name: "the_profile_edit_image_crop",
  mixins: [
    support,
  ],

  data() {
    return {
      fcanvas:      null, // fabric.Canvas インスタンス
      uploaded_src: null,
      image_obj:    null,
    }
  },

  created() {
    if (this.app.info.warp_to === "profile_edit_image_crop") {
      this.uploaded_src = "/foo.png"
    }
    this.html_background_color_set("black")
  },

  beforeDestroy() {
    this.fabric_free()
    this.html_background_color_set("")
  },

  mounted() {
    this.canvas_setup()

    if (this.$parent.upload_file_info) {
      this.input_file_to_canvas()
    } else if (this.uploaded_src) {
      this.image_url_to_canvas()
    }
  },

  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.$parent.current_component = "the_profile_edit_form"
    },

    canvas_setup() {
      this.fcanvas = new fabric.Canvas(this.$refs.my_canvas)
      this.fcanvas.on('after:render', () => {
        this.circle_stroke({strokeStyle: CIRCLE_OUTER_COLOR, lineWidth: CIRCLE_OUTER_WIDTH})
        this.circle_stroke({strokeStyle: CIRCLE_INNER_COLOR, lineWidth: CIRCLE_INNER_WIDTH})
      })
      this.fcanvas.renderAll()
    },

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
      reader.readAsDataURL(this.$parent.upload_file_info)
    },

    image_url_to_canvas() {
      // http://fabricjs.com/docs/fabric.Image.html#.fromURL
      fabric.Image.fromURL(this.uploaded_src, e => {
        this.image_obj = e
        this.fcanvas.add(e)             // canvasに設置
        e.scale(Math.max(IMAGE_SIZE / e.width, IMAGE_SIZE / e.height))   // 円の中に隙間ができない最小の倍率に調整
        e.center()                      // 中央配置
        e.set(CONTROLLER_PARAMS)
        this.fcanvas.setActiveObject(e) // タップした状態にする
      })
    },

    // 切り抜く
    clop_handle() {
      this.sound_play("click")

      // http://fabricjs.com/docs/fabric.Canvas.html#toDataURL
      this.__assert__(this.fcanvas, "this.fcanvas")
      this.$parent.croped_image = this.fcanvas.toDataURL({
        top:    CANVAS_PADDING,
        left:   CANVAS_PADDING,
        width:  IMAGE_SIZE,
        height: IMAGE_SIZE,
      })

      // toDataURL で after:render が呼ばれて半透明で描画した部分だけがさらに濃くなるため再描画で無かったことにする
      // が、どうせ戻るので意味ない
      this.fcanvas.renderAll()

      this.$parent.current_component = "the_profile_edit_form"
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
    fabric_free() {
      // http://fabricjs.com/docs/fabric.Canvas.html#getObjects
      this.__assert__(this.fcanvas.getObjects().length >= 1, "this.fcanvas.getObjects().length >= 1")
      // http://fabricjs.com/docs/fabric.StaticCanvas.html#dispose
      this.fcanvas.dispose()
      this.__assert__(this.fcanvas.getObjects().length === 0, "this.fcanvas.getObjects().length === 0")
    },
  },
  computed: {
    canvas_size() {
      return IMAGE_SIZE + CANVAS_PADDING * 2
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_profile_edit_image_crop
  @extend %padding_top_for_primary_header
  .primary_header
    background-color: $black-ter

  .canvas_container
    flex-direction: column
    align-items: center
    .button
     margin-top: 1.5rem

  .footer_nav
    color: $white
    background-color: $black-ter
    justify-content: center
</style>
