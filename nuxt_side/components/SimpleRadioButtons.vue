<template lang="pug">
b-field.is_scroll_x.SimpleRadioButtons(:message="field_message" v-bind="$attrs")
  template(#label)
    span(:class="{'is-clickable': present_p(hint_str)}" @click="label_click_handle")
      | {{label}}
      template(v-if="permanent_mark_append")
        span.has-text-primary
          | *

  template(v-if="real_model.input_type === 'numberinput'")
    b-numberinput(
      :size="element_size"
      controls-position="compact"
      v-model="real_value"
      :min="real_model.min"
      :max="real_model.max"
      :exponential="true"
      @input="input_handle"
      )
  template(v-else)
    template(v-for="e in real_model.values")
      b-radio-button(
        v-if="e.environment == null || e.environment.includes($config.STAGE)"
        :class="e.key"
        @input="input_handle"
        v-model="real_value"
        :native-value="e.key"
        :type="e.type"
        v-on="$listeners"
        :size="element_size"
        )
        | {{e.name}}
</template>

<script>
export default {
  name: "SimpleRadioButtons",
  props: {
    base:         { type: Object, required: true,  },
    model_name:   { type: String, required: true,  },
    var_name:     { type: String, required: false, }, // DEPRECATION
    element_size: { type: String, required: false, },
    permanent_mark_append: { type: Boolean, default: false, required: false, },
    my_value:     { required: false, },
  },
  data() {
    return {
      current_my_value: this.my_value,
    }
  },
  watch: {
    my_value() {
      this.current_my_value = this.my_value
    },
    current_my_value() {
      this.$emit("update:my_value", this.current_my_value)
    },
  },
  methods: {
    input_handle(e) {
      this.$sound.play_click()
      if (this.real_model.input_type === 'numberinput') {
      } else {
        this.talk(this.current.talk_message || this.current.name)
      }
      this.$emit("user_input", this.real_model)
    },
    label_click_handle(e) {
      if (this.present_p(this.hint_str)) {
        this.$sound.stop_all()
        this.$sound.play_click()
        this.toast_ok(this.hint_str, {duration: 1000 * this.duration_sec})
      }
    },
  },
  computed: {
    real_model() { return this.base[this.model_name]                     },
    current()    { return this.real_model.fetch(this.real_value)         },
    label()      { return this.real_model.field_label                    },
    hint_str()   { return (this.real_model.hint_messages || []).join("") },
    current()    { return this.real_model.fetch(this.real_value)         },
    field_message() {
      let str = null
      if (this.real_model.input_type === 'numberinput') {
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
</style>
