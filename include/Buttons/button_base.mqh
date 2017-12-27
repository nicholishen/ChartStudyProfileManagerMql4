//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "../defines.mqh"
//#include "../profile_manager.mqh"
#include "../Profiles/profile.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VButtonBase : public CChartObjectButton
{
 protected:
   VProfileManager *m_manager;
   VProfile *m_profile;
   int m_position;
   CChartObjectLabel m_label;
   int m_type;
   bool m_firstclick;

 public:
   VButtonBase(VProfileManager *mgr);
   ~VButtonBase();
   virtual void AssignProfile(VProfile *profile);
   virtual void OnTimer();
   virtual void OnChartEvent(int id, long lparam, double dparam, string sparam);
   virtual void ProfileState(bool flag);
   virtual void Clear();
   virtual int ButtonType() const;
   virtual int Positon() const;
   virtual bool Save(const int file_handle) override;
   virtual bool Load(const int file_handle) override;
   virtual bool Create(string name = NULL);
   virtual bool AddChartObject(string name);
   virtual VProfile *GetProfile() { return m_profile; }

 protected:
   int ChartWidth();
   int ChartHeight();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

VButtonBase::VButtonBase(VProfileManager *mgr) : m_manager(mgr)
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VButtonBase::~VButtonBase()
{
   if (CheckPointer(m_profile))
      delete m_profile;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VButtonBase::OnTimer()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void VButtonBase::OnChartEvent(int id, long lparam, double dparam, string sparam)
{
   if (id == CHARTEVENT_CHART_CHANGE)
   {
      int size = m_manager.Size();
      int x = (ChartWidth() - (m_manager.TotalButtons() * size)) / 2;
      int y = ChartHeight() / 2;
      X_Distance(x + int(size * m_position));
      if (m_label.ChartId() >= 0)
      {
         m_label.X_Distance(ChartWidth() / 2);
         m_label.Y_Distance(y);
      }
      X_Size(size);
      Y_Size(size);
      FontSize(int((double)size / 2));
   }
}

void VButtonBase::AssignProfile(VProfile *profile) { m_profile = profile; }
void VButtonBase::ProfileState(bool flag) {}
//bool VButtonBase::Create() { return true; }
void VButtonBase::Clear() {}
int VButtonBase::ButtonType() const { return m_type; }
int VButtonBase::Positon() const { return m_position; }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonBase::Save(const int file_handle) override
{
   //if(!FileWriteInteger(file_handle,(int)m_type)) // for create element
   //   return false;
   if (!FileWriteInteger(file_handle, m_position))
      return false;
   bool save_label = m_label.ChartId() >= 0;
   if (!FileWriteInteger(file_handle, (int)save_label))
      return false;
   if (save_label)
      if (!m_label.Save(file_handle))
         return false;
   if (!CChartObjectButton::Save(file_handle))
      return false;
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonBase::Load(const int file_handle) override
{
   m_position = FileReadInteger(file_handle);
   bool load_label = (bool)FileReadInteger(file_handle);
   if (load_label)
   {
      if (!m_label.Create(0, "__Profile_" + (string)m_position, 0, 0, 0))
         return false;
      if (!m_label.Load(file_handle))
         return false;
   }
   if (!CChartObjectButton::Load(file_handle))
      return false;
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonBase::Create(string name = NULL)
{
   if (!Create(0, name, 0, 0, 0, 0, 0))
      return false;
   X_Size(m_manager.Size());
   Y_Size(m_manager.Size());
   int x = ChartWidth() / 2;
   Corner(CORNER_LEFT_UPPER);
   BackColor(m_manager.Color());
   Z_Order(100);
   FontSize(int(double(m_manager.Size()) / 1.0));
   Font("Consolas");
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VButtonBase::ChartWidth()
{
   return (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS, 0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VButtonBase::ChartHeight()
{
   return (int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS, 0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VButtonBase::AddChartObject(string name)
{
   return false;
}
//+------------------------------------------------------------------+
