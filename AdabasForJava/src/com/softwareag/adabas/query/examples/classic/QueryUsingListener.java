/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: QueryUsingListener.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.IEntryCollector;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

public class QueryUsingListener implements IEntryCollector {

    private static final int ADA_FILENR = 11;

    private static final String[] ADA_DATA_FIELDS = { "AA", "AE" };

    private static final int START_ISN = 1;

    private static final int MAX_RECORDS = 200;

    /*
     * (non-Javadoc)
     * 
     * @see com.softwareag.adabas.query.IEntryCollector#entryProcessing(com.softwareag
     * .adabas.query.parser.interfaces.IRecordEntry)
     */
    @Override
    public final boolean entryProcessing(final IRecordEntry adaEntry) throws QueryException {
        /* output entries found during query, no memory used to store the list */
        System.out.println("-  ISN: " + adaEntry.getIsn() + String.format("[%x]", adaEntry.getIsn()) + " ISNQ: "
            + adaEntry.getIsnQuantity());
        for (IAdaFieldValue d : adaEntry.getFieldValues()) {
            String name = d.getType().getName();
            if (!name.equals(d.getType().getShortName())) {
                name += "(" + d.getType().getShortName() + ")";
            }
            System.out.println(" " + name + ": " + d.toString());
        }
        return true;
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
            /* Create session using Adabas Java Connection string */
            /* Create request containing needed parameters */
            ReadRequest request = AdabasConnection.createSession("acj:target=" + dbid).createReadRequest(ADA_FILENR);

            /* Define range for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            request.setEntryCollector(new QueryUsingListener());

            /* Define list of fields which need to be read */
            request.addFieldsQuery(ADA_DATA_FIELDS);

            /* Send request and receive result */
            IQueryResult result = request.readIsnSequence();
            System.out.println("Error code=" + result.getRsp() + ", overall records in result="
                + result.getNumberRecords());
            request.close();
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
