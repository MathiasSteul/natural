/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: ComplexQueryWithMappingExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This examples read data in descending order using a range search. The fields are
 * sorted using two fields.
 *
 * prereq.: demo database started GenerateExampleMappings executed
 */

public abstract class ComplexQueryWithMappingExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final int MAX_RECORDS = 20;

    private static final String[] ADA_LN_FIELDS = { "FirstName", "LastName" };

    private static final String[] ADA_SORT_KEYS = { "LastName", "FirstName" };

    public static void main(final String[] args) throws QueryException {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* Create session using Adabas Java Connection string */
            /* Use EmployeeMap generated using GenerateExampleMappings */
            AdabasConnection conn =
                AdabasConnection.createSession("ajc:map=" + ADA_EMPNAT_MAPNAME
                    + ";config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");

            /* Create request with an example map */
            try (ReadRequest request = conn.createReadRequest()) {

                /* Set max number of records to return */
                request.setLimit(MAX_RECORDS);

                /* Add fields to be read into query */
                request.addFieldsQuery(ADA_LN_FIELDS);

                /* Add sort order */
                request.sortedBy(ADA_SORT_KEYS);

                /* Search for a range -> LastName>=TE and LastName<=TH */
                request.setSearch(
                    ADA_LN_FIELDS[1] + ">=TE and " + ADA_LN_FIELDS[1] + "<=TH");

                /* Return in descending order */
                request.setAscending(false);

                /* Send request and receive result */
                IQueryResult result =
                     request.readIsnSequence();
                result.output(System.out);

                if (result.list().size() > 0) {
                    /* Get first record */
                    IRecordEntry record = result.list().get(0);

                    /* Get field value */
                    IAdaFieldValue fieldValueFirstName =
                        record.valueOf(ADA_LN_FIELDS[0]);

                    /* Use String representation of value and show them */
                    System.out.println(
                        "First entry " + fieldValueFirstName.toString());
                }
            }
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
