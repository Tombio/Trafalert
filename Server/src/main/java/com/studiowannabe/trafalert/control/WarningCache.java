package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.warning.Warning;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Created by Tomi on 31/01/16.
 */

@Component
public class WarningCache {

    private static AtomicReference<HashMap<Long, List<Warning>>> cacheData;
    private static boolean inited = false;

    public WarningCache() {
        if(!inited) {
            cacheData = new AtomicReference<>(new HashMap<>());
            inited = true;
        }
    }
    public HashMap<Long, List<Warning>> getCacheData() {
        return cacheData.get();
    }
    public void setCacheData(HashMap<Long, List<Warning>> warnings) {
        cacheData.set(warnings);
    }
}
