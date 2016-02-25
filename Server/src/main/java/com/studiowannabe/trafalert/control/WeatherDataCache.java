package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.WeatherStationData;
import com.studiowannabe.trafalert.util.Pair;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Created by Tomi on 31/01/16.
 */

@Component
public class WeatherDataCache {

    private static AtomicReference<HashMap<Long, Pair<WeatherStationData, RoadWeatherType>>> cacheData;
    private static boolean inited = false;

    public WeatherDataCache() {
        if(!inited) {
            cacheData = new AtomicReference<>(new HashMap<>());
            inited = true;
        }
    }
    public HashMap<Long, Pair<WeatherStationData, RoadWeatherType>> getCacheData() { return cacheData.get(); }
    public void setCacheData(HashMap<Long, Pair<WeatherStationData, RoadWeatherType>> data) {
        cacheData.set(data);
    }
}
