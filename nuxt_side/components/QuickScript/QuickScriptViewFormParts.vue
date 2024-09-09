<template lang="pug">
.QuickScriptViewFormParts.columns.is-mobile.is-multiline(v-if="QS.params.form_method && QS.showable_form_parts.length >= 1")
  .column.is-12
    template(v-for="form_part in QS.showable_form_parts")
      b-field(
        :label-for="QS.form_part_id(form_part)"
        :label="form_part.label"
        custom-class="is-small"
        :message="QS.form_part_help_message(form_part)"
        )

        template(v-if="false")
        template(v-else-if="form_part.type === 'file'")
          b-field(class="file" :class="{'has-name': !!QS.attributes[form_part.key]}")
            b-upload(
              :id="QS.form_part_id(form_part)"
              @input="file => QS.file_upload_handle(form_part, file)"
              class="file-label"
              )
              span(class="file-cta")
                b-icon(class="file-icon" icon="upload")
                span(class="file-label") アップロード
              span(class="file-name" v-if="QS.attributes[form_part.key]")
                | {{QS.attributes[form_part.key].name}}
          .image_preview.mt-2(v-if="QS.attributes[form_part.key]")
            img(:src="QS.attributes[form_part.key].data_uri")
            button.delete(size="is-small" @click="QS.file_upload_cancel_handle(form_part)")
        template(v-else-if="form_part.type === 'string'")
          template(v-if="form_part.ac_by === 'b_autocomplete'")
            b-autocomplete(
              :id="QS.form_part_id(form_part)"
              v-model.trim="QS.attributes[form_part.key]"
              :placeholder="form_part.placeholder"
              spellcheck="false"
              :data="QS.form_part_autocomplete_datalist(form_part)"
              max-height="50vh"
              )
          template(v-else)
            b-input(
              :id="QS.form_part_id(form_part)"
              v-model="QS.attributes[form_part.key]"
              :placeholder="form_part.placeholder"
              spellcheck="false"
              :list="QS.form_part_datalist_id(form_part)"
              )
        template(v-else-if="form_part.type === 'taginput'")
          // 作りかけ
          //- :size="TheApp.input_element_size"
          //- v-model="current_tags"
          //- :data="filtered_tags"
          //- autocomplete
          //- open-on-focus
          //- allow-new
          //- icon="label"
          //- placeholder="Add a tag"
          //- spellcheck="false"
          //- @typing="typing_handle"
          //- @add="add_handle"
          //- @remove="remove_handle"
          //- max-height="50vh"
          //- group-field="name"
          //- group-options="values"
          //- expanded
          //- attached
          //- @typing="typing_handle"
          //- :data="QS.form_part_autocomplete_datalist(form_part)"
          //- max-height="50vh"
          b-taginput(
            :id="QS.form_part_id(form_part)"
            :on-paste-separators="[',', ' ']"
            v-model="QS.attributes[form_part.key]"
            :placeholder="form_part.placeholder"
            spellcheck="false"
            )
        template(v-else-if="form_part.type === 'static'")
          template(v-if="true")
            input.input.is-static(:id="QS.form_part_id(form_part)" v-model="QS.attributes[form_part.key]" readonly)
          template(v-else)
            p.control
              span.is-static(:id="QS.form_part_id(form_part)" v-text="QS.attributes[form_part.key]")
        template(v-else-if="form_part.type === 'text'")
          b-input(
            :id="QS.form_part_id(form_part)"
            type="textarea"
            v-model="QS.attributes[form_part.key]"
            :placeholder="form_part.placeholder"
            spellcheck="false"
            )
        template(v-else-if="form_part.type === 'numeric'")
          b-numberinput(
            :id="QS.form_part_id(form_part)"
            v-model="QS.attributes[form_part.key]"
            controls-position="compact"
            :exponential="true"
            :min="form_part?.options?.min"
            :max="form_part?.options?.max"
            :step="form_part?.options?.step ?? 1"
            )
        template(v-else-if="form_part.type === 'select'")
          b-select(
            :id="QS.form_part_id(form_part)"
            v-model="QS.attributes[form_part.key]"
            @input="e => click_talk_handle(e)"
            )
            template(v-for="[key, label] in QS.form_part_elems_to_key_label_array(form_part.elems)")
              option(:value="key") {{label}}
        template(v-else-if="form_part.type === 'radio_button' || form_part.type === 'checkbox_button'")
          template(v-for="[key, label] in QS.form_part_elems_to_key_label_array(form_part.elems)")
            component(
              :is="QS.form_part_type_to_component(form_part.type)"
              @input="click_talk_handle(label)"
              v-model="QS.attributes[form_part.key]"
              :native-value="key")
              span {{label}}
        template(v-else)
          pre form_part.type が間違っている : {{form_part.type}}

  // b-input の隣に書くとレイアウトが崩れるため分けて記述する
  template(v-for="form_part in QS.showable_form_parts")
    template(v-if="form_part.type === 'string'")
      template(v-if="form_part.ac_by === 'html5'")
        template(v-if="form_part.elems")
          datalist(:id="QS.form_part_datalist_id(form_part)")
            template(v-for="e in form_part.elems")
              option(:value="e")
</template>

<script>
export default {
  name: "QuickScriptViewFormParts",
  inject: ["QS"],
  methods: {
    click_talk_handle(str) {
      this.$sound.play_click()
      this.talk(str)
    },
  },
}
</script>

<style lang="sass">
.QuickScriptViewFormParts
  .image_preview
    height: 8rem
    display: flex
    align-items: center
    img
      max-height: 100%
      max-width:  100%
      // border: 1px solid $grey-lighter
      // border-radius: 4px
    button
      margin-left: 0.5rem
</style>
