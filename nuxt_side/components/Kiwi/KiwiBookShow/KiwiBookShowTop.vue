<<template lang="pug">
MainSection.KiwiBookShowTop
  .container.is-fluid
    .columns
      .column
        KiwiBookShowTopMainCard(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowTop",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .KiwiBookShowTop
    .column, .book_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.MainSection.section.KiwiBookShowTop
  +mobile
    padding: 1.0rem 0.75rem
  +tablet
    padding: 1.0rem 0.75rem
</style>
