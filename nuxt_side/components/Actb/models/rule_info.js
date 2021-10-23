import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { TimeSupport } from "./time_support.js"

import dayjs from "dayjs"

// https://github.com/iamkun/dayjs/blob/master/docs/ja/Plugin.md#isbetween
import isBetween from 'dayjs/plugin/isBetween'
dayjs.extend(isBetween)

export class RuleInfo extends ApplicationMemoryRecord {
  // delegate
  static time_range_active_p(range) { return TimeSupport.time_range_active_p(range)                }
  static time_ranges_active_p(list) { return TimeSupport.time_ranges_active_p(list)                }
  get time_range_active_p()         { return TimeSupport.time_range_active_p(this.raw_time_ranges) }
}
