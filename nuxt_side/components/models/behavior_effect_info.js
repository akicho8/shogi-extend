import MemoryRecord from 'js-memory-record'

export class BehaviorEffectInfo extends MemoryRecord {
  static get define() {
    return [
      {
        key: "kill_attack",
        name: "殺した",
        sound_key: [
          "SWORD_Hit_Armor_Hard_RR1_mono",
          "SWORD_Hit_Armor_Hard_RR3_mono",
          "SWORD_Whoosh_Hit_Armor_Hard_RR1_mono",
          "SWORD_Whoosh_Hit_Armor_Hard_RR2_mono",
        ],
      },
      {
        key: "move_or_appear",
        name: "移動または打った",
        sound_key: [
          "VOICE_Martial_Art_Shout_06_mono",
          "VOICE_Martial_Art_Shout_07_mono",
          "VOICE_Martial_Art_Shout_08_mono",
          "VOICE_Martial_Art_Shout_12_mono",
        ],
      },
      {
        key: "killed_and_death",
        name: "殺された",
        sound_key: [
          "SCREAM_Male_B_06_mono",
          "SCREAM_Male_B_07_mono",
          "GROAN_Male_Hurt_Long_mono",
          "GROAN_Male_Hurt_Long_Pain_mono",
          "GRUNT_Male_B_Hurt_Medium_01_mono",
        ],
      },
    ]
  }
}
