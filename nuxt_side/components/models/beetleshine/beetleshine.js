import { Xassertion } from "./xassertion.js"
import { Xinteger   } from "./xinteger.js"
import { Xfloat     } from "./xfloat.js"
import { Xarray     } from "./xarray.js"
import { Xstring    } from "./xstring.js"
import { Xhash      } from "./xhash.js"
import { Xenumerate } from "./xenumerate.js"
import { Xobject    } from "./xobject.js"
import { Xformat    } from "./xformat.js"
import { Xdelay     } from "./xdelay.js"
import { Xthread    } from "./xthread.js"
import { Xmath      } from "./xmath.js"
import { Xrand      } from "./xrand.js"
import { Xtag       } from "./xtag.js"
import { Xhtml      } from "./xhtml.js"
import { Xtime      } from "./xtime.js"
import { Xaratio    } from "./xaratio.js"
import { Xbase64    } from "./xbase64.js"
import { Xquery     } from "./xquery.js"

export const Beetleshine = {
  ...Xassertion,
  ...Xinteger,
  ...Xfloat,
  ...Xarray,
  ...Xstring,
  ...Xhash,
  ...Xenumerate,
  ...Xobject,
  ...Xformat,
  ...Xdelay,
  ...Xmath,
  ...Xrand,
  ...Xtag,
  ...Xhtml,
  ...Xtime,
  ...Xaratio,
  ...Xbase64,
  ...Xquery,
}
