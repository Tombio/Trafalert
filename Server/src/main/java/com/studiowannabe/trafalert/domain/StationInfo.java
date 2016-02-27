package com.studiowannabe.trafalert.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

/**
 * Created by Tomi on 23/02/16.
 */
public @Data class StationInfo {

    private final Long id;
    private final String tsaName;
    @JsonIgnore
    private final String nameFi;
    @JsonIgnore
    private final int roadNumber;
    @JsonIgnore
    private final CoordinateNode coordinateNode;
}
