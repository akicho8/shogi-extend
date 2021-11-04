import { GalleryConfig } from './models/gallery_config.js'

export const all_support = {
  computed: {
    GalleryConfig() { return GalleryConfig },
    s_config() {
      return {
        TRUNCATE_MAX: 20,
      }
    },
  },
}
