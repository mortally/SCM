/**
 * SICS ISL Java Utilities
 * http://www.sics.se/tac/    tac-dev@sics.se
 *
 * Copyright (c) 2001-2003 SICS AB. All rights reserved.
 *
 * SICS grants you the right to use, modify, and redistribute this
 * software for noncommercial purposes, on the conditions that you:
 * (1) retain the original headers, including the copyright notice and
 * this text, (2) clearly document the difference between any derived
 * software and the original, and (3) acknowledge your use of this
 * software in pertaining publications and reports.  SICS provides
 * this software "as is", without any warranty of any kind.  IN NO
 * EVENT SHALL SICS BE LIABLE FOR ANY DIRECT, SPECIAL OR INDIRECT,
 * PUNITIVE, INCIDENTAL OR CONSEQUENTIAL LOSSES OR DAMAGES ARISING OUT
 * OF THE USE OF THE SOFTWARE.
 *
 * -----------------------------------------------------------------
 *
 * BinaryTransport
 *
 * Author  : Joakim Eriksson, Niclas Finne, Sverker Janson
 * Created : Wed Jan 15 17:29:32 2003
 * Updated : $Date: 2004/06/06 22:22:53 $
 *           $Revision: 1.2 $
 * Purpose :
 *
 */
package se.sics.isl.transport;

public interface BinaryTransport {

  public static final byte START_NODE = 'n';
  public static final byte END_NODE = '\n';
  public static final byte NODE = 'N';
  public static final byte TABLE = 'T';
  public static final byte INT = 'i';
  public static final byte LONG = 'l';
  public static final byte FLOAT = 'f';
  public static final byte STRING = 's';

  public static final byte INT_ARR = 'I';

  public static final byte ALIAS = 'A';
  public static final byte STUFF_CHAR = '\\';

} // BinaryTransport
