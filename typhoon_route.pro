;+
; NAME:
;   typhoon_route
;
; PURPOSE:
;
;   输出多种格式台风路径文件.
;
; INPUTS:
;
;   in_dir:包含台风报文txt文件的文件夹路径.
;   out_dir:输出文件路径.
;   Typhoon_name:台风名称.
;
; EXAMPLE:
;
;   IDL>route = typhoon_route(in_dir='C:\Users\Administrator',out_dir='C:\Users\Administrator',Typhoon_name='Ampil')
;   Generate typhoon files(txt, evf, kml)
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Written by Dr.Fan. Rewritten by Liqiliang.
;
function typhoon_route,in_dir=in_dir,out_dir=out_dir,Typhoon_name=Typhoon_name
;  in_dir       = 'D:\0\Typhoon\山神'
;  out_dir      = 'D:\0\Typhoon\SON-TINH'
;  
;  Typhoon_name = 'SON-TINH'
  search_name  = 'tc_text_*.txt' 
  
  filelists     = FILE_SEARCH(in_dir,search_name,count=file_count)
  lon_lat       = !null
  PRINT,'     - ', STRTRIM(file_count,1), ' file(s) found in the directory ',in_dir
  
  IF file_count GT 0 THEN BEGIN


    FOR i=0,file_count-1 DO BEGIN
      PRINT,'# ',STRTRIM(i+1,1),' of ',STRTRIM(file_count,1),' input file : ',filelists[i]
      Track_points = READ_TEXT(filelists[i])
      Head         = STRSPLIT(Track_points[1],/EXTRACT)
      Info         = STRSPLIT(Track_points[3],/EXTRACT)

      TF_position  = STRSPLIT(Track_points[4],/EXTRACT)
      lon          = strmid(TF_position[2],0,strlen(TF_position[2])-1)
      lat          = strmid(TF_position[1],0,strlen(TF_position[1])-1)
      lon_lat      = [[lon_lat],[[lon,lat]]]

    ENDFOR
  ENDIF
  
  DIR_CHECK  = FILE_SEARCH(out_dir,count=Dir_count)
  IF Dir_count EQ 0 THEN FILE_MKDIR,out_dir,/NOEXPAND_PATH
  
  out_kml_file   = out_dir+PATH_SEP()+'Thpoon_Route_'+Typhoon_name+'.kml'
  evf_file_point = out_dir+PATH_SEP()+'Thpoon_Route_'+Typhoon_name+'_points.evf'
  evf_file_line  = out_dir+PATH_SEP()+'Thpoon_Route_'+Typhoon_name+'_line.evf'
  lon_lat_file   = out_dir+PATH_SEP()+'Thpoon_Route_'+Typhoon_name+'_lon_lat.txt'
  lon_lat_time   = out_dir+PATH_SEP()+'Thpoon_Route_'+Typhoon_name+'_lon_lat_time.txt'

  WRITE_GOOGLE_EARTH_KML,out_kml_file,grid_point=lon_lat,color='ffD2B48C'
  ;WRITE_EVF,evf_file_point,Record_GRID_POLYGON=lon_lat,TYPE=1
  ;WRITE_EVF,evf_file_line,Record_GRID_POLYGON=lon_lat,TYPE=3

  OPENW,unit,lon_lat_file,/GET_LUN
  PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
  FREE_LUN,unit

  OPENW,unit,lon_lat_time,/GET_LUN
  PRINTF,unit,STRTRIM(lon_lat[0,*],1)+'  '+STRTRIM(lon_lat[1,*],1)+' '
  FREE_LUN,unit
  PRINT
  PRINT,'The End'
  PRINT
  
  
  return,1
end