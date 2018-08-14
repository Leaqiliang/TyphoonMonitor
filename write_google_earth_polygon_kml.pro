;+
; NAME:
;   WRITE_GOOGLE_EARTH_POLYGON_KML
;
; PURPOSE:
;
;   输出kml格式的Polygon.
;
; INPUTS:
;
;   out_kml_file:输出文件名称.
;   grid_point:经纬度数组.
;   ty_name:polygon名称.
;   color:颜色.
;
; EXAMPLE:
;
;   IDL>WRITE_GOOGLE_EARTH_POLYGON_KML,out_kml_file='temp_kml_polygon.kml',grid_point=[110,24],ty_name='temp',color='8c5500ff'
;   Open it in Google Earth.
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Written by Dr.Fan. Rewritten by Liqiliang.
;
PRO WRITE_GOOGLE_EARTH_POLYGON_KML,out_kml_file=out_kml_file,grid_point=grid_point,ty_name=ty_name,color=color
  
OPENW,unit,out_kml_file,/GET_LUN
PRINTF,unit,'<?xml version="1.0" encoding="UTF-8"?>'
PRINTF,unit,'<kml xmlns="http://earth.google.com/kml/2.2">'
PRINTF,unit,'<Document>'
PRINTF,unit,'<name>'+ty_name+'</name> '
PRINTF,unit,'<Style id="transGreenPoly">'
PRINTF,unit,'<LineStyle>'
PRINTF,unit,'<width>1.5</width>'
PRINTF,unit,'</LineStyle>'
PRINTF,unit,'<PolyStyle>'
PRINTF,unit,'<color>'+color+'</color>'
PRINTF,unit,'</PolyStyle>'
PRINTF,unit,'</Style>'
PRINTF,unit,'<Placemark>'
PRINTF,unit,'<name>Relative</name>'
PRINTF,unit,'<visibility>1</visibility>'
PRINTF,unit,'<styleUrl>#transGreenPoly</styleUrl>'
PRINTF,unit,'<Polygon>'
PRINTF,unit,'<extrude>100</extrude>'
PRINTF,unit,'<tessellate>1</tessellate>'
PRINTF,unit,'<altitudeMode>clampToGround</altitudeMode>'
PRINTF,unit,'<outerBoundaryIs>'
PRINTF,unit,'<LinearRing>'
PRINTF,unit,'<coordinates>'
PRINTF,unit,STRTRIM(GRID_POINT[0,*],1)+','+STRTRIM(GRID_POINT[1,*],1)+',100'
PRINTF,unit,'</coordinates>'
PRINTF,unit,'</LinearRing>'
PRINTF,unit,'</outerBoundaryIs>'
PRINTF,unit,'</Polygon>'
PRINTF,unit,'</Placemark>'
PRINTF,unit,'</Document>'
PRINTF,unit,'</kml>'


FREE_LUN,unit

END