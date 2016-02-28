package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.domain.warning.Warning;
import com.studiowannabe.trafalert.util.CollectionUtils;
import com.studiowannabe.trafalert.wsdl.RoadWeatherType;
import org.junit.Test;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Collections;
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
        final List<Warning> warnings = ISSUER.calculateWarnings(0L, createBlackIceRoadWeather());
        assertTrue(warnings.size() == 2);
        assertEquals(warnings.get(0).getWarningType(), Warning.WarningType.BLACK_ICE);
        assertEquals(warnings.get(1).getWarningType(), Warning.WarningType.POOR_VISIBILITY);
    }

    private static final List<RoadWeatherType> createBlackIceRoadWeather() {
        final RoadWeatherType rwt = new RoadWeatherType();
        rwt.setStationid(BigInteger.ZERO);
        rwt.setAirtemperature1(new BigDecimal(1));
        rwt.setRoaddewpointdifference(new BigDecimal(-0.01));
        rwt.setRoadsurfacetemperature1(new BigDecimal(-0.01));
        rwt.setVisibilitymeters(new BigDecimal(100));
        return Collections.singletonList(rwt);
    }

    @Test
    public void testMean(){
        final BigDecimal bd = WeatherUtil.getMean(
                new BigDecimal(1.000007), new BigDecimal(1.100003), new BigDecimal(1.200005));
        assertEquals(1.1, bd.doubleValue(), 1);

    }
}