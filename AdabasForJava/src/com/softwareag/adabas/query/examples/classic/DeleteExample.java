/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: DeleteExample.java 6276 2017-09-11 15:00:33Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import java.util.ArrayList;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.DeleteRequest;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.SearchTree;
import com.softwareag.adabas.query.SearchTree.C;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. A search criteria
 * is given to search for all records where AA values starts with "TEST". The
 * StoreDataUsingAdabasNotation examples
 * store fields with TEST* in AA. All records that meet the search criteria will
 * be deleted.
 *
 * prereq.: demo database started using file 11 StoreDataUsingAdabasNotation
 * executed
 */

public abstract class DeleteExample {

    private static final int ADA_FILENR = 11;

    private static final String ADA_SEARCH_FIELD = "AA";

    private static final String[] ADA_DATA_FIELDS = { "AA" };

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 4;

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

            /*
             * Define search tree, one node for lower limit and one node for
             * upper limit.
             * Search for all AA entries in "TEST" <= x < "TESTX"
             *
             * Create an search tree node with the value greater equal and the
             * corresponding
             * "TEST" value content. It's possible to reference value directly
             * SearchTree lowerTre2e =
             * request.createSearchNode(ADA_SEARCH_FIELD, C.GE,"TEST");
             * or with an separate call
             */
            SearchTree lowerTree =
                            request.createSearchNode(ADA_SEARCH_FIELD, C.GE);
            lowerTree.setValue("TEST".getBytes());
            /* Upper limit define all AA data less then "TESTX" */
            SearchTree upperTree =
                            request.createSearchNode(ADA_SEARCH_FIELD, C.LT);
            upperTree.setValue("TESTX".getBytes());

            /* Combine both search tree nodes with an AND logic */
            lowerTree.bound(upperTree, SearchTree.Logic.AND);
            request.setSearchTree(lowerTree);

            /* Send request and receive result in ISN order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
            ArrayList<Long> isnList = new ArrayList<>();
            System.out.print("Delete ISNs: ");
            for (IRecordEntry rec : list) {
                System.out.print(" " + rec.getIsn());
                isnList.add(rec.getIsn());
            }

            System.out.println();

            /*
             * Delete evaluated list of records (ISN's) In addition the
             * DeleteRequest.deleteRecord(isn) method can be
             * used
             */
            try (DeleteRequest deleteRequest = new DeleteRequest(request)) {
                deleteRequest.setIsnList(isnList.toArray(new Long[0]));
                deleteRequest.deleteRecords();
                deleteRequest.endTransaction();
            }
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }

}
