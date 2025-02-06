/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: MappingPeriodGroupExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.IRecordTraverser;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This example uses Mapping notation in combination with period group. See output of
 * Period Group AQ
 *
 * prereq.: demo database started using file 11
 */

public abstract class MappingPeriodGroupExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final int START_ISN = 250;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final int MAX_RECORDS = 200;

    /**
     * Database entry
     * Id -> AA - Unique Id
     * Name -> AB - Name group
     * Income -> AQ - Perido group containing salaray and bonux
     */
    private static final String[] ADA_LN_FIELDS = { "Id", "Name", "Income" };

    /**
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        /* Create session using Adabas Java Connection string */
        AdabasConnection connection =
            AdabasConnection.createSession("acj:map=" + ADA_EMPNAT_MAPNAME
                + ";config=[" + dbid + "," + ADA_FILE_DATA_DESIGNER + "]");

        /* Create request containing needed parameters */
        try (ReadRequest request = connection.createReadRequest()) {

            /* Define range and fields for the result set */
            request.setStart(START_ISN);
            request.setLimit(MAX_RECORDS);
            request.addFieldsQuery(ADA_LN_FIELDS);

            /* Send request and receive result */
            IQueryResult result = request.readIsnSequence();

            /*
             * Example evaluation getting all data in period group.
             *
             * Output for each record:
             * {FirstName:ANTONIO,LastName:PUERTOLAS}: Number of Income entries : 4
             * Salary 10578
             * 1 -> Id[-1,-1]=60008107
             * 1 -> Name[-1,-1]={FirstName:ANTONIO,LastName:PUERTOLAS}
             * 2 -> FirstName[-1,-1]=ANTONIO
             * 2 -> LastName[-1,-1]=PUERTOLAS
             * 1 ->
             * Income[-1,-1]={Salary[1]:10578,Bonus[1]:}{Salary[2]:10481,Bonus[2]:}{
             * Salary[3]:10433,Bonus[3]:}{Salary[4]:10120,Bonus[4]:}
             * 2 -> Salary[1,-1]=10578
             * 2 -> Bonus[1,-1]=
             * 2 -> Salary[2,-1]=10481
             * 2 -> Bonus[2,-1]=
             * 2 -> Salary[3,-1]=10433
             * 2 -> Bonus[3,-1]=
             * 2 -> Salary[4,-1]=10120
             * 2 -> Bonus[4,-1]=
             *
             */
            result.list().forEach(record -> {
                try {
                    System.out.println(
                        record.valueOf("Name") + ": Number of Income entries : "
                            + record.fieldQuantity("Income"));
                    System.out.println("Salary " + record.valueOf("Salary", 1));
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
                } catch (QueryException e) {
                    e.printStackTrace();
                }
            });
        } catch (QueryException e) {
            System.out.println(e.getMessage());
        }
    }
}
