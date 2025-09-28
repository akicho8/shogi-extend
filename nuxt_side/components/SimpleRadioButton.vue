<template lang="pug">
b-field.SimpleRadioButton(
  v-bind="$attrs"
  :class="{'is_scroll_x': buttons_p}"
  )
  template(#label)
    span {{label}}
    template(v-if="permanent_mark_append")
      span.has-text-danger ＊
    template(v-if="hint_exist_p")
      a.hint_icon(@click="label_click_handle")
        b-icon(icon="help-circle-outline" size="is-small")
  template(#message)
    p(v-html="field_message")

  template(v-if="real_model.input_type === 'numberinput'")
    b-numberinput(
      :size="element_size"
      controls-position="compact"
      v-model="real_value"
      :min="real_model.min"
      :max="real_model.max"
      :step="real_model.step ?? 1"
      :exponential="true"
      :editable="true"
      @input="input_handle"
      )
  template(v-else-if="real_model.input_type === 'slider'")
    b-slider(
      lazy
      :indicator="true"
      :tooltip="false"
      :size="element_size"
      controls-position="compact"
      v-model="real_value"
      :min="real_model.min"
      :max="real_model.max"
      :step="real_model.step ?? 1"
      :ticks="real_model.ticks"
      @change="input_handle"
      )
  template(v-else)
    template(v-for="e in real_model.values")
      // https://buefy.org/documentation/radio
      b-radio-button(
        v-if="e.environment == null || e.environment.includes($config.STAGE)"
        :class="e.key"
        @input="input_handle"
        v-model="real_value"
        :native-value="e.key"
        :type="e.type"
        v-on="$listeners"
        :size="element_size"
        :expanded="false"
        )
        | {{e.name}}
</template>

<script>
import { Gs } from "@/components/models/gs.js"

// 使い方
//  SimpleRadioButton.auto_resign(:base="SB" custom-class="is-small" element_size="is-small" model_name="AutoResignInfo" :sync_value.sync="SB.new_v.auto_resign_key")
export default {
  name: "SimpleRadioButton",
  props: {
    base:                  { type: Object, required: true,  },
    model_name:            { type: String, required: true,  },
    var_name:              { type: String, required: false, }, // DEPRECATION
    element_size:          { type: String, required: false, },
    permanent_mark_append: { type: Boolean, default: false, required: false, },
    sync_value:            { required: false, },
  },
  data() {
    return {
      current_my_value: this.sync_value,
    }
  },
  watch: {
    sync_value() {
      this.current_my_value = this.sync_value
    },
    current_my_value() {
      this.$emit("update:sync_value", this.current_my_value)
    },
  },
  methods: {
    input_handle(e) {
      if (false) {
      } else if (this.buttons_p) {
        if (false) {
          // se_select は本来ラジオボタン専用に作られているが2回クリック音が鳴ることに違和感しかない
          this.sfx_play("se_select")
        } else {
          this.sfx_click()
        }
      } else if (this.slider_p) {
      } else {
        this.sfx_click()
      }
      if (this.real_model.input_handle_callback) {
        this.real_model.input_handle_callback(this, e)
      }
      if (this.buttons_p) {
        this.talk(this.current.talk_message || this.current.name)
      }
      this.$emit("user_input", this.real_model)
    },
    label_click_handle(e) {
      if (this.$gs.present_p(this.hint_str)) {
        this.sfx_stop_all()
        this.sfx_click()
        this.toast_ok(this.hint_str, {duration: 1000 * this.duration_sec})
      }
    },
  },
  computed: {
    real_model() { return this.base[this.model_name]                                    },
    numeric_p()  { return this.real_model.input_type === "numberinput" || this.slider_p },
    buttons_p()  { return !this.numeric_p                                               },
    slider_p()   { return this.real_model.input_type === "slider"                       },
    current()    { return this.real_model.fetch(this.real_value)                        },
    label()      { return this.real_model.field_label                                   },
    hint_str()   { return (this.real_model.hint_messages || []).join("")                },
    hint_exist_p() { return Gs.present_p(this.hint_str) },
    field_message() {
      let str = null
      if (this.numeric_p) {
        // current は参照できない
      } else {
        str = str ?? this.current.message
      }
      str = str ?? this.real_model.field_message
      return str
    },
    duration_sec() {
      return this.$route.query.__system_test_now__ ? 2 : 7
    },
    real_value: {
      get() {
        if (this.var_name) {
          return this.base[this.var_name]
        } else {
          return this.current_my_value
        }
      },
      set(v) {
        if (this.var_name) {
          this.base[this.var_name] = v
        } else {
          this.current_my_value = v
        }
      },
    },
  },
}
</script>

<style lang="sass">
.SimpleRadioButton
  .b-slider
    .b-slider-thumb-wrapper.has-indicator .b-slider-thumb
      padding: 10px 6px
      font-size: 10px
    .b-slider-thumb-wrapper .b-slider-thumb
      transform: unset // 掴んでも拡大させない
</style>
