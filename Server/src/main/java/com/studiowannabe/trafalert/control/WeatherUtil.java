package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.wsdl.RoadWeatherType;

import java.math.BigDecimal;
import java.util.List;
import java.util.function.Function;

/**
 * Created by Tomi on 28/02/16.
 */
public class WeatherUtil {

    protected static BigDecimal countAverage(final List<RoadWeatherType> data, final Function<RoadWeatherType, BigDecimal> func) {
        int count = 0;
        BigDecimal sum = new BigDecimal(0);
        for(final RoadWeatherType datum : data){
            final BigDecimal bd = func.apply(datum);
            if(bd == null){
                continue;
            }
            sum = sum.add(bd);
            count++;
        }
        if(count == 0){
            return null; // No relevant data available
        }
        return sum.divide(new BigDecimal(count), BigDecimal.ROUND_HALF_UP);
    }

    protected static BigDecimal getMean(final BigDecimal... vals) {
        int count = 0;
        BigDecimal sum = new BigDecimal(0);

        for(final BigDecimal d : vals){
            if(d == null) {
                continue;
            }
            sum = sum.add(d);
            count++;
        }

        if(count == 0){
            return null;
        }
        return sum.divide(new BigDecimal(count), BigDecimal.ROUND_HALF_UP);

    }
}
