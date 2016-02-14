package com.studiowannabe.trafalert.control;

import com.studiowannabe.trafalert.GlobalExceptionHandler;
import lombok.extern.apachecommons.CommonsLog;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.SystemEnvironmentPropertySource;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;

@Configuration
@ComponentScan(basePackages="com.studiowannabe.trafalert")
@CommonsLog
public class InterceptorConfig extends WebMvcConfigurerAdapter {
    private static final String AK = "API_KEY";
    private static final String API_KEY = getApiKey();

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        log.info("API key: " + API_KEY);
        registry.addInterceptor(new AccessInterceptor()).addPathPatterns("/**");
    }

    private class AccessInterceptor implements HandlerInterceptor {

        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
            if (API_KEY.equals(request.getHeader(AK))){
                return true;
            }
            throw new GlobalExceptionHandler.UnauthorizedAccessException(request.getHeader(AK));
        }

        @Override
        public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        }

        @Override
        public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

        }
    }

    private static String getApiKey() {
        if(System.getProperty(AK) != null){
            return System.getProperty(AK);
        }
        else if(System.getenv(AK) != null) {
            return System.getenv(AK);
        }

        throw new RuntimeException("No API key defined in env/properties");
    }
}
