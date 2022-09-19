import { Xassertion } from "./core/xassertion.js"
import { Xinteger   } from "./core/xinteger.js"
import { Xarray     } from "./core/xarray.js"
import { Xstring    } from "./core/xstring.js"
import { Xenumerate } from "./core/xenumerate.js"
import { Xobject    } from "./core/xobject.js"

export const Gs2 = {
  ...Xassertion,
  ...Xinteger,
  ...Xarray,
  ...Xstring,
  ...Xenumerate,
  ...Xobject,
}
