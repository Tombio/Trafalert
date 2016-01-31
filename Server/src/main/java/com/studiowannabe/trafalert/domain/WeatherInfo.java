package com.studiowannabe.trafalert.domain;

import lombok.Data;

import java.util.List;

/**
 * Created by Tomi on 31/01/16.
 */
public @Data class WeatherInfo {

    final WeatherStationData WeatherData;
    final List<Warning> warnings;
}
