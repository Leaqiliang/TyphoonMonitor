;+
; NAME:
;   lon_lat_validation
;
; PURPOSE:
;
;   检测经纬度是否超出范围
;
; INPUTS:
;
;   down_left_up_right:经纬度四至
;
; EXAMPLE:
;
;   IDL>lon_lat = lon_lat_validation([10,10,100,100])
;   IDL>print,lon_lat
;     0
;   IDL>lon_lat = lon_lat_validation([10,10,70,100])
;   IDL>print,lon_lat
;     1
;     
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Copyright (c) 2018, by Liqiliang. All rights reserved.
;
FUNCTION lon_lat_validation,down_left_up_right
  down_valid  = 0
  left_valld  = 0
  up_valid    = 0
  right_valid = 0
  rl_valid    = 0
  ud_valid    = 0
  
  IF down_left_up_right[0] GE -90  AND down_left_up_right[0] LT  90  THEN down_valid  = 1
  IF down_left_up_right[1] GE -180 AND down_left_up_right[1] LT  180 THEN left_valld  = 1
  IF down_left_up_right[2] LE  90  AND down_left_up_right[2] GT -90  THEN up_valid    = 1
  IF down_left_up_right[3] LE  540 AND down_left_up_right[3] GT -180 THEN right_valid = 1
  
  IF down_left_up_right[2] GT down_left_up_right[0] THEN rl_valid = 1
  IF down_left_up_right[3] GT down_left_up_right[1] THEN ud_valid = 1
  
  RETURN,down_valid*left_valld*up_valid*right_valid*rl_valid*ud_valid
end