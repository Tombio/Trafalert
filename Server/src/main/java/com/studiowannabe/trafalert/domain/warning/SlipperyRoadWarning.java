package com.studiowannabe.trafalert.domain.warning;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 10/02/16.
 */
public @Data class SlipperyRoadWarning extends Warning {

    final BigDecimal warningDetail;

    public SlipperyRoadWarning(final BigDecimal detail) {
        super(WarningType.SLIPPERY_ROAD);
        this.warningDetail = detail;
    }
}
