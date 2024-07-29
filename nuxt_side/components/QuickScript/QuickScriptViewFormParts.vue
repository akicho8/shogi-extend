<template lang="pug">
.QuickScriptViewFormParts.columns.is-mobile.is-multiline(v-if="QS.params.form_method && QS.showable_form_parts.length >= 1")
  .column.is-12
    template(v-for="form_part in QS.showable_form_parts")
      b-field(
        :label-for="QS.form_part_id(form_part)"
        :label="form_part.label"
        custom-class="is-small"
        :message="form_part.help_message"
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
          b-input(
            :id="QS.form_part_id(form_part)"
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
        template(v-else-if="form_part.type === 'integer'")
          b-numberinput(
            :id="QS.form_part_id(form_part)"
            v-model="QS.attributes[form_part.key]"
            controls-position="compact"
            :exponential="true"
            )
        template(v-else-if="form_part.type === 'select'")
          b-select(
            :id="QS.form_part_id(form_part)"
            v-model="QS.attributes[form_part.key]"
            )
            template(v-for="[label, value] in QS.form_part_elems_to_select_options(form_part.elems)")
              option(:value="value") {{label}}
        template(v-else-if="form_part.type === 'radio_button' || form_part.type === 'checkbox_button'")
          template(v-for="[label, value] in QS.form_part_elems_to_select_options(form_part.elems)")
            component(
              :is="QS.form_part_type_to_component(form_part.type)"
              v-model="QS.attributes[form_part.key]"
              :native-value="value")
              span {{label}}
        template(v-else)
          pre form_part.type が間違っている : {{form_part.type}}
</template>

<script>
export default {
  name: "QuickScriptViewFormParts",
  inject: ["QS"],
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
