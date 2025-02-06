/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 *
 * $Id: StoreMapData.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.common.QueryExceptionInfo;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.query.StoreRequest;

/**
 * Example program to show, how a array of data can be given and stored using the
 * Mapping facility
 *
 */
public class StoreMapData {

    private final StoreRequest _request;

    private final String[] _fields;

    private final SimpleDateFormat _formatter =
                    new SimpleDateFormat("MM/dd/yyyy HH:mm:SS a Z");

    private final SimpleDateFormat _formatterS =
                    new SimpleDateFormat("dd/MM/yyyy");

    private final SimpleDateFormat _formatterT =
                    new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:SSZ");

    public StoreMapData(final StoreRequest request, final String[] header)
                    throws QueryException {
        /* StoreRequest handle store calls */
        _request = request;
        if (header == null) {
            _fields = request.getMap().getMapLongNameFields();
        } else {
            _fields = header;
        }
        _request.addStoredFields(_fields);
    }

    /**
     * Store map data constructor with a given Map name
     *
     * @param mapName MAP name to use for storage
     * @throws QueryException Error connecting database or evaluating map
     */
    public StoreMapData(final String mapName) throws QueryException {
        this(new StoreRequest(mapName), null);
    }

    public void storeRecord(final String[] data, final String[] dateFields)
                    throws QueryException {
        /* Create an record entry for each matrix object */
        RecordEntry entry = _request.createRecordEntry();

        /* Loop through fields and add value in record entry */
        for (int i = 0; i < data.length; i++) {
            if (i > (_fields.length - 1)) {
                break;
            }
            /* Add field value data */
            // System.out.println("Work on " + _fields[i] + "=" + data[i]);
            boolean dateField = false;
            for (String dateField1 : dateFields) {
                if (_fields[i].equals(dateField1)) {
                    dateField = true;
                    break;
                }
            }
            if (dateField) {
                try {
                    if (data[i].trim().isEmpty()) {
                        entry.addValue(_fields[i], (long) 0);
                    } else {
                        Date dateStr;
                        if (data[i].trim().length() < 11) {
                            dateStr = _formatterS.parse(data[i].trim());
                        } else if (data[i].trim().charAt(10) == 'T') {
                            dateStr = _formatterT.parse(data[i].trim());
                        } else {
                            dateStr = _formatter.parse(data[i].trim());
                        }
                        entry.addValue(_fields[i], dateStr.getTime());
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                    throw new QueryException(QueryExceptionInfo.ACJ00268, e);
                }
            } else {
                if (!data[i].isEmpty()) {
                    entry.addValue(_fields[i], data[i]);
                }
            }
        }

        /*
         * Put entries in request, storeEntry send Adabas call after a defined number
         * of records given
         */
        _request.storeEntry(entry);
    }

    /**
     * Close the database and store the rest of add entries to request
     *
     * @throws QueryException Error connecting database
     */
    public void close() throws QueryException {
        try {
            _request.endTransaction();
            System.out.println("Records flushed, end transaction now");
            _request.close();
        } catch (QueryException e) {
            e.printStackTrace();
            _request.close();
            throw e;
        }
    }

}
