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

public abstract class MappingFindMultTraverse {
	private static final String[] ADA_DATA_FIELDS = { "CUSTID", "FIRSTNAME", "LASTNAME", "PHONE", "KIND", "SPECIAL"};
	private static final int START_ISN = 1;
	private static final int MAX_RECORDS = 10000;
	public static String tab(int level) {
		String result = "";
		for (int i=0;i<=level;i++) {
			result = result + "   ";
		}
	return level+result;
	}
	public static void main(final String[] args) throws Exception {
		try {
			AdabasConnection connection = AdabasConnection.createSession("acj:map=CUSTOMERS;config=[103,11]");
			ReadRequest request = connection.createReadRequest(); 
			request.addFieldsQuery(ADA_DATA_FIELDS);
			request.setStart(START_ISN);
			request.setLimit(MAX_RECORDS);
			request.sortedBy(new String[] { "LASTNAME","CUSTID" });
			IQueryResult result = request.findWith("LASTNAME >='A' AND LASTNAME<='C' AND PHONE='Phone 10' AND REMARKS='Remark 2 7'");
			System.out.println("Treffer : "+ result.getNumberRecords());
			QueryResultList list = (QueryResultList) result.list();
            list.forEach(record -> {
                try {
                    record.traverse(new IRecordTraverser() {
                        @Override
                        public boolean traverse(final int level,final IRecordEntry entry,final IAdaFieldValue value) {
                        	if (value.getList() != null) {
                        		System.out.println(tab(level) + " "+value.getType().getName());
                        	} else {
                             	System.out.println(tab(level) + " "+value.getType().getName()+" = "+value.toString());                        		
                        	}
                            return true;
                        }
                    });
                } catch (QueryException exception) {
                    System.err.println("Error display records : "
                        + exception.getLocalizedMessage());
                }
                System.out.println("NEUER RECORD---");
            });			
            request.close();
			connection.close();
		} catch (QueryException e) {
			System.out.println(e.getMessage());
		}
	}
}
