package com.studiowannabe.trafalert.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class CollectionUtils {

    public static <T, K> List<T> map(final Collection<K> from, final Mapper<T, K> mapper) {
        final List<T> to = new ArrayList<T>(from.size());
        for (final K k : from) {
            to.add(mapper.map(k));
        }
        return to;
    }

    public interface Mapper<K, T> extends Serializable {
        K map(final T t);
    }
}
