/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: SuperdescriptorSearchExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.SearchTree;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. A search criteria
 * is given to search for all records where value of AE field is equal "SMITH".
 * 
 * prereq.: demo database started using file 11
 */

public abstract  class SuperdescriptorSearchExample {

    private static final int ADA_FILENR = 11;

    private static final String ADA_DATA_GROUP = "AB";
    
    private static final String ADA_SEARCH_FIELD = "S2";

    private static final String[] ADA_DATA_FIELDS =
        { ADA_SEARCH_FIELD, ADA_DATA_GROUP };
    
    private static final String ADA_SEARCH_VALUE = "'SALE02' 'SMITH'";
    
    private static final String ADA_SEARCH_VALUE_TO = "'SALE02' 'ZZ'";

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 1000;

    private SuperdescriptorSearchExample() {
    }


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
            /* simple Adabas Database target definition (dbid) */
            AdabasTarget target = new AdabasTarget(dbid);
            target.open();

            /* Create read request using the database target file number */
            ReadRequest request = new ReadRequest(target, ADA_FILENR);

            /* Set list of Adabas short name fields for read request */
            request.queryFields(ADA_DATA_FIELDS);

            /*
             * Define range for the result set. Set start ISN offset and a
             * maximum value of records to return. 
             * Set search criteria - i.e.:  S2 >= "'SALE02' 'SMITH'" && 
             *                              S2 <= "'SALE02' 'ZZ'"
             */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);

            SearchTree superDescriptorSearchS2 = request.createSearchNode(
                ADA_SEARCH_FIELD, SearchTree.C.GE, ADA_SEARCH_VALUE);
            SearchTree superDescriptorSearchS2To = request.createSearchNode(
                ADA_SEARCH_FIELD, SearchTree.C.LE, ADA_SEARCH_VALUE_TO);
            superDescriptorSearchS2.bound(superDescriptorSearchS2To,
                SearchTree.Logic.AND);
            request.setSearchTree(superDescriptorSearchS2);

            /* Send request and receive result in ISN order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();

            /* Use an internal output method to output data */
            list.output(System.out);
            if (list.size() > 0) {
                /*
                 * first value in list :
                 * IAdaFieldValue fieldValue =
                 * list.get(0).valueOf(ADA_SEARCH_FIELD);
                 */
                System.out.println("search criteria -> " + ADA_SEARCH_FIELD
                    + " >= '" + ADA_SEARCH_VALUE + "' && " + ADA_SEARCH_FIELD
                    + " <= '" + ADA_SEARCH_VALUE_TO + "'");
            }
            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
