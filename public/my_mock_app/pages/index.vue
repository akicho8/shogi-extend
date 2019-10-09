<template lang="pug">
.section
  .columns.is-mobile
    .column
      .box
        | 文言1
      label
        | テキストフィールドのラベル
        input#input_id1(value="xxx")
      a#a_tag_id1.button.is-text(href="/?foo=1") リンク1
      a.button.is-text(href="/?foo=2") リンク名2
      button ボタン名1

      .multiple_class1 a
      .multiple_class1 b
      .single_class1 c

      #element_id1(
        value="xxx"
        @click="handle_run('click')"
        @click.right="handle_run('right_click')"
        @dblclick="handle_run('dblclick')"
        @mouseover="handle_run('mouseover')"
        @keypress="handle_run($event.key)"
        )
        span
          | テキスト1
        span
          | テキスト2

      input#input_element(@keypress="handle_run($event.key)")

      label
        | SELECT_LABEL1
        select#select_id1
          option(value="option1") OPTION_LABEL1
          option(value="option2") OPTION_LABEL2
          option(value="option3" selected) OPTION_LABEL3

      textarea#event_logs(v-model="log_text")

      button#log_clear(@click="log_text = []") 消去

      #table_id1
        table
          tr
            td

      //- .box(@dragover="f_dragover" @drop="f_drop")
      span#id_a(draggable="true") A

      //- <div class="box" ondragover="f_dragover(event)" ondrop="f_drop(event)">
      //- </div>

      #drop_area.box(@drop.prevent="drop_handle" @dragover.prevent)
        | (drop_area)
      template(v-if="file_src")
          img(:src="file_src" width="64")

      .box
        dropzone(id="dropzone_id" ref="el" :options="options" :destroyDropzone="true")
          | (DROPZONE)

    .column
      label
        input#checkbox_id1(type="checkbox" value="cb_value_a")
        | CB_NAME_A
      label
        input(type="checkbox" value="cb_value_b" checked)
        | CB_NAME_B
</template>

<script>
// import Dropzone from 'nuxt-dropzone'
import 'nuxt-dropzone/dropzone.css'

export default {
  name: 'HomePage',
  data() {
    return {
      log_text: [],
      file_src: null,

      options: {
        url: "http://httpbin.org/anything",
      },

    }
  },

  mounted() {
    // Everything is mounted and you can access the dropzone instance
    // const instance = this.$refs.el.dropzone
  },

  methods: {
    handle_run(str) {
      this.log_text.push(str)
    },
    drop_handle(e) {
      // console.log()
      this.$buefy.toast.open(e.dataTransfer.files[0].name)

      this.file_info = e.dataTransfer.files[0]
      const reader = new FileReader()
      reader.addEventListener("load", () => { this.file_src = reader.result }, false)
      reader.readAsDataURL(this.file_info)
      console.log(e)
    },
  },
}
</script>
