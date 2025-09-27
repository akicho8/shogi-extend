<template lang="pug">
.KiwiLemonNewFormPro1
  SimpleRadioButton.field_block(:base="base" model_name="ViewpointInfo" var_name="viewpoint")

  .page_duration_field.field_block
    //- b-field(:message="base.page_duration_message" v-if="false")
    //-   template(#label)
    //-     p 1ページあたりの秒数
    //-     b-taglist.fps_values
    //-       template(v-for="fps in [60, 30, 20, 15]")
    //-         a.has-text-primary.is-italic.has-text-weight-normal(@click="base.page_duration_set_by_fps(fps)") {{fps}}fps
    //-   b-numberinput(key="numberinput-page_duration" v-model="base.page_duration" :min="base.page_duration_step" :max="3" :step="base.page_duration_step" exponential @input="sfx_play_click()")

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
            .buttons.is-flex-wrap-nowrap.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click.native="base.page_duration_add(-0.1)") -0.1
              b-button.mb-0(@click.native="base.page_duration_set_by_value(1.0)") 1.0
              b-button.mb-0(@click.native="base.page_duration_add(+0.1)") +0.1
          .control
            .buttons.is-flex-wrap-nowrap.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click.native="base.page_duration_mul(0.5)") ÷2
              b-button.mb-0(@click.native="base.page_duration_mul(2.0)") ×2

        b-field(grouped).mb-0
          .control
            .buttons.is-flex-wrap-nowrap.mb-0.has-addons.are-small.mt-2
              b-button.mb-0(@click="base.compute_from_bpm_modal_handle") BPM
          .control
            .buttons.is-flex-wrap-nowrap.mb-0.has-addons.are-small.mt-2
              template(v-for="fps in [60, 30, 20, 15]")
                b-button.mb-0(@click="base.page_duration_set_by_fps(fps)") {{fps}}f

      b-input(key="input-page_duration" v-model.number="base.page_duration")


  SimpleRadioButton.field_block(:base="base" model_name="TurnEmbedInfo" var_name="turn_embed_key")
  SimpleRadioButton.field_block(:base="base" model_name="PieceFontWeightInfo" var_name="piece_font_weight_key")

  //- SimpleRadioButton(:base="base" model_name="RectSizeInfo" var_name="rect_size_key")
  // SimpleRadioButton(:base="base" model_name="RecipeInfo" var_name="recipe_key")

  //- b-collapse(:open="false" position="is-bottom")
  //-   template(#trigger="props")
  //-     a
  //-       b-icon(:icon="!props.open ? 'menu-down' : 'menu-up'")
  //-       template(v-if="!props.open")
  //-         | すべてのフォームを表示する
  //-       template(v-else)
  //-         | 隠す
  //- b-field.field_block(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="30" :max="60" :step="1" exponential @input="sfx_play_click()")
  //- b-field.field_block(label="FPS")
  //-   b-numberinput(v-model="base.video_fps" :min="1" :max="60" :step="0.01" exponential)

  // 分数形式なども受けつけるように文字列入力にすること
  //- b-field.field_block(label="MP4のFPS" message="1手1秒なら1FPSで良い気もするけど30FPS以上にしといた方が安全かもしれない")
  //-   b-input(v-model="base.video_fps")

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewFormPro1",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewFormPro1
  .recipe_key_field
    .dropdown-item
      +desktop
        min-width: 24rem
      .media-left
        flex-basis: 20%

  .rect_size_field
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
