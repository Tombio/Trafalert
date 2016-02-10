package com.studiowannabe.trafalert.domain.warning;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 *
 * Wind warning is issued when wind speeds exceed 20 m/s on average.
 * For gusts same limits apply but only when average speed is less than warning limit.
 */
public @Data class WindWarning extends Warning {

    private final BigDecimal windSpeed;

    public WindWarning(final BigDecimal windSpeed) {
        super(WarningType.STRONG_WIND);
        this.windSpeed = windSpeed;
    }
}
