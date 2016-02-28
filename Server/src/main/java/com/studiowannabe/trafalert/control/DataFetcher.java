package com.studiowannabe.trafalert.control;

import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.studiowannabe.trafalert.domain.*;
import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.util.CollectionUtils;
import com.studiowannabe.trafalert.util.Pair;
import com.studiowannabe.trafalert.wsdl.RoadWeatherResponse;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import lombok.extern.apachecommons.CommonsLog;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Tomi on 31/01/16.
 */
@Component
@CommonsLog
public class DataFetcher {

    private static final String WEATHER_URL = "http://tie.digitraffic.fi/sujuvuus/ws/roadWeather";
    private static final String SCHEMA_URL = "https://raw.githubusercontent.com/finnishtransportagency/metadata/master/csv/meta_rws_stations.csv";

    private final WeatherDataCache cache;
    private final WarningCache warningCache;
    private final WeatherClient weatherClient;
    private final WarningIssuer warningIssuer;
    private final StationGroupping stationGroupping;
    private final CoordinateConverter coordinateConverter;

    @Autowired
    public DataFetcher(final WeatherDataCache cache, final WeatherClient weatherClient,
                       final WarningIssuer warningIssuer, final WarningCache warningCache,
                       final StationGroupping stationGroupping,
                       final CoordinateConverter coordinateConverter) throws IOException  {
        this.cache = cache;
        this.weatherClient = weatherClient;
        this.warningIssuer = warningIssuer;
        this.warningCache = warningCache;
        this.stationGroupping = stationGroupping;
        this.coordinateConverter = coordinateConverter;

        readSchema();
    }

    private void readSchema() throws IOException {
        URL url = new URL(SCHEMA_URL);
        final InputStream in = url.openStream();
        try {
            log.info("Read station meta");
            CsvMapper mapper = new CsvMapper();
            CsvSchema schema = CsvSchema.emptySchema().withColumnSeparator(';').withHeader(); // use first row as header; otherwise defaults are fine
            MappingIterator<Map<String, String>> it = mapper.reader(Map.class)
                    .with(schema)
                    .readValues(in);
            while (it.hasNext()) {
                Map<String, String> rowAsMap = it.next();
                final Long id = Long.parseLong(rowAsMap.get("NUMERO"));
                final String tsaNimi = rowAsMap.get("TSA_NIMI");
                final String tieNimiFi = rowAsMap.get("NIMI_FI");
                final int roadNumber = Integer.parseInt(rowAsMap.get("TIE"));
                final Double x = Double.parseDouble(rowAsMap.get("Y"));
                final Double y = Double.parseDouble(rowAsMap.get("X"));
                final CoordinateNode coord = coordinateConverter.getProjectedCoordinates(x, y);
                final StationInfo info = new StationInfo(id, tsaNimi, tieNimiFi, roadNumber, coord);
                stationGroupping.add(coord, info);
            }
        }
        finally {
            in.close();
        }
    }


    @Scheduled(fixedDelay = 60 * 1000) // 60 seconds
    private void runDataUpdate(){
        log.info("Run update...");
        final RoadWeatherResponse response = weatherClient.getRoadWeather();
        if(response != null) {
            updateCaches(response);
            calculateWarnings();
        }
    }

    private void calculateWarnings(){
        final HashMap<Long, List<Warning>> warningMap = new HashMap<>();
        final Map<Long, List<StationInfo>> groupping = stationGroupping.getStationGroups();
        final Map<Long, Pair<WeatherStationData, RoadWeatherType>> cacheData = cache.getCacheData();

        for(final HashMap.Entry<Long, List<StationInfo>> entry : groupping.entrySet()) {
            final List<RoadWeatherType> data = CollectionUtils.mapWithoutNulls(entry.getValue(),
                    new CollectionUtils.Mapper<RoadWeatherType, StationInfo>() {
                @Override
                public RoadWeatherType map(final StationInfo stationInfo) {
                    if(stationInfo == null){
                        return null;
                    }
                    final Pair<WeatherStationData, RoadWeatherType> type = cacheData.get(stationInfo.getId());
                    return type != null ? type.getRight() : null;
                }
            });
            if(entry.getKey() == null || data == null){
                log.warn("Null value in cache");
                continue;
            }
            final List<Warning> warnings = warningIssuer.calculateWarnings(entry.getKey(), data);
            if(!org.springframework.util.CollectionUtils.isEmpty(warnings)) {
                log.info(entry.getKey() + " Issued warnings " + warnings);
            }
            warningMap.put(entry.getKey(), warnings);
        }
        warningCache.setCacheData(warningMap);
    }

    private void updateCaches(final RoadWeatherResponse response) {
        final HashMap<Long, Pair<WeatherStationData, RoadWeatherType>> map = new HashMap<>(response.getRoadweatherdata().getRoadweather().size());

        for (final RoadWeatherType data : response.getRoadweatherdata().getRoadweather()) {

            final Precipitation precipitation = Precipitation.parse(data.getPrecipitation());
            final PrecipitationType precipitationType = PrecipitationType.parse(data.getPrecipitationtype());
            final RoadCondition roadCondition = RoadCondition.parse(data.getRoadsurfaceconditions1());

            final WeatherStationData wsd = new WeatherStationData(data.getStationid().longValue(), data.getAirtemperature1(), data.getRoadsurfacetemperature1(),
                    data.getAveragewindspeed(), data.getMaxwindspeed(), data.getVisibilitymeters(), data.getDewpoint(),
                    data.getRoaddewpointdifference(), data.getHumidity(), data.getWinddirection(), precipitation, data.getPrecipitationintensity(),
                    data.getPrecipitationsum(), precipitationType, roadCondition, data.getSunup());

            map.put(data.getStationid().longValue(), Pair.instance(wsd, data));
        }
        cache.setCacheData(map);
    }
}
