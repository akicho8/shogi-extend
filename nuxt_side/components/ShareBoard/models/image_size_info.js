import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ImageSizeInfo extends ApplicationMemoryRecord {
  static field_label = "サイズ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_image_size_854x480",   name: "854x480",   width: 854,  height: 480,  aspect_ratio: "16:9", environment: ["development"],                          },
      { key: "is_image_size_1280x720",  name: "1280x720",  width: 1280, height: 720,  aspect_ratio: "16:9", environment: ["development", "staging", "production"], },
      { key: "is_image_size_1920x1080", name: "1920x1080", width: 1920, height: 1080, aspect_ratio: "16:9", environment: ["development", "staging", "production"], },
      { separator: true                                                                                                                                            },
      { key: "is_image_size_320x240",   name: "320x240",   width: 320,  height: 240,  aspect_ratio: "4:3",  environment: ["development"],                          },
      { key: "is_image_size_640x480",   name: "640x480",   width: 640,  height: 480,  aspect_ratio: "4:3",  environment: ["development"],                          },
      { key: "is_image_size_720x540",   name: "720x540",   width: 720,  height: 540,  aspect_ratio: "4:3",  environment: ["development"],                          },
      { key: "is_image_size_800x600",   name: "800x600",   width: 800,  height: 600,  aspect_ratio: "4:3",  environment: ["development"],                          },
      { key: "is_image_size_960x720",   name: "960x720",   width: 960,  height: 720,  aspect_ratio: "4:3",  environment: ["development"],                          },
      { key: "is_image_size_1024x768",  name: "1024x768",  width: 1024, height: 768,  aspect_ratio: "4:3",  environment: ["development", "staging", "production"], },
      { key: "is_image_size_1280x960",  name: "1280x960",  width: 1280, height: 960,  aspect_ratio: "4:3",  environment: ["development", "staging", "production"], },
      { key: "is_image_size_1600x1200", name: "1600x1200", width: 1600, height: 1200, aspect_ratio: "4:3",  environment: ["development", "staging", "production"], },
      { separator: true                                                                                                                                            },
      { key: "is_image_size_1200x630",  name: "1200x630",  width: 1200, height: 630,  aspect_ratio: "OGP",  environment: ["development", "staging", "production"], },
    ]
  }

  get option_name() {
    return `${this.name} (${this.aspect_ratio})`
  }

  get to_params() {
    return {
      width: this.width,
      height: this.height,
    }
  }
}
