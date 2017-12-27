//+------------------------------------------------------------------+
//|                                            PersistentObjects.mqh |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict

#include "container.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VContainerList : public CArrayObj
{
 protected:
   VProfileManager *m_mgr;

 public:
   VContainerList(VProfileManager *mgr);
   VContainer *operator[](const int i);
   bool Add(const string object_name);
   bool DetachAll();
   bool Delete(const string object_name);
   virtual bool CreateElement(const int index) override;
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VContainerList::VContainerList(VProfileManager *mgr) : m_mgr(mgr)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VContainer *VContainerList::operator[](const int i)
{
   return dynamic_cast<VContainer *>(At(i));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainerList::CreateElement(const int index) override
{
   m_data[index] = new VContainer(m_mgr);
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainerList::Add(const string object_name)
{
   for (int i = 0; i < Total(); i++)
      if (this[i].Name() == object_name)
         return false;

   VContainer *container = new VContainer(m_mgr);
   if (!container.Init(object_name) || !CArrayObj::Add(container))
   {
      if (CheckPointer(container))
         delete container;
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainerList::DetachAll()
{
   bool res = true;
   for (int i = 0; i < Total(); i++)
   {
      CChartObject *obj = this[i].GetMemberPointer();
      if (CheckPointer(obj))
         obj.Detach();
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VContainerList::Delete(const string object_name)
{
   for (int i = Total() - 1; i >= 0; i--)
   {
      if (this[i].Name() == object_name)
         return Delete(i);
   }
   return false;
}
//+------------------------------------------------------------------+
