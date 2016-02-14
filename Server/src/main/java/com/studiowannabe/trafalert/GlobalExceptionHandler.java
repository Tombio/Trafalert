package com.studiowannabe.trafalert;

import lombok.extern.apachecommons.CommonsLog;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by Tomi on 03/12/15.
 */
@CommonsLog
@ControllerAdvice
public class GlobalExceptionHandler {

    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    @ExceptionHandler(UnauthorizedAccessException.class)
    public void handleUnauthorizedAccess(final HttpServletRequest req, final UnauthorizedAccessException exception) {
        log.error("Unauthorized access from " + req.getRemoteAddr(), exception);
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)  // 500
    @ExceptionHandler(Throwable.class)
    public void handleAllExceptions(final HttpServletRequest req, final Exception exception) {
        Thread.dumpStack();
        System.out.println("Global exception handler");
    }

    public static class UnauthorizedAccessException extends Exception {
        public UnauthorizedAccessException(final String apiKey){
            super("Unauthorized access with API key " + apiKey);
        }
    }
}