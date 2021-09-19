<template lang="pug">
.XmovieFormPro
  b-field.one_block(label="表紙")
    b-input(type="textarea" v-model.trim="base.cover_text" expanded rows="4" placeholder="御城将棋\n☗六代大橋宗銀 vs ☖伊藤印達\n1711/02/28")

  SimpleRadioButtons.one_block(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")

  .page_duration_field.one_block
    //- b-field(:message="base.page_duration_message" v-if="false")
    //-   template(#label)
    //-     p 1ページあたりの秒数
    //-     b-taglist.fps_values
    //-       template(v-for="fps in [60, 30, 20, 15]")
    //-         a.has-text-primary.is-italic.has-text-weight-normal(@click="base.page_duration_set_by_fps(fps)") {{fps}}fps
    //-   b-numberinput(key="numberinput-page_duration" v-model="base.page_duration" :min="base.page_duration_step" :max="3" :step="base.page_duration_step" exponential @input="sound_play('click')")

    b-field(:message="base.page_duration_message")
      template(#label)
        p 1ページあたりの秒数

        //- b-taglist.mt-1
        //-   template(v-for="fps in [60, 30, 20, 15]")
        //-     //- a.has-text-primary.is-italic.has-text-weight-normal(@click="base.page_duration_set_by_fps(fps)") {{fps}}fps
        //-     b-tag.is-clickable(type="is-primary is-light" @click.native="base.page_duration_set_by_fps(fps)") {{fps}}fps
        //-   //- template(v-for="value in [0.5, 1.0, 1.5, 2.0]")
        //-   //-   //- a.has-text-primary.is-italic.has-text-weight-normal(@click="base.page_duration_set_by_value(value)") {{value}}
        //-   //-   b-tag.is-clickable(type="is-primary is-light" @click.native="base.page_duration_set_by_value(value)") {{value}}
        //-   b-tag.is-clickable(type="is-primary is-light" @click.native="base.page_duration_add(-0.1)") -0.1
        //-   b-tag.is-clickable(type="is-primary is-light" @click.native="base.page_duration_set_by_value(1.0)") 1.0
        //-   b-tag.is-clickable(type="is-primary is-light" @click.native="base.page_duration_add(+0.1)") +0.1

        b-field(grouped).mb-0
          .control
            .buttons.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click.native="base.page_duration_add(-0.1)") -0.1
              b-button.mb-0(@click.native="base.page_duration_set_by_value(1.0)") 1.0
              b-button.mb-0(@click.native="base.page_duration_add(+0.1)") +0.1
          .control
            .buttons.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click.native="base.page_duration_mul(0.5)") ÷2
              b-button.mb-0(@click.native="base.page_duration_mul(2.0)") ×2

        b-field(grouped).mb-0
          .control
            .buttons.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click="base.compute_from_bpm_modal_handle") BPM
          .control
            .buttons.mb-0.has-addons.are-small.mt-2
              template(v-for="fps in [60, 30, 20, 15]")
                b-button.mb-0(@click="base.page_duration_set_by_fps(fps)") {{fps}}f

      b-input(key="input-page_duration" v-model.number="base.page_duration")

  b-field.one_block.recipe_key_field(:label="base.RecipeInfo.field_label" :message="base.RecipeInfo.fetch(base.recipe_key).message || base.RecipeInfo.field_message")
    .control
      b-dropdown(v-model="base.recipe_key" @active-change="e => e && sound_play('click')")
        template(#trigger)
          b-button(:label="base.recipe_info.name" icon-right="menu-down")
        template(v-for="e in base.RecipeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key" @click="sound_play('click')")
              .media
                .media-left
                  | {{e.name}}
                  //- | {{e.real_ext}}
                .media-content
                  //- .has-text-weight-bold {{e.name}}
                  h3 {{e.title}}
                  span {{e.message}}
                  //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                  //- small {{e.message}}

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.one_block(v-if="development_p" :label="base.RecipeInfo.field_label" :message="base.RecipeInfo.fetch(base.recipe_key).message || base.RecipeInfo.field_message")
    b-select(type="number" v-model="base.recipe_key" @input="sound_play('click')")
      option(v-for="e in base.RecipeInfo.values" :value="e.key" v-text="e.name")

  //- https://buefy.org/documentation/field#combining-addons-and-groups
  b-field.one_block(grouped v-if="development_p && false")
    b-field(label="サイズプリセット" :message="[base.animation_size_info.message]")
      b-select(v-model="base.animation_size_key" @input="base.animation_size_key_input_handle" @click.native="sound_play('click')")
        option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name" v-if="e.environment == null || e.environment.includes($config.STAGE)")
    b-field.compact_wh_input(label="サイズ" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
      b-input(required type="number" v-model.number="base.img_width"  :min="0" :max="4096" :step="1" expanded placeholder="width")
      b-input(required type="number" v-model.number="base.img_height" :min="0" :max="4096" :step="1" expanded placeholder="height")

  b-field.one_block(grouped v-if="development_p && false")
    b-field.animation_size_field(label="サイズ" :message="[base.animation_size_info.message]")
      b-dropdown.control(v-model="base.animation_size_key" @active-change="e => e && sound_play('click')" @input="base.animation_size_key_input_handle")
        template(#trigger)
          b-button(:label="base.animation_size_info.option_name" icon-right="menu-down")
        template(v-for="e in base.AnimationSizeInfo.values")
          b-dropdown-item(:value="e.key" v-if="e.environment == null || e.environment.includes($config.STAGE)")
            .media
              .media-left
                | {{e.option_name}}
              .media-content
                //- h3 {{e.name}}
                span {{e.message}}
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}

    b-field.compact_wh_input(label="サイズ(非表示)" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
      b-input(required type="number" v-model.number="base.img_width"  :min="0" :max="4096" :step="1" placeholder="width")
      b-input(required type="number" v-model.number="base.img_height" :min="0" :max="4096" :step="1" placeholder="height")

  //////////////////////////////////////////////////////////////////////////////// 縦
  //- b-field.one_block
  //-   b-field(label="サイズプリセット" :message="[base.animation_size_info.message]" v-if="false")
  //-     b-select(v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
  //-       option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")

  .one_block.animation_size_field
    b-field(label="サイズ" :message="[base.animation_size_info.message]")
      .control
        // @active-change="sound_play('click')"
        b-dropdown(v-model="base.animation_size_key" @active-change="e => e && sound_play('click')" @input="base.animation_size_key_input_handle")
          template(#trigger)
            b-button(:label="base.animation_size_info.option_name" icon-right="menu-down")
          template(v-for="e in base.AnimationSizeInfo.values")
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

    b-field(label="" :type="{'is-danger': base.i_size_danger_p}" :message="[base.i_size_aspect_ratio_human]" v-if="base.animation_size_info.key === 'is_custom'")
      b-input(required type="number" v-model.number="base.img_width"  :min="0" :max="4096" :step="1" expanded placeholder="width" )
      b-input(required type="number" v-model.number="base.img_height" :min="0" :max="4096" :step="1" expanded placeholder="height")

  b-field.one_block(label="1ページあたりの秒数" v-if="development_p && false")
    b-slider(:indicator="true" :tooltip="false" v-model="base.page_duration" :min="0.1" :max="5" :step="0.1")

  SimpleRadioButtons.one_block(:base="base" :model="base.LoopInfo" var_name="loop_key" v-if="base.recipe_info.loop_key_enable")

  b-field.one_block(label="最後に指定秒間停止" message="7秒ぐらいが良い。BGMもこの秒数だけﾌｪｲﾄﾞｱｳﾄする")
    b-numberinput(v-model="base.end_duration" :min="0" :max="10" :step="1" exponential @input="sound_play('click')")

  SimpleRadioButtons.one_block(:base="base" :model="base.XfontInfo" var_name="xfont_key")

  b-field.one_block(label="映像品質レベル" message="18〜23推奨。高←→低(ﾓﾊﾞｲﾙ向け)。-6毎にﾋﾞｯﾄﾚｰﾄが倍になる")
    b-numberinput(v-model="base.video_crf" :min="0" :max="51" :step="1" exponential @input="sound_play('click')")

  b-field.one_block(label="音声ビットレート" message="Twitterの推奨は128kだけど厳密な制限はしてないっぽい")
    b-input(v-model="base.audio_bit_rate" placeholder="128k")

  //- SimpleRadioButtons(:base="base" :model="base.AnimationSizeInfo" var_name="animation_size_key")
  // SimpleRadioButtons(:base="base" :model="base.RecipeInfo" var_name="recipe_key")

  //- b-collapse(:open="false" position="is-bottom")
  //-   template(#trigger="props")
  //-     a
  //-       b-icon(:icon="!props.open ? 'menu-down' : 'menu-up'")
  //-       template(v-if="!props.open")
  //-         | すべてのフォームを表示する
  //-       template(v-else)
  //-         | 隠す
  //- b-field.one_block(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="30" :max="60" :step="1" exponential @input="sound_play('click')")
  //- b-field.one_block(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="1" :max="60" :step="0.01" exponential)

  // 分数形式なども受けつけるように文字列入力にすること
  //- b-field.one_block(label="MP4のFPS" message="1手1秒なら1FPSで良い気もするけど30FPS以上にしといた方が安全かもしれない")
  //-   b-input(v-model="base.video_fps")

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieFormPro",
  mixins: [support_child],
  data() {
    return {
      foo_key: false,
    }
  },

}
</script>

<style lang="sass">
.XmovieFormPro
  .recipe_key_field
    .dropdown-item
      +desktop
        min-width: 24rem
      .media-left
        flex-basis: 20%

  .animation_size_field
    .dropdown-item
      +desktop
        min-width: 24rem
      .media-left
        flex-basis: 50%

  .compact_wh_input
    label
      visibility: hidden
    input
      width: 5rem

  // .fps_values
  //   a:not(:first-child)
  //     margin-left: 0.25rem
</style>
