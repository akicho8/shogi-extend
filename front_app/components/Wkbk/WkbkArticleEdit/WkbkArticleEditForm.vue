<template lang="pug">
.WkbkArticleEditForm
  .columns.is-gapless
    .column
      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.article.title" required)

      b-field(label="ヒント" label-position="on-border" v-if="base.config.hint_enable")
        b-input(v-model.trim="base.article.hint_desc")

      b-field.lineage_key(label="種類" label-position="on-border" v-if="base.LineageInfo")
        b-select(v-model="base.article.lineage_key" expanded)
          option(v-for="row in base.LineageInfo.values" :value="row.key") {{row.name}}

      b-field(label="制限時間" label-position="on-border" v-if="base.config.time_limit_sec_enable")
        b-timepicker(v-model="base.article.time_limit_clock" icon="clock" :enable-seconds="true" :mobile-native="false")

      b-field(label="解説" label-position="on-border")
        b-input(v-model.trim="base.article.description" type="textarea" rows="3")

      b-field(label="難易度" custom-class="is-small" v-if="base.config.difficulty_level_enable")
        b-rate(v-model="base.article.difficulty_level" spaced :max="base.config.difficulty_level_max" :show-score="false")

      b-field(label="メッセージ" label-position="on-border" message="問題と一緒に表示する文言です。何手指してほしいかや、ヒントを伝えたいときだけ入力してください。基本未入力でかまいません")
        b-input(v-model.trim="base.article.direction_message" placeholder="3手指してください")

      b-field(label="タグ" label-position="on-border")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.article.owner_tag_list" rounded :confirm-key-codes="[13, 188, 9, 32]")

      b-field(v-if="lineage_info.mate_validate_on")
        b-switch(v-model="base.article.mate_skip" size="is-small") 最後は無駄合い (なので詰みチェックしない)

      b-collapse.mt-5(:open="source_author_collapse_open_p")
        b-button(slot="trigger" @click="sound_play('click')" slot-scope="props" size="is-small") 作者が他者の場合
        .box.py-5
          b-field
            b-switch(v-model="base.article.source_about_key" size="is-small" true-value="unknown" false-value="ascertained") 作者不詳

          b-field(label="作者" label-position="on-border")
            b-input(v-model.trim="base.article.source_author" placeholder="初代大橋宗桂" :disabled="base.article.source_about_key === 'unknown'")

          b-field(label="出典メディア" label-position="on-border")
            b-input(v-model.trim="base.article.source_media_name" placeholder="詰パラ")

          b-field(label="出典年月日" label-position="on-border")
            b-datepicker(
              v-model="base.article.date_casted_source_published_on"
              :month-names="[1,2,3,4,5,6,7,8,9,10,11,12]"
              :day-names="['日','月','火','水','木','金', '土']"
              :years-range="[-500, 100]"
              :mobile-native="false"
            )

          b-field(label="出典URL" label-position="on-border")
            b-input(v-model.trim="base.article.source_media_url" type="url")

      b-field(label="フォルダ" custom-class="is-small" v-if="base.FolderInfo")
        b-field.is-marginless
          template(v-for="row in base.FolderInfo.values")
            b-radio-button(v-model="base.article.folder_key" :native-value="row.key" :type="row.type")
              b-icon(:icon="row.icon" size="is-small")
              span {{row.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleEditForm",
  mixins: [
    support_child,
  ],
  data() {
    return {
      source_author_collapse_open_p: null,
    }
  },
  created() {
    this.source_author_collapse_open_p = this.base.article.source_author_collapse_open_p
  },
  watch: {
    "article.lineage_key": {
      handler(v) {
        this.sound_play("click")
        this.talk(v)
      },
    },
    "article.mate_skip": {
      handler(v) {
        this.sound_play("click")
        this.talk(v)
      },
    },
    "article.folder_key": {
      handler(v) {
        const folder_info = this.base.FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk(folder_info.name)
      },
    },
    "article.difficulty_level": {
      handler(v) {
        this.sound_play("click")
        this.talk(v)
      },
    },
    "base.article.source_about_key": {
      handler(v) {
        if (v === "unknown") {
          this.talk("作者不詳")
        }
        this.sound_play("click")
      },
    },
  },
  computed: {
    article()     { return this.base.article                                     },
    lineage_info() { return this.base.LineageInfo.fetch(this.article.lineage_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleEditForm
  margin: $wkbk_share_gap
  .field:not(:first-child)
    margin-top: $wkbk_share_gap
  .help
    color: $grey
    font-size: $size-7
  .b-radio
    font-size: $size-7
</style>
