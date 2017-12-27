//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict

#include "profile.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VProfileList : public CArrayObj
{
   VProfileManager *m_mgr;

 public:
   VProfileList(VProfileManager *mgr);
   VProfile *operator[](const int i);
   bool GetProfileAt(VProfile *ptr, const int profile_number);
   virtual bool Save();
   virtual bool CreateElements(const int num_profiles);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VProfileList::VProfileList(VProfileManager *mgr) : m_mgr(mgr)
{
}

VProfile *VProfileList::operator[](const int i)
{
   return At(i);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfileList::CreateElements(const int num_profiles)
{
   for (int i = 0; i < num_profiles; i++)
   {
      VProfile *profile = new VProfile(m_mgr);
      if (!CArrayObj::Add(profile))
         return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfileList::Save(void)
{
   for (int i = 0; i < Total(); i++)
      if (!this[i].Save())
         return false;
   return true;
}
//+------------------------------------------------------------------+
bool VProfileList::GetProfileAt(VProfile *ptr, const int profile_number)
{
   Sort();
   ptr = this[profile_number];
   if (ptr != NULL && ptr.ProfileNumber() == profile_number)
      return true;
   ptr = this[0];
   for (int i = 0; i < Total() && ptr != NULL; ptr = this[++i])
      if (ptr.ProfileNumber() == profile_number)
         return true;
   return false;
}
//+------------------------------------------------------------------+
