package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.WeatherStationData;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Created by Tomi on 31/01/16.
 */

@Component
public class WeatherDataCache {

    private static AtomicReference<HashMap<Long, WeatherStationData>> cacheData;
    private static boolean inited = false;

    public WeatherDataCache() {
        if(!inited) {
            cacheData = new AtomicReference<>(new HashMap<>());
            inited = true;
        }
    }
    public HashMap<Long, WeatherStationData> getCacheData() { return cacheData.get(); }
    public void setCacheData(HashMap<Long, WeatherStationData> data) {
        cacheData.set(data);
    }
}
