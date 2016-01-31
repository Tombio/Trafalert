package com.studiowannabe.trafalert.control;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.studiowannabe.trafalert.domain.Warning;
import com.studiowannabe.trafalert.domain.WeatherInfo;
import com.studiowannabe.trafalert.domain.WeatherStationData;
import lombok.extern.apachecommons.CommonsLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by Tomi on 30/01/16.
 */

@RestController
@CommonsLog
public class MainController {

    private final WeatherDataCache cache;
    private final WarningCache warningCache;
    private final ObjectMapper objectMapper;

    @Autowired
    public MainController(final WeatherDataCache cache, final WarningCache warningCache,
                          final ObjectMapper objectMapper) {
        this.cache = cache;
        this.warningCache = warningCache;
        this.objectMapper = objectMapper;
    }

    @RequestMapping(value = "/warning/{region}/{version}", method = RequestMethod.GET, produces = "application/json")
    public String warningsForRegion(@PathVariable(value = "region") final Long region,
                                           @PathVariable(value = "version") final Long version) throws Exception {
        final List<Warning> warnings = getWarningsForRegion(region);
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("warnings").writeValueAsString(warnings);
    }

    @RequestMapping(value = "/weather/{region}", method = RequestMethod.GET, produces = "application/json")
    public String weatherForRegion(@PathVariable(value = "region") final Long region) throws Exception {
        final WeatherStationData wsd = getWeatherForRegion(region);
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("weather").writeValueAsString(wsd);
    }

    @RequestMapping(value = "/info/{region}", method = RequestMethod.GET, produces = "application/json")
    public String fullInfoForRegion(@PathVariable(value = "region") final Long region) throws Exception {
        final WeatherStationData wsd = cache.getCacheData().get(region);
        final List<Warning> warnings = warningCache.getCacheData().get(region);
        final WeatherInfo wi = new WeatherInfo(wsd.getStationId(), wsd, warnings);
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("stationInfo").writeValueAsString(wi);
    }

    @RequestMapping(value = "/info", method = RequestMethod.GET, produces = "application/json")
    public String allRegions() throws Exception {
        final List<WeatherInfo> infos = getAllStationsWithWarnings();
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("fullInfo").writeValueAsString(infos);
    }

    private List<Warning> getWarningsForRegion(final long region) {
        return warningCache.getCacheData().get(region);
    }

    private WeatherStationData getWeatherForRegion(final long region) {
        return cache.getCacheData().get(region);
    }

    private List<WeatherInfo> getAllStationsWithWarnings() {
        final List<WeatherInfo> infos = new ArrayList<WeatherInfo>();
        final Collection<WeatherStationData> datas = cache.getCacheData().values();
        for(final WeatherStationData data : datas) {
            final List<Warning> warnings = warningCache.getCacheData().get(data.getStationId());
            final WeatherInfo wi = new WeatherInfo(data.getStationId(), data, warnings);
            infos.add(wi);
        }
        return infos;
    }


}
