<<template lang="pug">
MainSection.WkbkBookShowTop
  .container.is-fluid
    .columns
      .column
        .columns
          .column
            WkbkBookShowTopMainCard(:base="base")
        .columns
          .column
            WkbkBookShowTopTweetStat(:base="base")
          .column
            WkbkBookShowTopTweetRecent(:base="base")
      .column
        WkbkBookShowTopXitemTable(:base="base" ref="WkbkBookShowTopXitemTable")
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

.MainSection.section.WkbkBookShowTop
  +mobile
    padding: 1.0rem 0.75rem
  +tablet
    padding: 1.0rem 0.75rem
</style>
