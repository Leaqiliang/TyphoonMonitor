;+
; NAME:
;   WRITE_GOOGLE_EARTH_KML
;
; PURPOSE:
;
;   输出kml格式的Polyline.
;
; INPUTS:
;
;   out_kml_file:输出文件名称.
;   point_now:经纬度数组.
;   color:颜色.
;   
; EXAMPLE:
;
;   IDL>WRITE_GOOGLE_EARTH_KML,out_kml_file='temp_kml_polyline.kml',grid_point=[[110,111,112],[24,25,26]],color='8c5500ff'
;   Open it in Google Earth.
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Written by Dr.Fan. Rewritten by Liqiliang.
;
PRO WRITE_GOOGLE_EARTH_KML,out_kml_file,grid_point=grid_point,color=color

OPENW,unit,out_kml_file,/GET_LUN

PRINTF,unit,'<?xml version="1.0" encoding="UTF-8"?>'
PRINTF,unit,'<kml xmlns="http://earth.google.com/kml/2.2">'
PRINTF,unit,'<Document>'
PRINTF,unit,'<name>'+FILE_BASENAME(out_kml_file)+'</name> '
PRINTF,unit,'<Style id="_LinestylePlot0"> '
PRINTF,unit,'<LineStyle>'
PRINTF,unit,'<color>'+color+'</color>'
PRINTF,unit,'<width>2.00000</width>'
PRINTF,unit,'</LineStyle>'
PRINTF,unit,' </Style>'
PRINTF,unit,'<Placemark>'
PRINTF,unit,'<name>Plot</name>'
PRINTF,unit,'<description>Plot</description>'
PRINTF,unit,'<styleUrl>#_LinestylePlot0</styleUrl>'
PRINTF,unit,'<LineString>'
PRINTF,unit,' <tessellate>1</tessellate>'
PRINTF,unit,'<coordinates>'

PRINTF,unit,STRTRIM(GRID_POINT[0,*],1)+','+STRTRIM(GRID_POINT[1,*],1)+' '

PRINTF,unit,'</coordinates>'
PRINTF,unit,'</LineString>'
PRINTF,unit,'</Placemark>'
PRINTF,unit,'</Document>'
PRINTF,unit,'</kml>'
FREE_LUN,unit

END