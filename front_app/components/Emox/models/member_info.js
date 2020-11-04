import Vue from "vue"

export class MemberInfo {
  constructor(membership_id) {
    this.membership_id = membership_id
    this.member_active_p = true        // true:部屋にいる false:切断した
  }
}
