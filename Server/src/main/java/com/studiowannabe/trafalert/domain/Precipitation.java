package com.studiowannabe.trafalert.domain;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public enum Precipitation {

    UNKNOWN(-1),
    NO_PRECIPITATION(0),
    WEAK(1),
    MODERATE(2),
    STRONG(3),
    WEAK_SNOW(4),
    MODERATE_SNOW(5),
    STRONG_SNOW(6);

    final int amount;

    Precipitation(final int amount){
        this.amount = amount;
    }

    public int getAmount() {
        return amount;
    }

    public static Precipitation parse(final BigDecimal bd) {
        if(bd != null) {
            for (Precipitation p : values()) {
                if (p.getAmount() == bd.intValue()) {
                    return p;
                }
            }
        }
        return UNKNOWN;
    }
}
