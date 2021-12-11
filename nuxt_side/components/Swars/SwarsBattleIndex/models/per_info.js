import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class PerInfo extends ApplicationMemoryRecord {
  static field_label = "件数"

  static get define() {
    return [
      { key: "is_per1",   name: "1",   per:   1, available_env: { development: true, staging: false, production: false, }, },
      { key: "is_per10",  name: "10",  per:  10, available_env: { development: true, staging: true,  production: true,  }, },
      { key: "is_per25",  name: "25",  per:  25, available_env: { development: true, staging: true,  production: true,  }, },
      { key: "is_per50",  name: "50",  per:  50, available_env: { development: true, staging: true,  production: true,  }, },
      { key: "is_per100", name: "100", per: 100, available_env: { development: true, staging: true,  production: true,  }, },
      { key: "is_per200", name: "200", per: 200, available_env: { development: true, staging: true,  production: true,  }, },
    ]
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
