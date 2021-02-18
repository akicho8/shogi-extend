<<template lang="pug">
MainSection.WkbkBookShowTop
  .container.is-fluid
    .columns
      .column.is-7
        .columns
          .column
            WkbkBookShowTopMainCard(:base="base")
        .columns
          .column
            WkbkBookShowTopTweetStat(:base="base")
          .column
            WkbkBookShowTopTweetRecent(:base="base")
      .column
        WkbkBookShowTopXitemList(:base="base" ref="WkbkBookShowTopXitemList")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTop",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowTop
    .column, .book_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowTop
  .MainSection.section
    +mobile
      padding: 1.0rem 0.75rem
    +tablet
      padding: 1.0rem 0.75rem
</style>
