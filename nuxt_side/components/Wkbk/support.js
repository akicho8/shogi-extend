import { FolderInfo } from './models/folder_info.js'
import { WkbkConfig } from './models/wkbk_config.js'

export const support = {
  computed: {
    FolderInfo() { return FolderInfo },
    WkbkConfig() { return WkbkConfig },
    s_config() {
      return {
        TRUNCATE_MAX: 20,
      }
    },
  },
}
