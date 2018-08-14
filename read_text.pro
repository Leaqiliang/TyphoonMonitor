;+
; NAME:
;   READ_TEXT
;
; PURPOSE:
;
;   将txt内容读入数组，每行放到数组每个元素中。
;
; INPUTS:
;
;   text_file:txt文件路径.
;
; EXAMPLE:
;
;   IDL>txt = typhoon_route('C:\Users\Administrator\temp.txt')
;   

FUNCTION READ_TEXT,text_file  
    
    line     = FILE_LINES(text_file)
    str_file = ''
    IF (line GT 0) THEN BEGIN    
         str_temp = MAKE_ARRAY(line,/STRING,value='')          
         OPENR,inunit,text_file,/GET_LUN       
         str   = '' 
         count = 0ll 
         WHILE ~ EOF(inunit) DO BEGIN 
            READF,inunit,str 
            str_temp[count] = str
            count++                
         ENDWHILE 
         FREE_LUN, inunit     
         str_file = str_temp 
    ENDIF
    
    RETURN, str_file
END
     