<template lang="pug">
.the_ready_go
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
  .columns(v-if="$parent.current_quest_base_sfen")
    .column
      .has-text-centered
        | {{turn_offset}}手目
      shogi_player(
        :key="`quest_${$parent.quest_index}`"
        ref="main_sp"
        :run_mode="'play_mode'"
        :kifu_body="$parent.current_quest_base_sfen"
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
      .has-text-centered
        
</template>

<script>
import the_support from './the_support'

export default {
  name: "the_ready_go",
  mixins: [
    the_support,
  ],
  data() {
    return {
      turn_offset: null,
    }
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_ready_go
  .vs_mark
    flex-direction: column
    justify-content: center
    align-items: center
</style>
