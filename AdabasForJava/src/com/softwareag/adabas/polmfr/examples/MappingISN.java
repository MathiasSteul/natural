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
import com.softwareag.adabas.parser.interfaces.IAdaFieldType;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasConnection;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;
import com.softwareag.adabas.query.interfaces.IQueryResult;

public abstract class MappingISN {
	private static final String[] ADA_DATA_FIELDS = { "CUSTID", "FIRSTNAME", "LASTNAME"};
	public static void main(final String[] args) throws Exception {
		try {
			AdabasConnection connection = AdabasConnection.createSession("acj:map=CUSTOMERS;config=[103,11]");
			ReadRequest request = connection.createReadRequest(); 
		    request.addFieldsQuery(ADA_DATA_FIELDS);
			IRecordEntry result = request.readIsn(10045);
			System.out.print("ISN = "+result.getIsn()+" ");
			for (IAdaFieldValue value:result.getFieldValues()) {
					System.out.print(value.getType().getName()+" = "+value.toString()+ " ");						
			}
			System.out.println();
			request.close();
			connection.close();
		} catch (QueryException e) {
			System.out.println(e.getMessage());
		}
	}
}
