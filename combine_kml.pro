;+
; NAME:
;   combine_kml
;
; PURPOSE:
;
;   合并KML文件成一个
;
; INPUTS:
;
;   file_array:待合并kml文件路径.
;   combined_file_name:合并后文件路径.
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Copyright (c) 2018, by Liqiliang. All rights reserved.
;
PRO combine_kml,file_array=file_array,combined_file_name=combined_file_name
  
  ;file_array = ['D:\0\Typhoon\Typhoon\2018\JONGDARI\Thpoon_Track_20180727_1443_Wind_circle_L7.kml','D:\0\Typhoon\Typhoon\2018\JONGDARI\Thpoon_Track_20180727_1443_Wind_circle_L10.kml','D:\0\Typhoon\Typhoon\2018\JONGDARI\Thpoon_Track_20180727_1443_Wind_circle_L12.kml']
  ;combined_file_name = '123.KML'
  
  file_txt       = READ_TEXT(file_array[0])
  PlacemarkEnd   = (WHERE(STRMATCH(file_txt,'</Placemark>') EQ 1))[0]
  
  temp = file_txt[0:PlacemarkEnd]
  
  FOR i=1,N_ELEMENTS(file_array)-1 DO BEGIN

    new_file_txt   = READ_TEXT(file_array[i])
    SytleStart     = (WHERE(STRMATCH(new_file_txt,'<Style*') EQ 1))[0]
    NePlacemarkEnd = (WHERE(STRMATCH(new_file_txt,'</Placemark>') EQ 1))[0]
    
    temp_placement = new_file_txt[SytleStart:NePlacemarkEnd]
    temp           = [temp,temp_placement]

  ENDFOR
  
  OPENW,unit,combined_file_name,/GET_LUN
  PRINTF,unit,temp
  PRINTF,unit,file_txt[PlacemarkEnd+1:-1]
  FREE_LUN,unit

END