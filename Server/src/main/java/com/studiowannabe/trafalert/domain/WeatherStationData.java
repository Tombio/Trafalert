package com.studiowannabe.trafalert.domain;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public @Data class WeatherStationData {

    final Long stationId;
    final BigDecimal airTemperature;
    final BigDecimal roadSurfaceTemperature;
    final BigDecimal averageWindSpeed;
    final BigDecimal maxWindSpeed;
    final BigDecimal visibility;
    final BigDecimal dewPoint;
    final BigDecimal roadSurfaceDewPointDifference;
    final BigDecimal humidity;
    final BigDecimal windDirection;
    final Precipitation precipitation;
    final BigDecimal precipitationIntensity;
    final BigDecimal precipitationSum;
    final PrecipitationType precipitationType;
    final RoadCondition roadCondition;

}
