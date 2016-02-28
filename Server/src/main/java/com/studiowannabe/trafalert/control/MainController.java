package com.studiowannabe.trafalert.control;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.studiowannabe.trafalert.domain.StationInfo;
import com.studiowannabe.trafalert.domain.json.GrouppedStations;
import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.domain.WeatherInfo;
import com.studiowannabe.trafalert.domain.WeatherStationData;
import lombok.extern.apachecommons.CommonsLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Tomi on 30/01/16.
 */

@RestController
@CommonsLog
public class MainController {

    private final WeatherDataCache cache;
    private final WarningCache warningCache;
    private final ObjectMapper objectMapper;
    private final StationGroupping stationGroupping;

    @Autowired
    public MainController(final WeatherDataCache cache, final WarningCache warningCache,
                          final ObjectMapper objectMapper, final StationGroupping stationGroupping) {
        this.cache = cache;
        this.warningCache = warningCache;
        this.objectMapper = objectMapper;
        this.stationGroupping = stationGroupping;
    }

    @RequestMapping(value = "/warning/{region}/{version}", method = RequestMethod.POST, produces = "application/json")
    public String warningsForRegion(@PathVariable(value = "region") final Long region,
                                           @PathVariable(value = "version") final Long version) throws Exception {
        final List<Warning> warnings = getWarningsForRegion(region);
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(warnings);
    }

    @RequestMapping(value = "/warning", method = RequestMethod.POST, produces = "application/json")
    public String warningsForRegion() throws Exception {
        final List<WeatherInfo> infos = getAllStationsWithWarnings();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(infos);
    }

    @RequestMapping(value = "/warning/stations", method = RequestMethod.POST, produces = "application/json")
    public String stationsWithWarning() throws Exception {
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(getStationIdsWithWarning());
    }

    @RequestMapping(value = "/weather/{region}", method = RequestMethod.POST, produces = "application/json")
    public String weatherForRegion(@PathVariable(value = "region") final Long region) throws Exception {
        final WeatherStationData wsd = getWeatherForRegion(region);
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(wsd);
    }

    @RequestMapping(value = "/info/{region}", method = RequestMethod.POST, produces = "application/json")
    public String fullInfoForRegion(@PathVariable(value = "region") final Long region) throws Exception {
        log.info("Siis tä");
        final WeatherStationData wsd = cache.getCacheData().get(region).getLeft();
        log.info("Vittu");
        final List<Warning> warnings = warningCache.getCacheData().get(region);
        log.info("Persehelvetti");
        final WeatherInfo wi = new WeatherInfo(wsd.getStationId(), wsd, warnings);
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(wi);
    }

    @RequestMapping(value = "/info", method = RequestMethod.POST, produces = "application/json")
    public String allRegions() throws Exception {
        final List<WeatherInfo> infos = getAllStationsAndWarnings();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(infos);
    }

    @Cacheable
    @RequestMapping(value = "/meta/station", method = RequestMethod.POST, produces = "application/json")
    public String metaStations() throws Exception {
        final GrouppedStations stations = new GrouppedStations();
        for(final HashMap.Entry<Long, List<StationInfo>> entry : stationGroupping.getStationGroups().entrySet()) {
            stations.addGroup(new GrouppedStations.StationGroup(entry.getKey(), entry.getValue()));
        }
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(stations.getStationGroup());
    }

    private List<Warning> getWarningsForRegion(final long region) {
        return warningCache.getCacheData().get(region);
    }

    private WeatherStationData getWeatherForRegion(final long region) {
        return cache.getCacheData().get(region).getLeft();
    }

    private List<WeatherInfo> getAllStationsAndWarnings() {
        final List<WeatherInfo> infos = new ArrayList<WeatherInfo>();
        for(final Long id : stationGroupping.getStationGroups().keySet()) {
            final StationInfo info = stationGroupping.getStationGroups().get(id).get(0); // Ugly, yeah :p
            final List<Warning> warnings = warningCache.getCacheData().get(id);
            final WeatherInfo wi = new WeatherInfo(id, cache.getCacheData().get(info.getId()).getLeft(), warnings);
            infos.add(wi);
        }
        return infos;
    }

    private List<WeatherInfo> getAllStationsWithWarnings() {
        try {
            final List<WeatherInfo> infos = new ArrayList<WeatherInfo>();
            for (final Long id : stationGroupping.getStationGroups().keySet()) {
                final List<Warning> warnings = warningCache.getCacheData().get(id);
                if (!CollectionUtils.isEmpty(warnings)) {
                    final WeatherInfo wi = new WeatherInfo(id, null, warnings);
                    infos.add(wi);
                }
            }
            return infos;
        }
        catch (Exception e) {
            log.info("Error fetching warnings", e);
            throw e;
        }
    }

    private List<Long> getStationIdsWithWarning() {
        final List<WeatherInfo> warningStations = getAllStationsWithWarnings();
        return warningStations.stream().map(station -> station.getStationId()).collect(Collectors.toList());
    }
}
