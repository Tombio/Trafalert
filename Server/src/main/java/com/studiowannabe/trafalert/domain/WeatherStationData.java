package com.studiowannabe.trafalert.domain;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public @Data class WeatherStationData {

    public enum Precipitation {
        UNKNOWN(-1),
        NO_PRECIPITATION(0),
        WEAK(1),
        MODERATE(2),
        STRONG(3),
        WEAK_SNOW(4),
        MODERATE_SNOW(5),
        STRONG_SNOW(6);

        final int amount;

        Precipitation(final int amount){
            this.amount = amount;
        }

        public int getAmount() {
            return amount;
        }

        public static Precipitation parse(final BigDecimal bd) {
            if(bd != null) {
                for (Precipitation p : values()) {
                    if (p.getAmount() == bd.intValue()) {
                        return p;
                    }
                }
            }
            return UNKNOWN;
        }
    }

    public enum PrecipitationType {
        UNKNOWN(-1),
        NO_PRECIPITATION(7),
        WEAK_PRECIPITATION_UNDEFINED(8),
        WEAK_WATER(9),
        WATER(10),
        SNOW(11),
        WET_SLEET(12),
        SLEET(13),
        HAIL(14),
        ICE_CRYSTAL(15),
        SNOW_PARTICLES(16),
        SNOW_HAIL(17),
        FREEZING_WEAK_WATER(18),
        FREEZING_WATER(19);

        final int value;

        PrecipitationType(final int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }

        public static PrecipitationType parse(final BigDecimal bd) {
            if(bd != null) {
                for (PrecipitationType p : values()) {
                    if (p.getValue() == bd.intValue()) {
                        return p;
                    }
                }
            }
            return UNKNOWN;
        }
    }

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
    final RoadCondition roadConditon;

}
