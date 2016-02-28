package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.StationInfo;
import com.studiowannabe.trafalert.domain.WeatherStationData;
import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.util.Pair;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by Tomi on 28/02/16.
 */
@Component
public class WeatherCalculator {

    private final WeatherDataCache cache;

    @Autowired
    public WeatherCalculator(final WeatherDataCache cache){
        this.cache = cache;
    }

    public WeatherStationData calculateData(final Long groupId){
        final HashMap<Long, List<Warning>> warningMap = new HashMap<>();
        final Map<Long, List<StationInfo>> groupping = StationGroupping.stationGroups;
        final Map<Long, Pair<WeatherStationData, RoadWeatherType>> cacheData = cache.getCacheData();

        final List<StationInfo> relevantStations = groupping.get(groupId);
        final List<RoadWeatherType> types =
                relevantStations.stream().map(stationInfo -> cacheData.get(stationInfo.getId())).
                        collect(Collectors.toList());

        if(!org.springframework.util.CollectionUtils.isEmpty(relevantStations)){
            final BigDecimal airTemp = WeatherUtil.getMean(
                    WeatherUtil.countAverage(types, RoadWeatherType::getAirtemperature1),

            return new WeatherStationData(groupId, )
        }
        throw new IllegalArgumentException("Unknown station group " + groupId);
    }
}
