package com.studiowannabe.trafalert.domain;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public enum RoadCondition {

    SENSOR_ERROR(0, false),
    DRY(1, false),
    DAMP(2, false),
    WET(3, true),
    WET_WITH_SALT(4, false),
    FROST(5, true),
    SNOW(6, false),
    ICE(7, true),
    LIKELY_WET_WITH_SALT(8, false);

    final int value;
    final boolean issueWarning;

    RoadCondition(final int value, final boolean issueWarning) {
        this.value = value;
        this.issueWarning = issueWarning;
    }

    public int getValue() {
        return value;
    }

    public static RoadCondition parse(final BigDecimal bd) {
        if(bd != null) {
            for (RoadCondition rc : values()) {
                if (rc.getValue() == bd.intValue()) {
                    return rc;
                }
            }
        }
        return SENSOR_ERROR;
    }
}
