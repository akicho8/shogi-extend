import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class XstatusInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "感想戦中",
        if_cond: c => c.cable_p && !c.order_enable_p && !c.cc_play_p && c.honpu_master && c.uniq_member_infos.length >= 2,
      },
      {
        name: "対戦相手待ち",
        if_cond: c => c.cable_p && !c.order_enable_p && c.uniq_member_infos.length < 2,
      },
      {
        name: "対局設定待ち",
        if_cond: c => c.cable_p && !c.order_enable_p && c.uniq_member_infos.length >= 2,
      },
      {
        name: "時計設置待ち",
        if_cond: c => c.cable_p && c.order_enable_p && !c.clock_box,
      },
      {
        name: "対局開始待ち",
        if_cond: c => c.cable_p && c.order_enable_p && c.clock_box && c.clock_box.current_status === "stop",
      },
      {
        name: "対局開始",
        if_cond: c => c.cable_p && c.order_enable_p && c.clock_box && c.clock_box.current_status === "play" && c.current_turn === 0,
      },
      {
        name: "時計再開待ち",
        if_cond: c => c.cable_p && c.order_enable_p && c.clock_box && c.clock_box.current_status === "pause",
      },
    ]
  }
}
