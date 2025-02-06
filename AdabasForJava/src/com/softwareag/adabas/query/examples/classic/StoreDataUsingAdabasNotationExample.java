/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: StoreDataUsingAdabasNotationExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.StoreRequest;

/**
 * This example uses Adabas classic notation like database id, file number and short name for fields. It stores records
 * where AA values starts with "TEST". Run DeleteExample program to remove these records again.
 *
 * prereq.: demo database started using file 11
 */

public abstract class StoreDataUsingAdabasNotationExample {

    private static final int ADA_FILENR = 11;

    private static final String[] ADA_FIELDS = { "AA", "AC", "AE", "AO" };

    private static final Object[][] DATA_MATRIX = { { "TEST1", "Peter", "Rapunzel", "R&D" },
        { "TEST2", "Karl", "Hutzenputzel", "FINCON" }, { "TEST3", "Claudia", "Energer", "HR" },
        { "TEST4", "Stefan", "Papa", "CONSUL" } };

    /**
     * @param args .
     * @throws Exception .
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* Create session using Adabas Java Connection string */
            /* StoreRequest handle insert statements. */
            StoreRequest request = AdabasConnection.createSession("acj:target=" + dbid).createStoreRequest(ADA_FILENR);
            request.addStoredFields(ADA_FIELDS);

            /*
             * Adabas file handler reads file definition in Adabas and provide corresponding field types to work with.
             */
            for (Object[] dataEntry : DATA_MATRIX) {
                /* Create an record entry for each matrix object */
                RecordEntry entry = request.createRecordEntry();
                for (int i = 0; i < ADA_FIELDS.length; i++) {
                    String field = ADA_FIELDS[i];
                    /* Receive field type out of file handler */
                    entry.addValue(field, dataEntry[i]);
                }
                request.storeEntry(entry);
            }

            /* Put entries in request */
            request.endTransaction();

            /* Show ISN values for result */
            for (RecordEntry recordEntry: request.getEntryList()) {
                System.out.println("new ISN: " + recordEntry.getIsn());
            }

            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
