<template lang="pug">
.KiwiLemonNewFormPro2
  b-field.field_block.recipe_key_field(:label="base.RecipeInfo.field_label" :message="base.RecipeInfo.fetch(base.recipe_key).message || base.RecipeInfo.field_message")
    .control
      b-dropdown(v-model="base.recipe_key" @active-change="e => e && sfx_click()")
        template(#trigger)
          b-button(:label="base.recipe_info.name" icon-right="menu-down")
        template(v-for="e in base.RecipeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key" @click="recipe_click_handle")
              .media
                .media-left
                  | {{e.name}}
                  //- | {{e.real_ext}}
                .media-content.is_line_break_on
                  //- .has-text-weight-bold {{e.name}}
                  h3 {{e.title}}
                  span {{e.message}}
                  //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                  //- small {{e.message}}

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.field_block(v-if="development_p" :label="base.RecipeInfo.field_label" :message="base.RecipeInfo.fetch(base.recipe_key).message || base.RecipeInfo.field_message")
    b-select(type="number" v-model="base.recipe_key" @input="sfx_click()")
      option(v-for="e in base.RecipeInfo.values" :value="e.key" v-text="e.name")

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.field_block(grouped v-if="development_p && false")
    b-field(label="サイズプリセット" :message="[base.rect_size_info.message]")
      b-select(v-model="base.rect_size_key" @input="base.rect_size_key_input_handle" @click.native="sfx_click()")
        option(v-for="e in base.RectSizeInfo.values" :value="e.key" v-text="e.option_name" v-if="e.environment == null || e.environment.includes($config.STAGE)")
    b-field.compact_wh_input(label="サイズ" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.rect_size_info.key === 'is_rect_size_custom'")
      b-input(required type="number" v-model.number="base.rect_width"  :min="0" :max="4096" :step="1" expanded placeholder="width")
      b-input(required type="number" v-model.number="base.rect_height" :min="0" :max="4096" :step="1" expanded placeholder="height")

  b-field.field_block(grouped v-if="development_p && false")
    b-field.rect_size_field(label="サイズ" :message="[base.rect_size_info.message]")
      b-dropdown.control(v-model="base.rect_size_key" @active-change="e => e && sfx_click()" @input="base.rect_size_key_input_handle")
        template(#trigger)
          b-button(:label="base.rect_size_info.option_name" icon-right="menu-down")
        template(v-for="e in base.RectSizeInfo.values")
          b-dropdown-item(:value="e.key" v-if="e.environment == null || e.environment.includes($config.STAGE)")
            .media
              .media-left
                | {{e.option_name}}
              .media-content
                //- h3 {{e.name}}
                span {{e.message}}
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}

    b-field.compact_wh_input(label="サイズ(非表示)" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.rect_size_info.key === 'is_rect_size_custom'")
      b-input(required type="number" v-model.number="base.rect_width"  :min="0" :max="4096" :step="1" placeholder="width")
      b-input(required type="number" v-model.number="base.rect_height" :min="0" :max="4096" :step="1" placeholder="height")

  //////////////////////////////////////////////////////////////////////////////// 縦
  //- b-field.field_block
  //-   b-field(label="サイズプリセット" :message="[base.rect_size_info.message]" v-if="false")
  //-     b-select(v-model="base.rect_size_key" @input="base.rect_size_key_input_handle")
  //-       option(v-for="e in base.RectSizeInfo.values" :value="e.key" v-text="e.option_name")

  .field_block.rect_size_field
    b-field(label="サイズ" :message="[base.rect_size_info.message]")
      .control
        // @active-change="sfx_click()"
        b-dropdown(v-model="base.rect_size_key" @active-change="e => e && sfx_click()" @input="base.rect_size_key_input_handle")
          template(#trigger)
            b-button(:label="base.rect_size_info.option_name" icon-right="menu-down")
          template(v-for="e in base.RectSizeInfo.values")
            template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
              template(v-if="e.separator")
                b-dropdown-item(separator)
              template(v-else)
                b-dropdown-item(:value="e.key")
                  .media
                    .media-left
                      span.ml-2 {{e.option_name}}
                    .media-content
                      //- h3 {{e.name}}
                      span {{e.message}}
                      //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                      //- small {{e.message}}

    b-field(label="" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.rect_size_info.key === 'is_rect_size_custom'")
      b-input(required type="number" v-model.number="base.rect_width"  :min="0" :max="4096" :step="1" expanded placeholder="width" )
      b-input(required type="number" v-model.number="base.rect_height" :min="0" :max="4096" :step="1" expanded placeholder="height")

  b-field.field_block(label="1ページあたりの秒数" v-if="development_p && false")
    b-slider(:indicator="true" :tooltip="false" v-model="base.page_duration" :min="0.1" :max="5" :step="0.1")

  SimpleRadioButton.field_block(:base="base" model_name="LoopInfo" var_name="loop_key" v-if="base.recipe_info.loop_key_enable")

  b-field.field_block(label="最後に指定秒間停止" message="7秒ぐらいが良い。BGMもこの秒数だけフェイドアウトする")
    b-numberinput(v-model="base.end_duration" :min="0" :max="10" :step="1" exponential @input="sfx_click()")

  b-field.field_block(label="音量")
    b-numberinput(v-model="base.main_volume" :min="0" :max="1.0" :step="0.1" exponential @input="sfx_click()")

  b-field.field_block(label="音声ビットレート" message="Twitterの推奨は128kだけど厳密な制限はしてないっぽい (よくわからない場合はそのままで)")
    b-input(v-model="base.audio_bit_rate" placeholder="128k")

  b-field.field_block(label="映像品質レベル" message="18〜23推奨。値が小さいほど品質が高くなる。ただし-6毎にビットレートが倍になる (よくわからない場合はそのままで)")
    b-numberinput(v-model="base.video_crf" :min="0" :max="51" :step="1" exponential @input="sfx_click()")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormPro2",
  mixins: [support_child],
  methods: {
    recipe_click_handle() {
      this.sfx_click()
      this.talk(this.base.recipe_info.name)
    },
  },
}
</script>

<style lang="sass">
.KiwiLemonNewFormPro2
  .dropdown-item
    +desktop
      min-width: 24rem
    .media-left
      flex-basis: 4rem
</style>
