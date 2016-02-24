package com.studiowannabe.trafalert.domain;

import lombok.Data;

/**
 * Created by Tomi on 23/02/16.
 */
public @Data class StationInfo {

    private final Long id;
    private final String tsaName;
    private final String nameFi;
    private final int roadNumber;
    private final CoordinateNode coordinateNode;
}
