<template lang="pug">
.GalleryWood
</template>

<script>

export default {
}
</script>

<style lang="sass">
.GalleryWood
  .slider_container
    width: 10rem

  .MainSection.section
    +mobile
      padding: 0.75rem
      .columns
        margin: 0
      .column
        padding: 0
        &:not(:first-child)
          margin-top: 0.75rem
    +tablet
      padding: 1.5rem

  .is_texture
    img
      border-radius: 3px

  .image_number
    position: absolute
    top: 0
    left: 0
    .image_number_body
      line-height: 1.0
      padding: 0.25rem 0.25rem
      font-size: $size-7
      border-radius: 3px
      color: change_color($warning, $lightness: 30%)
      background-color: change_color($warning, $lightness: 100%)
      opacity: 0.1

  .cc_container
    .image
      width: 100%
      +tablet
        max-width: 12rem

.STAGE-development
  .GalleryWood
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)
    .image
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .img
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .image_number
      border: 1px dashed change_color($warning, $alpha: 0.5)
</style>
