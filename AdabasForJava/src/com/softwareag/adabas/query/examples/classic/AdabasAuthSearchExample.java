/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: AdabasAuthSearchExample.java 6083 2017-06-27 15:15:18Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import java.io.Console;
import java.nio.charset.Charset;
import java.util.InputMismatchException;
import java.util.Scanner;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.jdc.security.AdabasSecurityHandler.AuthType;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.query.AdabasSession;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example supports new security feature for Adabas on LUW (Authentication)
 * and asks for identification through credentials if required.
 * 
 * Adabas classic notation like database id, file number and short name for
 * fields, as well as a search criteria is given to search for all records where
 * value of AE field is equal "SMITH".
 * 
 * prereq.: demo database started using file 11
 */

public abstract class AdabasAuthSearchExample {

    private static final int ADA_FILENR = 12;

    private static final String ADA_SEARCH_FIELD = "AC";

    private static final String ADA_SEARCH_VALUE = "SIECA";

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AC","M1","PE","PM" };

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 1000;

    private static final int NOT_EXPECTED_RC = 1;

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        String username = "";
        String password = "";
        AdabasTarget target = null;
        AdabasSession session = null;
        Scanner sc = new Scanner(System.in);
        int dbid = 0;

        /* get valid database id */
        do {
            System.out.print(
                "\n*** Please enter valid dbid of your Adabas Demo Database [1 .. 255] > ");
            try {
                dbid = sc.nextInt();
            } catch (InputMismatchException ime) {
                sc.next();
            }
        } while ((dbid < 1) || (dbid > 255));

        /*
         * simple Adabas Database target definition, but catch security
         * violation and ask for credentials
         */
        try {
            target = new AdabasTarget(dbid);
            target.open();
        } catch (QueryException qe) {
            if ((qe.getMessageIndex() == 30)
                && (qe.getMessage().contains("Security violation"))) {
                System.out.println(
                    "  Security violation - Please enter your username and password.");

                Console console = System.console();
                if ((console == null)) {
                    System.out.println(
                        "    warning: Couldn't get Console instance ... disable echoing not possible !");
                    System.out.print("  Username > ");
                    username = sc.next();
                    System.out.print("  Password > ");
                    password = sc.next();
                } else {
                    /*
                     * Console available ... hide password possible !
                     */
                    System.out.print("Username > ");
                    username = sc.next();
                    System.out.print("Password > ");
                    password = new String(console.readPassword());
                }
                sc.close();

                /* add credentials to access ssx protected database */
                session = new AdabasSession(AuthType.ADA_PW_SECURITY);
                session.addCredentials(username.getBytes(),
                    password.getBytes());
                target.setSession(session);
                target.setCharset(Charset.forName("windows-1252"));

            } else {
                sc.close();
                System.out.println(qe.getMessage());
                System.exit(NOT_EXPECTED_RC);
            }
        }

        /* Create read request using the database target file number */
        try {
            ReadRequest request = new ReadRequest(target, ADA_FILENR);

            /* Set list of Adabas short name fields for read request */
            request.queryFields(ADA_DATA_FIELDS);

            /*
             * Define range for the result set. Set start ISN offset and a
             * maximum value of records to return. Set search criteria - i.e.
             * AE='SMITH'
             */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);

            /* Send request and receive result in ISN order */
            QueryResultList list = (QueryResultList) request.readIsnSequence();

            /* Use an internal output method to output data */
            list.output(System.out);
            if (list.size() > 0) {
                IAdaFieldValue fieldValue =
                    list.get(0).valueOf(ADA_SEARCH_FIELD);
                System.out.println("search criteria -> " + ADA_SEARCH_FIELD
                    + " = " + fieldValue.toString());
            }
            /* request implicit closes target instance */
            request.close();
        } catch (QueryException qerequest) {
            System.out.println(qerequest.getMessage());
        }

    }

}
