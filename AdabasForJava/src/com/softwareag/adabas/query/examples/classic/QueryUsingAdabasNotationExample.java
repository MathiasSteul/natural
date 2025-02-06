/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: QueryUsingAdabasNotationExample.java 6083 2017-06-27 15:15:18Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. Read (with hold) all records where name="SMITH" and
 * increase salary by 10%
 *
 * prereq.: demo database started using file 11
 */

public abstract class QueryUsingAdabasNotationExample {

    private static final int ADA_FILENR = 11;

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AS[N]" };

    private static final String ADA_SEARCH_FIELD = "AE";

    private static final String ADA_SEARCH_VALUE = "SMITH";

    private static final String ADA_SHORT_FOR_FIRSTNAME = "AC";

    private static final String ADA_SHORT_FOR_NAME = "AE";

    private static final String ADA_SHORT_FOR_SALARY = "AS";

    private static final String ADA_SESSION_USER = "ACJ";

    /**
     * @param args
     * @throws QueryException
     */
    public static void main(final String[] args) throws QueryException {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        AdabasConnection connection =
            AdabasConnection.createSession("acj:target=" + dbid
                + ";auth=NONE,user=" + ADA_SESSION_USER);

        /* The transaction class lets all read data to be set in hold. */
        try (ReadRequest request = connection.createReadRequest(ADA_FILENR)) {
            request.setHold(true);
            request.queryFields(ADA_DATA_FIELDS);

            /*
             * Define range for the result set and search criteria A limit=0
             * will read the whole dataset in the file/table.
             */
            request.setStart(0);
            request.setLimit(0);
            request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);

            /* Send the request to Adabas and receive result */
            QueryResultList list = (QueryResultList) request.readIsnSequence();

            /* Internal output method() to send it to any output writer */
            list.output(System.out);

            /* Analyse result set */
            System.out.println("Found " + list.size() + " entries:");

            for (IRecordEntry record : list) {

                /* Get field value in Adabas notation */
                IAdaFieldValue fieldValueFirstName =
                    record.valueOfbyShortName(ADA_SHORT_FOR_FIRSTNAME);
                IAdaFieldValue fieldValueName =
                    record.valueOf(ADA_SHORT_FOR_NAME);
                IAdaFieldValue fieldSalary =
                    record.valueOfbyShortName(ADA_SHORT_FOR_SALARY);

                /* String representation of value */
                System.out.println(String.format("%4d %-20s %-20s %8d",
                    record.getIsn(), fieldValueFirstName.toString(),
                    fieldValueName.toString(), fieldSalary.longValue()));
            }

        } catch (QueryException exception) {
            System.out.println("Error "+exception.getMessage());
            exception.printStackTrace();
        }
    }
}
