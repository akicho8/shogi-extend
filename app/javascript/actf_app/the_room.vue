<template lang="pug">
.the_room
  .columns.is-centered.is-mobile
    template(v-for="(membership, i) in $parent.room.memberships")
      .column.user_container.is-flex
        template(v-if="membership.rensho_count >= 2")
          .rensho_count
            | {{membership.rensho_count}}連勝中！
        figure.image.is-32x32
          img.is-rounded(:src="membership.user.avatar_path")
        .user_name.has-text-weight-bold
          | {{membership.user.name}}
        .user_quest_index.has-text-weight-bold.is-size-4
          | {{$parent.quest_index_for(membership)}}
      template(v-if="i === 0")
        .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
          | vs
  .columns(v-if="$parent.current_quest_init_sfen")
    .column
      .has-text-centered
        | {{$parent.quest_index + 1}}問目
        | {{turn_offset}}手目
      shogi_player(
        :key="`quest_${$parent.quest_index}`"
        ref="main_sp"
        :run_mode="'play_mode'"
        :kifu_body="`position sfen ${$parent.current_quest_init_sfen}`"
        :summary_show="false"
        :setting_button_show="development_p"
        :size="'default'"
        :sound_effect="true"
        :volume="0.5"
        :controller_show="true"
        :human_side_key="'both'"
        :theme="'simple'"
        :vlayout="false"
        @update:turn_offset="v => turn_offset = v"
        @update:play_mode_advanced_full_moves_sfen="$parent.play_mode_advanced_full_moves_sfen_set"
      )
      .has-text-centered.tags_container
        //- p 難易度:{{quest.difficulty_level}}
        b-taglist.is-centered
          b-tag(v-if="quest.title") {{quest.title}}
          b-tag(v-if="quest.source_desc") {{quest.source_desc}}
          b-tag(v-if="!quest.source_desc") {{quest.user.name}}作
          b-tag(v-if="quest.hint_description") {{quest.hint_description}}
          b-tag(v-if="quest.difficulty_level && quest.difficulty_level >= 1")
            template(v-for="i in quest.difficulty_level")
              | ★

        //- | 難易度:{{$parent.current_simple_quest_info.difficulty_level}}
        //- e.time_limit_sec        = 60 * 3
        //- e.difficulty_level      = 5
        //- e.title                 = "(title)"
        //- e.description           = "(description)"
        //- e.hint_description      = "(hint_description)"
        //- e.source_desc           = "(source_desc)"
        //- e.other_twitter_account = "(other_twitter_account)"
</template>

<script>
import the_support from "./the_support.js"

export default {
  name: "the_room",
  mixins: [
    the_support,
  ],
  data() {
    return {
      turn_offset: null,
    }
  },
  created() {
    this.main_nav_set(false)
  },
  computed: {
    quest() {
      return this.$parent.current_simple_quest_info
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_room
  .vs_mark
    flex-direction: column
    justify-content: center
    align-items: center
  .tags_container
    margin-top: 0.7rem
</style>
