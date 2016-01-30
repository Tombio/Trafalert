package com.studiowannabe.trafalert.control;

import lombok.AllArgsConstructor;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Created by Tomi on 31/01/16.
 */
@Component
public class DataFetcher {

    private static Logger log = Logger.getLogger(DataFetcher.class);

    private static final String WEATHER_URL = "http://tie.digitraffic.fi/sujuvuus/ws/roadWeather";

    private final WeatherDataCache cache;
    private final WeatherClient weatherClient;

    @Autowired
    public DataFetcher(WeatherDataCache cache, WeatherClient weatherClient) {
        this.cache = cache;
        this.weatherClient = weatherClient;
    }

    @Scheduled(fixedDelay = 30 * 1000) // 30 seconds
    private void runDataUpdate(){
        log.info("Run update...");
        weatherClient.getRoadWeather();
    }
}
