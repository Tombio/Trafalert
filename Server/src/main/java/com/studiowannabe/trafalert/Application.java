package com.studiowannabe.trafalert;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Created by Tomi on 30/01/16.
 */

@Configuration
@ComponentScan({ "com.studiowannabe.trafalert.*" })
@EnableAutoConfiguration
@EnableScheduling
public class Application {
    
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
