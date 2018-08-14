;+
; NAME:
;   poin_offset
;
; PURPOSE:
;
;   已知一个点的经纬度，距离，角度，计算球面上另一个点的经纬度
;
; INPUTS:
;
;   lon:经度.
;   lat:纬度.
;   distance:距离（m）.
;   angle:角度（0-360）.
;   
; EXAMPLE:
;
;   IDL>lon_lat = poin_offset(lon=110,lat=24,distance=1000,angle=30)
;   IDL>print,lon_lat
;     114.92104       31.786609
; 
; AUTHOR:
; 
;   Name:   Liqiliang
;   E-mail: leaqiliang@163.com
;   
; Algorithm come from Internet.Rewritten by Liqiliang.
;
function poin_offset,lon=lon,lat=lat,distance=distance,angle=angle

    Ea   = DOUBLE(6378137);     //   赤道半径  
    Eb   = DOUBLE(6356725);     //   极半径 
    
    distance = distance
    angle    = angle

    GLON = lon
    GLAT = lat
    
    dx = DOUBLE(distance) * 1000 * SIN(angle * !PI / 180.0);
    dy = DOUBLE(distance) * 1000 * COS(angle * !PI / 180.0);
    ;double ec = 6356725 + 21412 * (90.0 - GLAT) / 90.0;
    ;21412 是赤道半径与极半径的差
    ec = DOUBLE(Eb + (Ea-Eb) * (90.0 - GLAT) / 90.0);
    ed = DOUBLE(ec * COS(GLAT * !PI / 180));
    BJD = (dx / ed + GLON * !PI / 180.0) * 180.0 / !PI;
    BWD = (dy / ec + GLAT * !PI / 180.0) * 180.0 / !PI
  
    RETURN,[BJD,BWD]
END