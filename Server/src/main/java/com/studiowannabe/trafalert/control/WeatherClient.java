package com.studiowannabe.trafalert.control;

/**
 * Created by Tomi on 31/01/16.
 */

import com.studiowannabe.trafalert.wsdl.*;
import lombok.extern.apachecommons.CommonsLog;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

@CommonsLog
public class WeatherClient extends WebServiceGatewaySupport {

    public RoadWeatherResponse getRoadWeather() {

        RoadWeather request = new RoadWeather();
        RoadWeatherResponse response = (RoadWeatherResponse) getWebServiceTemplate()
            .marshalSendAndReceive(
                "http://tie.digitraffic.fi/sujuvuus/ws/roadWeather",
                request,
                null);
        return response;
    }

    public void printResponse(RoadWeatherResponse response) {
        RoadWeatherResponse.Roadweatherdata roadweatherdata = response.getRoadweatherdata();
        for (final RoadWeatherType rw : roadweatherdata.getRoadweather()){
            log.info(
                rw.getStationid() + " => " +
                "Temperature " + rw.getAirtemperature1() + " / " + rw.getAirtemperature3() + " " +
                "Average wind speed" + rw.getAveragewindspeed() + " " +
                "Max wind speed " + rw.getMaxwindspeed() + "  " +
                "Freezing point " + rw.getFreezingpoint1() + " / " + rw.getFreezingpoint2() + " " +
                "Humidity " + rw.getHumidity() + " " +
                "Dew point " + rw.getDewpoint());
        }
    }

}
