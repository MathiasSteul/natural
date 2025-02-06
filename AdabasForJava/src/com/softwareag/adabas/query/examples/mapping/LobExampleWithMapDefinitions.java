/*
 * Copyright (c) 2016-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: LobExampleWithMapDefinitions.java 6474 2018-04-13 10:33:13Z tkn $
 */

package com.softwareag.adabas.query.examples.mapping;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.StoreRequest;

/**
 * Example to lob picture into database field. Map is defined
 * using following FDT:
 * 1 , BA ; Location
 * 2 , BC, 0, W, DE ; Filename
 * 1 , CA ; Type
 * 2 , CC, 0, W ; MimeType
 * 1 , DA ; Data
 * 2 , DC, 0, A, LB, NV, NB, NU ; Picture
 * 1 , EA ; Checksum
 * 2 , EC, 40,A ; PictureSHAchecksum
 * 
 * Java example is called with
 * - No parameter will list all records
 * - filename parameter will load data into Adabas record
 * - Numeric value parameter will read data and output checksum
 *
 */
public class LobExampleWithMapDefinitions {

    /* Adapt this values to define the location of ACJ map file */
    private static final int MAP_DBID = 24;
    private static final int MAP_FILE = 4;

    /* Picture is the field name in the map */
    private static final String LOB_FIELD = "Picture";
    private static final String LOB_MAP = "LOB_MAP";
    private final AdabasConnection connection;

    private static long storedISN;

    public LobExampleWithMapDefinitions(final String name,
        final AdabasTarget target, final int file) throws QueryException {
        connection = AdabasConnection.createSession("ajc:map=" + name
            + ";config=[" + target.toString() + "," + file + "]");

    }

    /**
     * Store a specific file into Adabas field Picture.
     * @param fileName File name
     * @throws Exception Error during write
     */
    public void storeLobImage(final String fileName) throws Exception {
        Object[][] data =
            { { "Filename", "p1.img" }, { "MimeType", "image/jpeg" },
                { LOB_FIELD, null }, { "PictureSHAchecksum", null }

            };

        Picture picture = new Picture(fileName);
        byte[] saveFileData = picture.getFileData();
        data[2][1] = saveFileData;
        data[3][1] = generateChecksumBytes(saveFileData);

        try (StoreRequest request = connection.createStoreRequest()) {
            RecordEntry entry = request.createRecordEntry();
            for (Object[] aData : data) {
                String field = (String) aData[0];
                entry.addValue(field, aData[1]);
            }
            request.storeEntry(entry);
            request.endTransaction();
            System.out.println("Stored record on ISN: " + entry.getIsn());
        }
    }

    /**
     * Read a specific lob field out of a ISN.
     * @param isn ISN of the record
     * @throws Exception Error during read
     */
    public void readLobImageStored(final long isn) throws Exception {
        try (ReadRequest request = connection.createReadRequest()) {
            request.addFieldsQuery(new String[] { LOB_FIELD });
            request.setStart(storedISN);
            request.setLimit(1);

            IRecordEntry record = request.readIsn(isn);
            IAdaFieldValue value = record.valueOf(LOB_FIELD);
            byte[] dbImageData = value.getRawValue();
            String readCheckSum = generateChecksumBytes(dbImageData);
            System.out.println("Read Checksum: " + readCheckSum);
        }
    }

    /**
     * Generate a checksum for validation.
     * @param buf buffer to check
     * @return String representation of the checksum
     */
    static String generateChecksumBytes(final byte[] buf) {
        try {
            byte[] sharesult;
            MessageDigest sha = MessageDigest.getInstance("SHA");

            sha.update(buf);

            sharesult = sha.digest();
            StringBuilder strBuf = new StringBuilder();
            for (byte aSharesult : sharesult) {
                strBuf.append(Integer.toString((aSharesult & 0xff) + 0x100, 16)
                    .substring(1));
            }

            return strBuf.toString();
        } catch (NoSuchAlgorithmException nsae) {
            return null;
        }
    }

    /**
     * List the content of the database file
     * @throws Exception
     */
    public void listContent() throws Exception {
        System.out.println(
            "Load image from map register " + connection.toString());
        try (ReadRequest request = connection.createReadRequest()) {
            request.addFieldsQuery(
                new String[] { "Filename", "MimeType", "PictureSHAchecksum" });

            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
        }
    }

    /**
     * This is a helper class to read the file data
     *
     */
    public class Picture {
        private final File _imageFile;

        public Picture(final String fileName) {
            _imageFile = new File(fileName);
        }

        byte[] getFileData() {
            byte[] data = null;
                try (FileInputStream fi = new FileInputStream(_imageFile)) {

                    int len = fi.available();
                    data = new byte[len];
                    fi.read(data);

                } catch (FileNotFoundException fnfe) {
                    System.err.println("File not found");
                    return null;
                } catch (IOException ioe) {
                    System.err.println("I/O error getting buffer");
                    return null;
                }
            return data;

        }

    }

    /**
     * No argument will list content, numeric value will read specific ISN and file
     * name will create a record
     * with the corresponding file data
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {
        AdabasTarget target = new AdabasTarget(MAP_DBID);

        LobExampleWithMapDefinitions lobExampleMap =
            new LobExampleWithMapDefinitions(LOB_MAP, target, MAP_FILE);
        if (args.length == 0) {
            lobExampleMap.listContent();
        } else {
            try {
                long isn = Long.parseLong(args[0]);
                lobExampleMap.readLobImageStored(isn);
            } catch (NumberFormatException ne) {
                lobExampleMap.storeLobImage(args[0]);
            }
        }
    }
}
