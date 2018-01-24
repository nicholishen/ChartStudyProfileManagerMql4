//+------------------------------------------------------------------+
//|                                            PersistentObjects.mqh |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict

#include "container_list.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VProfile : public CObject
{
 protected:
   VProfileManager *m_mgr;
   VContainerList *m_obj_list;
   bool m_hideflag;
   string m_filename;
   int m_profilenumber;
   //static int        m_profile_instances;
 public:
   VProfile(VProfileManager *mgr, int profile_number);
   ~VProfile();
   //void              OnTick();
   //void              OnTimer();
   void OnChartEvent(int, long, double, string);
   bool OnInit();

   long ChartID() const;
   void ChartID(long id);
   int Subwindow() const;
   void Subwindow(int id);
   int Total() const;
   int ProfileNumber() const;

   virtual bool Load(void);
   virtual bool Save(void);
   virtual bool Show(void);
   virtual bool Hide(void);
   virtual bool Clear(void);

   virtual int Compare(const CObject *node, const int mode = 0) const override;

 protected:
   void SweepObjects();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int VProfile::m_profile_instances = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VProfile::VProfile(VProfileManager *mgr, int profile_number)
{
   m_mgr = mgr;
   m_hideflag = false;
   m_profilenumber = profile_number;
   m_obj_list = new VContainerList(m_mgr);
   m_filename = "ChartProfileManager2/" + _Symbol + "/";
   m_filename += "_subwindow_" + string(m_mgr.SubWindow()) + "_profile_" + string(m_profilenumber) + ".bin";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VProfile::~VProfile()
{
   //if(!Save())
   //   Print(__FUNCTION__," SaveError: ",ErrorDescription(GetLastError()));

   if (CheckPointer(m_obj_list))
      delete m_obj_list;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool VProfile::Load()
{
   int handle = FileOpen(m_filename, FILE_READ | FILE_BIN);
   if (handle != INVALID_HANDLE)
   {
      //m_profilenumber=FileReadInteger(handle);
      bool res = m_obj_list.Load(handle);
      FileClose(handle);
      if (!res)
      {
         Print(__FUNCTION__, " <!!> ", ErrorDescription(GetLastError()));
         return false;
      }
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfile::Save()
{
   //SweepObjects();
   int handle = FileOpen(m_filename, FILE_WRITE | FILE_BIN);
   if (handle != INVALID_HANDLE)
   {
      bool res = true;
      //if(!FileWriteInteger(handle,m_profilenumber))
      //   res=false;
      //else
      if (!m_obj_list.Save(handle))
         res = false;
      FileClose(handle);
      if (!res)
         Print(__FUNCTION__, " <!!> ", ErrorDescription(GetLastError()));
      else
         return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfile::Compare(const CObject *node, const int mode = 0) const
{
   const VProfile *other = node;
   if (this.ProfileNumber() > other.ProfileNumber())
      return 1;
   if (this.ProfileNumber() < other.ProfileNumber())
      return -1;
   return 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfile::Hide()
{
   if (!m_hideflag && !Save())
      return false;
   m_hideflag = true;
   m_obj_list.Clear();
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfile::Show()
{
   m_hideflag = false;
   return Load();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfile::Clear()
{
   m_obj_list.Clear();
   return Save();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfile::Total() const
{
   return m_obj_list.Total();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfile::ProfileNumber() const
{
   return m_profilenumber;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfile::OnInit(void)
{
   if (!ChartSetInteger(m_mgr.SubWindow(), CHART_EVENT_OBJECT_CREATE, true))
      return false;
   //if (!ChartSetInteger(m_chartid, CHART_EVENT_OBJECT_DELETE, true))
   //	return false;
   //return Load();
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VProfile::OnChartEvent(int id, long lparam, double dparam, string sparam)
{
   if (id == CHARTEVENT_OBJECT_CREATE)
   {
      if (!m_hideflag)
         if (!m_obj_list.Add(sparam))
            __error("object add error");
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VProfile::SweepObjects()
{

   m_obj_list.DetachAll();
   m_obj_list.Clear();
   for (int i = ObjectsTotal(m_mgr.ChartID(), m_mgr.SubWindow()) - 1; i >= 0; i--)
   {
      string name = ObjectName(m_mgr.ChartID(), m_mgr.SubWindow());
      if (!m_obj_list.Add(name))
         Print("Did not add object: ", name);
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
