package com.studiowannabe.trafalert.control;

/**
 * Created by Tomi on 31/01/16.
 */

import java.text.SimpleDateFormat;
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
        printResponse(response);
        return response;
    }

    public void printResponse(RoadWeatherResponse response) {
        RoadWeatherResponse.Roadweatherdata roadweatherdata = response.getRoadweatherdata();
        for (final RoadWeatherType rw : roadweatherdata.getRoadweather()){
            log.info(
                    rw.getStationid() + " => " +
                    rw.getAirtemperature1() + " / " +
                    rw.getAveragewindspeed() + " / " +
                    rw.getMaxwindspeed() + " / " +
                    rw.getFreezingpoint1() + " / " +
                    rw.getHumidity());
        }
    }

}
