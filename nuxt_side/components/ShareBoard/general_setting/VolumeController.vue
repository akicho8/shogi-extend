<template lang="pug">
//- ~/src/shogi-extend/nuxt_side/components/SimpleRadioButtons.vue
b-field.VolumeController(custom-class="is-small" :label="real_model.field_label" grouped :message="real_model.field_message")
  //- b-switch(v-model="mut_active" type="is-primary" size="is-small")
  b-slider(v-bind="slider_attrs" v-model="mut_volume" v-on="$listeners" :disabled="!mut_active")
</template>

<script>
export default {
  name: "SimpleSlider",
  props: {
    base:        { type: Object,  required: true, },
    model_name:  { type: String,  required: true, },
    sync_volume: { type: Number,  required: true, },
    sync_active: { type: Boolean, required: true, },
  },
  data() {
    return {
      mut_volume: this.sync_volume,
      mut_active: this.sync_active,
    }
  },
  watch: {
    sync_volume() { this.mut_volume = this.sync_volume                },
    mut_volume()  { this.$emit("update:sync_volume", this.mut_volume) },

    sync_active() { this.mut_active = this.sync_active                },
    mut_active()  { this.$emit("update:sync_active", this.mut_active) },
  },
  computed: {
    real_model() { return this.base[this.model_name]  },

    slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
        min: 0,
        max: 10,
        ...this.$attrs,
      }
    },

  },
}
</script>

<style lang="sass">
.VolumeController
  .label
    margin-bottom: 0
  .is-grouped
    align-items: center           // スライダーとスイッチの縦位置を水平に揃えるため
  .help
    margin-top: 0                 // スライダーの下の説明の上の隙間をつめる
  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 10px 6px
        font-size: 10px
  .b-slider .b-slider-thumb-wrapper .b-slider-thumb
    transform: unset              // 握っても拡大させない
</style>
