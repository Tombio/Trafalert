package com.studiowannabe.trafalert.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class CollectionUtils {

    public static <T, K> List<T> map(final Collection<K> from, final Mapper<T, K> mapper) {
        final List<T> to = new ArrayList<T>(from.size());
        for (final K k : from) {
            to.add(mapper.map(k));
        }
        return to;
    }

    public static <T, K> List<T> mapWithoutNulls(final Collection<K> from, final Mapper<T, K> mapper) {
        if(org.springframework.util.CollectionUtils.isEmpty(from)){
            return Collections.emptyList();
        }
        final List<T> to = new ArrayList<>();
        for (final K k : from) {
            if(k == null){
                continue;
            }
            final T t = mapper.map(k);
            if(t != null) {
                to.add(t);
            }
        }
        return to;
    }

    public interface Mapper<K, T> extends Serializable {
        K map(final T t);
    }
}
