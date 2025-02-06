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
import com.softwareag.adabas.parser.IRecordTraverser;
import com.softwareag.adabas.parser.interfaces.IAdaFieldType;
import com.softwareag.adabas.parser.interfaces.IAdaFieldValue;
import com.softwareag.adabas.parser.interfaces.IDataTypes;
import com.softwareag.adabas.parser.interfaces.IRecordEntry;
import com.softwareag.adabas.query.AdabasTarget;
import com.softwareag.adabas.query.QueryResultList;
import com.softwareag.adabas.query.ReadRequest;

/**
 * This example uses Adabas classic notation like database id, file number and
 * short name for fields. A search criteria is given to search for all records
 * where value of AE field is equal "SMITH".
 * 
 * prereq.: demo database started using file 10
 */

public abstract class ClassicSearch {
	private static final int ADA_FILENR = 10;
	private static final int ADA_DBID = 103;
	private static final String ADA_SEARCH_FIELD = "AC";
	private static final String ADA_SEARCH_VALUE = "SIECA";
	private static final String[] ADA_DATA_FIELDS = { "AA", "AB", "AC","M1","PE","PM"};
	private static final int START_ISN = 1;
	private static final int MAX_RECORDS = 10000;
	public static void main(final String[] args) throws Exception {
		try {
			AdabasTarget target = new AdabasTarget(ADA_DBID);
			target.open();
			target.setCharset(Charset.forName("windows-1252"));
			ReadRequest request = new ReadRequest(target, ADA_FILENR);
			request.queryFields(ADA_DATA_FIELDS);
			request.setStart(START_ISN);
			request.setLimit(MAX_RECORDS);
			request.setSearch(ADA_SEARCH_FIELD + "=" + ADA_SEARCH_VALUE);
			/* Send request and receive result in ISN order */
			QueryResultList list = (QueryResultList) request.readIsnSequence();
			for (IRecordEntry record : list) {
				System.out.println("ISN : " + record.getIsn() + " -----------------------------------");
				try {
					record.traverse(new IRecordTraverser() {
						@Override
						public boolean traverse(final int level, final IRecordEntry entry, final IAdaFieldValue value) {
							if (level == 1) {								// System.out.println(value.getType());
								System.out.println(value.getType().getName()+" = "+value.toString());
							}
							return true;
						}
					});
				} catch (QueryException exception) {
					System.err.println("Error display records : " + exception.getLocalizedMessage());
				}
			}
			request.close();
			target.close();
		} catch (QueryException e) {
			System.out.println(e.getMessage());
		}
	}
}
