//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//#include "../defines.mqh"
//#include "../profile_manager.mqh"
#include "button_base.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VButtonClear : public VButtonBase
{

 public:
   VButtonClear(VProfileManager *mgr, int position = 0);

   virtual void OnTimer() override;
   virtual void OnChartEvent(int id, long lparam, double dparam, string sparam) override;
   virtual bool Create(string name = NULL) override;
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

VButtonClear::VButtonClear(VProfileManager *mgr, int position = 0) : VButtonBase(mgr)
{
   m_firstclick = false;
   m_position = position;
   m_type = BUTTON_CLEAR;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonClear::OnTimer() override
{
   State(false);
   m_firstclick = false;
   EventKillTimer();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonClear::OnChartEvent(int id, long lparam, double dparam, string sparam) override
{

   VButtonBase::OnChartEvent(id, lparam, dparam, sparam);

   if (id == CHARTEVENT_OBJECT_CLICK && sparam == Name())
   {
      if (m_firstclick) //double click recognized
      {
         VButtonBase *button = m_manager.GetActiveButtonPointer();
         if (CheckPointer(button))
            button.Clear();
         EventSetMillisecondTimer(100);
         m_firstclick = false;
      }
      else
      {
         m_firstclick = true;
         EventSetMillisecondTimer(300);
      }
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonClear::Create(string name = NULL) override
{
   name = name != NULL ? name : "__vb_clear__" + string(m_position);
   ObjectDelete(0, name);
   if (!VButtonBase::Create(name))
      return false;
   VButtonBase::OnChartEvent(CHARTEVENT_CHART_CHANGE, NULL, NULL, NULL);
   Description("C");
   Tooltip("Press to clear selected profile");
   BackColor(clrRed);
   return true;
}
//+------------------------------------------------------------------+
