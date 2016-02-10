package com.studiowannabe.trafalert.domain.warning;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 *
 */
public @Data class GustWarning extends Warning {

    private final BigDecimal windSpeed;

    public GustWarning(final BigDecimal windSpeed) {
        super(WarningType.STRONG_WIND_GUSTS);
        this.windSpeed = windSpeed;
    }
}
