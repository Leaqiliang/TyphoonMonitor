;+
; NAME:
;   typhoon_forcast_track
;
; PURPOSE:
;
;   输出台风预测路劲，风圈
;
; INPUTS:
;
;   TCs_file:台风报文文件路径.
;   out_dir:输出文件路径.
;   data_time_sub:当前台风时间戳.
;   typhoon_name：台风名称
;
; EXAMPLE:
;
;   IDL>READ_TCs_txt,TCs_file='C:\Users\Administrator\tcs_text_201807271430.txt',out_dir='C:\Users\Administrator',data_time_sub='20180727143000000',typhoon_name='Ampil'
;   Generate typhoon files(txt, evf, kml)
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Written by Dr.Fan. Rewritten by Liqiliang.
;
PRO typhoon_forcast_track,TCs_file=TCs_file,out_dir=out_dir,data_time_sub=data_time_sub,typhoon_name=typhoon_name
 
 
   Track_points  = READ_TEXT(TCs_file)

   FOR i=0,N_ELEMENTS(Track_points)-1 DO PRINT,'      #',STRTRIM(i,1),' ',Track_points[i]
   
   Move_index        = (WHERE(STRMATCH(Track_points,'MOVE*') EQ 1))[0]
   End_index         = (WHERE(STRMATCH(Track_points,'NNNN') EQ 1))[0]
   Location_index    = (WHERE(STRMATCH(Track_points,'00HR*') EQ 1))[0]
   Wind_circle_30kts = (WHERE(STRMATCH(Track_points,'30KTS*') EQ 1))[0]
   Wind_circle_50kts = (WHERE(STRMATCH(Track_points,'50KTS*') EQ 1))[0]
   Wind_circle_64kts = (WHERE(STRMATCH(Track_points,'64KTS*') EQ 1))[0]
   data              = strmid(data_time_sub,0,8)
   Ttime             = strmid(data_time_sub,8,4)
   
   ;输出当前台风位置KML
   IF Location_index NE -1 THEN BEGIN
     out_kml_point = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Point.kml'
     TY_Location   = STRSPLIT(Track_points[Location_index],/EXTRACT)
     lon           = STRMID(TY_Location[2],0,STRLEN(TY_Location[2])-1)
     lat           = STRMID(TY_Location[1],0,STRLEN(TY_Location[1])-1)
     lon_lat_1     = [lon,lat]
     Time_1        = TY_Location[0]
     WRITE_GOOGLE_EARTH_POINT_KML,out_kml_point,point_now=lon_lat_1,ty_name=typhoon_name
   ENDIF

   
   IF End_index-Move_index-1 GT 0 AND Move_index*End_index GT 0 THEN BEGIN
  
       lon_lat       = MAKE_ARRAY(2,End_index-Move_index,/STRING,value='')
       time          = STRARR(End_index-Move_index)
       lon_lat[*,0]  = lon_lat_1
       Time_1[0]     = Time_1
       
       ;输出台风预测路线 KML，EVF
       FOR i= Move_index+1,End_index-1 DO BEGIN
        temp = STRSPLIT(Track_points[i],/EXTRACT)
        lon  = STRMID(temp[2],0,STRLEN(temp[2])-1)
        lat  = STRMID(temp[1],0,STRLEN(temp[1])-1)
        tmpindex             = i-Move_index
        Time[tmpindex]       = temp[0]
        lon_lat[*,tmpindex] = [lon,lat]
       ENDFOR
       
        DIR_CHECK  = FILE_SEARCH(out_dir,count=Dir_count)
        IF Dir_count EQ 0 THEN FILE_MKDIR,out_dir,/NOEXPAND_PATH
  
        out_kml_file   = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'.kml'
        evf_file_point = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_points.evf'
        evf_file_line  = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_line.evf'
        lon_lat_file   = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_lon_lat.txt'
        lon_lat_time   = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_lon_lat_time.txt'
        
        
        WRITE_GOOGLE_EARTH_KML,out_kml_file,grid_point=lon_lat,color='FFC0CBcb'
        ;WRITE_EVF,evf_file_point,Record_GRID_POLYGON=lon_lat,TYPE=1
        ;WRITE_EVF,evf_file_line,Record_GRID_POLYGON=lon_lat,TYPE=3
  
        OPENW,unit,lon_lat_file,/GET_LUN
        PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
        FREE_LUN,unit
        
        OPENW,unit,lon_lat_time,/GET_LUN
        PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '+time
        FREE_LUN,unit
        PRINT
        PRINT,'The End'
        PRINT
   ENDIF ELSE BEGIN
    PRINT
   ENDELSE
  
   ;输出风圈 KML
   wind_file_30kts = '' & wind_file_50kts = '' & wind_file_64kts = ''
   IF Wind_circle_30kts NE -1 THEN BEGIN
     radii_array         = !NULL
     wind_file_30kts     = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L7.kml'
     wind_file_30kts_txt = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L7.txt'
     FOR i= Wind_circle_30kts,Wind_circle_30kts+3 DO BEGIN
       temp        = STRSPLIT(Track_points[i],/EXTRACT)
       radii       = STRMID(temp[-2],0,STRLEN(temp[-2])-2)
       radii_array = [radii_array,radii]
     ENDFOR
     lon_lat       = WRITE_Wind_circle(lon=lon_lat_1[0],lat=lon_lat_1[1],distance_array=radii_array)
     WRITE_GOOGLE_EARTH_POLYGON_KML,out_kml_file=wind_file_30kts,grid_point=lon_lat,ty_name=typhoon_name+'_Wind_circle_L7_'+data+'_'+Ttime,color='7d00ff00'
     
     OPENW,unit,wind_file_30kts_txt,/GET_LUN
     PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
     FREE_LUN,unit
   ENDIF
   IF Wind_circle_50kts NE -1 THEN BEGIN
     radii_array         = !NULL
     wind_file_50kts     = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L10.kml'
     wind_file_50kts_txt = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L10.txt'
     FOR i= Wind_circle_50kts,Wind_circle_50kts+3 DO BEGIN
       temp        = STRSPLIT(Track_points[i],/EXTRACT)
       radii       = STRMID(temp[-2],0,STRLEN(temp[-2])-2)
       radii_array = [radii_array,radii]
     ENDFOR
     lon_lat = WRITE_Wind_circle(lon=lon_lat_1[0],lat=lon_lat_1[1],distance_array=radii_array)
     WRITE_GOOGLE_EARTH_POLYGON_KML,out_kml_file=wind_file_50kts,grid_point=lon_lat,ty_name=typhoon_name+'_Wind_circle_L10_'+data+'_'+Ttime,color='b300ffff'
     
     OPENW,unit,wind_file_50kts_txt,/GET_LUN
     PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
     FREE_LUN,unit
   ENDIF
   IF Wind_circle_64kts NE -1 THEN BEGIN
     radii_array         = !NULL
     wind_file_64kts     = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L12.kml'
     wind_file_64kts_txt = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_L12.txt'
     FOR i= Wind_circle_64kts,Wind_circle_64kts+3 DO BEGIN
       temp  = STRSPLIT(Track_points[i],/EXTRACT)
       radii = STRMID(temp[-2],0,STRLEN(temp[-2])-2)
       radii_array = [radii_array,radii]
     ENDFOR
     lon_lat = WRITE_Wind_circle(lon=lon_lat_1[0],lat=lon_lat_1[1],distance_array=radii_array)
     WRITE_GOOGLE_EARTH_POLYGON_KML,out_kml_file=wind_file_64kts,grid_point=lon_lat,ty_name=typhoon_name+'_Wind_circle_L12_'+data+'_'+Ttime,color='8c5500ff'
     
     OPENW,unit,wind_file_64kts_txt,/GET_LUN
     PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
     FREE_LUN,unit
   ENDIF
   
   ;合并L7,L10,L12风圈
   IF Wind_circle_30kts NE -1 OR Wind_circle_50kts NE -1 OR Wind_circle_64kts NE -1 THEN BEGIN
     kml_file_array = [wind_file_30kts,wind_file_50kts,wind_file_64kts]
     kml_file_lable = ['L7','L10','L12']
     valid_kml_file_index = WHERE(kml_file_array NE '')
     valid_kml_file_array = kml_file_array[valid_kml_file_index]
     valid_lable_string = '' & foreach element, valid_kml_file_index,i do valid_lable_string = valid_lable_string +kml_file_lable[valid_kml_file_index[i]]
     combined_file_name = out_dir+PATH_SEP()+'Thpoon_Track_'+data+'_'+Ttime+'_Wind_circle_'+valid_lable_string+'.kml'
     combine_kml,file_array=valid_kml_file_array,combined_file_name=combined_file_name
     IF FILE_TEST(kml_file_array[0]) THEN FILE_DELETE,kml_file_array[0], /ALLOW_NONEXISTENT,/QUIET
     IF FILE_TEST(kml_file_array[1]) THEN FILE_DELETE,kml_file_array[1], /ALLOW_NONEXISTENT,/QUIET
     IF FILE_TEST(kml_file_array[2]) THEN FILE_DELETE,kml_file_array[2], /ALLOW_NONEXISTENT,/QUIET
   ENDIF
  
END