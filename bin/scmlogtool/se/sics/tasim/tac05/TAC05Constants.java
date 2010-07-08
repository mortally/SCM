/**
 * TAC Supply Chain Management Simulator
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
 * TAC05Constants
 *
 * Author  : Joakim Eriksson, Niclas Finne, Sverker Janson
 * Created : Tue Feb 25 16:24:25 2003
 * Updated : $Date: 2005/01/04 16:03:55 $
 *           $Revision: 1.1 $
 */
package se.sics.tasim.tac05;

/**
 * <code>TAC05Constants</code> defines a number of constants used by
 * TAC05 SCM simulations. The constants are, among other things, used
 * to tag information in the simulation logs files and simulation
 * viewer communication.
 */
public interface TAC05Constants {

  /** The simulation type for TAC05 SCM simulations. */
  public static final String SIMULATION_TYPE = "tac05scm";

  public static final int TYPE_NONE = 0;


  // -------------------------------------------------------------------
  // Event types (human readable messages)
  // -------------------------------------------------------------------

  public static final int TYPE_MESSAGE = 1;
  public static final int TYPE_WARNING = 2;


  // -------------------------------------------------------------------
  // Interaction types
  // -------------------------------------------------------------------

  public final static int TYPE_NEGOTIATION = 10;
  public final static int TYPE_ORDER = 11;
  public final static int TYPE_DELIVERY = 12;


  // -------------------------------------------------------------------
  // Data update types
  // -------------------------------------------------------------------

  /** The bank account status for a specific agent (int or long) */
  public final static int DU_BANK_ACCOUNT = 100;

  /** The customers product demand specified in units (int) */
  public final static int DU_CUSTOMER_DEMAND = 101;
  /** The customers ordered specified in units (int) */
  public final static int DU_CUSTOMER_ORDERED = 102;

  /** Supplier capacity for a specific assembly line (int).
   *  <ul>
   *   <li> current capacity for line 1 -> DU_CAPACITY_FLAG + 0
   *   <li> current capacity for line 2 -> DU_CAPACITY_FLAG + 1, etc.
   *  </ul>
   */
  public final static int DU_CAPACITY_FLAG = 1 << 10;

  /** Supplier inventory for a specific assembly line (int).
   *  <ul>
   *   <li> current inventory for line 1 -> DU_INVENTORY_FLAG + 0
   *   <li> current inventory for line 2 -> DU_INVENTORY_FLAG + 1, etc.
   *  </ul>
   */
  public final static int DU_INVENTORY_FLAG = 1 << 11;

  /** Supplier nominal capacity for a specific assembly line (int).
   *  <ul>
   *   <li> nominal capacity for line 1 -> DU_NOMINAL_CAPACITY_FLAG + 0
   *   <li> nominal capacity for line 2 -> DU_NOMINAL_CAPACITY_FLAG + 1, etc.
   *  </ul>
   *  The same nominal capacity is used for all assembly lines if only
   *  specified for line 1.
   */
  public final static int DU_NOMINAL_CAPACITY_FLAG = 1 << 12;

  /** Supplier production level for a specific assembly line (int).
   *  <ul>
   *   <li> current production level for line 1 -> DU_PRODUCTION_FLAG + 0
   *   <li> current production level for line 2 -> DU_PRODUCTION_FLAG + 1, etc.
   *  </ul>
   */
  public final static int DU_PRODUCTION_FLAG = 1 << 13;

  /** Supplier component price for a specific assembly line (int).
   *  <ul>
   *   <li> current component price for line 1 -> DU_COMPONENT_PRICE_FLAG + 0
   *   <li> current component price for line 2 -> DU_COMPONENT_PRICE_FLAG + 1,
   *     etc.
   *  </ul>
   *  <em>This might not be available depending on server version.</em>
   */
  public final static int DU_COMPONENT_PRICE_FLAG = 1 << 14;

  /** Supplier component id for a specific assembly line (int).
   *  <ul>
   *   <li> component id for line 1 -> DU_COMPONENT_ID_FLAG + 0
   *   <li> component id for line 2 -> DU_COMPONENT_ID_FLAG + 1,
   *     etc.
   *  </ul>
   *  <em>This might not be available depending on server version.</em>
   */
  public final static int DU_COMPONENT_ID_FLAG = 1 << 15;


  // -------------------------------------------------------------------
  // The TAC05 SCM participant roles
  // -------------------------------------------------------------------

  /** The TAC05 SCM manufacturer role */
  public static final int MANUFACTURER = 0;
  /** The TAC05 SCM supplier role */
  public static final int SUPPLIER = 1;
  /** The TAC05 SCM customer role */
  public static final int CUSTOMER = 2;
  /** The TAC05 SCM factory role */
  public static final int FACTORY = 3;

  /** The TAC05 SCM participant roles as human readable names. */
  public static final String[] ROLE_NAME = {
    "PCManufacturer", "Supplier", "Customer", "Factory"
  };

} // TAC05Constants
