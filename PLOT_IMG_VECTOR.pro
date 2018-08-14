function remove_typhoon_vector
  COMMON SHARE3,MAP,M1,M2,GRID,tree_node,Typhoon_name_list,Route_line_list,Typhoon_text_list,Track_line_list,rgb_img_list,rgb_img_name_list,Wind_circle_list_L7,Wind_circle_list_L10,Wind_circle_list_L12,Symbol_list,Symbol_name_list,Vector_list,Vector_name_list,Vector_line_list,Vector_line_name_list,Warning_line_24_list,Warning_line_48_list,Typhoon_current_time,Text_list,Text_name_list,Title_list

  num = n_elements(Typhoon_name_list)

  FOR i=0,num-1 DO BEGIN
    Route_line_list[i].delete
    Typhoon_text_list[i].delete
    Track_line_list[i].delete
    IF OBJ_VALID(Wind_circle_list_L7[i]) THEN Wind_circle_list_L7[i].delete
    IF OBJ_VALID(Wind_circle_list_L7[i]) THEN Wind_circle_list_L10[i].delete
    IF OBJ_VALID(Wind_circle_list_L7[i]) THEN Wind_circle_list_L12[i].delete
    Typhoon_current_time.delete
  ENDFOR
  RETURN,1
end

FUNCTION show_typhoon_vector,ProjectDir=ProjectDir,time_flag=time_flag
  ;Typhoon_DIR_list = FILE_SEARCH(ProjectDir,'*',/TEST_DIRECTORY,COUNT=COUNT)
  COMMON SHARE3,MAP,M1,M2,GRID,tree_node,Typhoon_name_list,Route_line_list,Typhoon_text_list,Track_line_list,rgb_img_list,rgb_img_name_list,Wind_circle_list_L7,Wind_circle_list_L10,Wind_circle_list_L12,Symbol_list,Symbol_name_list,Vector_list,Vector_name_list,Vector_line_list,Vector_line_name_list,Warning_line_24_list,Warning_line_48_list,Typhoon_current_time,Text_list,Text_name_list,Title_list

  
  FOREACH ELEMENT, Typhoon_name_list, i DO BEGIN
    typhoon_dir = ProjectDir + PATH_SEP() + Typhoon_name_list

    tc_text_files = FILE_SEARCH(typhoon_dir,'tc_text_*.txt')
    IF FILE_TEST(tc_text_files[-1]) THEN BEGIN
      time_flag = STRMID(FILE_BASENAME(tc_text_files[-1]),8,13)        ;tc_text_20180803_1108.txt    20180803_1108
      Route_line_file = FILE_SEARCH(typhoon_dir,'Thpoon_Route*lon_lat.txt')
      Track_line_file = FILE_SEARCH(typhoon_dir,'Thpoon_Track*lon_lat.txt')
      Wind_circle_file_L7 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L7.txt');Wind_circle_list_L7
      Wind_circle_file_L10 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L10.txt')
      Wind_circle_file_L12 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L12.txt')
    ENDIF
    ;-----------------------------------------------------------------------------------
    
    IF FILE_TEST(Route_line_file) THEN BEGIN
      IF FILE_LINES(Route_line_file) GT 1 THEN BEGIN
        lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Route_line_file,LINE=2,flag_ok=flag_ok)
        IF flag_ok EQ 1 THEN BEGIN
          x = REFORM(FLOAT(lon_lat_arr[0,*]))
          y = REFORM(FLOAT(lon_lat_arr[1,*]))
          Route_line_list[i]   = POLYLINE(x, y, COLOR=!COLOR.AQUA, THICK=2, /DATA,HIDE=0)
        ENDIF
      ENDIF ELSE BEGIN
        Result = OBJ_NEW()
        Route_line_list   = [Route_line_list,Result]
      ENDELSE
      IF FILE_LINES(Route_line_file) EQ 1 THEN BEGIN
        lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Route_line_file,LINE=2,flag_ok=flag_ok)
        IF flag_ok EQ 1 THEN BEGIN
          x = FLOAT(lon_lat_arr[0])
          Y = FLOAT(lon_lat_arr[1])
        ENDIF
      ENDIF
    ENDIF
    ;-----------------------------------------------------------------------------
    Typhoon_text_list[i] = TEXT(x[-1],y[-1]+1,Typhoon_name_list[i], /DATA, COLOR=!COLOR.NAVY,HIDE=0)
    ;-----------------------------------------------------------------------------

    IF FILE_TEST(Track_line_file[-1]) THEN BEGIN
      lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Track_line_file[-1],LINE=2,flag_ok=flag_ok)
      IF flag_ok EQ 1 THEN BEGIN
        x = REFORM(FLOAT(lon_lat_arr[0,*]))
        y = REFORM(FLOAT(lon_lat_arr[1,*]))
        Track_line_list[i]   = POLYLINE(x, y, COLOR=!COLOR.HOT_PINK, THICK=2, /DATA,HIDE=0,LINESTYLE=2)
      ENDIF
    ENDIF
    ;-------------------------------------------------------------------------------

    IF FILE_TEST(Wind_circle_file_L7) THEN BEGIN
      lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L7,LINE=2,flag_ok=flag_ok)
      IF flag_ok EQ 1 THEN BEGIN
        x                    = REFORM(FLOAT(lon_lat_arr[0,*]))
        y                    = REFORM(FLOAT(lon_lat_arr[1,*]))
        Wind_circle_list_L7[i]  = POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.LIME_GREEN,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)
      ENDIF
    ENDIF
    ;----------------------------------------------------------------------------------


    IF FILE_TEST(Wind_circle_file_L10[-1]) THEN BEGIN
      lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L10,LINE=2,flag_ok=flag_ok)
      IF flag_ok EQ 1 THEN BEGIN
        x                    = REFORM(FLOAT(lon_lat_arr[*,0]))
        y                    = REFORM(FLOAT(lon_lat_arr[*,1]))
        Wind_circle_list_L10[i]  = POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.GOLD,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)
      ENDIF
    ENDIF
    ;------------------------------------------------------------------------------------

    IF FILE_TEST(Wind_circle_file_L12[-1]) THEN BEGIN
      lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L12,LINE=2,flag_ok=flag_ok)
      IF flag_ok EQ 1 THEN BEGIN
        x                    = REFORM(FLOAT(lon_lat_arr[*,0]))
        y                    = REFORM(FLOAT(lon_lat_arr[*,1]))
        Wind_circle_list_L12[i]  = POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.RED,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)
      ENDIF
    ENDIF

  ENDFOREACH

  ;IF FILE_TEST(tc_text_files[-1]) THEN BEGIN
  year = STRMID(time_flag,0,4) & month = STRMID(time_flag,4,2) & day = STRMID(time_flag,6,2) & hour = STRMID(time_flag,9,2) & minute = STRMID(time_flag,11,2)
  Typhoon_current_time = TEXT(0.8,0.06,['   '+hour+':'+minute+' AM',' '+year+'-'+month+'-'+day,'Beijing Time'], COLOR=!COLOR.white,HIDE=0,/CURRENT,/RELATIVE,TARGET=m1,FONT_STYLE=1)
  
  ;ENDIF
  RETURN,1
END

PRO MY_TREE_UPDATE_DESCENDANTS, node, state

  COMPILE_OPT IDL2

  children = WIDGET_INFO( node, /ALL_CHILDREN )
  IF ( children[0] EQ 0 ) THEN RETURN
  FOREACH c, children DO BEGIN
    WIDGET_CONTROL, c, SET_TREE_CHECKED = state
    MY_TREE_UPDATE_DESCENDANTS, c, state
  ENDFOREACH
END

PRO MY_TREE_UPDATE_ANCESTORS, node

  COMPILE_OPT IDL2

  parent = WIDGET_INFO( node, /parent )
  IF ( parent NE 0 AND WIDGET_INFO( parent, /type ) EQ 11 ) THEN BEGIN
    children = WIDGET_INFO( parent, /all_children )
    nOnes = TOTAL( WIDGET_INFO( children, /TREE_CHECKED ) eq 1 )
    nTwos = TOTAL( WIDGET_INFO( children, /TREE_CHECKED ) eq 2 )
    nChildren = N_ELEMENTS( children )
    IF ( nOnes EQ nChildren ) THEN BEGIN
      newState = 1
    ENDIF ELSE IF ( nOnes GE 1 || nTwos GE 1 ) THEN BEGIN
      newState = 2
    ENDIF ELSE BEGIN
      newState = 0
    ENDELSE
    WIDGET_CONTROL, parent, SET_TREE_CHECKED = newState
    MY_TREE_UPDATE_ANCESTORS, parent
  ENDIF
END


PRO PLOT_IMG_VECTOR_EVENT,ev
  COMPILE_OPT IDL2
  COMMON SHARE3,MAP,M1,M2,GRID,tree_node,Typhoon_name_list,Route_line_list,Typhoon_text_list,Track_line_list,rgb_img_list,rgb_img_name_list,Wind_circle_list_L7,Wind_circle_list_L10,Wind_circle_list_L12,Symbol_list,Symbol_name_list,Vector_list,Vector_name_list,Vector_line_list,Vector_line_name_list,Warning_line_24_list,Warning_line_48_list,Typhoon_current_time,Text_list,Text_name_list,Title_list
  WIDGET_CONTROL,ev.TOP,get_UValue = pState
  
  Catch, errorStatus

  ; Error handler
  if (errorStatus ne 0) then begin
    Catch, /CANCEL
    RETURN

  endif
  
  IF (TAG_NAMES(ev, /STRUCTURE_NAME) EQ 'WIDGET_TIMER') and ((*pState).flag_online_offline eq 0) THEN BEGIN
    PRINT, 'Timer Fired'
          foreach elements,Typhoon_name_list,i do START_TYPHOON,out_dir=(*pState).ProjectDir,typhoon_name=Typhoon_name_list[i],pro_dir=(*pState).pro_dir
          remove_vector = REMOVE_TYPHOON_VECTOR()
          get_vector    = SHOW_TYPHOON_VECTOR(ProjectDir=(*pState).ProjectDir,time_flag=(*pState).time_flag)
          WIDGET_CONTROL,(*pState).BorderText,GET_VALUE = border_text
          MAP.Save,(*pState).ProjectDir+PATH_SEP()+Typhoon_name_list[0]+PATH_SEP()+STRTRIM(ROUND(SYSTIME(1)),1)+'.PNG',BORDER=FLOAT(border_text),RESOLUTION=400
    WIDGET_CONTROL, ev.TOP, TIMER=(*pState).INTERNAL_TIME
  ENDIF


  
  
  IF (TAG_NAMES(ev,/STRUCTURE) EQ 'WIDGET_BUTTON') THEN BEGIN
    WIDGET_CONTROL,(*pState).MiddleText,GET_VALUE = middle_text
    zoom_level = FLOAT(middle_text[0])
    down_left_up_right = (*pState).down_left_up_right
    PRINT,down_left_up_right
    CASE WIDGET_INFO(ev.ID,/Uname) OF
      'Up' : begin
        IF down_left_up_right[2] LT 90 THEN BEGIN
          down_left_up_right[2] = down_left_up_right[2] + zoom_level
          down_left_up_right[0] = down_left_up_right[0] + zoom_level
        ENDIF
      end
      'Down' : begin
        IF down_left_up_right[0] GT -90 THEN BEGIN
          down_left_up_right[2] = down_left_up_right[2] - zoom_level
          down_left_up_right[0] = down_left_up_right[0] - zoom_level
        ENDIF
      end
      'Left' : begin
        IF down_left_up_right[1] GT -180 THEN BEGIN
          down_left_up_right[1] = down_left_up_right[1] - zoom_level
          down_left_up_right[3] = down_left_up_right[3] - zoom_level
        ENDIF
      end
      'Right' : begin
        IF down_left_up_right[3] LT 540 THEN BEGIN
          down_left_up_right[1] = down_left_up_right[1] + zoom_level
          down_left_up_right[3] = down_left_up_right[3] + zoom_level
        ENDIF
      end
      'image' : begin
        image_text = DIALOG_PICKFILE(filter =['*.img','*.bat','*'],path='D:\data\影像\chao')
        IF FILE_TEST(image_text) THEN BEGIN
          IF FILE_TEST(image_text) THEN BEGIN
            rgb_img                  = get_rgb_bands_from_img(file=image_text,rgb_pos=[2,3,1],img_position=img_position,img_dimensions=img_dimensions)
            (*pState).img_position   = img_position
            (*pState).img_dimensions = img_dimensions
            rgb_img_list             = [rgb_img_list,IMAGE(rgb_img,DIMENSIONS=[63,63],IMAGE_DIMENSIONS=img_dimensions,IMAGE_LOCATION=img_position,/OVERPLOT,/DEVICE)]
            rgb_img_name_list        = [rgb_img_name_list,'Image'+FILE_BASENAME(image_text,'.JPG')]
            m                        = WIDGET_TREE((*pState).ROOT, VALUE=FILE_BASENAME(image_text,'.JPG'),/CHECKBOX,UNAME ='Image'+FILE_BASENAME(image_text,'.JPG'),CHECKED=1,BITMAP=(*pState).image_icon)
            PRINT,(*pState).img_position,(*pState).img_dimensions
          ENDIF
        ENDIF
      end
      'ImageTrans':begin
        WIDGET_CONTROL,(*pState).ImageText,GET_VALUE = image_transparency
        FOREACH Element,rgb_img_name_list,i DO rgb_img_list[i].TRANSPARENCY = fix(image_transparency)
      end
      'imagezoom':begin
        img_position       = (*pState).img_position
        img_dimensions     = (*pState).img_dimensions
        IF img_dimensions[0]*img_dimensions[1] THEN BEGIN
          down_left_up_right = [img_position[1],img_position[0],img_position[1]+img_dimensions[1],img_position[0]+img_dimensions[0]]
          PRINT,down_left_up_right
        ENDIF
      end
      'Vector':begin
        Vector_line_text = DIALOG_PICKFILE(filter =['*.txt','*'],path=(*pState).ProjectDir)
        IF FILE_TEST(Vector_line_text) THEN BEGIN
          IF FILE_LINES(Vector_line_text) GT 1 THEN BEGIN
            lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Vector_line_text,LINE=2,flag_ok=flag_ok)
            IF flag_ok EQ 1 THEN BEGIN
              x = REFORM(FLOAT(lon_lat_arr[0,*]))
              y = REFORM(FLOAT(lon_lat_arr[1,*]))
              Vector_line_list      = [Vector_line_list,POLYLINE(x, y, COLOR=!COLOR.RED, THICK=2, /DATA,HIDE=0)]
              Vector_line_name_list = [Vector_line_name_list,'Line_Vector'+FILE_BASENAME(Vector_line_text,'.txt')]
              v = WIDGET_TREE( (*pState).ROOT, VALUE = FILE_BASENAME(Vector_line_text,'.txt'),/CHECKBOX,UNAME = 'Line_Vector'+FILE_BASENAME(Vector_line_text,'.txt'),CHECKED=1,BITMAP=(*pState).Symbol_icon)
            ENDIF
          ENDIF ELSE BEGIN
            TMP = DIALOG_MESSAGE('Just have one point.Not a line.')
          ENDELSE
        ENDIF
      END
      'Symbol':begin
        Symbol_text = DIALOG_PICKFILE(filter =['*.txt','*'],path=(*pState).ProjectDir)
        IF FILE_TEST(Symbol_text) THEN BEGIN
          lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Symbol_text,LINE=3,flag_ok=flag_ok)
          IF flag_ok EQ 1 THEN BEGIN
            x      = REFORM(FLOAT(lon_lat_arr[0,*]))
            y      = REFORM(FLOAT(lon_lat_arr[1,*]))
            labels = STRTRIM(REFORM(Lon_lat_arr[2,*]),1)
            Symbol_list      = [Symbol_list,SYMBOL(x, y, 'period',/DATA, SYM_COLOR='dim_grey', SYM_SIZE = 8,LABEL_FONT_NAME='AvantGarde-Demi',LABEL_STRING=labels,LABEL_POSITION='b',LABEL_FONT_SIZE=8,LABEL_SHIFT=[0,1.1],/RELATIVE,/OVERPLOT)]
            Symbol_name_list = [Symbol_name_list,'Symbol'+FILE_BASENAME(Symbol_text,'.txt')]
            s = WIDGET_TREE( (*pState).ROOT, VALUE = FILE_BASENAME(Symbol_text,'.txt'),/CHECKBOX,UNAME = 'Symbol'+FILE_BASENAME(Symbol_text,'.txt'),CHECKED=1,BITMAP=(*pState).Symbol_icon)
          ENDIF
        ENDIF
      END

      'Typhoon':BEGIN

      END
      'Text':BEGIN
        WIDGET_CONTROL,(*pState).TextText,GET_VALUE = Text_text
        Text_list = [Text_list,TEXT(0.78,-0.1,Text_text, COLOR=!COLOR.green,HIDE=0,/CURRENT,/RELATIVE,TARGET=m1,FONT_STYLE=1,FONT_SIZE=9)]
        Text_name_list = [Text_name_list,'CustomText'+Text_text+STRTRIM((*pState).flag_Text_text,1)]
        IF (*pState).flag_Text_text EQ 1 THEN BEGIN
          CT = WIDGET_TREE( (*pState).ROOT, /FOLDER, /EXPANDED, VALUE = 'Custom Text',UNAME = 'CustomText',/CHECKBOX,CHECKED=1,BITMAP=(*pState).Text_icon)
          CTN = WIDGET_TREE( CT, VALUE =Text_text,/CHECKBOX,UNAME = 'CustomText'+Text_text+STRTRIM((*pState).flag_Text_text,1),CHECKED=1,BITMAP=(*pState).text_icon)
          (*pState).flag_Text_text ++ & (*pState).Custom_tree_folder_id = CT
        ENDIF ELSE BEGIN
          CTN = WIDGET_TREE( (*pState).Custom_tree_folder_id, VALUE =Text_text,/CHECKBOX,UNAME = 'CustomText'+Text_text+STRTRIM((*pState).flag_Text_text,1),CHECKED=1,BITMAP=(*pState).text_icon)
        ENDELSE
       
      END
      'Add' : begin
        WIDGET_CONTROL,(*pState).AddText,GET_VALUE = add_text
        temp_typhoon_name_list = [Typhoon_name_list,'']
        IF WHERE(STRMATCH(temp_typhoon_name_list, add_text, /FOLD_CASE) EQ 1) EQ -1 THEN BEGIN
          Typhoon_name_list = [Typhoon_name_list,add_text]
          tree_node = 'Typhoon'+Typhoon_name_list
          typhoon_dir = (*pState).ProjectDir + PATH_SEP() + add_text
          URL_Check = QUERY_CSV('http://www.nmc.cn/publish/typhoon/message.html')
          IF URL_Check THEN BEGIN
            start_typhoon,out_dir=(*pState).ProjectDir,typhoon_name=add_text,pro_dir=(*pState).pro_dir
          ENDIF ELSE BEGIN
            TMP = DIALOG_MESSAGE('Please check your Internet !')
          ENDELSE
          
          IF FILE_TEST(typhoon_dir) THEN BEGIN
            f = WIDGET_TREE( (*pState).ROOT, /FOLDER, /EXPANDED, VALUE = add_text,UNAME = 'Typhoon'+add_text,/CHECKBOX,CHECKED=1,BITMAP=(*pState).typhoon_icon)
            tc_text_files = FILE_SEARCH(typhoon_dir,'tc_text_*.txt')
            IF FILE_TEST(tc_text_files[-1]) THEN BEGIN
              time_flag = STRMID(FILE_BASENAME(tc_text_files[-1]),8,13)        ;tc_text_20180803_1108.txt    20180803_1108
              Route_line_file = FILE_SEARCH(typhoon_dir,'Thpoon_Route*lon_lat.txt')
              Track_line_file = FILE_SEARCH(typhoon_dir,'Thpoon_Track*lon_lat.txt')
              Wind_circle_file_L7 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L7.txt');Wind_circle_list_L7
              Wind_circle_file_L10 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L10.txt')
              Wind_circle_file_L12 = FILE_SEARCH(typhoon_dir,'Thpoon_Track_'+time_flag+'_Wind_circle_L12.txt')
            ENDIF
            ;===============================================

            ;===============================================
            IF FILE_TEST(tc_text_files[-1]) THEN BEGIN
              MAP.TITLE = 'Path Map of Typhoon '+  add_text
              Title_list = MAP.TITLE
              Title_list.font_size = 15
              t = WIDGET_TREE( (*pState).ROOT, VALUE = 'Title',/CHECKBOX,UNAME = 'Title',CHECKED=1,BITMAP=(*pState).text_icon)
            ENDIF
            ;===============================================
            IF FILE_TEST(Route_line_file) THEN BEGIN
              IF FILE_LINES(Route_line_file) GT 1 THEN BEGIN
                lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Route_line_file,LINE=2,flag_ok=flag_ok)
                IF flag_ok EQ 1 THEN BEGIN
                  x = REFORM(FLOAT(lon_lat_arr[0,*]))
                  y = REFORM(FLOAT(lon_lat_arr[1,*]))
                  Route_line_list   = [Route_line_list,POLYLINE(x, y, COLOR=!COLOR.AQUA, THICK=2, /DATA,HIDE=0)]
                  n = WIDGET_TREE( f, VALUE = 'Route',/CHECKBOX,UNAME = 'Typhoon'+add_text,CHECKED=1,BITMAP=(*pState).route_icon)
                ENDIF
              ENDIF ELSE BEGIN
                Result = OBJ_NEW()
                Route_line_list   = [Route_line_list,Result]
              ENDELSE
              IF FILE_LINES(Route_line_file) EQ 1 THEN BEGIN
                lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Route_line_file,LINE=2,flag_ok=flag_ok)
                IF flag_ok EQ 1 THEN BEGIN
                  x = FLOAT(lon_lat_arr[0])
                  Y = FLOAT(lon_lat_arr[1])
                ENDIF
              ENDIF
            ENDIF
            ;===============================================
            Typhoon_text_list = [Typhoon_text_list,TEXT(x[-1]+1,y[-1]+1,add_text, /DATA, COLOR=!COLOR.NAVY,HIDE=0)] ;, FILL_COLOR=!COLOR.PALE_TURQUOISE
            n = WIDGET_TREE( f, VALUE = 'Text',/CHECKBOX,UNAME = 'Typhoon'+add_text,CHECKED=1,BITMAP=(*pState).text_icon)
            ;===============================================
            IF FILE_TEST(Track_line_file[-1]) THEN BEGIN
              lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Track_line_file[-1],LINE=2,flag_ok=flag_ok)
              IF flag_ok EQ 1 THEN BEGIN
                x = REFORM(FLOAT(lon_lat_arr[0,*]))
                y = REFORM(FLOAT(lon_lat_arr[1,*]))
                Track_line_list = [Track_line_list,POLYLINE(x, y, COLOR=!COLOR.HOT_PINK, THICK=2, /DATA,HIDE=0,LINESTYLE=2)]
                n = WIDGET_TREE( f, VALUE = 'Track',/CHECKBOX,UNAME = 'Typhoon'+add_text,CHECKED=1,BITMAP=(*pState).track_icon)
              ENDIF
            ENDIF ELSE BEGIN
              Result = OBJ_NEW()
              Track_line_list = [Track_line_list,Result]
            ENDELSE
            ;===============================================
            
            IF FILE_TEST(Wind_circle_file_L7) THEN BEGIN
              lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L7,LINE=2,flag_ok=flag_ok)
              IF flag_ok EQ 1 THEN BEGIN
                x                    = REFORM(FLOAT(lon_lat_arr[0,*]))
                y                    = REFORM(FLOAT(lon_lat_arr[1,*]))
                Wind_circle_list_L7  = [Wind_circle_list_L7,POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.LIME_GREEN,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)]
                n = WIDGET_TREE( f, VALUE = 'Wind Circle',/CHECKBOX,UNAME = 'Typhoon'+add_text,CHECKED=1,BITMAP=(*pState).wind_circle_l7_icon)
              ENDIF
            ENDIF ELSE BEGIN
              Result = OBJ_NEW()
              Wind_circle_list_L7  = [Wind_circle_list_L7,Result]
            ENDELSE
            ;===============================================
            IF FILE_TEST(Wind_circle_file_L10) THEN BEGIN
              lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L10,LINE=2,flag_ok=flag_ok)
              IF flag_ok EQ 1 THEN BEGIN
                x                    = REFORM(FLOAT(lon_lat_arr[0,*]))
                y                    = REFORM(FLOAT(lon_lat_arr[1,*]))
                Wind_circle_list_L10 = [Wind_circle_list_L10,POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.GOLD,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)]
              ENDIF
            ENDIF ELSE BEGIN
              Result = OBJ_NEW()
              Wind_circle_list_L10  = [Wind_circle_list_L10,Result]
            ENDELSE
            ;===============================================
            IF FILE_TEST(Wind_circle_file_L12) THEN BEGIN
              lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wind_circle_file_L12,LINE=2,flag_ok=flag_ok)
              IF flag_ok EQ 1 THEN BEGIN
                x                    = REFORM(FLOAT(lon_lat_arr[0,*]))
                y                    = REFORM(FLOAT(lon_lat_arr[1,*]))
                Wind_circle_list_L12 = [Wind_circle_list_L12,POLYGON(x,y,COLOR=!COLOR.WHITE, FILL_COLOR = !COLOR.RED,TRANSPARENCY=30,THICK=1.5, /DATA,HIDE=0)]
              ENDIF
            ENDIF ELSE BEGIN
              Result = OBJ_NEW()
              Wind_circle_list_L12  = [Wind_circle_list_L12,Result]
            ENDELSE
            ;===============================================
            IF FILE_TEST(tc_text_files[-1]) THEN BEGIN
              (*pState).time_flag = time_flag
              year = STRMID(time_flag,0,4) & month = STRMID(time_flag,4,2) & day = STRMID(time_flag,6,2) & hour = STRMID(time_flag,9,2) & minute = STRMID(time_flag,11,2)
              Typhoon_current_time = TEXT(0.8,0.06,['   '+hour+':'+minute+' AM',' '+year+'-'+month+'-'+day,'Beijing Time'], COLOR=!COLOR.white,HIDE=0,/CURRENT,/RELATIVE,TARGET=m1,FONT_STYLE=1)
              t = WIDGET_TREE( f, VALUE = 'Timestamp',/CHECKBOX,UNAME = 'Timestamp',CHECKED=1,BITMAP=(*pState).text_icon)
            ENDIF
            ;===============================================
          ENDIF
        ENDIF ELSE BEGIN
          PRINT,'HENG'
        ENDELSE

        IF Typhoon_name_list NE !NULL THEN WIDGET_CONTROL,(*pState).StartFireButton,SENSITIVE = 1
      end
      'Online' : begin
        WIDGET_CONTROL,(*pState).StartFireText,GET_VALUE = INTERNAL_TIME
        INTERNAL_TIME = INTERNAL_TIME*60
        (*pState).INTERNAL_TIME = INTERNAL_TIME
        URL_Check = QUERY_CSV('http://www.nmc.cn/publish/typhoon/message.html')
        IF URL_Check THEN BEGIN
          IF (*pState).flag_online_offline THEN BEGIN
            PRINT,'Data will be updated every 30 minutes !'
            WIDGET_CONTROL,(*pState).StartFireButton,SET_VALUE='Off Line'
            (*pState).flag_online_offline = 0
            foreach elements,Typhoon_name_list,i do start_typhoon,out_dir=(*pState).ProjectDir,typhoon_name=Typhoon_name_list[i],pro_dir=(*pState).pro_dir
            remove_vector = remove_typhoon_vector()
            get_vector    = show_typhoon_vector(ProjectDir=(*pState).ProjectDir,time_flag=(*pState).time_flag)
            ;typhoon_dir = MAP.Save,typhoon_dir,BORDER=15,RESOLUTION=300
            WIDGET_CONTROL, ev.TOP, TIMER=INTERNAL_TIME
          ENDIF ELSE BEGIN
            PRINT,'Stop update !'
            WIDGET_CONTROL,(*pState).StartFireButton,SET_VALUE='On Line'
            (*pState).flag_online_offline = 1
          ENDELSE
        ENDIF ELSE BEGIN
          TMP = DIALOG_MESSAGE('Please check your Internet !')
        ENDELSE

      END
      'LimitOK':BEGIN
        
        WIDGET_CONTROL,(*pState).LeftText,GET_VALUE = left_text
        WIDGET_CONTROL,(*pState).RightText,GET_VALUE = right_text
        WIDGET_CONTROL,(*pState).UpText,GET_VALUE = up_text
        WIDGET_CONTROL,(*pState).DownText,GET_VALUE = down_text
        down_left_up_right = DOUBLE([down_text,left_text,up_text,right_text])
        ;tmp = FLOAT(STRSPLIT(limit_text,',',/EXTRACT))
        lon_lat_ok = lon_lat_validation(down_left_up_right)
        ;print,lon_lat_ok
        IF lon_lat_ok THEN BEGIN
          PRINT,down_left_up_right
          HELP,down_left_up_right
          
        ENDIF ELSE BEGIN
          TMP = DIALOG_MESSAGE('Wrong Lon/Lat')
        ENDELSE
        
      END
      'Save':begin
        WIDGET_CONTROL,(*pState).BorderText,GET_VALUE = border_text
        FILTERS = [['*.PNG','*.EMF','*.EPS;*.PS','*.GIF','*.JPG;*.JPEG','*.JP2;*.JPX;*.J2K','*.KML','*.KMZ','*.PDF','*.PICT','*.BMP','*.SVG','*.TIF;*.TIFF'],$
                  ['PNG','EMF','EPS;PS','GIF','JPG;JPEG','JP2;JPX;J2K','KML','KMZ','PDF','PICT','BMP','SVG','TIF;TIFF']]
        TMP = DIALOG_PICKFILE(FILTER=FILTERS, DEFAULT_EXTENSION='*.PNG',/WRITE)
        ;IF FILE_TEST(TMP) THEN BEGIN
          suffix = STRMID(TMP,STRLEN(TMP)-3,3)
          MAP.Save,TMP,BORDER=FLOAT(border_text),RESOLUTION=300
;          IF (WHERE(STRMATCH(['PNG','GIF','JPG;JPEG','JP2;JPX;J2K','PICT','BMP','TIF;TIFF'],suffix)) EQ 1) NE -1 THEN BEGIN
;            MAP.Save,TMP,BORDER=FLOAT(border_text),RESOLUTION=300
;          ENDIF ELSE BEGIN
;            MAP.Save,TMP
;          ENDELSE
        ;ENDIF
      end
      'refresh':begin
        M1 = MAPCONTINENTS( /COUNTRIES,COLOR ='GRAY',FILL_COLOR='beige')
        M1.Order, /SEND_TO_BACK
        M2 = MAPCONTINENTS( (*pState).china_province,color='GRAY',FILL_COLOR='MOCCASIN')
        
      end
      'setting':begin

      end
      ELSE: BEGIN
      END

    ENDCASE
    
    MAP.LIMIT = down_left_up_right
    FOREACH gline, grid.LONGITUDES DO gline.LABEL_ANGLE = 0
    FOREACH gline, grid.LATITUDES  DO gline.LABEL_ANGLE = 90
    GRID.LABEL_POSITION = 0
    
    WIDGET_CONTROL,(*pState).GridText,GET_VALUE = grid_Text
    GRID.GRID_LONGITUDE = DOUBLE(grid_Text)
    GRID.GRID_LATITUDE  = DOUBLE(grid_Text)


    diff = down_left_up_right EQ (*pState).down_left_up_right
    IF MAX(WHERE(diff EQ 0)) NE -1 THEN BEGIN
      
      GRID.LATITUDE_MAX  = down_left_up_right[2] & GRID.LATITUDE_MIN  = down_left_up_right[0]
      GRID.LONGITUDE_MIN = down_left_up_right[1] & GRID.LONGITUDE_MAX = down_left_up_right[3]
      MAP.XRANGE = [GRID.LONGITUDE_MIN,GRID.LONGITUDE_MAX]
      MAP.YRANGE = [GRID.LATITUDE_MIN,GRID.LATITUDE_MAX]
      ;MAP.LIMIT=[GRID.LATITUDE_MIN,GRID.LONGITUDE_MIN,GRID.LATITUDE_MAX,GRID.LONGITUDE_MAX]
      (*pState).down_left_up_right = down_left_up_right
      WIDGET_CONTROL,(*pState).LeftText,SET_VALUE  = STRTRIM(DOUBLE(down_left_up_right[1]),1)
      WIDGET_CONTROL,(*pState).RightText,SET_VALUE = STRTRIM(DOUBLE(down_left_up_right[3]),1)
      WIDGET_CONTROL,(*pState).UpText,SET_VALUE    = STRTRIM(DOUBLE(down_left_up_right[2]),1)
      WIDGET_CONTROL,(*pState).DownText,SET_VALUE  = STRTRIM(DOUBLE(down_left_up_right[0]),1)
    ENDIF
    
  ENDIF
END
;+--------------------------------------------------------------------------
;   This procedure is the clean-up method for the object.
;---------------------------------------------------------------------------
PRO PLOT_IMG_VECTOR_Cleanup, base
  Widget_Control, base, Get_UValue=pState, /No_Copy
  IF N_Elements(pState) EQ 0 THEN Heap_GC ELSE $
    Ptr_Free,pState
END
PRO TREE_CHECKBOX_EXAMPLE_EVENT, e

END

PRO HANDLE_TREE_EVENT, e

  COMPILE_OPT IDL2
  COMMON SHARE3,MAP,M1,M2,GRID,tree_node,Typhoon_name_list,Route_line_list,Typhoon_text_list,Track_line_list,rgb_img_list,rgb_img_name_list,Wind_circle_list_L7,Wind_circle_list_L10,Wind_circle_list_L12,Symbol_list,Symbol_name_list,Vector_list,Vector_name_list,Vector_line_list,Vector_line_name_list,Warning_line_24_list,Warning_line_48_list,Typhoon_current_time,Text_list,Text_name_list,Title_list
  WIDGET_CONTROL,e.TOP,get_UValue = pState
  
  ;HELP, e, /STRUCTURE
  ;PRINT,WIDGET_INFO(e.ID,/PARENT)
  ;PRINT,WIDGET_INFO(e.ID,/TREE_INDEX)
  ;PRINT,(WIDGET_INFO(e.ID,/TREE_CHECKED))
  ;PRINT,WIDGET_INFO(e.ID,/TREE_ROOT)
  ;PRINT,WIDGET_INFO(e.ID,/TREE_EXPANDED)
;  ;文件夹
;  IF WIDGET_INFO(e.ID,/TREE_EXPANDED) THEN BEGIN
    IF (TAG_NAMES(e,/STRUCTURE) EQ 'WIDGET_TREE_CHECKED') THEN BEGIN
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'CustomText*') THEN BEGIN
        tag = WHERE(STRMATCH(Text_name_list,WIDGET_INFO(e.ID,/Uname)) EQ 1)
        Text_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'CustomText') THEN BEGIN
        FOREACH ELEMENT,Text_list,i DO Text_list[i].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Title') THEN BEGIN
        Title_list.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Grid') THEN BEGIN
        Grid.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Timestamp') THEN BEGIN
        Typhoon_current_time.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Warning_line_24') THEN BEGIN
        Warning_line_24_list.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Warning_line_48') THEN BEGIN
        Warning_line_48_list.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'china_province') THEN BEGIN
        M2.HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Symbol*') THEN BEGIN
        tag = WHERE(STRMATCH(Symbol_name_list,WIDGET_INFO(e.ID,/Uname)) EQ 1)
        Symbol_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF 
      
      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Image*') THEN BEGIN
        tag = WHERE(STRMATCH(rgb_img_name_list,WIDGET_INFO(e.ID,/Uname)) EQ 1)
        rgb_img_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
      ENDIF

      IF STRMATCH(WIDGET_INFO(e.ID,/Uname),'Typhoon*') THEN BEGIN
        tag = WHERE(STRMATCH(tree_node,WIDGET_INFO(e.ID,/Uname)) EQ 1)
        IF WIDGET_INFO(e.ID,/TREE_FOLDER) THEN BEGIN
          IF OBJ_VALID(Route_line_list[tag]) THEN Route_line_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Typhoon_text_list[tag]) THEN Typhoon_text_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Track_line_list[tag]) THEN Track_line_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Wind_circle_list_L7[tag]) THEN Wind_circle_list_L7[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Wind_circle_list_L10[tag]) THEN Wind_circle_list_L10[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Wind_circle_list_L12[tag]) THEN Wind_circle_list_L12[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          IF OBJ_VALID(Typhoon_current_time[tag]) THEN Typhoon_current_time[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
        ENDIF ELSE BEGIN
          CASE WIDGET_INFO(e.ID,/TREE_INDEX) OF
            0:Route_line_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
            1:Typhoon_text_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
            2:Track_line_list[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
            3:begin
              IF OBJ_VALID(Wind_circle_list_L7[tag]) THEN Wind_circle_list_L7[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
              IF OBJ_VALID(Wind_circle_list_L10[tag]) THEN Wind_circle_list_L10[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
              IF OBJ_VALID(Wind_circle_list_L12[tag]) THEN Wind_circle_list_L12[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
            end
            4:Typhoon_current_time[tag].HIDE = ~(WIDGET_INFO(e.ID,/TREE_CHECKED))
          ENDCASE
        ENDELSE
      ENDIF
  ENDIF

  

  IF ( e.type EQ 2 ) THEN BEGIN

    MY_TREE_UPDATE_DESCENDANTS, e.id, e.state
    MY_TREE_UPDATE_ANCESTORS, e.id

  ENDIF
END
;+--------------------------------------------------------------------------
;   This is the interface construction part and class definition module.
;
; :Params:
;    state1: out, optional, type=structure
;       Occasionally, it is useful to have an object class definition as
;       a structure variable. Using this output keyword will allow that.
;---------------------------------------------------------------------------
PRO PLOT_IMG_VECTOR
  COMPILE_OPT IDL2
  COMMON SHARE3,MAP,M1,M2,GRID,tree_node,Typhoon_name_list,Route_line_list,Typhoon_text_list,Track_line_list,rgb_img_list,rgb_img_name_list,Wind_circle_list_L7,Wind_circle_list_L10,Wind_circle_list_L12,Symbol_list,Symbol_name_list,Vector_list,Vector_name_list,Vector_line_list,Vector_line_name_list,Warning_line_24_list,Warning_line_48_list,Typhoon_current_time,Text_list,Text_name_list,Title_list
  
  down_left_up_right = [10,100,40,150]
  time_TEXT          = SYSTIME(0)
  year               = STRMID(TIME_TEXT,20,4)
  
  pro_dir            = FILE_DIRNAME(ROUTINE_FILEPATH())
  TyphoonMainDir     = pro_dir + PATH_SEP() + 'Typhoon'
  ProjectDir         = TyphoonMainDir + PATH_SEP() + year
  vector_dir         = TyphoonMainDir + PATH_SEP() + 'resource' + PATH_SEP() + 'vector'
  icon_dir           = TyphoonMainDir + PATH_SEP() + 'resource' + PATH_SEP() + 'icon'
  
  land_cover         = vector_dir + PATH_SEP() + 'ne_50m_land.shp'
  china_province     = vector_dir + PATH_SEP() + 'province_2004.shp'
  Wline_24_text      = vector_dir + PATH_SEP() + 'Thpoon_24h_line_v1_line.txt'
  Wline_48_text      = vector_dir + PATH_SEP() + 'Thpoon_48h_line_v1_line.txt'
  
  DIR_CHECK = FILE_SEARCH(ProjectDir,COUNT=Dir_count)
  IF Dir_count EQ 0 THEN FILE_MKDIR,ProjectDir,/NOEXPAND_PATH
  
  READ_JPEG,icon_dir + PATH_SEP() + 'typhoon_icon.JPG',typhoon_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'image_icon.JPG',image_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'Route_icon.jpg',route_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'track_icon.JPG',track_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'text_icon.JPG',text_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'wind_circle_l7_icon.JPG',wind_circle_l7_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'wind_circle_l10_icon.JPG',wind_circle_l10_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'wind_circle_l12_icon.JPG',wind_circle_l12_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'Symbol_icon.JPG',Symbol_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'grid_icon.JPG',grid_icon,true=3
  READ_JPEG,icon_dir + PATH_SEP() + 'refresh_icon.jpg',refresh_icon,true=3
  
  base = WIDGET_BASE(TITLE = 'PLOT_IMG_VECTOR',column=1);,mbar=bar
  ;MenuFile         = WIDGET_BUTTON(bar,           value = 'File',  /menu)
  ;MenuNew          = WIDGET_BUTTON(MenuFile,      value = 'Setting',uname='setting')
  ;interface
  TabUpBase        = WIDGET_BASE(base,row=1)
  TabDownBase      = WIDGET_BASE(base,row=1)
  BasicParaBase    = WIDGET_TAB(TabUpBase, LOCATION=location)
  FirstBase        = WIDGET_BASE(BasicParaBase,row=1,TITLE='Basic')
  TreeBase         = WIDGET_BASE(TabDownBase,column=1,/ALIGN_CENTER,/FRAME)
  root             = WIDGET_TREE(TreeBase, event_pro = 'HANDLE_TREE_EVENT'  ,XSIZE=200,ysize=600)

  DrawBase         = WIDGET_BASE(TabDownBase,XSIZE=800,YSIZE=600,/FRAME)
  DRAW             = WIDGET_WINDOW(DrawBase,XSIZE=800,YSIZE=600)
  ;=====================================================================================================
  DirectionBase    = WIDGET_BASE(FirstBase,column=5, /ALIGN_CENTER,/FRAME)
  LeftButton       = WIDGET_BUTTON(DirectionBase,VALUE = icon_dir + PATH_SEP() + 'shift_left.bmp',UNAME = 'Left',xsize=25,ysize=25,/BITMAP)
  RightButton      = WIDGET_BUTTON(DirectionBase,VALUE = icon_dir + PATH_SEP() + 'shift_right.bmp',UNAME = 'Right',xsize=25,ysize=25,/BITMAP)
  UpButton         = WIDGET_BUTTON(DirectionBase,VALUE = icon_dir + PATH_SEP() + 'shift_up.bmp',UNAME = 'Up',xsize=25,ysize=25,/BITMAP)
  DownButton       = WIDGET_BUTTON(DirectionBase,VALUE = icon_dir + PATH_SEP() + 'shift_down.bmp',UNAME = 'Down',xsize=25,ysize=25,/BITMAP)
  MiddleText       = WIDGET_TEXT(DirectionBase,VALUE = '10',XSIZE=3,editable=1)
  
  LimitBase        = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  LeftLabel        = WIDGET_LABEL(LimitBase,VALUE='Left',xsize=30, /ALIGN_RIGHT)
  LeftText         = WIDGET_TEXT(LimitBase,VALUE = STRTRIM(DOUBLE(down_left_up_right[1]),1),xsize=10,editable=1,SENSITIVE=1)
  RightLabel       = WIDGET_LABEL(LimitBase,VALUE='Right',xsize=30, /ALIGN_RIGHT)
  RightText        = WIDGET_TEXT(LimitBase,VALUE = STRTRIM(DOUBLE(down_left_up_right[3]),1),xsize=10,editable=1,SENSITIVE=1)
  DownLabel        = WIDGET_LABEL(LimitBase,VALUE='Down',xsize=30, /ALIGN_RIGHT)
  DownText         = WIDGET_TEXT(LimitBase,VALUE = STRTRIM(DOUBLE(down_left_up_right[0]),1),xsize=10,editable=1,SENSITIVE=1)
  UpLabel          = WIDGET_LABEL(LimitBase,VALUE='Up',xsize=30, /ALIGN_RIGHT)
  UpText           = WIDGET_TEXT(LimitBase,VALUE = STRTRIM(DOUBLE(down_left_up_right[2]),1),xsize=10,editable=1,SENSITIVE=1)
  GridLabel        = WIDGET_LABEL(LimitBase,VALUE='Grid',xsize=30, /ALIGN_RIGHT)
  GridText         = WIDGET_TEXT(LimitBase,VALUE = '10',xsize=4,editable=1,SENSITIVE=1)
  LimitButton      = WIDGET_BUTTON(LimitBase,VALUE = icon_dir+PATH_SEP()+'OK.BMP',UNAME = 'LimitOK',/BITMAP)
  
  ImageBase        = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  ImageButton      = WIDGET_BUTTON(ImageBase,VALUE = icon_dir + PATH_SEP() + 'palette.bmp',UNAME = 'image',/BITMAP)
  ImageZoomButton  = WIDGET_BUTTON(ImageBase,VALUE = icon_dir + PATH_SEP() + 'fitwindow.bmp',UNAME = 'imagezoom',/BITMAP)

  SymbolBase       = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  SymbolButton     = WIDGET_BUTTON(SymbolBase,VALUE = Symbol_icon,UNAME = 'Symbol',/BITMAP)
  
  SaveBase         = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  SaveButton       = WIDGET_BUTTON(SaveBase,VALUE = icon_dir + PATH_SEP() + 'save.bmp',UNAME = 'Save',/BITMAP)
  BorderLabel      = WIDGET_LABEL(SaveBase,VALUE='Border:',xsize=50, /ALIGN_RIGHT)
  BorderText       = WIDGET_TEXT(SaveBase,VALUE = '24',xsize=4,editable=1,SENSITIVE=1)
  RefreshButton    = WIDGET_BUTTON(SaveBase,VALUE = refresh_icon,UNAME = 'refresh',/BITMAP)
  ;VectorBase       = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  ;VectorButton     = WIDGET_BUTTON(VectorBase,VALUE = icon_dir + PATH_SEP() + 'freeform.bmp',UNAME = 'Vector',/BITMAP)
  
  TextBase        = WIDGET_BASE(FirstBase,ROW=1, /ALIGN_CENTER,/FRAME)
  AddLabel        = WIDGET_LABEL(TextBase,VALUE='T:',xsize=16, /ALIGN_RIGHT)
  TextText        = WIDGET_TEXT(TextBase,VALUE = 'Courtesy of Qiliang',XSIZE=7,editable=1,SENSITIVE=1)
  TextButton      = WIDGET_BUTTON(TextBase,VALUE = icon_dir+PATH_SEP()+'OK.BMP',UNAME = 'Text',/BITMAP)
  

  ;====================================================================================================
  SecondBase       = WIDGET_BASE(BasicParaBase,row=1,TITLE='Typhoon')
  AddBase          = WIDGET_BASE(SecondBase,ROW=1, /ALIGN_CENTER,/FRAME)
  AddLabel         = WIDGET_LABEL(AddBase,VALUE='Typhoon',xsize=46, /ALIGN_RIGHT)
  AddText          = WIDGET_TEXT(AddBase,VALUE = 'JONGDARI',editable=1,SENSITIVE=1)
  ;tf_list = FILE_BASENAME(FILE_SEARCH(ProjectDir,'*',/TEST_DIRECTORY))
  ;AddText          = WIDGET_COMBOBOX(AddBase,VALUE = tf_list,XSIZE=50,editable=1,SENSITIVE=1)
  AddButton        = WIDGET_BUTTON(AddBase,VALUE = icon_dir + PATH_SEP() + 'plus.bmp',UNAME = 'Add',/BITMAP)
  
  StartFireBase    = WIDGET_BASE(SecondBase,ROW=1, /ALIGN_CENTER,/FRAME)
  StartFireButton  = WIDGET_BUTTON(StartFireBase,VALUE = 'On line',UNAME = 'Online',SENSITIVE=0)
  StartFireLabel   = WIDGET_LABEL(StartFireBase,VALUE='Interval(M)',xsize=80, /ALIGN_RIGHT)
  StartFireText    = WIDGET_TEXT(StartFireBase,VALUE = '1',xsize=4,editable=1,SENSITIVE=1)

  WebsiteBase      = WIDGET_BASE(SecondBase,ROW=1, /ALIGN_CENTER,/FRAME)
  WebsiteLabel     = WIDGET_LABEL(WebsiteBase,VALUE='Website:',xsize=50, /ALIGN_RIGHT)
  WebsiteText      = WIDGET_TEXT(WebsiteBase,VALUE = 'http://www.nmc.cn/publish/typhoon/message.html',xsize=50,editable=1,SENSITIVE=1)
  ;=======================================================================================================
;  ThirdBase     = WIDGET_BASE(BasicParaBase,/ROW,TITLE='Configuration')
;
;  OutBase       = WIDGET_BASE(ThirdBase,ROW=1, /ALIGN_CENTER)
;  OutLabel      = WIDGET_LABEL(OutBase,VALUE='Out Dir')
;  OutText       = WIDGET_TEXT(OutBase,VALUE = 'D:\0\Typhoon\Typhoon',XSIZE=30,editable=1)
;
;  ProBase       = WIDGET_BASE(ThirdBase,ROW=1, /ALIGN_CENTER)
;  ProLabel      = WIDGET_LABEL(ProBase,VALUE='Pro Dir')
;  ProText       = WIDGET_TEXT(ProBase,VALUE = FILE_DIRNAME(ROUTINE_FILEPATH()),XSIZE=30,editable=1)
;
;  OutBase       = WIDGET_BASE(ThirdBase,ROW=1, /ALIGN_CENTER)
;  OutLabel      = WIDGET_LABEL(OutBase,VALUE='Out Dir')
;  OutText       = WIDGET_TEXT(OutBase,VALUE = 'D:\0\Typhoon\Typhoon',XSIZE=30,editable=1)
  
  Device, GET_SCREEN_SIZE = screenSize
  xy = WIDGET_INFO(base,/geo)
  offsetxy = (screenSize-[xy.SCR_XSIZE,xy.SCR_YSIZE])/2
  
  
  
  Typhoon_name_list    = !NULL
  Route_line_list      = !NULL
  Typhoon_text_list    = !NULL
  Track_line_list      = !NULL
  rgb_img_list         = !NULL
  rgb_img_name_list    = !NULL
  Wind_circle_list_L7  = !NULL
  Wind_circle_list_L10 = !NULL
  Wind_circle_list_L12 = !NULL
  Symbol_list          = !NULL
  Symbol_name_list     = !NULL
  Vector_list          = !NULL
  Vector_name_list     = !NULL
  Vector_line_name_list= !NULL
  Vector_line_list     = !NULL
  Text_list            = !NULL
  Title_list           = !NULL
  Text_name_list       = !NULL
  
  state1={base:base,UpButton:UpButton,DownButton:DownButton,LeftButton:LeftButton,RightButton:RightButton,$
    AddButton:AddButton,StartFireButton:StartFireButton,SaveButton:SaveButton,$
    AddText:AddText,TextText:TextText,TextButton:TextButton,$
    GridText:GridText,MiddleText:MiddleText,DRAW:DRAW,StartFireText:StartFireText,$
    LeftText:LeftText,RightText:RightText,UpText:UpText,DownText:DownText,BorderText:BorderText,$
    ;MenuNew:MenuNew,SettingButton:SettingButton,HideButton:HideButton,ImageText:ImageText,ImageButton:ImageButton,$
    Wline_24_text:Wline_24_text,Wline_48_text:Wline_48_text,$
    root:root,$
    flag_online_offline:1,ProjectDir:ProjectDir,land_cover:land_cover,china_province:china_province,$
    down_left_up_right:down_left_up_right,INTERNAL_TIME:1,pro_dir:pro_dir,flag_Text_text:1,Custom_tree_folder_id:0,$
    typhoon_icon:typhoon_icon,image_icon:image_icon,route_icon:route_icon,track_icon:track_icon,text_icon:text_icon,$
    Symbol_icon:Symbol_icon,time_flag:0,$
    wind_circle_l7_icon:wind_circle_l7_icon,wind_circle_l10_icon:wind_circle_l10_icon,wind_circle_l12_icon:wind_circle_l12_icon,$
    img_position:[0.0,0.0],img_dimensions:[0.0,0.0]}
  

  ;Create a pointer
  pState = PTR_NEW(state1)
  WIDGET_CONTROL,base,/real,set_UValue = pState,xoffset=offsetxy[0],yoffset=offsetxy[1]
  WIDGET_CONTROL, Draw, GET_VALUE=oWin
  oWin.Select
  
  
  MAP=MAP('GEOGRAPHIC',LIMIT= down_left_up_right,BACKGROUND_COLOR='SKY_BLUE',/CURRENT,/BOX_AXES,MARGIN=0.1);,/BOX_AXES
  ;M1 = MAPCONTINENTS( land_cover,COLOR ='GRAY',FILL_COLOR='MOCCASIN',/HIRES);,/HIRES,'D:\xingzhengquhua_shp\province_2004.shp'  /CONTINENTS
  M1 = MAPCONTINENTS( /COUNTRIES,COLOR ='GRAY',FILL_COLOR='beige');,/HIRES,'D:\xingzhengquhua_shp\province_2004.shp'  /CONTINENTS
  ;M2 = MAPCONTINENTS( china_province,COLOR ='GRAY',FILL_COLOR='MOCCASIN')
  GRID=MAP.MAPGRID
  GRID.GRID_LONGITUDE = 10
  GRID.GRID_LATITUDE = 10
  GRID.LABEL_POSITION = 0
  FOREACH gline, grid.LONGITUDES DO gline.LABEL_ANGLE = 0
  FOREACH gline, grid.LATITUDES  DO gline.LABEL_ANGLE = 90
  GRID.LATITUDE_MAX  = down_left_up_right[2] & GRID.LATITUDE_MIN  = down_left_up_right[0]
  GRID.LONGITUDE_MIN = down_left_up_right[1] & GRID.LONGITUDE_MAX = down_left_up_right[3]

  ;--------------------------------

  ;--------------------------------
  
  IF FILE_TEST(china_province) THEN BEGIN
    M2 = MAPCONTINENTS(china_province,color='GRAY',FILL_COLOR='MOCCASIN')
    v = WIDGET_TREE( ROOT, VALUE = FILE_BASENAME(china_province,'.shp'),/CHECKBOX,UNAME = 'china_province',CHECKED=1,BITMAP=Symbol_icon)
  ENDIF
  
  IF FILE_TEST(Wline_48_text) AND FILE_TEST(Wline_24_text) THEN BEGIN
    lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wline_24_text,LINE=2,flag_ok=flag_ok)
    IF flag_ok EQ 1 THEN BEGIN
      x = REFORM(FLOAT(lon_lat_arr[0,*]))
      y = REFORM(FLOAT(lon_lat_arr[1,*]))
      Warning_line_24_list = POLYLINE(x, y, COLOR=!COLOR.RED, THICK=2, /DATA,HIDE=0)
      W24 = WIDGET_TREE( (*pState).ROOT, VALUE = FILE_BASENAME(Wline_24_text,'.txt'),/CHECKBOX,UNAME = 'Warning_line_24',CHECKED=1,BITMAP=(*pState).Symbol_icon)
    ENDIF
    lon_lat_arr      = CHECK_AND_READ_TXT_TO_ARRY(Wline_48_text,LINE=2,flag_ok=flag_ok)
    IF flag_ok EQ 1 THEN BEGIN
      x = REFORM(FLOAT(lon_lat_arr[0,*]))
      y = REFORM(FLOAT(lon_lat_arr[1,*]))
      Warning_line_48_list = POLYLINE(x, y, COLOR=!COLOR.GREEN, THICK=2, /DATA,HIDE=0)
      W48 = WIDGET_TREE( (*pState).ROOT, VALUE = FILE_BASENAME(Wline_48_text,'.txt'),/CHECKBOX,UNAME = 'Warning_line_48',CHECKED=1,BITMAP=(*pState).Symbol_icon)
    ENDIF
  ENDIF
  g = WIDGET_TREE( (*pState).ROOT, VALUE = 'Grid',/CHECKBOX,UNAME = 'Grid',CHECKED=1,BITMAP=grid_icon)
  XMANAGER,'PLOT_IMG_VECTOR',cleanup='PLOT_IMG_VECTOR_Cleanup',base, /NO_BLOCK
END
