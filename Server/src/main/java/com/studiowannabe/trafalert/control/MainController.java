package com.studiowannabe.trafalert.control;


import com.studiowannabe.trafalert.domain.Warning;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by Tomi on 30/01/16.
 */

@RestController
public class MainController {

    private final WeatherDataCache cache;

    @Autowired
    public MainController(WeatherDataCache cache) {
        this.cache = cache;
    }

    @RequestMapping(value = "/warning/{region}/{version}", method = RequestMethod.GET, produces = "application/json")
    public List<Warning> warningsForRegion(@PathVariable(value = "region") final int region,
                                           @PathVariable(value = "version") final Long version) {

        return null;
    }

}
