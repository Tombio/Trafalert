package com.studiowannabe.trafalert.util;

/**
 * Created by Tomi on 24/02/16.
 */
public class Pair<K,V> {

    final K left;
    final V right;

    private Pair(final K k, final V v){
        this.left = k;
        this.right = v;
    }

    public static<K, V> Pair instance(final K left, final V right){
        return new Pair<>(left, right);
    }

    public K getLeft(){
        return left;
    }

    public V getRight(){
        return right;
    }

}
