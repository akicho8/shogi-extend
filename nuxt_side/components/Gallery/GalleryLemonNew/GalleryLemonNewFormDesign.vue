<template lang="pug">
.GalleryLemonNewFormDesign
  GalleryLemonNewFormDesignColorTheme(:base="base")
  GalleryLemonNewFormDesignAudioTheme(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryLemonNewFormDesign",
  mixins: [support_child],
}
</script>

<style lang="sass">
.GalleryLemonNewFormDesign
</style>
