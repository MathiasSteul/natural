/*
 * Copyright (c) 2016-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: LobExampleWithDatabaseClassicParameters.java 6474 2018-04-13 10:33:13Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
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
public class LobExampleWithDatabaseClassicParameters {
    /* Adapt this values to define the location of ACJ map file */
    private static final int DBID = 54712;
    private static final int FILE = 5;

    /* DC is the Adabas short name ALPHA with LB
       Don't forget to add lob file */
    private static final String LOB_FIELD = "DC";
    private final AdabasTarget _target;
    private final int _file;

    private static long storedISN;

    public LobExampleWithDatabaseClassicParameters(final AdabasTarget target, final int file) {
        _target = target;
        _file = file;
    }

    /**
     * Store a specific file into Adabas field Picture.
     * @param fileName File name
     * @throws Exception Error during write
     */
    public void storeLobImage(final String fileName) throws Exception {
        Object[][] data = { { "BC", "p1.img" }, { "CC", "image/jpeg" },
            { LOB_FIELD, null }, { "EC", null }

        };
        Picture picture = new Picture(fileName);
        byte[] saveFileData = picture.getFileData();
        data[2][1] = saveFileData;
        data[3][1] = generateChecksumBytes(saveFileData);

        try (StoreRequest request = new StoreRequest(_target, _file)) {
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
        try (ReadRequest request = new ReadRequest(_target, _file)) {
            request.addFieldsQuery(new String[] { LOB_FIELD });
            request.setStart(storedISN);
            request.setLimit(1);

            /* Read only one record with a specific ISN */
            IRecordEntry record = request.readIsn(isn);
            IAdaFieldValue value = record.valueOf(LOB_FIELD);

            /* Here is the image raw data which you can work with */
            byte[] dbImageData = value.getRawValue();

            /* The data is checked using checksum function */
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
                strBuf.append(Integer
                        .toString((aSharesult & 0xff) + 0x100, 16).substring(1));
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
        System.out.println("List content of Adabas on "
            + _target.getStub().getUrl() + "/" + _file);
        try (ReadRequest request = new ReadRequest(_target, _file)) {
            request.addFieldsQuery(
                new String[] { "BC", "CC", "EC" });

            QueryResultList list = (QueryResultList) request.readIsnSequence();
            list.output(System.out);
        }
    }

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
     * No argument will list content of all records in the database
     * Numeric value will read a specific ISN
     * A file name will create a record and store data reference with the
     *  file name with the corresponding file data
     *
     * Example: LobExampleClassic <picture>
     *
     * @param args
     * @throws Exception
     */
    public static void main(final String[] args) throws Exception {
        AdabasTarget target = new AdabasTarget(DBID);

        LobExampleWithDatabaseClassicParameters lobExample =
            new LobExampleWithDatabaseClassicParameters(target, FILE);
        if (args.length == 0) {
            lobExample.listContent();
        } else {
            try {
                long isn = Long.parseLong(args[0]);
                lobExample.readLobImageStored(isn);
            } catch (NumberFormatException ne) {
                lobExample.storeLobImage(args[0]);
            }
        }
    }

}
