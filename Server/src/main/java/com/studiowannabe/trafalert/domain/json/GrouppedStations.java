package com.studiowannabe.trafalert.domain.json;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.studiowannabe.trafalert.domain.CoordinateNode;
import com.studiowannabe.trafalert.domain.StationInfo;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Tomi on 25/02/16.
 */
@NoArgsConstructor
public @Data class GrouppedStations {

    final List<StationGroup> stationGroup = new ArrayList<>();

    public void addGroup(final StationGroup group) {
        stationGroup.add(group);
    }

    public static @Data class StationGroup {
        @JsonProperty(value = "group_id")
        private final Long groupId;
        @JsonProperty(value = "stations")
        private final List<StationInfo> stationInfoList;
        @JsonProperty(value = "name")
        private final String getName(){
            return stationInfoList.get(0).getNameFi();
        }
        @JsonProperty(value = "road_number")
        private final int getRoadNumber(){
            return stationInfoList.get(0).getRoadNumber();
        }
        @JsonProperty(value = "coordinates")
        private final CoordinateNode getCoordinates(){
            return stationInfoList.get(0).getCoordinateNode();
        }

    }
}
