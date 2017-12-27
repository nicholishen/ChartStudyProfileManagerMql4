//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "button_base.mqh"
#include "button_clear.mqh"
#include "button_profile.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VButtonList : public CArrayObj
{
 protected:
   VProfileManager *m_manager;

 public:
   VButtonList(VProfileManager *mgr);
   VButtonBase *operator[](int i);
   virtual bool Save(const int file_handle) override;
   virtual bool Load(const int file_handle) override;
};
//+------------------------------------------------------------------+
VButtonList::VButtonList(VProfileManager *mgr) : m_manager(mgr)
{
}

VButtonBase *VButtonList::operator[](int i)
{
   return At(i);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonList::Save(const int file_handle) override
{
   int i = 0;

   if (!CArray::Save(file_handle))
      return (false);

   if (FileWriteInteger(file_handle, m_data_total, INT_VALUE) != INT_VALUE)
      return (false);

   for (i = 0; i < m_data_total; i++)
   {
      VButtonBase *button = m_data[i];
      if (!FileWriteInteger(file_handle, button.ButtonType()))
         break;
      if (!FileWriteInteger(file_handle, StringLen(button.Name())))
         break;
      if (!FileWriteString(file_handle, button.Name()))
         break;

      if (button.Save(file_handle) != true)
         break;
   }

   return (i == m_data_total);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonList::Load(const int file_handle) override
{
   int i = 0, num;

   if (!CArray::Load(file_handle))
      return (false);

   num = FileReadInteger(file_handle, INT_VALUE);

   Clear();
   if (num != 0)
   {
      if (!Reserve(num))
         return (false);
      for (i = 0; i < num; i++)
      {
         //if(!CreateElement(i))
         int type = FileReadInteger(file_handle);
         string name = FileReadString(file_handle, FileReadInteger(file_handle));
         if (type == BUTTON_CLEAR)
         {
            m_data[i] = new VButtonClear(m_manager);
            VButtonBase *b = m_data[i];
            if (!b.Create(name))
               break;
         }
         else if (type == BUTTON_PROFILE)
         {
            m_data[i] = new VButtonProfile(m_manager);
            VButtonBase *b = m_data[i];
            if (!b.Create(name))
               break;
         }
         else
            break;
         if (m_data[i].Load(file_handle) != true)
            break;
         m_data_total++;
      }
   }
   m_sort_mode = -1;

   return (m_data_total == num);
}
//+------------------------------------------------------------------+
