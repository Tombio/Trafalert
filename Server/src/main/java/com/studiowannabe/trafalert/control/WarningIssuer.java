package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.warning.*;
import com.studiowannabe.trafalert.wsdl.RoadWeather;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.function.Function;

/**
 * Created by Tomi on 31/01/16.
 */
@Component
public class WarningIssuer {

    private final WarningCache warningCache;

    private static final int WIND_WARNING_SPEED = 15;
    private static final int VISIBILITY_WARNING_METERS = 500;
    private static final List<Integer> PRECIPITATION_WARNING_VALUES = Arrays.asList(3,6);

    @Autowired
    public WarningIssuer(final WarningCache warningCache){
        this.warningCache = warningCache;
    }

    public List<Warning> calculateWarnings(final Long groupId, final List<RoadWeatherType> data) {
        if(CollectionUtils.isEmpty(data)) {
            return Collections.emptyList();
        }
        final List<Warning> warnings = new ArrayList<>();

        final Warning ww = createWindWarning(groupId, data);
        if(ww != null) {
            warnings.add(ww);
        }

        final Warning gw = createGustWarning(groupId, data);
        if(gw != null) {
            warnings.add(gw);
        }

        final Warning biw = createBlackIceWarning(groupId, data);
        if(biw != null) {
            warnings.add(biw);
        }

        final Warning vw = createVisibilityWarning(groupId, data);
        if(vw != null){
            warnings.add(vw);
        }

        final Warning srw = createSlipperyRoadWarning(groupId, data);
        if(srw != null){
            warnings.add(srw);
        }

        final Warning hrw = createHeavyRainWarning(groupId, data);
        if(hrw != null){
            warnings.add(hrw);
        }
        return warnings;
    }

    private Warning createHeavyRainWarning(final Long groupId, List<RoadWeatherType> data) {
        for(final RoadWeatherType type : data) {
            if (type.getPrecipitation() != null && PRECIPITATION_WARNING_VALUES.contains(type.getPrecipitation().intValue())) {
                final Warning hrw = existingWarning(Warning.WarningType.HEAVY_RAIN, groupId);
                if (hrw != null) {
                    return hrw;
                } else {
                    return new HeavyRainWarning(type.getPrecipitation());
                }
            }
        }
        return null;
    }

    private Warning createSlipperyRoadWarning(final Long groupId, List<RoadWeatherType> data) {
        for(final RoadWeatherType type : data) {
            if (type.getWarning3() != null && type.getWarning3().intValue() > 0) {
                final Warning srw = existingWarning(Warning.WarningType.SLIPPERY_ROAD, groupId);
                if (srw != null) {
                    return srw;
                } else {
                    return new SlipperyRoadWarning(type.getWarning3());
                }
            }
        }
        return null;
    }

    private Warning createWindWarning(final Long groupId, final List<RoadWeatherType> data) {
        final BigDecimal avgWind = WeatherUtil.countAverage(data, RoadWeatherType::getAveragewindspeed);
        if(avgWind != null && avgWind.intValue() >= WIND_WARNING_SPEED) {
           final Warning cw = existingWarning(Warning.WarningType.STRONG_WIND, groupId);
            if(cw != null) {
                return cw;
            }
            else {
                return new WindWarning(avgWind);
            }
        }
        return null;
    }

    private Warning createGustWarning(final Long groupId, final List<RoadWeatherType> data) {
        final BigDecimal maxWind = WeatherUtil.countAverage(data, RoadWeatherType::getMaxwindspeed);
        if(maxWind != null && maxWind.intValue() >= WIND_WARNING_SPEED) {
            final Warning cw = existingWarning(Warning.WarningType.STRONG_WIND_GUSTS, groupId);
            if(cw != null) {
                return cw;
            }
            else {
                return new GustWarning(maxWind);
            }
        }
        return null;
    }

    private Warning createVisibilityWarning(Long groupId, final List<RoadWeatherType> data) {
        final BigDecimal vis = WeatherUtil.countAverage(data, RoadWeatherType::getVisibilitymeters);
        if(vis != null && vis.intValue() < VISIBILITY_WARNING_METERS) {
            final Warning cw = existingWarning(Warning.WarningType.POOR_VISIBILITY, groupId);
            if(cw != null) {
                return cw;
            }
            else {
                return new VisibilityWarning(Warning.WarningType.POOR_VISIBILITY, vis);
            }
        }
        return null;
    }

    private Warning createBlackIceWarning(Long groupId, final List<RoadWeatherType> data) {
        // road surface dew point and road surface temperature both need to be negative for
        // Also air needs to be above freezing... maybe..
        // black ice to form... at least to my current understanding
        final BigDecimal roadDew = WeatherUtil.countAverage(data, RoadWeatherType::getRoaddewpointdifference);
        final BigDecimal roadTemp = WeatherUtil.getMean(
                WeatherUtil.countAverage(data, RoadWeatherType::getRoadsurfacetemperature1),
                WeatherUtil.countAverage(data, RoadWeatherType::getRoadsurfacetemperature2),
                WeatherUtil.countAverage(data, RoadWeatherType::getRoadsurfacetemperature3));

        final BigDecimal airTemp = WeatherUtil.getMean(
                WeatherUtil.countAverage(data, RoadWeatherType::getAirtemperature1),
                WeatherUtil.countAverage(data, RoadWeatherType::getAirtemperature3));
        if(roadDew == null || roadTemp == null || airTemp == null) {
            return null;
        }

        if(roadDew.doubleValue() > 0 || roadTemp.doubleValue() > 0){
            return null;
        }

        if(airTemp.doubleValue() < 0){ // Black Ice forms more rapidly when road is below and air is above freezing
            return null;
        }

        final Warning cw = existingWarning(Warning.WarningType.BLACK_ICE, groupId);
        if(cw != null) {
            return cw;
        }
        else {
            return new BlackIceWarning(roadDew, roadTemp);
        }
    }

    private Warning existingWarning(final Warning.WarningType type, final long groupId) {
        final List<Warning> currentData = warningCache.getCacheData().get(groupId);
        if(currentData == null) {
            return null;
        }
        for(final Warning w : currentData) {
            if(w.warningType == type) {
                return w;
            }
        }
        return null;
    }
}
