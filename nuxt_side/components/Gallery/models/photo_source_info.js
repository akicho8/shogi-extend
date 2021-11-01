import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class PhotoSourceInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // { author: "Morgennebel", photo_url: "https:www.flickr.com/photos/morgennebel/4500506623/" },
      // { author: "maz ngibad",  photo_url: "https:www.flickr.com/photos/129544884@N04/16616909541" },
    ]
  }
}
