import { Xassertion } from "./core/xassertion.js"
import { Xinteger   } from "./core/xinteger.js"
import { Xarray     } from "./core/xarray.js"
import { Xstring    } from "./core/xstring.js"
import { Xhash      } from "./core/xhash.js"
import { Xenumerate } from "./core/xenumerate.js"
import { Xobject    } from "./core/xobject.js"
import { Xdelay     } from "./core/xdelay.js"
import { Xmath      } from "./core/xmath.js"
import { Xrand      } from "./core/xrand.js"
import { Xtag       } from "./core/xtag.js"
import { Xhtml      } from "./core/xhtml.js"
import { Xaratio    } from "./core/xaratio.js"
import { Xtime      } from "./core/xtime.js"

export const Gs2 = {
  ...Xassertion,
  ...Xinteger,
  ...Xarray,
  ...Xstring,
  ...Xhash,
  ...Xenumerate,
  ...Xobject,
  ...Xdelay,
  ...Xmath,
  ...Xrand,
  ...Xtag,
  ...Xhtml,
  ...Xaratio,
  ...Xtime,
}
