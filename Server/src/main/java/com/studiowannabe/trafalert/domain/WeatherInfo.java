package com.studiowannabe.trafalert.domain;

import com.fasterxml.jackson.annotation.JsonRootName;
import com.studiowannabe.trafalert.domain.warning.Warning;
import com.sun.istack.internal.Nullable;
import lombok.Data;

import java.util.List;

/**
 * Created by Tomi on 31/01/16.
 */
@JsonRootName(value = "weatherInfo")
public @Data class WeatherInfo {

    final long stationId;
    @Nullable
    final WeatherStationData WeatherData;
    final List<Warning> warnings;
}
