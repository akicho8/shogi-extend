import { FolderInfo } from './models/folder_info.js'
import { KiwiConfig } from './models/kiwi_config.js'

export const all_support = {
  computed: {
    FolderInfo() { return FolderInfo },
    KiwiConfig() { return KiwiConfig },
    s_config() {
      return {
        TRUNCATE_MAX: 20,
      }
    },
  },
}
