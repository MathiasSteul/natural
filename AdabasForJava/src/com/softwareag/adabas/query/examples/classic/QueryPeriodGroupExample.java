/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: QueryPeriodGroupExample.java 6083 2017-06-27 15:15:18Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.IRecordTraverser;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and short
 * name for fields. See output of
 * Period Group AQ
 * 
 * prereq.: demo database started using file 11
 */

public abstract class QueryPeriodGroupExample {

    private static final int ADA_FILENR = 10;

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 200;

    private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AC" , "PE" };

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
 //           ReadRequest request =
 //               AdabasConnection.createSession("acj:target=" + dbid)
 //                   .createReadRequest(ADA_FILENR);
            ReadRequest request =
                    AdabasConnection.createSession("acj:target=" + dbid)
                        .createReadRequest(ADA_FILENR);


            /* Define range and fields for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            request.addFieldsQuery(ADA_DATA_FIELDS);

            /* Send request and receive result */
            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
            request.close();
            list.forEach(record -> {
                try {
                    record.traverse(new IRecordTraverser() {
                        @Override
                        public boolean traverse(final int level,
                            final IRecordEntry entry,
                            final IAdaFieldValue value) {
                            String prefix = "";
                            if (value.getType()
                                .getType() != IDataTypes.Types.TYPE_PERIOD_GROUP) {
                                prefix = "  ";
                            }
                            System.out.println(prefix + String.format(
                                "%d -> %s[%d,%d]=%s", level,
                                value.getType().getName(), value.getPeIndex(),
                                value.getMuIndex(), value.toString()));
                            return true;
                        }
                    });
                } catch (QueryException exception) {
                    System.err.println("Error display records : "
                        + exception.getLocalizedMessage());
                }
            });
        } catch (QueryException exception) {
            System.out.println(exception.getMessage());
        }
    }
}
