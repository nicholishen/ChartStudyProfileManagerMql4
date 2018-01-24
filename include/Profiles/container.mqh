//+------------------------------------------------------------------+
//|                                            PersistentObjects.mqh |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict

#include "../defines.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VContainer : public CObject
{
 protected:
   string m_name;
   ENUM_OBJECT m_type;
   CChartObject *m_obj;
   VProfileManager *m_mgr;

 public:
   VContainer(VProfileManager *mgr);
   ~VContainer();
   bool Init(string object_name);
   string Name() const;
   CChartObject *GetMemberPointer();
   CChartObject *ChartObjectPointer();
   virtual bool Load(const int file_handle) override;
   virtual bool Save(const int file_handle) override;
   virtual int Compare(const CObject *node, const int mode = 0) const override;

 protected:
   CChartObject *Attach(CChartObject *obj, long chrtid, string name, int subwindow, int points);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VContainer::VContainer(VProfileManager *mgr) : m_mgr(mgr)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//VContainer::VContainer(VProfile *mgr, string name) : m_mgr(mgr), m_name(name)
//{
//   m_type = (ENUM_OBJECT)ObjectGetInteger(mgr.ChartID(), name, OBJPROP_TYPE);
//   if(!CheckPointer(ChartObjectPointer()))
//      __error("Pointer error")
//}

bool VContainer::Init(string name)
{
   m_name = name;
   m_type = (ENUM_OBJECT)ObjectGetInteger(m_mgr.ChartID(), name, OBJPROP_TYPE);
   return CheckPointer(ChartObjectPointer());
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VContainer::~VContainer()
{
   if (CheckPointer(m_obj))
      delete m_obj;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string VContainer::Name() const
{
   return m_name;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChartObject *VContainer::GetMemberPointer()
{
   return m_obj;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainer::Load(const int file_handle) override
{
   m_type = (ENUM_OBJECT)FileReadInteger(file_handle);
   m_name = FileReadString(file_handle, FileReadInteger(file_handle));
   m_obj = ChartObjectPointer();
   if (!CheckPointer(m_obj))
      return false;
   return m_obj.Load(file_handle);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainer::Save(const int file_handle) override
{
   if (!FileWriteInteger(file_handle, (int)m_type))
      return false;
   int len = StringLen(m_name);
   if (!FileWriteInteger(file_handle, len))
      return false;
   if (!FileWriteString(file_handle, m_name, len))
      return false;
   return m_obj.Save(file_handle);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VContainer::Compare(const CObject *node, const int mode = 0) const
{
   const VContainer *other = node;
   string thisname = this.Name();
   string othername = other.Name();
   return StringCompare(this.Name(), other.Name());
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChartObject *VContainer::ChartObjectPointer()
{
   long id = m_mgr.ChartID();
   int sw = m_mgr.SubWindow();
   //if (ObjectFind(id, m_name) > 0)
   //   m_type = (ENUM_OBJECT)ObjectGetInteger(id, m_name, OBJPROP_TYPE);
   CChartObject *resobj = NULL;

   switch (m_type)
   {
   case OBJ_HLINE:
      if (StringFind(m_name, "Horizontal") == 0)
      {
         CChartObjectHLine *obj = new CChartObjectHLine;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 1))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_TREND:
      if (StringFind(m_name, "Trend") == 0)
      {
         CChartObjectTrend *obj = new CChartObjectTrend;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_VLINE:
      if (StringFind(m_name, "Vertical") == 0)
      {
         CChartObjectVLine *obj = new CChartObjectVLine;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 1))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_FIBO:
      if (StringFind(m_name, "Fibo") == 0)
      {
         CChartObjectFibo *obj = new CChartObjectFibo;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_FIBOFAN:
      if (StringFind(m_name, "Fibo") == 0)
      {
         CChartObjectFiboFan *obj = new CChartObjectFiboFan;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_FIBOTIMES:
      if (StringFind(m_name, "Fibo") == 0)
      {
         CChartObjectFiboTimes *obj = new CChartObjectFiboTimes;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_EXPANSION:
      if (StringFind(m_name, "Expansion") == 0)
      {
         CChartObjectFiboExpansion *obj = new CChartObjectFiboExpansion;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 3))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_PITCHFORK:
      if (StringFind(m_name, "Andrews") == 0)
      {
         CChartObjectPitchfork *obj = new CChartObjectPitchfork;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 3))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;

   case OBJ_TRIANGLE:
      if (StringFind(m_name, "Triangle") == 0)
      {
         CChartObjectTriangle *obj = new CChartObjectTriangle;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 3))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_ELLIPSE:
      if (StringFind(m_name, "Ellipse") == 0)
      {
         CChartObjectEllipse *obj = new CChartObjectEllipse;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               printf("Ellipse Creation Error: %s",ErrorDescription(_LastError));
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_CHANNEL:
      if (StringFind(m_name, "Channel") == 0)
      {
         CChartObjectChannel *obj = new CChartObjectChannel;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 3))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_REGRESSION:
      if (StringFind(m_name, "Regression") == 0)
      {
         CChartObjectRegression *obj = new CChartObjectRegression;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, (datetime)0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;

   case OBJ_STDDEVCHANNEL:
      if (StringFind(m_name, "StdDev") == 0)
      {
         CChartObjectStdDevChannel *obj = new CChartObjectStdDevChannel;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_ARROW:
      if (StringFind(m_name, "Arrow") == 0)
      {
         CChartObjectArrow *obj = new CChartObjectArrow;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (char)0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 1))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_RECTANGLE:
      if (StringFind(m_name, "Rectangle") == 0)
      {
         CChartObjectRectangle *obj = new CChartObjectRectangle;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;

   case OBJ_TEXT:
      if (StringFind(m_name, "Text") == 0)
      {
         CChartObjectText *obj = new CChartObjectText;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 1))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;

   case OBJ_LABEL:
      if (StringFind(m_name, "Label") == 0)
      {
         CChartObjectLabel *obj = new CChartObjectLabel;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (int)0, (int)0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 1))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_FIBOARC:
      if (StringFind(m_name, "Label") == 0)
      {
         CChartObjectFiboArc *obj = new CChartObjectFiboArc;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0,(datetime)0, 0.0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
    case OBJ_GANNFAN:
      if (StringFind(m_name, "Gann") == 0)
      {
         CChartObjectGannFan *obj = new CChartObjectGannFan;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0,(datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_GANNLINE:
      if (StringFind(m_name, "Gann") == 0)
      {
         CChartObjectGannLine *obj = new CChartObjectGannLine;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0,(datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   case OBJ_GANNGRID:
      if (StringFind(m_name, "Gann") == 0)
      {
         CChartObjectGannGrid *obj = new CChartObjectGannGrid;
         if (ObjectFind(id, m_name) < 0)
         {
            if (!obj.Create(id, m_name, sw, (datetime)0, 0.0,(datetime)0, 0.0))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
         else
         {
            if (!obj.Attach(id, m_name, sw, 2))
            {
               if (CheckPointer(obj))
                  delete obj;
            }
            else
               resobj = obj;
         }
      }
      break;
   //---end switch
   
   }
   m_obj = resobj;
   return m_obj;
}
//+------------------------------------------------------------------+
