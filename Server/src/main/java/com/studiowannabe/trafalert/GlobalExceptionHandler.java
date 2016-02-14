package com.studiowannabe.trafalert;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Created by Tomi on 03/12/15.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)  // 500
    @ExceptionHandler(UnauthorizedAccessException.class)
    public void handleUnauthrozedAccess() {
        System.out.println("Unauthorized access");
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)  // 500
    @ExceptionHandler(Throwable.class)
    public void handleAllExceptions() {
        Thread.dumpStack();
        System.out.println("Global exception handler");
    }

    public static class UnauthorizedAccessException extends Exception {
        public UnauthorizedAccessException(final String apiKey){
            super("Unauthorized access with API key " + apiKey);
        }
    }
}