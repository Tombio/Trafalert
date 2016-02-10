package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

import static org.junit.Assert.*;

/**
 * Created by Tomi on 04/02/16.
 */
public class WarningIssuerTest {

    private static final WarningCache CACHE = new WarningCache();
    private static final WarningIssuer ISSUER = new WarningIssuer(CACHE);

    @org.junit.Test
    public void testBlackIceWarning() throws Exception {
        final List<Warning> warnings = ISSUER.calculateWarnings(createBlackIceRoadWeather());
        assertTrue(warnings.size() == 1);
        assertEquals(warnings.get(0).getWarningType(), Warning.WarningType.BLACK_ICE);
    }

    private static final RoadWeatherType createBlackIceRoadWeather() {
        final RoadWeatherType rwt = new RoadWeatherType();
        rwt.setStationid(BigInteger.ZERO);
        rwt.setRoaddewpointdifference(new BigDecimal(-0.01));
        rwt.setRoadsurfacetemperature1(new BigDecimal(-0.01));
        return rwt;
    }
}