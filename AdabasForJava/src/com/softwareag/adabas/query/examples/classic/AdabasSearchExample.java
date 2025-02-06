/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: AdabasSearchExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import java.nio.charset.Charset;
import java.util.InputMismatchException;
import java.util.Locale;
import java.util.Scanner;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and short name for fields. A search criteria
 * is given to search for all records where value of AE field is equal "SMITH".
 * 
 * prereq.: demo database started using file 11
 */

public abstract class AdabasSearchExample {
	
    private static final int ADA_FILENR = 10;
    
    private static final int ADA_DBID = 103;

    private static final String ADA_SEARCH_FIELD = "AC";

    private static final String ADA_SEARCH_VALUE = "SIECA";

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AC", "PE" };

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 1000;

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        try {
            /* simple Adabas Database target definition (dbid) */
            AdabasTarget target = new AdabasTarget(ADA_DBID);
            target.open();
                                  
            target.setCharset(Charset.forName("windows-1252"));
 
            /* Create read request using the database target file number */
            ReadRequest request = new ReadRequest(target, ADA_FILENR);

            /* Set list of Adabas short name fields for read request */
            request.queryFields(ADA_DATA_FIELDS);

            /*
             * Define range for the result set. Set start ISN offset and a maximum value of records to return. Set
             * search criteria - i.e. AE='SMITH'
             */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);

            /* Send request and receive result in ISN order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();

            /* Use an internal output method to output data */
            list.output(System.out);
            
            // System.out.println(list.get(1).getFieldTypeList().toString());
            
            if (list.size() > 0) {
                IAdaFieldValue fieldValue = list.get(0).valueOf(ADA_SEARCH_FIELD);
                System.out.println("search criteria -> " + ADA_SEARCH_FIELD + " = " + fieldValue.toString());
            }
            request.close();
            
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }

    }

}
