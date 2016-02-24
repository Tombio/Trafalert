package com.studiowannabe.trafalert.domain;

import org.junit.Test;

import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created by Tomi on 23/02/16.
 */
public class CoordinateNodeTest {

    private final CoordinateNode NODE_1 = new CoordinateNode(25.532109883841848, 64.94740628492444);
    private final CoordinateNode NODE_2 = new CoordinateNode(25.532109883841848, 64.94740628492444);
    private final CoordinateNode NODE_666 = new CoordinateNode(66.6, 66.6);

    @Test
    public void testEquals() throws Exception {
        assertTrue(NODE_1.equals(NODE_2));
        assertFalse(NODE_1.equals(NODE_666));
    }

    @Test
    public void testHashCode() throws Exception {
        assertTrue(NODE_1.hashCode() == NODE_2.hashCode());
        assertFalse(NODE_1.hashCode() == NODE_666.hashCode());
    }

    @Test
    public void whatIsWrongWithMap(){
        final HashMap<CoordinateNode, String> map = new HashMap<>();
        map.put(NODE_1, "");
        assertTrue(map.size() == 1);
        assertTrue(map.containsKey(NODE_2));

        map.put(NODE_2, "");
        assertTrue(map.size() == 1);
        assertTrue(map.containsKey(NODE_1));

        map.put(NODE_666, "");
        assertTrue(map.size() == 2);
    }
}