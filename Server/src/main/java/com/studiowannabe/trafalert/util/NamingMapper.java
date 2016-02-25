package com.studiowannabe.trafalert.util;

/**
 * Created by Tomi on 25/02/16.
 */
public class NamingMapper<T> {

    private final String name;
    private final T value;

    public NamingMapper(final String name,final T value) {
        this.name = name;
        this.value = value;
    }
}
