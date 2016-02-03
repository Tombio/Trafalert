package com.studiowannabe.trafalert.domain;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 04/02/16.
 */
public @Data class BlackIceWarning extends Warning {

    private final BigDecimal roadDewPointDifference;
    private final BigDecimal roadSurfaceTemperature;

    public BlackIceWarning(BigDecimal roaddewpointdifference, BigDecimal roadsurfacetemperature) {
        super(WarningType.BLACK_ICE);
        this.roadDewPointDifference = roaddewpointdifference;
        this.roadSurfaceTemperature = roadsurfacetemperature;
    }
}
