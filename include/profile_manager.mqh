//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "Buttons/list_buttons.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VProfileManager //: public CObject
{
   int m_size;
   int m_num_profiles;
   color m_color;
   VButtonList *m_list_buttons;
   VButtonBase *m_active_button;
   string m_filename;
   OPMODE m_opmode;

   long m_chartid;
   int m_subwindow;

 public:
   VProfileManager(int num_profiles,
                   OPMODE mode,
                   int size,
                   color col);
   ~VProfileManager();
   int Size() const;
   color Color() const;
   long ChartID() const;
   int SubWindow() const;
   OPMODE OperationMode() const;
   bool OnInit();
   void OnTimer();
   void OnChartEvent(int id, long lparam, double dparam, string sparam);
   VButtonList *GetButtonListPointer();
   void SetActiveButtonPointer(VButtonBase *button);
   VButtonBase *GetActiveButtonPointer();
   int TotalButtons() const;
   bool Save();
   bool Load();
};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VProfileManager::VProfileManager(int num_profiles,
                                 OPMODE opmode,
                                 int size,
                                 color col)
{
   m_list_buttons = new VButtonList(GetPointer(this));
   m_opmode = opmode;
   m_num_profiles = num_profiles;
   m_size = size;
   m_color = col;
   m_filename = "ChartProfileManager2/" + _Symbol + "/last-state.bin";
   m_chartid = ::ChartID();
   m_subwindow = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VProfileManager::~VProfileManager()
{
   if (CheckPointer(m_active_button))
      if (CheckPointer(m_active_button.GetProfile()))
         m_active_button.GetProfile().Save();
   if (CheckPointer(m_list_buttons))
      delete m_list_buttons;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfileManager::Size() const
{
   return m_size;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color VProfileManager::Color() const
{
   return m_color;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OPMODE VProfileManager::OperationMode() const
{
   return m_opmode;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfileManager::OnInit()
{
   ObjectsDeleteAll(ChartID(), "__vb");
   ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, true);
   if (!Load())
   {
      m_list_buttons.Clear();
      VButtonBase *button = new VButtonClear(GetPointer(this), 0);
      if (!button.Create() || !m_list_buttons.Add(button))
         return false;
      for (int i = 0; i < m_num_profiles; i++)
      {
         button = new VButtonProfile(GetPointer(this));
         if (!button.Create() || !m_list_buttons.Add(button))
            return false;
      }
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VProfileManager::OnTimer()
{
   for (int i = m_list_buttons.Total() - 1; i >= 0; i--)
      m_list_buttons[i].OnTimer();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VProfileManager::OnChartEvent(int id, long lparam, double dparam, string sparam)
{
   if (id == CHARTEVENT_OBJECT_CREATE && CheckPointer(m_active_button) == POINTER_DYNAMIC)
   {
      m_active_button.AddChartObject(sparam);
   }
   for (int i = m_list_buttons.Total() - 1; i >= 0; i--)
      m_list_buttons[i].OnChartEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VButtonList *VProfileManager::GetButtonListPointer()
{
   return GetPointer(m_list_buttons);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VProfileManager::SetActiveButtonPointer(VButtonBase *button)
{
   m_active_button = button;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VButtonBase *VProfileManager::GetActiveButtonPointer()
{
   return m_active_button;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfileManager::TotalButtons() const
{
   return m_list_buttons.Total();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long VProfileManager::ChartID(void) const
{
   return m_chartid;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VProfileManager::SubWindow(void) const
{
   return m_subwindow;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfileManager::Save()
{
   int h = FileOpen(m_filename, FILE_WRITE | FILE_BIN);
   bool res = m_list_buttons.Save(h);
   if (CheckPointer(m_active_button))
      FileWriteInteger(h, m_active_button.Positon());
   else
      FileWriteInteger(h, -1);
   FileWriteInteger(h, m_list_buttons.Total());
   for (int i = 0; i < m_list_buttons.Total(); i++)
      FileWriteInteger(h, (int)m_list_buttons[i].State());

   FileClose(h);
   return res;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VProfileManager::Load()
{
   int h = FileOpen(m_filename, FILE_READ | FILE_BIN);
   if (h == INVALID_HANDLE)
      return false;
   bool res = m_list_buttons.Load(h);

   int activebutton_pos = FileReadInteger(h);

   int total_buttons = FileReadInteger(h);

   if (total_buttons != m_num_profiles + 1)
   {
      FileClose(h);
      FileDelete(m_filename);
      return false;
   }

   for (int i = 0; i < total_buttons; i++)
   {
      if ((bool)FileReadInteger(h))
         m_list_buttons[i].GetProfile().Show();
   }

   FileClose(h);
   if (!res || m_list_buttons.Total() != m_num_profiles + 1)
   {
      FileDelete(m_filename);
      return false;
   }

   if (!res)
      return false;
   if (activebutton_pos >= 0)
   {
      for (int i = m_list_buttons.Total() - 1; i >= 0; i--)
      {
         if (m_list_buttons[i].Positon() == activebutton_pos)
         {
            m_active_button = m_list_buttons[i];
            m_active_button.GetProfile().Show();
         }
      }
   }
   this.OnChartEvent((int)CHARTEVENT_CHART_CHANGE, NULL, NULL, NULL);
   return true;
}
//+------------------------------------------------------------------+
