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

public abstract class MappingFindMult {
	private static final String[] ADA_DATA_FIELDS = { "CUSTID", "FIRSTNAME", "LASTNAME", "PHONE", "KIND", "SPECIAL"};
	private static final int START_ISN = 1;
	private static final int MAX_RECORDS = 10000;
	public static void main(final String[] args) throws Exception {
		try {
			AdabasConnection connection = AdabasConnection.createSession("acj:map=CUSTOMERS;config=[103,11]");
			ReadRequest request = connection.createReadRequest(); 
			request.addFieldsQuery(ADA_DATA_FIELDS);
			//request.addAllFieldsQuery();
			request.setStart(START_ISN);
			request.setLimit(MAX_RECORDS);
			request.sortedBy(new String[] { "LASTNAME","FIRSTNAME","CUSTID" });
			IQueryResult result = request.findWith("LASTNAME >='A' AND LASTNAME<='C' AND PHONE='Phone 10' AND REMARKS='Remark 2 7'");
			System.out.println("Treffer : "+ result.getNumberRecords());
			QueryResultList list = (QueryResultList) result.list();
			int i = 0;
			for (IRecordEntry record : list) {
				System.out.print(++i + " ISN = "+record.getIsn()+" ");
				for (IAdaFieldValue value:record.getFieldValues()) {
					if (!value.getType().checkMU()) {
						System.out.print(value.getType().getName()+" = "+value.toString()+ " ");						
					} else {
						System.out.println(); 
						int o = 0;
						for (IRecordEntry mult : value.getList()) {
							o++;
							for (IAdaFieldValue multValue : mult.getFieldValues()) {
								if (multValue.getType().checkMU()) {
									if (multValue.getList() == null) {
										System.out.println("    "+value.getType().getName()+"["+o+"] = "+multValue.toString()+" ");										
									} else {
										int o2 = 0;
										for (IRecordEntry multInner : multValue.getList()) {
											o2++;
											for (IAdaFieldValue multValueInner : multInner.getFieldValues()) {
												System.out.println("    "+value.getType().getName()+"["+o+"]"+multValueInner.getType().getName()+"["+o2+"] = "+multValueInner.toString());
											}
										}
									}
								} else {
									System.out.println("    "+value.getType().getName()+"["+o+"]."+multValue.getType().getName()+" = "+multValue.toString());
								}
							}
						}
					}
				}
				System.out.println();
			}
			request.close();
			connection.close();
		} catch (QueryException e) {
			System.out.println(e.getMessage());
		}
	}
}
