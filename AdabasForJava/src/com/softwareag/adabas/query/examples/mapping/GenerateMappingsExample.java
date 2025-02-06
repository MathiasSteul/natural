/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: GenerateMappingsExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.config.QueryMapConfig;
import com.softwareag.adabas.mapping.AdabasMapper;
import com.softwareag.adabas.query.AdabasTarget;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This Java application generates some example maps in the Adabas Data Designer
 * file. The Adabas file number to store
 * Data Designer metadata is set to be 4 as default. Currently, only Data Designer
 * allows you to create this file.
 * 
 * prereq.: demo database started and metadata file exists
 */

public abstract class GenerateMappingsExample {

    private static final int ADA_FILE_DATA_DESIGNER = 4;

    private static final int ADA_EMPNAT_DEMO_FILE = 11;

    private static final int ADA_VEHICLE_DEMO_FILE = 12;

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";

    private static final String ADA_VEHICLE_MAPNAME = "VehicleMap";

    /**
     * An Employee example mapping from short to long name
     */
    private static final String[][] FIELD_DEFINITION_EMPLOYEE =
        { { "AA", "Id" }, { "AB", "Name" }, { "AC", "FirstName" },
            { "AE", "LastName" }, { "AQ", "Income" }, { "AS", "Salary" },
            { "AT", "Bonus" }, { "AO", "Department" }, { "AP", "JobTitle" },
            { "AJ", "City" } };

    /**
     * An Vehicle example mapping from short to long name
     */
    private static final String[][] FIELD_DEFINITION_VEHICLE =
        { { "AD", "Vendor" }, { "AE", "Model" }, { "AF", "Color" } };

    /**
     * Defines name for a mapping configuration
     */
    private static final Object[][] MAP_DEFINITION = {
        { ADA_EMPNAT_MAPNAME, ADA_EMPNAT_DEMO_FILE, FIELD_DEFINITION_EMPLOYEE },
        { ADA_VEHICLE_MAPNAME, ADA_VEHICLE_DEMO_FILE,
            FIELD_DEFINITION_VEHICLE } };

    /**
     * Creates a new map. Here the data and config are stored in the same database
     * 
     * @param configStub
     * @param mapFile
     * @throws Exception
     */
    public static void createAdabasMapper(final AdabasTarget configStub,
        final AdabasTarget dataStub, final int mapFile) throws Exception {
        for (Object[] mapDef : MAP_DEFINITION) {
            QueryMapConfig qmp =
                new QueryMapConfig(configStub, mapFile, (String) mapDef[0]);
            AdabasMapper adabasMapper =
                new AdabasMapper(qmp, dataStub, (Integer) mapDef[1]);
            String[][] fields = (String[][]) mapDef[2];
            for (String[] field : fields) {
                adabasMapper.addField(field[0], field[1], "");
            }
            adabasMapper.storeConfig();
            System.out.println("sample " + mapDef[0] + " for Adabas demo file "
                + mapDef[1] + " defined ");
        }
    }

    /**
     * Start the storage of example maps in the database.
     * 
     * @param args No args used
     * @throws Exception Error during processing
     */
    public static void main(final String[] args) throws Exception {

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* simple Adabas Database target definition (dbid) */
            AdabasTarget target = new AdabasTarget(dbid);

            /* add sample mapping definitions */
            createAdabasMapper(target, target, ADA_FILE_DATA_DESIGNER);
        } catch (QueryException qe) {
            System.out.println(qe.getMessage());
            if ("ACJ00064".equals(qe.getMessageCode())) {
                System.out.println("note: Please delete existing map entries "
                    + ADA_EMPNAT_MAPNAME + ", " + ADA_VEHICLE_MAPNAME
                    + " using Data Designer");
            }
        }
    }
}
