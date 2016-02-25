package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.CoordinateNode;
import org.osgeo.proj4j.*;
import org.springframework.stereotype.Component;

@Component
public class CoordinateConverter {

    private CoordinateTransform transformer;

    public CoordinateConverter() {
        CRSFactory crsFactory = new CRSFactory();
        CoordinateReferenceSystem coordinateTransformFrom = crsFactory.createFromParameters("EPSG:3067",
                "+proj=utm +zone=35 ellps=GRS80 +units=m +no_defs");
        CoordinateReferenceSystem coordinateTransformTo = crsFactory.createFromParameters("EPSG:4326",
                "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs");
        CoordinateTransformFactory coordinateTransformFactory = new CoordinateTransformFactory();
        transformer = coordinateTransformFactory.createTransform(coordinateTransformFrom, coordinateTransformTo);
    }

    public CoordinateNode getProjectedCoordinates(final Double x, final Double y) {
        ProjCoordinate from = new ProjCoordinate();
        ProjCoordinate to = new ProjCoordinate();
        from.x = x;
        from.y = y;
        transformer.transform(from, to);
        return new CoordinateNode(to.x, to.y);
    }
}
