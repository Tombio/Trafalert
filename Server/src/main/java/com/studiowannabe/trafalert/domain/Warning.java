package com.studiowannabe.trafalert.domain;

/**
 * Created by Tomi on 31/01/16.
 */

import java.time.LocalDateTime;

public interface Warning {

    enum WarningType {
        BLACK_ICE("Black ice"),
        STRONG_WIND("Strong wind"),
        STRONG_WIND_GUSTS("Strong wind in gusts"),
        POOR_VISIBILITY("Poor visibility"),
        SLIPPERY_ROAD("Slippery road"),
        HEAVY_RAIN("Heavy rain");

        final String descr;

        WarningType(final String s) {
            descr = s;
        }
    }

    WarningType getWarningType();
    LocalDateTime getBeginTime();
}
