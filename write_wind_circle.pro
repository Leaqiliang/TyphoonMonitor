;+
; NAME:
;   write_wind_circle
;
; PURPOSE:
;
;   根据中心点经纬度，四个方向的距离数据，返回表示风圈的点集
;
; INPUTS:
;
;   lon:经度.
;   lat:纬度.
;   distance_array:距离数组（m）.
;   
; EXAMPLE:
;
;   IDL>lon_lat = write_wind_circle(lon=lon,lat=lat,distance_array=distance_array)
;   IDL>print,lon_lat
;    110.00000       32.991202
;    111.70906       32.854605
;    113.36619       32.448966
;    114.92104       31.786609
;    116.32637       30.887660
;    117.53948       29.779433
;    118.52350       28.495601
;    ......
;    107.64366       29.914276
;    108.80365       30.198224
;    110.00000       30.293841
;    110.00000       32.991202
;    
; AUTHOR:
; 
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;   
; Copyright (c) 2018, by Liqiliang. All rights reserved.
;
function write_wind_circle,lon=lon,lat=lat,distance_array=distance_array
  compile_opt idl2

  
  angle    = 0
  num = 9
  
  circle_angle = 90/num
  lon_lat  = !null
  FOR j=0,3 DO BEGIN
    distance = distance_array[j]
    ;print,'--'
    FOR i=0,num DO BEGIN
      ;print,angle
      ff = POIN_OFFSET(lon=lon,lat=lat,distance=distance,angle=angle)
      angle = angle + circle_angle
      lon_lat = [[lon_lat],[[ff]]]
    ENDFOR
    angle = angle - circle_angle
  ENDFOR

  lon_lat = [[lon_lat],[lon_lat[*,0]]]
  return,lon_lat
  
  
END