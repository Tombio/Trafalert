package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.*;
import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.util.Pair;
import com.studiowannabe.trafalert.wsdl.RoadWeather;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.studiowannabe.trafalert.control.WeatherUtil.countAverage;
import static com.studiowannabe.trafalert.control.WeatherUtil.getMean;
import static com.studiowannabe.trafalert.control.WeatherUtil.getFirst;

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
        final Map<Long, List<StationInfo>> groupping = StationGroupping.stationGroups;
        final Map<Long, Pair<WeatherStationData, RoadWeatherType>> cacheData = cache.getCacheData();

        final List<StationInfo> relevantStations = groupping.get(groupId);
        final List<RoadWeatherType> types = new ArrayList<>(relevantStations.size());
        for(final StationInfo si : relevantStations){
            types.add(cacheData.get(si.getId()).getRight());
        }

        if(!org.springframework.util.CollectionUtils.isEmpty(relevantStations)){
            final BigDecimal airTemp = getMean(
                    countAverage(types, RoadWeatherType::getAirtemperature1),
                    countAverage(types, RoadWeatherType::getAirtemperature3));
            final BigDecimal roadSurfaceTemp = getMean(
                    countAverage(types, RoadWeatherType::getRoadsurfacetemperature1),
                    countAverage(types, RoadWeatherType::getRoadsurfacetemperature2),
                    countAverage(types, RoadWeatherType::getRoadsurfacetemperature3));
            final BigDecimal averageWindSpeed = countAverage(types, RoadWeatherType::getAveragewindspeed);
            final BigDecimal maxWindSpeed = countAverage(types, RoadWeatherType::getMaxwindspeed);
            final BigDecimal visibility = countAverage(types, RoadWeatherType::getVisibilitymeters);
            final BigDecimal dewPoint = countAverage(types, RoadWeatherType::getDewpoint);
            final BigDecimal roadSurfaceDewPointDifference = countAverage(types, RoadWeatherType::getRoaddewpointdifference);
            final BigDecimal humidity = getMean(
                    countAverage(types, RoadWeatherType::getHumidity),
                    countAverage(types, RoadWeatherType::getHumidity3));
            final BigDecimal windDirection = countAverage(types, RoadWeatherType::getWinddirection);
            final Precipitation precipitation = Precipitation.parse(getFirst(types, RoadWeatherType::getPrecipitation));
            final PrecipitationType precipitationType = PrecipitationType.parse(getFirst(types, RoadWeatherType::getPrecipitationtype));
            final BigDecimal precipitationIntensity = countAverage(types, RoadWeatherType::getPrecipitationintensity);
            final BigDecimal precipitationSum = countAverage(types, RoadWeatherType::getPrecipitationsum);
            final RoadCondition roadCondition = RoadCondition.parse(getFirst(types, RoadWeatherType::getRoadsurfaceconditions1));
            final BigDecimal sunUp = getFirst(types, RoadWeatherType::getSunup);

            return new WeatherStationData(groupId, airTemp, roadSurfaceTemp, averageWindSpeed, maxWindSpeed, visibility, dewPoint,
                    roadSurfaceDewPointDifference, humidity, windDirection, precipitation, precipitationIntensity, precipitationSum,
                    precipitationType, roadCondition, sunUp);
        }
        throw new IllegalArgumentException("Unknown station group " + groupId);
    }
}
