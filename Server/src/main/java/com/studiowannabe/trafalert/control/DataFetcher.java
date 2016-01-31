package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.Warning;
import com.studiowannabe.trafalert.domain.WeatherStationData;
import com.studiowannabe.trafalert.wsdl.RoadWeatherResponse;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;

/**
 * Created by Tomi on 31/01/16.
 */
@Component
public class DataFetcher {

    private static Logger log = Logger.getLogger(DataFetcher.class);

    private static final String WEATHER_URL = "http://tie.digitraffic.fi/sujuvuus/ws/roadWeather";

    private final WeatherDataCache cache;
    private final WarningCache warningCache;
    private final WeatherClient weatherClient;
    private final WarningIssuer warningIssuer;

    @Autowired
    public DataFetcher(final WeatherDataCache cache, final WeatherClient weatherClient,
                       final WarningIssuer warningIssuer, final WarningCache warningCache) {
        this.cache = cache;
        this.weatherClient = weatherClient;
        this.warningIssuer = warningIssuer;
        this.warningCache = warningCache;
    }

    @Scheduled(fixedDelay = 60 * 1000) // 30 seconds
    private void runDataUpdate(){
        log.info("Run update...");
        final RoadWeatherResponse response = weatherClient.getRoadWeather();
        if(response != null) {
            updateCaches(response);
        }

        log.info("Cached weather stations " + cache.getCacheData().size());
        log.info("Cached warning stations " + warningCache.getCacheData().size());
    }

    private void updateCaches(final RoadWeatherResponse response) {
        final HashMap<Long, WeatherStationData> map = new HashMap<>(response.getRoadweatherdata().getRoadweather().size());
        final HashMap<Long, List<Warning>> warningMap = new HashMap<>();
        for (RoadWeatherType data : response.getRoadweatherdata().getRoadweather()) {
            final WeatherStationData.Precipitation precipitation = WeatherStationData.Precipitation.parse(data.getPrecipitation());
            final WeatherStationData.PrecipitationType precipitationType = WeatherStationData.PrecipitationType.parse(data.getPrecipitationtype());
            final WeatherStationData.RoadCondition roadCondition = WeatherStationData.RoadCondition.parse(data.getRoadsurfaceconditions1());

            final WeatherStationData wsd = new WeatherStationData(data.getAirtemperature1(), data.getRoadsurfacetemperature1(),
                    data.getAveragewindspeed(), data.getMaxwindspeed(), data.getVisibilitymeters(), data.getDewpoint(),
                    data.getRoaddewpointdifference(), data.getHumidity(), data.getWinddirection(), precipitation, data.getPrecipitationintensity(),
                    data.getPrecipitationsum(), precipitationType, roadCondition);
            map.put(data.getStationid().longValue(), wsd);

            warningMap.put(data.getStationid().longValue(), warningIssuer.calculateWarnings(data));
        }
        cache.setCacheData(map);
        warningCache.setCacheData(warningMap);
    }
}
