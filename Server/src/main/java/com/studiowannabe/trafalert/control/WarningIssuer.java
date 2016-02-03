package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.BlackIceWarning;
import com.studiowannabe.trafalert.domain.Warning;
import com.studiowannabe.trafalert.domain.WindWarning;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Tomi on 31/01/16.
 */
@Component
public class WarningIssuer {

    private final WarningCache warningCache;

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

        final Warning biw = createBlackIceWarning(data);
        if(biw != null) {
            warnings.add(biw);
        }


        return warnings;
    }

    private Warning createWindWarning(final RoadWeatherType data) {
        if(data.getAveragewindspeed() == null) {
            return null;
        }
        if(data.getAveragewindspeed().intValue() >= 5) { // Check if current wind is above warning level
            final Warning cw = existingWarning(Warning.WarningType.STRONG_WIND, data.getStationid().longValue());
            if(cw != null) { // if there already is a issued warning return same instance
                return cw;
            }
            else { // or create new one
                return new WindWarning(data.getAveragewindspeed());
            }
        }
        return null; // No need for wind warning...
    }

    private Warning createBlackIceWarning(final RoadWeatherType data) {
        // road surface dew point and road surface temperature both need to be negative for
        // black ice to form... at least to my current understanding
        if(data.getRoaddewpointdifference() == null || data.getRoadsurfacetemperature1() == null) {
            return null;
        }

        if(data.getRoaddewpointdifference().doubleValue() > 0 || data.getRoadsurfacetemperature1().doubleValue() > 0){
            return null;
        }


        final Warning cw = existingWarning(Warning.WarningType.BLACK_ICE, data.getStationid().longValue());
        if(cw != null) {
            return cw;
        }
        else {
            return new BlackIceWarning(data.getRoaddewpointdifference(), data.getRoadsurfacetemperature1());
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
}
