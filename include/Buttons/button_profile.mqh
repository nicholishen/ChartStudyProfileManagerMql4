//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "../defines.mqh"
#include "../profile_manager.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VButtonProfile : public VButtonBase
{
 protected:
   static int m_instances;

 public:
   VButtonProfile(VProfileManager *mgr);
   ~VButtonProfile();
   virtual void OnChartEvent(int id, long lparam, double dparam, string sparam) override;
   virtual void ProfileState(bool flag) override;
   virtual bool Create(string name = NULL) override;
   virtual void Clear() override;
   virtual bool AddChartObject(string name) override;
};
int VButtonProfile::m_instances = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

VButtonProfile::VButtonProfile(VProfileManager *mgr) : VButtonBase(mgr)
{
   m_position = ++m_instances;
   m_type = BUTTON_PROFILE;
   m_profile = new VProfile(m_manager, m_position);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VButtonProfile::~VButtonProfile()
{
   m_instances--;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonProfile::OnChartEvent(int id, long lparam, double dparam, string sparam) override
{
   VButtonBase::OnChartEvent(id, lparam, dparam, sparam);
   //if(CheckPointer(m_profile)==POINTER_DYNAMIC)
   //   m_profile.OnChartEvent(id,lparam,dparam,sparam);
   if(id == CHARTEVENT_KEYDOWN)
   {
      int press = int(CharToStr((uchar)TranslateKey((int)lparam)));
      if(press == m_position)
      {
         State(!State());
         id = CHARTEVENT_OBJECT_CLICK;
         sparam = Name();
      }
   }
      
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == Name())
   {
      if (State())
      {
         //if (m_manager.OperationMode() == SINGLE)
         //{
         //   VButtonList *list = m_manager.GetButtonListPointer();
         //   for (int i = list.Total() - 1; i >= 0; i--)
         //   {
         //      CObject *button = list[i];
         //      if (CheckPointer(dynamic_cast<VButtonProfile *>(list[i])) && list[i].Name() != Name())
         //         list[i].ProfileState(false);
         //   }
         //}
         ProfileState(true);
      }
      else
      {
         ProfileState(false);
      }
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonProfile::ProfileState(bool flag) override
{
   if (!flag)
   {
      BackColor(m_manager.Color());
      m_manager.SetActiveButtonPointer(NULL);
      VButtonList *list = m_manager.GetButtonListPointer();
      for(int i=0;i<list.Total();i++)
      {
         //list[i].BackColor(m_manager.Color());
         if(list[i].State())
         {
            m_manager.SetActiveButtonPointer(list[i]);
            break;
         }
      }
      if (CheckPointer(m_profile))
         m_profile.Hide();
   }
   else
   {
      //State(true);
      
      if (CheckPointer(m_profile))
         m_profile.Show();
      m_manager.SetActiveButtonPointer(GetPointer(this));
      VButtonList *list = m_manager.GetButtonListPointer();
      for(int i=0;i<list.Total();i++)
      {
         VButtonProfile *profile = dynamic_cast<VButtonProfile*>(list[i]);
         if(CheckPointer(profile))
            profile.BackColor(m_manager.Color());
      }
      BackColor(clrLightGreen);
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonProfile::Create(string name = NULL) override
{
   name = name != NULL ? name : "__vb_profile__" + string(m_position);
   if (!VButtonBase::Create(name))
      return false;
   Description(string(m_position));
   Tooltip("Toggle profile " + string(m_position));
   VButtonBase::OnChartEvent(CHARTEVENT_CHART_CHANGE, NULL, NULL, NULL);
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonProfile::Clear()
{
   if (CheckPointer(m_profile) == POINTER_DYNAMIC)
      m_profile.Clear();
}
//+------------------------------------------------------------------+

bool VButtonProfile::AddChartObject(string name)
{
   if (CheckPointer(m_profile))
      m_profile.OnChartEvent(CHARTEVENT_OBJECT_CREATE, 0, 0.0, name);
   return true;
}
//+------------------------------------------------------------------+
