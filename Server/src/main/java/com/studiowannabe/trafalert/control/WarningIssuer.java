package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.warning.*;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

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

    public List<Warning> calculateWarnings(final RoadWeatherType data) {
        if(data == null) {
            return Collections.emptyList();
        }
        final List<Warning> warnings = new ArrayList<>();

        final Warning ww = createWindWarning(data);
        if(ww != null) {
            warnings.add(ww);
        }

        final Warning gw = createGustWarning(data);
        if(gw != null) {
            warnings.add(gw);
        }

        final Warning biw = createBlackIceWarning(data);
        if(biw != null) {
            warnings.add(biw);
        }

        final Warning vw = createVisibilityWarning(data);
        if(vw != null){
            warnings.add(vw);
        }

        final Warning srw = createSlipperyRoadWarning(data);
        if(srw != null){
            warnings.add(srw);
        }

        final Warning hrw = createHeavyRainWarning(data);
        if(hrw != null){
            warnings.add(hrw);
        }

        return warnings;
    }

    private Warning createHeavyRainWarning(RoadWeatherType data) {
        if(data.getPrecipitation() != null && PRECIPITATION_WARNING_VALUES.contains(data.getPrecipitation().intValue())){
            final Warning hrw = existingWarning(Warning.WarningType.HEAVY_RAIN, data.getStationid().longValue());
            if(hrw != null) {
                return hrw;
            }
            else {
                return new HeavyRainWarning(data.getPrecipitation());
            }
        }

        return null;
    }

    private Warning createSlipperyRoadWarning(RoadWeatherType data) {
        if(data.getWarning3() != null && data.getWarning3().intValue() > 0){
            final Warning srw = existingWarning(Warning.WarningType.SLIPPERY_ROAD, data.getStationid().longValue());
            if(srw != null) {
                return srw;
            }
            else {
                return new SlipperyRoadWarning(data.getWarning3());
            }
        }

        return null;
    }

    private Warning createWindWarning(final RoadWeatherType data) {
        if(data.getAveragewindspeed() != null && data.getAveragewindspeed().intValue() >= WIND_WARNING_SPEED) {
           final Warning cw = existingWarning(Warning.WarningType.STRONG_WIND, data.getStationid().longValue());
            if(cw != null) {
                return cw;
            }
            else {
                return new WindWarning(data.getAveragewindspeed());
            }
        }
        return null;
    }

    private Warning createGustWarning(final RoadWeatherType data) {
        if(data.getMaxwindspeed() != null && data.getMaxwindspeed().intValue() >= WIND_WARNING_SPEED) {
            final Warning cw = existingWarning(Warning.WarningType.STRONG_WIND_GUSTS, data.getStationid().longValue());
            if(cw != null) {
                return cw;
            }
            else {
                return new GustWarning(data.getMaxwindspeed());
            }
        }
        return null;
    }

    private Warning createVisibilityWarning(final RoadWeatherType data) {
        if(data.getVisibilitymeters() == null) {
            return null;
        }
        if(data.getVisibilitymeters().intValue() < VISIBILITY_WARNING_METERS) { // Check if current wind is above warning level
            final Warning cw = existingWarning(Warning.WarningType.POOR_VISIBILITY, data.getStationid().longValue());
            if(cw != null) {
                return cw;
            }
            else {
                return new VisibilityWarning(Warning.WarningType.POOR_VISIBILITY, data.getVisibilitymeters());
            }
        }
        return null;
    }

    private Warning createBlackIceWarning(final RoadWeatherType data) {
        // road surface dew point and road surface temperature both need to be negative for
        // Also air needs to be above freezing... maybe..
        // black ice to form... at least to my current understanding
        final BigDecimal roadDew = data.getRoaddewpointdifference();
        final BigDecimal roadTemp = getMean(data.getRoadsurfacetemperature1(), data.getRoadsurfacetemperature2(), data.getRoadsurfacetemperature3());
        final BigDecimal airTemp = getMean(data.getAirtemperature1(), data.getAirtemperature3());
        if(roadDew == null || roadTemp == null || airTemp == null) {
            return null;
        }

        if(roadDew.doubleValue() > 0 || roadTemp.doubleValue() > 0){
            return null;
        }

        if(airTemp.doubleValue() < 0){ // Black Ice forms more rapidly when road is below and air is above freezing
            return null;
        }

        final Warning cw = existingWarning(Warning.WarningType.BLACK_ICE, data.getStationid().longValue());
        if(cw != null) {
            return cw;
        }
        else {
            return new BlackIceWarning(roadDew, roadTemp);
        }
    }

    private Warning existingWarning(final Warning.WarningType type, final long station) {
        final List<Warning> currentData = warningCache.getCacheData().get(station);
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

    protected static BigDecimal getMean(final BigDecimal... vals) {
        int count = 0;
        BigDecimal sum = new BigDecimal(0);

        for(final BigDecimal d : vals){
            if(d == null) {
                continue;
            }
            sum = sum.add(d);
            count++;
        }

        if(count == 0){
            return null;
        }

        return sum.divide(new BigDecimal(count), BigDecimal.ROUND_HALF_UP);
    }
}
