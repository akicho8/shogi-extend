import { FolderInfo } from './models/folder_info.js'
import { GalleryConfig } from './models/gallery_config.js'

export const all_support = {
  computed: {
    FolderInfo() { return FolderInfo },
    GalleryConfig() { return GalleryConfig },
    s_config() {
      return {
        TRUNCATE_MAX: 20,
      }
    },
  },
}
