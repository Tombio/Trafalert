package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.WeatherStation;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Created by Tomi on 31/01/16.
 */

@Component
public class WeatherDataCache {

    private static AtomicReference<List<WeatherStation>> cacheData;

    public WeatherDataCache() {}

    public List<WeatherStation> getCacheData() {
        return cacheData.get();
    }

    public void setCacheData(List<WeatherStation> list) {
        cacheData.set(list);
    }
}
