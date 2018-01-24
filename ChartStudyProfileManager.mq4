//+------------------------------------------------------------------+
//|                                     ChartStudyProfileManager.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "00.00.02"
#property strict
#property indicator_chart_window

#property icon "resources/icon.ico"
 
#property description "* Start by selecting a profile in the toolbar and begin marking up your chart."
#property description "* Hide the profile by unselecting it the toolbar."
#property description "* Selecing a different profile number in the toolbar to make a different chart markup."
#property description "* Overlay profiles by selecting multiple profile numbers in the toolbar."
#property description "* Clear a profile by selecting it and double clicking the clear (\"C\") button."
#property description "* If you experience issues, delete the MQL\\Files\\ChartProfileManager folder."


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#include "include/profile_manager.mqh"

input int NumberOfProfiles = 5;          //Number of profiles
input int ButtonSize = 15;               //Size of buttons in pixels
input color ButtonColor = clrDarkOrange; //Button Background Color
OPMODE Mode = MULTI;                     //Mode for profile selection

VProfileManager pm(NumberOfProfiles, Mode, ButtonSize, ButtonColor);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   if (!pm.OnInit())
      return INIT_FAILED;

   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return (rates_total);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   pm.OnTimer();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   pm.OnChartEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   pm.Save();
}
//+------------------------------------------------------------------+
