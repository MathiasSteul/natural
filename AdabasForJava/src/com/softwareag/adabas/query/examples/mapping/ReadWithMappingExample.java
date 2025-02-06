/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: ReadWithMappingExample.java 6232 2017-08-28 14:52:41Z tkn $
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
 * This examples read data in ISN sequence using demo file 11 and long names defined
 * in EmployeeMap.
 *
 * prereq.: demo database started GenerateExampleMappings executed
 */

public abstract class ReadWithMappingExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final int START_ISN = 200;

    private static final int MAX_RECORDS = 200;

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

        AdabasConnection connection = AdabasConnection.createSession(
            "acj:map;config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");

        try (
            /* Create request with an example map */
            ReadRequest request =
                connection.createReadRequest(ADA_EMPNAT_MAPNAME)) {

            /* Define range for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);

            /* Add fields to be read into query */
            request.addFieldsQuery(ADA_LN_FIELDS);

            /*
             * Send request and receive result. This call will read all records in
             * ISN order
             */
            IQueryResult result = request.readLogicalByIsn();
            result.output(System.out);

            if (result.list().size() > 0) {
                /* Get first record */
                IRecordEntry record = result.list().get(0);

                /* Get field value */
                IAdaFieldValue fieldValueFirstName =
                    record.valueOf(ADA_LN_FIELDS[0]);

                /*
                 * Get String value of the Adabas fields 'LastName' which is an Alpha
                 * field
                 */
                String fieldValueName =
                    (String) record.valueOf(ADA_LN_FIELDS[1]).getValue();

                /* Use String representation of value and show them */
                System.out.println("First entry "
                    + fieldValueFirstName.toString() + " -> " + fieldValueName);
            }
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
