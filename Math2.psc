scriptname Zebrina:Math2 hidden

import Math

float function atan2(float y, float x) global
    if (x > 0.0)
        return atan(y / x)
    elseif (x < 0.0)
        if (y >= 0)
            return atan(y / x) + 180.0
        else
            return atan(y / x) - 180.0
        endif
    elseif (y > 0.0)
        return 90.0
    elseif (y < 0.0)
        return -90.0
    endif

    ; Undefined!
    return 0.0
endfunction
