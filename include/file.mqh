//+------------------------------------------------------------------+
//|                                                         file.mqh |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict
#include <Files\FileBin.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VFile : public CFileBin
{
 public:
   bool WriteString(const string value)
   {
      if (m_handle != INVALID_HANDLE)
      {
         int size = StringLen(value);
         if (!FileWriteInteger(m_handle, size))
            return false;
         return (FileWriteString(m_handle, value, size) > 0);
      }
      return false;
   }
   string ReadString()
   {
      if (m_handle != INVALID_HANDLE)
      {
         int size = FileReadInteger(m_handle);
         return FileReadString(m_handle, size);
      }
      return "";
   }
   void Init(const string file_name) { m_name = file_name; }

   int OpenRead()
   {
      if (m_handle != INVALID_HANDLE)
         Close();
      m_handle = FileOpen(m_name, FILE_READ | FILE_BIN);
      return (m_handle);
   }
   int OpenWrite()
   {
      if (m_handle != INVALID_HANDLE)
         Close();
      m_handle = FileOpen(m_name, FILE_WRITE | FILE_BIN);
      return (m_handle);
   }
};
//+------------------------------------------------------------------+
