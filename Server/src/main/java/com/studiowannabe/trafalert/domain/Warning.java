package com.studiowannabe.trafalert.domain;

/**
 * Created by Tomi on 31/01/16.
 */

import lombok.Data;

import java.time.LocalDateTime;

public @Data class Warning {

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

    private final WarningType warningType;
    private final LocalDateTime beginTime;
}
