/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: QueryAdabasAdvancedSearchExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.SearchTree;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. A search criteria is given to search using
 * a sub descriptor.
 * 
 * prereq.: demo database started using file 11
 */

public abstract class QueryAdabasAdvancedSearchExample {

    private static final int ADA_FILENR = 11;

    /* Use sub descriptor to search for */
    private static final String ADA_SEARCH_FIELD = "S1";

    private static final String ADA_SEARCH_VALUE = "SALE";

    private static final String ADA_DATA_GROUP = "AB";

    private static final String[] ADA_DATA_FIELDS =
        { ADA_SEARCH_FIELD, ADA_DATA_GROUP };

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
            ReadRequest request =
                AdabasConnection.createSession("acj:target=" + dbid)
                    .createReadRequest(ADA_FILENR).queryFields(ADA_DATA_FIELDS);

            /* Define range for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);

            /* Define search tree */
            SearchTree subDescriptorSearch =
                request.createSearchNode(ADA_SEARCH_FIELD, SearchTree.C.GE);
            subDescriptorSearch.setValue(ADA_SEARCH_VALUE);
            request.setSearchTree(subDescriptorSearch);

            /* Send request and receive result in descriptor order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
