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
    public List<Warning> warningsForRegion(@PathVariable(value = "region") final int region,
                                           @PathVariable(value = "version") final Long version) {
        return null;
    }

    @RequestMapping(value = "/weather/{region}", method = RequestMethod.GET, produces = "application/json")
    public String warningsForRegion(@PathVariable(value = "region") final long region) throws Exception {
        final WeatherStationData wsd = cache.getCacheData().get(region);
        log.info("Weather for " + region  + " => " + wsd);
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("weather").writeValueAsString(wsd);
    }

    @RequestMapping(value = "/info/{region}", method = RequestMethod.GET, produces = "application/json")
    public String fullInfoForRegion(@PathVariable(value = "region") final long region) throws Exception {
        final WeatherStationData wsd = cache.getCacheData().get(region);
        final List<Warning> warnings = warningCache.getCacheData().get(region);
        final WeatherInfo wi = new WeatherInfo(wsd, warnings);
        log.info("Info for " + region  + " => " + wsd);
        return objectMapper.writerWithDefaultPrettyPrinter().withRootName("WeatherInfo").writeValueAsString(wi);
    }

}
