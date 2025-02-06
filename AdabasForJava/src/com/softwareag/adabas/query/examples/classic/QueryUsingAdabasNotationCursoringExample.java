/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: QueryUsingAdabasNotationCursoringExample.java 6083 2017-06-27 15:15:18Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.jdc.security.AdabasSecurityHandler.AuthType;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.query.AdabasSession;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultCursor;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. Read (with hold) all records where name="SMITH" and
 * increase salary by 10%
 * 
 * prereq.: demo database started using file 11
 */

public abstract class QueryUsingAdabasNotationCursoringExample {

    private static final int ADA_FILENR = 11;

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "ASN" };

    private static final String ADA_SEARCH_FIELD = "AE";

    private static final String ADA_SEARCH_VALUE = "SMITH";

    private static final String ADA_SESSION_USER = "ACJ";

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws QueryException {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        /* simple Adabas Database target definition (dbid) */
        AdabasTarget target = new AdabasTarget(dbid);

        /*
         * Setting target implicit close to false will not send a CL(close) call to
         * Adabas. The target need to be closed explicitly.
         * This option needed to be used if a number of Requests are done in series.
         */
        target.setImplicitClose(false);

        try {
            AdabasSession session =
                new AdabasSession(AuthType.NONE);
            session.setUser(ADA_SESSION_USER);

            try (ReadRequest request =
                new ReadRequest(target, session, ADA_FILENR)) {
                request.queryFields(ADA_DATA_FIELDS);

                /*
                 * Define range for the result set and search criteria A limit=0
                 * will read the whole dataset in the file/table.
                 */
                request.setStart(0);
                request.setLimit(0);
                request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);

                /* Send the request to Adabas and receive result per cursoring */
                QueryResultCursor cursor = request.readByCursor();

                /*
                 * Check if all records are read. If next record is available, then
                 * read next. ACJ will read records in junks and not all together.
                 */
                while (cursor.hasNext()) {
                    RecordEntry entry = cursor.next();
                    System.out.println("Record : " + entry.toString());
                }

                /* Close connection to database */
            } catch (QueryException e) {
                System.out.println(e.getMessage());
            }
        } finally {
            /*
             * Because of target is set not to call an implict close to the database,
             * the application need to do that explicitly.
             */
            target.close();
        }
    }
}
