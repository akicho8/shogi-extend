<template lang="pug">
.XconvForm
  .columns.is-centered.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
    .column.is-half
      ////////////////////////////////////////////////////////////////////////////////
      b-field.mb-0.body_field(:type="base.body_field_type")
        template(#label)
          .label_text 棋譜
          a.is-size-7(@click="base.share_board_handle")
            b-icon(icon="open-in-new" size="is-small")
            | 将棋盤
          a.is-size-7(@click="base.adapter_handle")
            b-icon(icon="open-in-new" size="is-small")
            | 棋譜変換
        b-input(type="textarea" ref="body" v-model.trim="base.body" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")
      p.mt-0(v-if="false")
        b-button(@click="base.share_board_handle" type="is-white" size="is-small" icon-left="open-in-new")
          | 共有将棋盤で確認
        a.is-size-7(@click="base.share_board_handle")
          b-icon(icon="open-in-new" size="is-small")
          | 共有将棋盤で確認
      ////////////////////////////////////////////////////////////////////////////////

        //- b-button(tag="nuxt-link" :to="{name: 'settings-battles', query: {query: 'ok'}}") リンク
        //- b-menu-item(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: config.current_swars_user_key}}" @click.native="sound_play('click')" icon="account" label="プレイヤー情報" :disabled="!config.current_swars_user_key")

      //- https://buefy.org/documentation/field#combining-addons-and-groups
      b-field(grouped)
        b-field(label="サイズ" expanded :message="[base.animation_size_info.message, base.i_size_aspect_ratio_human]" )
          b-field(:type="{'is-danger': base.i_size_danger_p}")
            b-select(type="number" v-model="base.animation_size_key" @input="base.animation_size_key_input_handle")
              option(v-for="e in base.AnimationSizeInfo.values" :value="e.key" v-text="e.option_name")
            b-input(required type="number" v-model="base.i_width"  :min="0" :max="development_p ? 3200 : 1600" :step="1" exponential expanded placeholder="width")
            b-input(required type="number" v-model="base.i_height" :min="0" :max="development_p ? 3200 : 1200" :step="1" exponential expanded placeholder="height")
            p.control(v-if="development_p && false")
              span.button.is-static
                | {{base.i_size_aspect_ratio_human}}

      //- https://buefy.org/documentation/field#combining-addons-and-groups
      b-field(v-if="false" :label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
        b-select(type="number" v-model="base.xout_format_key" @input="sound_play('click')")
          option(v-for="e in base.XoutFormatInfo.values" :value="e.key" v-text="e.name")

      b-field(label="出力形式" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
        b-dropdown.xout_format_key_dropdown.control(v-model="base.xout_format_key" @active-change="sound_play('click')")
          template(#trigger)
            b-button(:label="base.xout_format_info.name" icon-right="menu-down")
          template(v-for="e in base.XoutFormatInfo.values")
            template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
              b-dropdown-item(:value="e.key")
                .media
                  .media-left
                    | {{e.name}}
                    //- | {{e.real_ext}}
                  .media-content
                    //- .has-text-weight-bold {{e.name}}
                    //- h3 {{e.name}}
                    span {{e.message}}
                    //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                    //- small {{e.message}}

      b-field(label="表示秒数/1枚" v-if="development_p && false")
        b-slider(:indicator="true" :tooltip="false" v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1")

      b-field(label="表示秒数/1枚")
        b-numberinput(v-model="base.delay_per_one" :min="0.1" :max="5" :step="0.1" exponential @input="sound_play('click')")

      //- SimpleRadioButtons(:base="base" :model="base.AnimationSizeInfo" var_name="animation_size_key")
      // SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")

    .column.is-one-third2
      SimpleRadioButtons(:base="base" :model="base.LoopInfo" var_name="loop_key")
      SimpleRadioButtons(:base="base" :model="base.ViewpointInfo" var_name="viewpoint_key")
      SimpleRadioButtons(:base="base" :model="base.ThemeInfo" var_name="theme_key")

      b-field(label="終了図停止枚数" :message="`最後に${base.end_seconds}秒停止する`")
        b-numberinput(v-model="base.end_frames" :min="0" :max="10" :step="1" exponential @input="sound_play('click')")

      .box(v-if="development_p")
        b-field(label="*負荷")
          b-input(type="number" v-model="base.sleep" expanded)

        b-field(label="*例外")
          b-input(type="text" v-model="base.raise_message" expanded)

      //- SimpleRadioButtons(:base="base" :model="base.XoutFormatInfo" var_name="xout_format_key")
      b-field(v-if="false" :label="base.XoutFormatInfo.field_label" :message="base.XoutFormatInfo.fetch(base.xout_format_key).message || base.XoutFormatInfo.field_message")
        template(#label)
          | Label with custom
          span(class="has-text-primary is-italic") style
        template(v-for="e in base.XoutFormatInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-radio-button(@input="sound_play('click')" v-model="base.xout_format_key" :native-value="e.key" :type="e.type")
              | {{e.name}}

      template(v-if="false")
        b-field(:label="base.LoopInfo.field_label" :message="base.LoopInfo.fetch(base.loop_key).message || base.LoopInfo.field_message")
          template(v-for="e in base.LoopInfo.values")
            b-radio-button(@input="sound_play('click')" v-model="base.loop_key" :native-value="e.key" :type="e.type")
              | {{e.name}}

  .columns.is-centered
    .column
      hr
      b-field
        .control
          .buttons
            b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary") 変換
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XconvForm
  .column > .field:not(:first-child)
    margin-top: 2rem
  .body_field
    label
      display: flex
      align-items: center
      justify-content: flex-start
      .label_text
        margin-right: auto // aリンクたちを右に押す
      a:not(:first-child)
        margin-left: 0.25rem // aリンク同士の間を開ける
        font-weight: normal  // label のなかは bold になるため元に戻す
  .xout_format_key_dropdown
    .dropdown-item
      &:not(.is-active)         // 選択してない項目だけ種類を青くする
        .media-left
          color: $primary
      .media-left
        min-width: 4ch
        font-weight: bold
</style>
