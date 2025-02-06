/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: LoadCsvExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import com.softwareag.adabas.mapping.AdabasMapper;
import com.softwareag.adabas.query.AdabasConnection;

/**
 * CSV example. Using the "EmployeeMap" and the input.csv file contained in the examples directory,
 * this file reads the CSV file content and stores the data into employees file referenced in the
 * EmployeeMap. 
 *
 */
public abstract class LoadCsvExample {
    private static final  String CSV_DELIMITER = ";";

    public static void main(final String[] args) throws Exception {
        AdabasConnection conn = AdabasConnection.createSession("ajc:map=EmployeeMap;config=[24,4]");

        AdabasMapper map = (AdabasMapper) conn.getConnectionObject();
        int nrFields = map.getFields().size();
        if (nrFields == 0) {
            throw new Exception("No fields");
        }

        StoreMapData storeMapData = null;
        BufferedReader reader = null;
        try {
            String line;
            String geoFile = "/home/tkn/acj-dev/acj/api/query/src/examples/java/examples/input.csv";
            reader = new BufferedReader(new FileReader(geoFile));
            String[] header = null;
            String[] values = null;
            System.out.println("Start reading");
            int stored = 0;
            while ((line = reader.readLine()) != null) {
                if ((line.trim().isEmpty())|(line.trim().startsWith("#"))) {
                    continue;
                }
                // System.out.println(line+" -> "+header);
                if (header == null) {
                    header = line.split(CSV_DELIMITER);
                    storeMapData = new StoreMapData(conn.createStoreRequest(), header);
                } else {
                    values = line.split(CSV_DELIMITER);
                    // System.out.println("Array Size = " + values.length);

                    for (int i = 0; i < values.length; i++) {
                        if (values[i].length() == 0) {
                            continue;
                        }
                        if (values[i].charAt(0) == '"') {
                            while (values[i].charAt(values[i].length() - 1) != '"') {
                                values[i] = values[i] + "," + values[i + 1];
                                System.out.println("Merge " + values[i]);
                                for (int j = i + 1; j < values.length - 1; j++) {
                                    System.out.println("Merge " + values[j + 1] + " to " + values[j]);
                                    values[j] = values[j + 1];
                                }
                                values[values.length - 1] = "";
                            }
                            values[i] = values[i].replaceAll("\"", "");
                        }
                        System.out.println(i + " " + header[i] + " -> " + values[i]);
                    }
                    storeMapData.storeRecord(values, new String[] {});
                    stored++;
                    if (stored % 1000 == 0) {
                        System.out.println("Stored " + stored + " records");
                    }
                }
            }
            System.out.println("Stored " + stored + " records");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
                if (storeMapData != null) {
                    storeMapData.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
