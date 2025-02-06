/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: ReadWithMappingDescriptorExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.mapping.AdabasMapperRepositories;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This examples read data in ISN sequence using demo file 11 and long names defined
 * in EmployeeMap.
 *
 * prereq.: demo database started GenerateExampleMappings executed
 */

public abstract class ReadWithMappingDescriptorExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String LASTNAME_FIELD = "LastName";
    private static final String FIRSTNAME_FIELD = "FirstName";
    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final int MAX_RECORDS = 200;

    private static final String[] ADA_LN_FIELDS =
        { FIRSTNAME_FIELD, LASTNAME_FIELD };

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        /* simple Adabas Database target definition (dbid) */
        AdabasTarget target = new AdabasTarget(dbid);

        /*
         * Register database map configuration location where the Adabas Client
         * for Java API will search for map
         * definitions. The notation is similar to use AdabasConnection with
         * ReadRequest request = AdabasConnection
         * .createSession("ajc:map:EmployeeMap;config=[24,4]")
         * .createReadRequest(11);
         */
        AdabasMapperRepositories.addMapStorage(target, ADA_FILE_DATA_DESIGNER);

        AdabasConnection connection = AdabasConnection.createSession("acj:map");

        try (
            /* Create request with an example map */
            ReadRequest request =
                connection.createReadRequest(ADA_EMPNAT_MAPNAME)) {

            /* Define range for the result set */
            request.setStart(0);
            request.setLimit(MAX_RECORDS);

            /* Need to set the view or the list of fields in the result set */
            request.addFieldsQuery(ADA_LN_FIELDS);

            /*
             * Send request and receive result. Here the range from including 'A'
             * thru including 'F' is read
             */
            IQueryResult result =
                request.readLogicalWith(LASTNAME_FIELD + "=['A':'F']");
            result.output(System.out);

            if (result.list().size() > 0) {
                /* Get first record */
                IRecordEntry record = result.list().get(0);

                /* Get field value */
                IAdaFieldValue fieldValueFirstName =
                    record.valueOf(ADA_LN_FIELDS[0]);

                /* Use String representation of value and show them */
                System.out
                    .println("First entry " + fieldValueFirstName.toString());
            }
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
