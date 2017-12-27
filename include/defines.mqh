//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict

#include <stdlib.mqh>
#include <Arrays\ArrayObj.mqh>
#include "ChartObjects/ChartObjectsLines.mqh"
#include "ChartObjects/ChartObjectsTxtControls.mqh"
#include "ChartObjects/ChartObjectsShapes.mqh"
#include "ChartObjects/ChartObjectsLines.mqh"
#include "ChartObjects/ChartObjectsFibo.mqh"
#include "ChartObjects/ChartObjectsArrows.mqh"
#include "ChartObjects/ChartObjectsChannels.mqh"
#include "ChartObjects/ChartObjectsGann.mqh"
#include "file.mqh"
#define BUTTON_CLEAR 88
#define BUTTON_PROFILE 89
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void __error(string description)
  {
   Print(__FUNCTION__,": ",description,": ",ErrorDescription(GetLastError()));
   ResetLastError();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum OPMODE
  {
   MULTI, //Overlays all selected profiles
   SINGLE //Select only one profile at a time
  };

//--- forward declarations
class VProfileManager;
class VProfile;
class VButtonList;
class VButtonBase;
class VButtonClear;
class VButtonProfile;
//+------------------------------------------------------------------+
