/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: UpdateDataWithMappingExample.java 6232 2017-08-28 14:52:41Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.StoreRequest;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * Example to update existing data in example employee file using mapping definition
 * EmployeeMap
 *
 * prereq.: demo database started GenerateExampleMappings executed
 * StoreDataWithMappingExample executed
 */

public abstract class UpdateDataWithMappingExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final int STARTISN = 1108;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final String[] ADA_LN_FIELDS =
                { "Id", "FirstName", "LastName", "Department" };

    private static final Object[][] dataMatrix =
                { { "TEST1upd", "Peter", "Rapunzel", "R&D" },
                    { "TEST2upd", "Karl", "Hutzenputzel", "FINCON" },
                    { "TEST3upd", "Claudia", "Energer", "HR" },
                    { "TEST4upd", "Stefan", "Papa", "CONSUL" } };

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        /* Create session using Adabas Java Connection string */
        /* Use EmployeeMap generated using GenerateExampleMappings */
        AdabasConnection conn =
                        AdabasConnection.createSession("ajc:map=" + ADA_EMPNAT_MAPNAME
                            + ";config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");

        /* Create request with an example map */
        try (StoreRequest request = conn.createStoreRequest()) {
            request.addStoredFields(ADA_LN_FIELDS);
            /*
             * AdabasMapper reads map definition in Adabas and provide corresponding
             * field types to work with
             */
            int isn = STARTISN;

            for (Object[] dataEntry : dataMatrix) {
                /* Create an record entry for each matrix object */
                RecordEntry entry = request.createRecordEntry();
                for (int i = 0; i < ADA_LN_FIELDS.length; i++) {
                    String field = ADA_LN_FIELDS[i];

                    /* Add field value data */
                    entry.addValue(field, dataEntry[i]);
                }
                /*
                 * Define ISN to be updated, either give ISN by input or read data
                 * before updating, read data will have
                 * the ISN already set in each received request entry.
                 */
                entry.setIsn(isn);
                isn++;

                /* Put entries in request */
                Long[] isns=request.updateEntry(entry);
            }

            /* Request update of data */
            request.endTransaction();

            /* Show ISN values for result */
            for (RecordEntry recordEntry : request.getEntryList()) {
                System.out.println("updated ISN: " + recordEntry.getIsn());
            }

        }

        catch (Exception qe) {
            System.out.println(qe.getMessage());
            System.out.println("Invalid ISN = " + STARTISN);
            System.out
            .println("Please execute StoreDataWithMapping example first "
                            + "(located in examples.mapping folder) ");
        } finally {
            System.out
            .println("note: Please use Data Designer for verification");
        }

    }

}
