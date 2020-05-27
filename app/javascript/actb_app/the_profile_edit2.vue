<template lang="pug">
.the_profile_edit2
  .primary_header
    .header_lr_text_button(@click="close_handle") キャンセル
    .header_lr_text_button.has-text-weight-bold(@click="tekiyou_handle") 適用

  .canvas_container.is-flex
    canvas(ref="my_canvas" :width="canvas_size" :height="canvas_size")
</template>

<script>

const IMAGE_SIZE         = 400                     // プロフィール画像直径
const CANVAS_PADDING     = 96                      // canvasの隙間
const CIRCLE_OUTER_COLOR = "hsla(0, 0%,  0%, 0.5)" // canvas内の円の色(外)
const CIRCLE_INNER_COLOR = "hsla(0, 0%,100%, 0.5)" // canvas内の円の色(内)
const CIRCLE_OUTER_WIDTH = IMAGE_SIZE              // canvas内の円の太さ(外)
const CIRCLE_INNER_WIDTH = 2                       // canvas内の円の太さ(内)

import { support } from "./support.js"
import { fabric } from "fabric"
import PaletteInfo from "../palette_info.js"

export default {
  name: "the_profile_edit2",
  mixins: [
    support,
  ],

  data() {
    return {
      fcanvas: null,             // fabric.Canvas インスタンス
      uploaded_src: null,
    }
  },

  created() {
    if (this.app.info.debug_scene === "profile_edit2") {
      this.uploaded_src = "/foo.png"
    }

    this.body_background_color_set("black")
  },

  beforeDestroy() {
    this.body_background_color_set("")
  },

  mounted() {
    this.canvas_setup()

    if (this.app.file_info) {
      this.input_file_to_canvas()
    } else if (this.uploaded_src) {
      this.image_url_to_canvas()
    }
  },

  methods: {
    close_handle() {
      this.sound_play("click")
      this.app.mode = "profile_edit"
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
        this.canvas_size / 2,                // x
        this.canvas_size / 2,                // y
        (IMAGE_SIZE / 2) + params.lineWidth / 2, // r + ペンの太さ/2 で直径 image_size の円にする
        0, Math.PI*2)                        // 1周

      c.closePath()             // 閉じないとオブジェクトに繋がってしまうため
      c.stroke()
    },

    input_file_to_canvas() {
      const reader = new FileReader()
      reader.addEventListener("load", () => {
        this.uploaded_src = reader.result
        this.image_url_to_canvas()
      }, false)
      reader.readAsDataURL(this.app.file_info)
    },

    image_url_to_canvas() {
      fabric.Image.fromURL(this.uploaded_src, e => {
        this.fcanvas.add(e)             // canvasに設置
        e.scale(IMAGE_SIZE / e.width)   // 合わせる
        e.center()                      // 中央配置

        e.set({
          borderColor: PaletteInfo.fetch("info").alpha(0.6),
          cornerColor: PaletteInfo.fetch("info").alpha(0.6),

          borderScaleFactor: 3,      // 線の太さ
          cornerSize: 12,            // 角の四角の大きさ
          cornerStyle: 'circle',     // 角の形状
          transparentCorners: false, // 角を塗り潰す
          rotatingPointOffset: 32,   // 回転棒の長さ
          padding: 12,               // 矢印にボーダーが重なるので若干離す
        })

        this.fcanvas.setActiveObject(e) // タップした状態にする
      })
    },

    tekiyou_handle() {
      if (this.fcanvas) {
        // http://fabricjs.com/docs/fabric.Canvas.html#toDataURL
        this.app.fab_src = this.fcanvas.toDataURL({
          top:    CANVAS_PADDING,
          left:   CANVAS_PADDING,
          width:  IMAGE_SIZE,
          height: IMAGE_SIZE,
        })

        // toDataURL で after:render が呼ばれて半透明で描画した部分だけがさらに濃くなるため再描画でなかったことにする
        this.fcanvas.renderAll()
      }
    },
  },
  computed: {
    img_src() {
      return this.app.fab_src || this.uploaded_src || this.app.current_user.avatar_path
    },
    canvas_size() {
      return IMAGE_SIZE + CANVAS_PADDING * 2
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_profile_edit2
  // background-color: $black

  @extend %padding_top_for_primary_header
  .primary_header
    background-color: $black-ter

    .header_lr_text_button
      // 押しやすいように最大まで広げて
      height: 100%

      // 中央配置
      display: flex
      justify-content: center
      align-items: center

      padding: 0 1rem
      cursor: pointer

  .canvas_container
    flex-direction: column
    align-items: center
    .button
     margin-top: 1.5rem

  .image_container
    margin-top: 2rem
    justify-content: center
    .image
      img
        width: 80px
        height: 80px
  .button_container
    margin-top: 1.5rem
</style>
