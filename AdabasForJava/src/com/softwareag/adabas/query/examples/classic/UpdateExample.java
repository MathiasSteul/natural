/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: UpdateExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.StoreRequest;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. A search criteria
 * is given to search for all records where AE is equal "SMITH". The
 * UpdateExample examples
 * update received field with new name "SMITH+" in AE. All records that meet the
 * search criteria will be updated.
 * 
 * prereq.: demo database started using file 11
 * (Attention the example file will be modified)
 */
public abstract class UpdateExample {

    private static final int ADA_FILENR = 11;

    private static final String ADA_SEARCH_FIELD = "AE";

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AS[N]" };

    private static final int START_ISN = 1;

    /* Update all entries */
    private static final int MAX_RECORDS = 0;

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        /*
         * Creates Adabas session using Adabas Java Connection string
         *
         * The createReadRequest creates a ReadRequest instance which
         * handle all read specific tasks. Each ReadRequest instance
         * could be enriched with fields and parameters used during
         * read out of the database.
         * 
         * The ReadRequest instance could be created using a
         * AdabasConnection or using a ReadRequest constructor. The
         * AdabasConnection is used if the application should work with
         * one Adabas session on different read/read or read/write
         * combinations.
         * 
         * In this example a third alternative is used if a given
         * request instance could be used as template for another
         * request task.
         * 
         */
        try (ReadRequest request =
            AdabasConnection.createSession("acj:target=" + dbid)
                .createReadRequest(ADA_FILENR)) {
            request.addFieldsQuery(ADA_DATA_FIELDS);

            /* Define range for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            /* Set read entries in hold */
            request.setHold(true);

            /*
             * Define search tree, one node for lower limit and one node for
             * upper limit.
             * Search for all AE entries in "SMITH" here the 
             */
            request.setSearch("AE=SMITH");
            /* Alternative search tree definition which can be used for complex searches:
               SearchTree lowerTree =
                request.createSearchNode(ADA_SEARCH_FIELD, C.EQ);
               lowerTree.setValue("SMITH");
                request.setSearchTree(lowerTree);
            */

            /* Send request and receive result in ISN order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
            try (StoreRequest storeRequest = new StoreRequest(request)) {
                for (IRecordEntry readEntry : list) {
                    /* Here the new value will be set into the record entry. */                    
                    readEntry.valueOf(ADA_SEARCH_FIELD).setValue("SMITH+");
                    
                    /*
                     * The store request can either insert or update an given entry.
                     * A new entry will by generate using
                     * storeRequest.createRecordEntry(fields)
                     * an update need to be read using ReadRequest to take the Adabas
                     * reference out of the databsae (ISN)
                     */
                    storeRequest.updateEntry(readEntry);
                }
                /* The final end of transaction call */
                storeRequest.endTransaction();
            }

        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }

}
