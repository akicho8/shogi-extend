import { support as root_support } from "../support.js"
import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export const support = {
  mixins: [
    root_support,
  ],
  methods: {
    ...mapMutations("builder", [
      "turn_offset_set",
      "mediator_snapshot_sfen_set",
    ]),
    ...mapActions("builder", [
      "resource_fetch",
      "records_fetch",
      "builder_index_handle",
      "tag_search_handle",
      "edit_mode_snapshot_sfen_set",
      "moves_answers_clear",
      "edit_stock_handle",
      "builder_new_handle",
      "question_edit_for",
      "question_edit",
      "mode_select",
      "edit_tab_change_handle",
      "haiti_mode_handle",
      "seikai_mode_handle",
      "form_mode_handle",
      "kensho_mode_handle",
      "question_save_handle",
      "back_to_index_handle",
      "page_change_handle",
      "sort_handle",
      "folder_change_handle",
    ]),
  },
  computed: {
    ...mapState("builder", [
      "question",
      "gvar2",
      "LineageInfo",
      "FolderInfo",
      "builder_form_resource_fetched_p",
      "questions",
      "question_counts",
      "page_info",
      "tab_index",
      "answer_tab_index",
      "answer_turn_offset",
      "mediator_snapshot_sfen",
      "exam_run_count",
      "valid_count",
    ]),
    ...mapGetters("builder", [
      "current_gvar2",
      "current_question",
    ]),
  },
}
