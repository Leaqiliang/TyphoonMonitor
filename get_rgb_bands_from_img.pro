;+
; NAME:
;   get_rgb_bands_from_img
;
; PURPOSE:
;
;   生成RGB快视图,返回一个三维数组
;
; INPUTS:
;
;   file:影像路径
;   rgb_pos:提取的影像波段，三个
;   img_position:影像左下角经纬度
;   img_dimensions:影像x和y的range（度）
;
; EXAMPLE:
;
;   IDL>jpg_file = get_rgb_bands_from_img(file='C:\Users\Administrator\temp.img',rgb_pos = [2,3,0],img_position=img_position,img_dimensions=img_dimensions)
;   IDL>help,jpg_file
;     jpg_file          BYTE      = Array[400, 400, 3]
;
;
; AUTHOR:
;
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;
; Copyright (c) 2018, by Liqiliang. All rights reserved.
;
function get_rgb_bands_from_img,file=file,rgb_pos = rgb_pos,img_position=img_position,img_dimensions=img_dimensions
  
  COMPILE_OPT idl2
  e = ENVI(/HEADLESS)
  ;file = 'D:\data\world_data\natural_earth\NE1_50M_SR_W\NE1_50M_SR_W.img'
  ;rgb_pos = [0,1,2]
  raster_file = file
  raster_img = e.OpenRaster(raster_file)
  
  stretchRaster = ENVILinearPercentStretchRaster(raster_img, percent=5.0)
  
  Metadata = raster_img.Metadata
  samples = Metadata['samples']
  lines   = Metadata['lines']
  ;print,Metadata
  red   = stretchRaster.GetData(BAND=rgb_pos[0])
  green = stretchRaster.GetData(BAND=rgb_pos[1])
  blue  = stretchRaster.GetData(BAND=rgb_pos[2])
  
  max_value = MAX(red,min=min_value)
  red       = BYTE(ROUND((red-min_value)*250./(max_value-min_value)))
  max_value = max(green,min=min_value)
  green     = BYTE(ROUND((green-min_value)*250./(max_value-min_value)))
  max_value = max(blue,min=min_value)
  blue      = BYTE(ROUND((blue-min_value)*250./(max_value-min_value)))
  
  x_range    = samples*(FLOAT((Metadata['map info'])[5]))
  y_range    = lines*(FLOAT((Metadata['map info'])[6]))
  x_position = (Metadata['map info'])[3]
  y_position = (Metadata['map info'])[4]
  
  img_dimensions = [x_range,y_range]
  img_position = [x_position,y_position-y_range]
  
  PRINT,img_dimensions,'--',img_position
  JPG_DIR = FILEPATH(FILE_BASENAME(file)+'.JPG',/TMP)
;  WRITE_JPEG ,JPG_DIR, [[[red]],[[green]],[[blue]]] , /ORDER, QUALITY=100 ,TRUE=3
;  READ_JPEG,JPG_DIR,JPG_IMG,TRUE=3
;  ;CONGRID_JPG_IMG = CONGRID(JPG_IMG,63,63,3)
;  RETURN,JPG_IMG
  
  RETURN,[[[red]],[[green]],[[blue]]]
END