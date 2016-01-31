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
    private final WeatherClient weatherClient;
    private final WarningIssuer warningIssuer;

    @Autowired
    public DataFetcher(final WeatherDataCache cache, final WeatherClient weatherClient, final WarningIssuer warningIssuer) {
        this.cache = cache;
        this.weatherClient = weatherClient;
        this.warningIssuer = warningIssuer;
    }

    @Scheduled(fixedDelay = 60 * 1000) // 30 seconds
    private void runDataUpdate(){
        log.info("Run update...");
        final RoadWeatherResponse response = weatherClient.getRoadWeather();
        if(response != null) {
            updateCache(response);
        }
    }

    private void updateCache(final RoadWeatherResponse response) {
        final HashMap<Long, WeatherStationData> map = new HashMap<>(response.getRoadweatherdata().getRoadweather().size());
        for (RoadWeatherType data : response.getRoadweatherdata().getRoadweather()) {
            final WeatherStationData wsd = new WeatherStationData(data.getAirtemperature1(), data.getRoadsurfacetemperature1(),
                    data.getAveragewindspeed(), data.getMaxwindspeed(), data.getVisibilitymeters(), data.getDewpoint(),
                    data.getRoaddewpointdifference(), data.getHumidity(), data.getWinddirection(), data.getPrecipitation(), data.getRoadsurfaceconditions1(),
                    data.getPrecipitationtype());
            map.put(data.getStationid().longValue(), wsd);

            final List<Warning> warnings = warningIssuer.calculateWarnings(data);
            log.info("Warnings: " + warnings);
        }
        cache.setCacheData(map);
    }
}
