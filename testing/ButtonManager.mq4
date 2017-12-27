//+------------------------------------------------------------------+
//|                                              aaButtonManager.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#include "../include/profile_manager.mqh"

input int      NumberOfProfiles  = 4;     //Number of profiles 
input OPMODE   Mode              = MULTI; //Mode for profile selection
input int      ButtonSize        = 15;    //Size of buttons in pixels
input color    ButtonColor       = clrDarkOrange;//Button Background Color


VProfileManager pm(NumberOfProfiles, Mode, ButtonSize, ButtonColor);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   if(!pm.OnInit())
      return INIT_FAILED;

   return(INIT_SUCCEEDED);
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
   return(rates_total);
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
   pm.OnChartEvent(id,lparam,dparam,sparam);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   pm.Save();
}
//+------------------------------------------------------------------+
