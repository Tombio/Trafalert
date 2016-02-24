package com.studiowannabe.trafalert.domain;

import lombok.Getter;

/**
 * Created by Tomi on 28/01/16.
 */
public @Getter class CoordinateNode {

    protected final double x;
    protected final double y;

    public CoordinateNode(double x, double y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        CoordinateNode that = (CoordinateNode) o;

        if (Double.compare(that.x, x) != 0) return false;
        return Double.compare(that.y, y) == 0;

    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        temp = Double.doubleToLongBits(x);
        result = (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(y);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }

    @Override
    public String toString() {
        return "CoordinateNode{" +
                "x=" + x +
                ", y=" + y +
                '}';
    }
}
