/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: ReadWithMappingGroupedExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.util.Collections;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.QueryResultGrouped;
import com.softwareag.adabas.query.ReadRequest;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This examples read data in ISN sequence using demo file 11 and long names defined
 * in EmployeeMap.
 *
 * prereq.: demo database started GenerateExampleMappings executed
 */

public abstract class ReadWithMappingGroupedExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final String LASTNAME_FIELD = "LastName";
    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";
    private static final String EMPLOYEE_DEPARTMENT = "Department";

    private static final int MAX_RECORDS = 200;

    private static final String[] ADA_LN_FIELDS = { EMPLOYEE_DEPARTMENT };

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        AdabasConnection connection = AdabasConnection.createSession(
            "acj:map;config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");

        try (
            /* Create request with an example map */
            ReadRequest originRequest =
                connection.createReadRequest(ADA_EMPNAT_MAPNAME)) {

            /* Define range for the result set */
            originRequest.setStart(0);
            originRequest.setLimit(MAX_RECORDS);

            /* Need to set the view or the list of fields in the result set */
            originRequest.addFieldsQuery(ADA_LN_FIELDS);
            originRequest.addFunction("SalarySum", "Salary[N]",
                (x, y) -> x + y);
            originRequest.setSearch(LASTNAME_FIELD + "='SMITH'");
            originRequest.sortedBy(Collections.singleton(EMPLOYEE_DEPARTMENT));

            /*
             * Send request and receive result. Employees named SMITH should be
             * grouped by
             * the department and the last salary should be summarized.
             */
            QueryResultGrouped originResult = originRequest.readByGrouping();
            while (originResult.hasNext()) {
                RecordEntry record = originResult.next();
                System.out.println(record.toString());
            }
        } catch (QueryException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

}
