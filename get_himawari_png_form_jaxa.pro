pro get_himawari_png_form_JAXA
  
  ;out_dir = 'C:\Users\Administrator'
  latest_json = 'http://www.eorc.jaxa.jp/ptree/js/himawari_set_latest.json'
  
  ;cd,out_dir
  ooj = WGET(latest_json)
  
  JSON_file = read_text(oo)
  TEMP = ''
  FOR i=0,FILE_LINES(oo)-1 DO TEMP = TEMP + JSON_file[i]

  output      = JSON_PARSE(TEMP, /DICTIONARY)
  latest_year = STRTRIM(STRING(output.latest.year,FORMAT='(I04)'),1)
  latest_mon  = STRTRIM(STRING(output.latest.mon, FORMAT='(I02)'),1)
  latest_day  = STRTRIM(STRING(output.latest.day, FORMAT='(I02)'),1)
  latest_hour = STRTRIM(STRING(output.latest.hour,FORMAT='(I02)'),1)
  latest_min  = STRTRIM(STRING(output.latest.min, FORMAT='(I02)'),1)
  time_string = latest_year+'/'+latest_mon+'/'+latest_day+'/'+latest_hour+'/'+latest_min

  oo1 = WGET('http://www.eorc.jaxa.jp/ptree/map/himawari/L1_RGB/'+time_string+'/3/6/4.png',filename='E90N0.png')
  oo2 = WGET('http://www.eorc.jaxa.jp/ptree/map/himawari/L1_RGB/'+time_string+'/3/7/4.png',filename='E135N0.png')
  
  IF FILE_TEST(ooj) THEN FILE_DELETE,ooj, /ALLOW_NONEXISTENT
  IF FILE_TEST(oo1) THEN FILE_DELETE,oo1, /ALLOW_NONEXISTENT
  IF FILE_TEST(oo2) THEN FILE_DELETE,oo2, /ALLOW_NONEXISTENT
  
END
