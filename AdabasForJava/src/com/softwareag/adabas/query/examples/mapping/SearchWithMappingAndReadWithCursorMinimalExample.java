/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: SearchWithMappingAndReadWithCursorMinimalExample.java 6232 2017-08-28 14:52:41Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.ReadRequest;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This examples read data with FirstName as sort criteria using demo file 11 and
 * long names defined in EmployeeMap.
 * The result is streamed using Java Lambda defined with different read criteria.
 * 
 * prereq.: demo database started GenerateExampleMappings executed
 */
public abstract class SearchWithMappingAndReadWithCursorMinimalExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final String[] ADA_LN_FIELDS = { "FirstName", "LastName" };

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* Create connection instance referencing database connection */
            AdabasConnection conn =
                AdabasConnection.createSession("acj:map=" + ADA_EMPNAT_MAPNAME
                    + ";config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");
            /* Create a read request for the corresponding Map name */
            try (ReadRequest request = conn.createReadRequest()) {
                /* Stream of an cursor based read of an search query */
                request.queryFields(ADA_LN_FIELDS).search("FirstName='ALAN'")
                    .sortedBy(new String[] { ADA_LN_FIELDS[0] }).readByCursor().forEach(entry -> System.out.println(entry.toString()));
            }
            
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
