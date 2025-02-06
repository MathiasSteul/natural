/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: AdabasToCsv.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.mapping.AdabasMapperRepositories;
import com.softwareag.adabas.parser.DynamicRecordEntry;
import com.softwareag.adabas.parser.interfaces.IAdaFieldType;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes.Types;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.parser.type.AdaStructureType;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.IEntryCollector;
import com.softwareag.adabas.query.ReadRequest;

import com.softwareag.adabas.query.examples.classic.DemoDbid;

/**
 * This example reads Adabas file records and stores them as so-called CSV file.
 * To keep it simple, period groups (PE) and Multiple fields (MU) are excluded.
 * 
 * prereq.: database started using demo file 11 GenerateExampleMappings executed
 * 
 */
public class AdabasToCsv implements IEntryCollector {

    private static final String ADA_EMPNAT_MAPNAME = "EmployeeMap";
    private static final int ADA_FILE_DATA_DESIGNER = 4;
    private static final String[] ADA_LN_FIELDS = { "Id", "FirstName", "LastName",
            "Department" };
    
    private int _counter = 0;
    private boolean _header = true;
    private BufferedWriter _writer = null;
    private final String _filename;
    private final String _mapname;
    private long _limit = 2000;

    /**
     * Constructor for the CSV generation.
     * 
     * @param filename
     *            file name for the CSV file
     * @param mapname
     *            Used <i>Adabas Client for Java</i> Map name
     * @param limit
     *            Maximum number of entries to read
     */
    public AdabasToCsv(final String filename, final String mapname, final long limit) {
        this._mapname = mapname;
        this._filename = filename;
        this._limit = limit;
    }

    /**
     * Create new read request instance handling the session
     * 
     * @return read request instance
     * @throws QueryException
     *             Error evaluating the map name
     */
    private ReadRequest createReadRequest() throws QueryException {
        return new ReadRequest(_mapname);
    }

    /**
     * Start reading the data
     * 
     * @return number of entries read during processing
     * @throws QueryException
     *             Error occurs during read from the database
     * @throws IOException
     *             Error occurs during write into CSV file
     */
    public int process() throws QueryException, IOException {
        _counter = 0;
        try (ReadRequest request = createReadRequest()) {

            /* Define a query using a subset of fields */
            request.queryFields(ADA_LN_FIELDS);

            /* Define a listener which will be executed for each read record */
            request.setEntryCollector(this);

            /* Maximum limit of records to be read in this sequence */
            request.setLimit(_limit);

            /* Read the data in database container in physical order */
            request.readPhysicalSequence();

            if (_writer != null) {
                _writer.close();
            }
            return _counter;
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * com.softwareag.adabas.query.IEntryCollector#entryProcessing(com.softwareag
     * .adabas.parser.interfaces.IRecordEntry)
     */
    @Override
    public boolean entryProcessing(final IRecordEntry adaEntry) throws QueryException {

        if (adaEntry instanceof DynamicRecordEntry) {
            DynamicRecordEntry record = (DynamicRecordEntry) adaEntry;
            try {
                /*
                 * In first call create header, go through each field and add
                 * field name
                 */
                if (_header) {
                    getWriter().write(
                            newHeader(record.getFieldTypeList(), 0, 0)
                                    + "\n");
                    _header = false;
                    System.out.println();
                }
                /* Write data line */
                getWriter().write(newDataLine(record, 0, 0) + "\n");
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
            _counter++;
        }
        /*
         * Activity output for each 100 records read. Each 200 records -> write
         * counter.
         */
        if (_counter % 100 == 0) {
            System.out.print(".");
        }
        if (_counter % 200 == 0) {
            System.out.print(_counter);
        }
        return true;
    }

    /**
     * Create new data line
     * 
     * @param record
     *            Record read
     * @param multiple
     * @param multiple2
     * @return
     */
    private String newDataLine(final DynamicRecordEntry record, final int multiple,
            final int multiple2) {
        StringBuilder sb = new StringBuilder();
        List<IAdaFieldValue> list = record.getFieldValues();
        for (IAdaFieldValue field : list) {
            switch (field.getType().getType()) {
            case TYPE_STRING:
                if (sb.length() != 0) {
                    sb.append(",");
                }
                sb.append(field.toString().trim().replace(",", " "));
                break;

            case TYPE_GROUP:
                for (Object obj : field.getList()) {
                    if (obj instanceof DynamicRecordEntry) {
                        if (sb.length() != 0) {
                            sb.append(",");
                        }
                        sb.append(newDataLine((DynamicRecordEntry) obj, 0, 0));
                    }
                }
                break;

            default:
                System.out.println(field.getType().getName() + "["
                        + field.getType().getShortName() + "]: "
                        + field.getType().getType() + " - " + field);
                System.out.println("*** type missing");
                break;
            }
        }
        return sb.toString();
    }

    private String newHeader(final List<IAdaFieldType> list, final int multiple,
            final int multiple2) {
        StringBuilder sb = new StringBuilder();
        for (IAdaFieldType field : list) {
            switch (field.getType()) {
            case TYPE_STRING:
                if (sb.length() != 0) {
                    sb.append(",");
                }
                String key = field.getName();
                key = key.replace("-", "_");
                if (multiple == 1) {
                    for (int i = 1; i < 6; i++) {
                        String keyMultiple = key + "_" + i;
                        if (multiple2 > 0) {
                            for (int j = 1; j < 6; j++) {
                                keyMultiple = key + "_" + i + "_" + j;
                                sb.append(keyMultiple);
                            }
                        } else {
                            sb.append(keyMultiple);
                        }
                    }
                } else {
                    sb.append(key);
                    System.out.println("field: " + key + " -> "
                            + field.getType());
                }
                break;

            case TYPE_GROUP:
                int index = 1;
                if (field.getType() == Types.TYPE_GROUP) {
                    index = 0;
                } else {
                    System.out.println("MU/PE");
                }

                int index2 = 0;
                if (multiple > 0) {
                    index2 = 1;
                }
                if (sb.length() != 0) {
                    sb.append(",");
                }
                sb.append(newHeader(((AdaStructureType)field).getSubTypeList(), index, index2));
                break;

            default:
                System.out.println("***" + field.getName() + "["
                        + field.getShortName() + "]: " + field.getType()
                        + " - " + field);
                break;
            }
        }

        return sb.toString();
    }

    public int getCounter() {
        return _counter;
    }

    private BufferedWriter getWriter() throws IOException {
        if (_writer == null) {
            File file = new File(_filename);
            _writer = new BufferedWriter(new FileWriter(file));
        }
        return _writer;
    }

    public static void main(final String[] args) throws Exception {

        String filename = ADA_EMPNAT_MAPNAME + ".csv";
        int limit = 1107;

        /* get database */
        DemoDbid id = new DemoDbid();
        id.setkbdDbid();
        int dbid = id.getDbid();

        try {
            /* simple Adabas Database target definition (dbid) */
            AdabasTarget target = new AdabasTarget(dbid);
            target.open();

            AdabasMapperRepositories.addMapStorage(new AdabasTarget(dbid),
                    ADA_FILE_DATA_DESIGNER);
            AdabasToCsv toCsv = new AdabasToCsv(filename, ADA_EMPNAT_MAPNAME,
                    limit);

            // process loop
            toCsv.process();

            System.out.println("\n\n ==> "
                    + toCsv.getCounter()
                    + " records written to " + filename);
        } catch (QueryException e) {
            System.out.println(e.getMessage());
            /* e.printStackTrace(); */
        }
    }
}
