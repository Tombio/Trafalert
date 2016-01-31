package com.studiowannabe.trafalert.domain;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public enum PrecipitationType {

    UNKNOWN(-1),
    NO_PRECIPITATION(7),
    WEAK_PRECIPITATION_UNDEFINED(8),
    WEAK_WATER(9),
    WATER(10),
    SNOW(11),
    WET_SLEET(12),
    SLEET(13),
    HAIL(14),
    ICE_CRYSTAL(15),
    SNOW_PARTICLES(16),
    SNOW_HAIL(17),
    FREEZING_WEAK_WATER(18),
    FREEZING_WATER(19);

    final int value;

    PrecipitationType(final int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static PrecipitationType parse(final BigDecimal bd) {
        if(bd != null) {
            for (PrecipitationType p : values()) {
                if (p.getValue() == bd.intValue()) {
                    return p;
                }
            }
        }
        return UNKNOWN;
    }
}
