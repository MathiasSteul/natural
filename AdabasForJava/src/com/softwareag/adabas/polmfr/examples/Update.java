/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: AdabasSearchExample.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.polmfr.examples;

import java.nio.charset.Charset;
import java.util.InputMismatchException;
import java.util.Locale;
import java.util.Scanner;

import com.softwareag.adabas.common.QueryException;
import com.softwareag.adabas.mapping.AdabasMapperRepositories;
import com.softwareag.adabas.parser.IRecordTraverser;
import com.softwareag.adabas.parser.RecordEntry;
import com.softwareag.adabas.parser.interfaces.IAdaFieldType;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.Request.SharedLock;
import com.softwareag.adabas.query.StoreRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

public abstract class Update {
	private static final String[] ADA_DATA_FIELDS = { "CUSTID", "FIRSTNAME", "LASTNAME" ,"PHONE" };

	public static void main(final String[] args) throws Exception {
		try {
			AdabasConnection connection = AdabasConnection.createSession("acj:map=CUSTOMERS;config=[103,11]");
			StoreRequest stRequest = connection.createStoreRequest();
			stRequest.addStoredFields(ADA_DATA_FIELDS);
			RecordEntry entry = stRequest.createRecordEntry();
			entry.addValue("CUSTID","76253");
			entry.addValue("FIRSTNAME","SIMSON");
			entry.addValue("LASTNAME","MADAMAäöü");
			entry.addValue("PHONE","001",1);
			entry.addValue("PHONE","002",2);
			entry.setIsn(10045);
			Long[] isns = stRequest.updateEntry(entry);
			System.out.println("updated ISN = "+isns[0].longValue());
			stRequest.endTransaction();
			stRequest.close();
			connection.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
