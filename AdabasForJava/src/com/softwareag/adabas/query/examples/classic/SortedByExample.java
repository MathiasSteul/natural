/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: SortedByExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and short name for fields. Read records
 * (MAX_RECORDS) sorted by descriptor field
 * 
 * prereq.: demo database started using file 11
 */

public abstract class SortedByExample {

    private static final int ADA_FILENR = 11;

    private static final String[] ADA_SORTBY_FIELDS = { "AE" };

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB" };

    private static final int MAX_RECORDS = 1000;

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws QueryException {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* Create session using Adabas Java Connection string */
            /* Create request containing needed parameters */
            ReadRequest request = AdabasConnection.createSession("acj:target=" + dbid).createReadRequest(ADA_FILENR);

            /* Define range for the result set */
            request.setStart(0);
            request.setLimit(MAX_RECORDS);
            request.queryFields(ADA_DATA_FIELDS);
            request.sortedBy(ADA_SORTBY_FIELDS);

            /* Send request and receive result */
            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);

            if (list.size() > 0) {
                /* Get first record */
                IRecordEntry record = list.get(0);
                /* Get field value */
                IAdaFieldValue fieldValueFirstName = record.valueOfbyShortName("AC");
                IAdaFieldValue fieldValueName = record.valueOfbyShortName("AE");

                /* String representation of value */
                System.out.println("First entry " + fieldValueFirstName.toString() + " " + fieldValueName.toString());
            }

            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
