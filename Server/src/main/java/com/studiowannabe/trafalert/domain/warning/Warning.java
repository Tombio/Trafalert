package com.studiowannabe.trafalert.domain.warning;

/**
 * Created by Tomi on 31/01/16.
 */

import lombok.Data;

import java.time.LocalDateTime;
import java.util.concurrent.atomic.AtomicLong;

public @Data abstract class Warning {

    public enum WarningType {
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

    private static final AtomicLong VERSION_SEQUENCE = new AtomicLong(0L);

    public final WarningType warningType;
    public final LocalDateTime beginTime;
    public final long version;

    public Warning(final WarningType type) {
        this.warningType = type;
        this.beginTime = LocalDateTime.now();
        this.version = VERSION_SEQUENCE.incrementAndGet();
    }
}
