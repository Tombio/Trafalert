package com.studiowannabe.trafalert.domain.warning;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 10/02/16.
 */
public @Data class HeavyRainWarning extends Warning {

    final BigDecimal warningDetail;

    public HeavyRainWarning(final BigDecimal precipitation) {
        super(WarningType.HEAVY_RAIN);
        this.warningDetail = precipitation;
    }
}
