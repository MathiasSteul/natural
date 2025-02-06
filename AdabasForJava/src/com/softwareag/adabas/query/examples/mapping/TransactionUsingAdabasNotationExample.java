/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: TransactionUsingAdabasNotationExample.java 6232 2017-08-28 14:52:41Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.util.Collections;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.mapping.AdabasMapperRepositories;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.StoreRequest;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. Read (with hold) all records where name="SMITH" and
 * increase salary by 10%
 *
 * prereq.: demo database started using file 11
 */

public abstract class TransactionUsingAdabasNotationExample {

    private static final int TIMEOUT = 10000;

    private static final int ADA_FILENR = 11;

    private static final String LASTNAME_FIELD = "LastName";
    private static final String FIRSTNAME_FIELD = "FirstName";
    private static final String SALARY_FIELD = "Salary";

//    private static final int MAX_RECORDS = 200;

    private static final String[] ADA_LN_FIELDS =
        { FIRSTNAME_FIELD, LASTNAME_FIELD, SALARY_FIELD };

    private static final String ADA_SEARCH_FIELD = LASTNAME_FIELD;

    private static final String ADA_SEARCH_VALUE = "SMITH";

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws QueryException {

        /* get database */
        int dbid;
        if (args.length > 0) {
            dbid = Integer.parseInt(args[0]);
        } else {
            DemoDbid id = new DemoDbid();
            id.setkbdDbid();
            dbid = id.getDbid();
        }

        /* simple Adabas Database target definition (dbid) */
        AdabasTarget target = new AdabasTarget(dbid);

        /*
         * Register database map configuration location where the Adabas Client
         * for Java API will search for map
         * definitions. The notation is similar to use AdabasConnection with
         * ReadRequest request = AdabasConnection
         * .createSession("ajc:map:EmployeeMap;config=[24,4]")
         * .createReadRequest(11);
         */
        AdabasMapperRepositories.addMapStorage(target, ADA_FILE_DATA_DESIGNER);

        AdabasConnection connection = AdabasConnection.createSession("acj:map");

        /* The transaction class lets all read data to be set in hold. */
        try (ReadRequest request =
            connection.createReadRequest(ADA_EMPNAT_MAPNAME)) {
            request.setHold(true);
            request.queryFields(ADA_LN_FIELDS);

            /*
             * Define range for the result set and search criteria A limit=0
             * will read the whole dataset in the file/table.
             */
            request.setStart(0);
            request.setLimit(0);
            request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);

            /* Send the request to Adabas and receive result */
            QueryResultList list = (QueryResultList) request.readIsnSequence();

            /* Records should be in hold now */
            System.out.println("Records should be in hold now");
            Thread.sleep(TIMEOUT);

            /* Internal output method() to send it to any output writer */
            list.output(System.out);

            /* Analyse result set */
            System.out.println("Found " + list.size() + " entries:");
            StoreRequest storeRequest =
                connection.createStoreRequest(ADA_FILENR);
            storeRequest
                .addStoredFields(Collections.singletonList(SALARY_FIELD));

            for (IRecordEntry record : list) {
                IRecordEntry storeRecord = storeRequest.createRecordEntry();
                storeRecord.setIsn(record.getIsn());

                /* Get field value in Adabas notation */
                IAdaFieldValue fieldValueFirstName =
                    record.valueOf(FIRSTNAME_FIELD);
                IAdaFieldValue fieldValueName = record.valueOf(LASTNAME_FIELD);
                int quantity = record.fieldQuantity(SALARY_FIELD);
                long oldValue =
                    record.valueOf(SALARY_FIELD, quantity).longValue();

                /* Calculate new value */
                long value = oldValue + (oldValue / 10);

                /* String representation of value */
                System.out.println(String.format(
                    "ISN=%4d %-20s %-20s old salary=%8d -> new salary=%8d",
                    record.getIsn(), fieldValueFirstName.toString(),
                    fieldValueName.toString(), oldValue, value));
                /* Add new period group entry */
                storeRecord.addValue(SALARY_FIELD, value, quantity + 1);

                /* Send/Update new value */
                storeRequest.updateEntry(record);
            }
            System.out.println("Sleep waiting to transaction");
            /* Records should be in hold */
            Thread.sleep(TIMEOUT);
            System.out.println("Done Sleep");

            /* Send end of transaction */
            connection.endTransaction();

            /* Close connection to database */
        } catch (QueryException | InterruptedException e) {
            System.out.println("Error " + e.getMessage());
            e.printStackTrace();
        }
    }
}
