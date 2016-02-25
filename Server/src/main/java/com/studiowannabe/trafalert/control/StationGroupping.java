package com.studiowannabe.trafalert.control;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.studiowannabe.trafalert.domain.CoordinateNode;
import com.studiowannabe.trafalert.domain.StationInfo;
import lombok.extern.apachecommons.CommonsLog;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

/**
 * Created by Tomi on 22/02/16.
 */
@Component
@CommonsLog
public class StationGroupping {

    private final static Map<CoordinateNode, Long> groupIds = new HashMap<>();

    @JsonProperty(value = "Stations")
    protected final static Map<Long, List<StationInfo>> stationGroups = new HashMap<>();
    private static AtomicLong SEQ = new AtomicLong(0);

    public Map<Long, List<StationInfo>> getStationGroups() {
        return stationGroups;
    }

    public void add(final CoordinateNode coordinateNode, final StationInfo info){
        final Long groupId;
        if(groupIds.containsKey(coordinateNode)){
            groupId = groupIds.get(coordinateNode);
        }
        else {
            groupId = SEQ.getAndIncrement();
            groupIds.put(coordinateNode, groupId);
        }

        if(stationGroups.containsKey(groupId)){
            stationGroups.get(groupId).add(info);
        }
        else {
            final List<StationInfo> list = new ArrayList<>(1);
            list.add(info);
            stationGroups.put(groupId, list);
        }
    }

    public static List<Long> getByGroupId(final Long key){
        if(groupIds.containsValue(key)){
            return stationGroups.get(key).
                    stream().map(StationInfo::getId).
                    collect(Collectors.toList());
        }
        else {
            return Collections.emptyList();
        }
    }

}
