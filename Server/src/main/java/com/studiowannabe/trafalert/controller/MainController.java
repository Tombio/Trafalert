package com.studiowannabe.trafalert.controller;


import com.studiowannabe.trafalert.domain.Warning;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by Tomi on 30/01/16.
 */

@RestController
public class MainController {


    public List<Warning> warningsForRegion(final int regionId, final Long version) {
        return null;
    }

}
