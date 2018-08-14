;+
; NAME:
;   WRITE_GOOGLE_EARTH_POINT_KML
;
; PURPOSE:
;
;   输出kml格式的Point.
;
; INPUTS:
;
;   out_kml_file:输出文件名称.
;   point_now:经纬度数组.
;   ty_name:point名称.
;
; EXAMPLE:
;
;   IDL>WRITE_GOOGLE_EARTH_POINT_KML,out_kml_file='temp_kml_polygon.kml',point_now=[110,24],ty_name='temp'
;   Open it in Google Earth.
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Written by Dr.Fan. Rewritten by Liqiliang.
;
PRO WRITE_GOOGLE_EARTH_POINT_KML,out_kml_file,point_now=point_now,ty_name=ty_name

OPENW,unit,out_kml_file,/GET_LUN

PRINTF,unit,'<?xml version="1.0" encoding="UTF-8"?>'
PRINTF,unit,'<kml xmlns="http://www.opengis.net/kml/2.2">'
PRINTF,unit,'<Document>'
PRINTF,unit,'<Style id="downArrowIcon">'
PRINTF,unit,'<IconStyle>'
PRINTF,unit,'<Icon>'
PRINTF,unit,'<href>C:\Users\Administrator\Desktop\Emoji_u1f300.svg.png</href>'
PRINTF,unit,'</Icon>'
PRINTF,unit,'</IconStyle>'
PRINTF,unit,'<width>10</width>'
PRINTF,unit,'</Style>'
PRINTF,unit,'<Placemark>'
PRINTF,unit,'<name>'+ty_name+'</name>'
PRINTF,unit,'<visibility>1</visibility>'
PRINTF,unit,'<description>Floats a defined distance above the ground.</description>'
PRINTF,unit,'<LookAt>'
PRINTF,unit,'<longitude>'+STRTRIM(point_now[0],1)+'</longitude>'
PRINTF,unit,'<latitude>'+STRTRIM(point_now[1],1)+'</latitude>'
PRINTF,unit,'<range>2000000</range>'
PRINTF,unit,'</LookAt>'
PRINTF,unit,'<styleUrl>#downArrowIcon</styleUrl>'
PRINTF,unit,'<Point>'
PRINTF,unit,'<altitudeMode>relativeToGround</altitudeMode>'
PRINTF,unit,'<coordinates>'

PRINTF,unit,STRTRIM(point_now[0],1)+','+STRTRIM(point_now[1],1)+','+'50'

PRINTF,unit,'</coordinates>'
PRINTF,unit,'</Point>'
PRINTF,unit,'</Placemark>'
PRINTF,unit,'</Document>'
PRINTF,unit,'</kml>'
FREE_LUN,unit

END
