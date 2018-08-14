;+
; :Author: Administrator
;-

    ;---------台风报文分析------------
    ;
    ;----------------------------------------------------------------------------------------------------
    ;第一种报文
    ;ZCZC
    ;WTPQ20 BABJ 270600                                   ;报文头部标签  WTPQ20：预测报文；WHCI40：登陆报文；TCPQ40：不懂
    ;SUBJECTIVE FORECAST
    ;TY JONGDARI 1812 (1812) INITIAL TIME 270600 UTC      ;台风等级，台风名称，台风代号，当前时间
    ;                                                     ;TD:Tropical Depression,TS:Tropical Storm,STS:Severe Tropical Storm,TY:Typhoon,STY:Severe Typhoon,SuperTY:Super Typhoon
    ;
    ;00HR 26.4N 143.7E 965HPA 38M/S                       ;当前位置，气压，风速
    ;30KTS WINDS 400KM NORTHEAST                          ;7级风圈大小 400KM半径 方向
    ;400KM SOUTHEAST
    ;220KM SOUTHWEST
    ;150KM NORTHWEST
    ;50KTS WINDS 80KM NORTHEAST                           ;10级风圈大小
    ;100KM SOUTHEAST
    ;60KM SOUTHWEST
    ;60KM NORTHWEST
    ;64KTS WINDS 50KM NORTHEAST                           ;12级风圈大小
    ;60KM SOUTHEAST
    ;50KM SOUTHWEST
    ;50KM NORTHWEST
    ;MOVE N 38KM/H                                        ;移动方向和速度
    ;P+12HR 30.6N 143.7E 960HPA 40M/S                     ;12小时后台风位置，气压，风速预测
    ;P+24HR 33.6N 139.9E 955HPA 42M/S
    ;P+36HR 34.8N 135.3E 982HPA 28M/S
    ;P+48HR 34.6N 131.9E 998HPA 18M/S
    ;P+60HR 34.2N 129.4E 1000HPA 15M/S=
    ;NNNN                                                 ;结束标志
    ;----------------------------------------------------------------------------------------------------
    ;第二种报文
    ;ZCZC
    ;WHCI40 BABJ 110110
    ;STY 1808 (1808) MARIA LANDED ON FUJIAN LIANJIANG      ;登陆地点
    ;110110GMT (42m/s)
    ;NNNN
    ;----------------------------------------------------------------------------------------------------
    ;第三种报文
    ;ZCZC
    ;TCPQ40 BABJ 261800
    ;CCAA 26180 99398 11165
    ;JONGDARI 12240 11409 12334 240// 90508
    ;NNNN
    ;=====================================================================================================
pro start_typhoon,out_dir=out_dir,typhoon_name=typhoon_name,pro_dir=pro_dir
  
  ;out_dir      = 'D:\0\Typhoon\Typhoon\2018'
  ;pro_dir       = 'C:\Users\Administrator\IDLWorkspace85\typhoon_text'
  
  tcs_text_name = 'tc_text_' 
  ;typhoon_name  = 'JONGDARI';SON-TINH,07,AMPIL,JONGDARI,WUKONG
  
  web_url       = 'http://www.nmc.cn/publish/typhoon/message.html'
  time_list     = '*<li><p class="time*'
  tc_text_url   = 'http://www.nmc.cn/f/rest/getContent?dataId='
  
  
  out_dir      = out_dir + path_sep()+typhoon_name
  
  DIR_CHECK =            FILE_SEARCH(out_dir,COUNT=Dir_count)
  IF Dir_count EQ 0 THEN FILE_MKDIR,out_dir,/NOEXPAND_PATH
  
  CD,out_dir
  oo = WGET(web_url,FILENAME='typhoon_html')

  CD,pro_dir
  typhoon_html  = READ_TEXT(oo)
  PRINT,'Get data from '+ web_url
  ;ANALYZE_TY_MESSAGE_TXT,typhoon_html=typhoon_html,out_dir=out_dir,tcs_text_name=tcs_text_name,time_list=time_list,tc_text_url=tc_text_url,typhoon_name=typhoon_name
  tcs_text_start  = WHERE(STRMATCH(typhoon_html,time_list) EQ 1,count)
  tcs_text_array  = FILE_SEARCH(out_dir,tcs_text_name+'*.txt')
  n = 0
  FOR i=0,count-1 DO BEGIN

    data_id       = STRSPLIT(typhoon_html[tcs_text_start[i]],'"',/extract) ;<li><p class="time " data-id="SEVP_NMC_TCFC_SFER_ETCT_ACHN_LNO_P9_20180727143000000">20180727 14:30</p></li>
    data_time     = data_id[3]                                             ;SEVP_NMC_TCFC_SFER_ETCT_ACHN_LNO_P9_20180727143000000
    data_time_sub = STRMID(data_time,STRLEN(data_time)-17,12)              ;20180727143000000
    data          = STRMID(data_time_sub,0,8)                              ;20180727
    time          = STRMID(data_time_sub,8,4)                              ;1430

    IF FILE_SEARCH(out_dir,tcs_text_name+data+'_'+time+'.txt') THEN BEGIN
      BREAK
    ENDIF ELSE BEGIN
      new_url   = tc_text_url+data_time                                    ;http://www.nmc.cn/f/rest/getContent?dataId=SEVP_NMC_TCFC_SFER_ETCT_ACHN_LNO_P9_20180727143000000
      WAIT,2

      oo        = WGET(new_url,filename=out_dir+path_sep()+'tc_html'+'.html')
      tcs_html  = READ_TEXT(oo)
      tcs_text  = tcs_html[1:-3]
      Head      = STRSPLIT(tcs_text[1],/EXTRACT)  ;报文头部标签  WTPQ20：预测报文；WHCI40：登陆报文；TCPQ40：不懂

      IF Head[0] EQ 'WTPQ20' THEN BEGIN
        Info = STRSPLIT(tcs_text[3],/EXTRACT)     ;第四行：台风等级，台风名称，台风代号，当前时间：TY JONGDARI 1812 (1812) INITIAL TIME 270600 UTC
        name  = Info[1]
        IF name EQ typhoon_name THEN BEGIN

          out_tc_text   = out_dir+PATH_SEP()+tcs_text_name+data+'_'+time+'.txt'
          OPENW,unit,out_tc_text,/GET_LUN
          FOR j=0,N_ELEMENTS(tcs_text)-1 DO BEGIN
            PRINTF,unit,STRMID(tcs_text[j],0,STRLEN(tcs_text[j])-4)
          ENDFOR
          FREE_LUN,unit

          typhoon_forcast_track,TCs_file=out_tc_text,out_dir=out_dir,data_time_sub=data_time_sub,typhoon_name=typhoon_name
          n ++
        ENDIF
      ENDIF

      IF Head[0] EQ 'WHCI40' THEN BEGIN
        Info = STRSPLIT(tcs_text[2],/EXTRACT)
        print,Info[3:-1]
      ENDIF
    ENDELSE
  ENDFOR

  IF N EQ 0 THEN BEGIN
    PRINT,'Update '+STRTRIM(N,1)+' news!'
  ENDIF ELSE BEGIN
    PRINT,'Update '+STRTRIM(N,1)+' news!'
    ii = TYPHOON_ROUTE(in_dir=out_dir,out_dir=out_dir,Typhoon_name=Typhoon_name)
  ENDELSE
  
  
  
  
  IF FILE_TEST(oo) THEN FILE_DELETE,oo, /ALLOW_NONEXISTENT
  IF FILE_TEST(out_dir+PATH_SEP()+'tc_html'+'.html') THEN FILE_DELETE,out_dir+PATH_SEP()+'tc_html'+'.html', /ALLOW_NONEXISTENT
  
  
  
end