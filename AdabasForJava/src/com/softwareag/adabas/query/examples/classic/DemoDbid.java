/*
 * Copyright (c) 2015-2022 Software AG, Darmstadt, Germany and/or Software AG USA
 * Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates 
 * and/or their licensors.
 * Use, reproduction, transfer, publication or disclosure is prohibited except
 * as specifically provided for in your License Agreement with Software AG.
 * 
 * $Id: DemoDbid.java 6220 2017-08-24 12:23:59Z tkn $
 */

package com.softwareag.adabas.query.examples.classic;

import java.util.InputMismatchException;
import java.util.Scanner;

/**
 * Example Dbid class to allow setting of valid dbid using a keybord. Default
 * constructors and getter/setter methods available.
 */
public class DemoDbid {

    private int _number;
    private final Scanner _input = new Scanner(System.in);

    public DemoDbid() {
        this(103);
    }

    public DemoDbid(final int dbid) {
        _number = dbid;
    }

    public final int getDbid() {
        return _number;
    }

    public final void setDbid(final int dbid) {
        _number = dbid;
    }

    public Scanner getInput() {
        return _input;
    }
    
    public final void setkbdDbid() {
        _number = 0;
         do {
            System.out
                    .print("*** Please enter valid dbid of your Adabas Demo Database [1 .. 65535] > ");
            try {
                _number = _input.nextInt();
            } catch (InputMismatchException ime) {
                /* System.out.println(ime + " - invalid dbid !"); */
                _input.next();
            }
        } while ((_number < 1) || (_number > 65535));

    }
    
    public void close() {
        _input.close();
    }
}
