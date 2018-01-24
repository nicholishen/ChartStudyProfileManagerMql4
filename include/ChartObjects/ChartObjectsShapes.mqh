//+------------------------------------------------------------------+
//|                                           ChartObjectsShapes.mqh |
//|                   Copyright 2009-2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//| All shapes.                                                      |
//+------------------------------------------------------------------+
#include "ChartObject.mqh"
//+------------------------------------------------------------------+
//| Class CChartObjectRectangle.                                     |
//| Purpose: Class of the "Rectangle" object of chart.               |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectRectangle : public CChartObject
  {
public:
                     CChartObjectRectangle(void);
                    ~CChartObjectRectangle(void);
   //--- method of creating the object
   bool              Create(long chart_id,const string name,const int window,
                            const datetime time1,const double price1,
                            const datetime time2,const double price2);
   //--- method of identifying the object
   virtual int       Type(void) const { return(OBJ_RECTANGLE); }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CChartObjectRectangle::CChartObjectRectangle(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CChartObjectRectangle::~CChartObjectRectangle(void)
  {
  }
//+------------------------------------------------------------------+
//| Create object "Rectangle"                                        |
//+------------------------------------------------------------------+
bool CChartObjectRectangle::Create(long chart_id,const string name,const int window,
                                   const datetime time1,const double price1,
                                   const datetime time2,const double price2)
  {
   if(!ObjectCreate(chart_id,name,OBJ_RECTANGLE,window,time1,price1,time2,price2))
      return(false);
   if(!Attach(chart_id,name,window,2))
      return(false);
//--- successful
   return(true);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectTriangle.                                      |
//| Purpose: Class of the "Triangle" object of chart.                |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectTriangle : public CChartObject
  {
public:
                     CChartObjectTriangle(void);
                    ~CChartObjectTriangle(void);
   //--- method of creating the object
   bool              Create(long chart_id,const string name,const int window,
                            const datetime time1,const double price1,
                            const datetime time2,const double price2,
                            const datetime time3,const double price3);
   //--- method of identifying the object
   virtual int       Type(void) const { return(OBJ_TRIANGLE); }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CChartObjectTriangle::CChartObjectTriangle(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CChartObjectTriangle::~CChartObjectTriangle(void)
  {
  }
//+------------------------------------------------------------------+
//| Create object "Triangle"                                         |
//+------------------------------------------------------------------+
bool CChartObjectTriangle::Create(long chart_id,const string name,const int window,
                                  const datetime time1,const double price1,
                                  const datetime time2,const double price2,
                                  const datetime time3,const double price3)
  {
   if(!ObjectCreate(chart_id,name,OBJ_TRIANGLE,window,time1,price1,time2,price2,time3,price3))
      return(false);
   if(!Attach(chart_id,name,window,3))
      return(false);
//--- successful
   return(true);
  }
//+------------------------------------------------------------------+
//| Class CChartObjectEllipse.                                       |
//| Purpose: Class of the "Ellipse" object of chart.                 |
//|          Derives from class CChartObject.                        |
//+------------------------------------------------------------------+
class CChartObjectEllipse : public CChartObject
  {
public:
                     CChartObjectEllipse(void);
                    ~CChartObjectEllipse(void);
   //--- method of creating the object
   bool              Create(long chart_id,const string name,const int window,
                            const datetime time1,const double price1,
                            const datetime time2,const double price2,
                            const double ellipse_scale=1.0);
   //--- method of identifying the object
   virtual int       Type(void) const { return(OBJ_ELLIPSE); }
   virtual bool      Save(const int file_handle) override;
   virtual bool      Load(const int file_handle) override;
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CChartObjectEllipse::CChartObjectEllipse(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CChartObjectEllipse::~CChartObjectEllipse(void)
  {
  }
//+------------------------------------------------------------------+
//| Create object "Ellipse"                                          |
//+------------------------------------------------------------------+
bool CChartObjectEllipse::Create(long chart_id,const string name,const int window,
                                 const datetime time1,const double price1,
                                 const datetime time2,const double price2,
                                 const double ellipse_scale=1.0)
  {
   if(!ObjectCreate(chart_id,name,OBJ_ELLIPSE,window,time1,price1,time2,price2))
      return(false);
   if(!ObjectSetDouble(chart_id,name,OBJPROP_SCALE,ellipse_scale)) 
      return false;
   if(!Attach(chart_id,name,window,2))
      return(false);
//--- successful
   return(true);
  }
//+------------------------------------------------------------------+

bool CChartObjectEllipse::Save(const int file_handle)override
{
   if(!CChartObject::Save(file_handle))
      return false;
   if(FileWriteDouble(file_handle,ObjectGetDouble(m_chart_id,m_name,OBJPROP_SCALE))!=sizeof(double))
      return false;
   return true;
}

bool CChartObjectEllipse::Load(const int file_handle)override
{
   if(!CChartObject::Load(file_handle))
      return false;   
   if(!ObjectSetDouble(m_chart_id,m_name,OBJPROP_SCALE,FileReadDouble(file_handle)))
      return false; 
   return true;
}