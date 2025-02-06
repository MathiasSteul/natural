/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: QueryAdabasSpecialSearchExample.java 6083 2017-06-27 15:15:18Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldType;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.SearchTree;
import com.softwareag.adabas.query.SearchTree.C;

/**
 * This example uses Adabas classic notation like database id, file number and short name for fields. A search criteria
 * is given to search for all records where value of a field is between given lower and upper limit.
 *
 * prereq.: demo database started using file 11
 */

public abstract class QueryAdabasSpecialSearchExample {

    private static final int ADA_FILENR = 11;

    private static final String ADA_SEARCH_FIELD = "AE";

    private static final String[] ADA_DATA_FIELDS = { ADA_SEARCH_FIELD };

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 1000;

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
            /* Create session using Adabas Java Connection string */
            /* Create request containing needed parameters */
            ReadRequest request = AdabasConnection.createSession("acj:target=" + dbid).createReadRequest(ADA_FILENR)
                            .queryFields(ADA_DATA_FIELDS);

            /* Define range for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);

            /* Get field type for a field */
            IAdaFieldType lastName = request.getDefinition().searchAllFieldsByShortName(ADA_SEARCH_FIELD);

            /* Define search tree, one value for lower and upper limit */
            SearchTree lowerTree = new SearchTree(C.GE, lastName.getFieldValue());
            lowerTree.setValue("SCHNEIDER".getBytes());
            SearchTree upperTree = new SearchTree(C.LT, lastName.getFieldValue());
            upperTree.setValue("SD".getBytes());
            lowerTree.bound(upperTree, SearchTree.Logic.AND);
            request.setSearchTree(lowerTree);

            /* Send request and receive result in descriptor order */
            QueryResultList list = (QueryResultList) request.histogramWith(ADA_SEARCH_FIELD+">='SCHNEIDER' AND "+ADA_SEARCH_FIELD+"<'SD'");
            list.output(System.out);
            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
