;========================================================
;      SIL-Power-G-Ethiopic
;========================================================
;version 1.2 2017-02-26: changing diacritic trigger
;    to match keyman ("." preceding number)
;version 1.1 2017-01-15:
;   -update diphthong keying, add [ option for infrequent
;      characters
;version 1.0 2016-12-19: original release
;
;Do not change this:
#include BasicRoutines.ahk
;

;========================================================
; The name of the this keyboard
;========================================================
KeyboardName()
{
  Global  ; don't modify this line
  sName        = SIL-Power-G-Ethiopic
}

;========================================================
; Basic definitions for the keyboard
;========================================================
PrepareValues()
{
  Global

; How are the elements of the matrix separated:
MatrixMarker := ","

; Every matrix has a keyvalue followed by elements
; eg. $h ,U+1200 ,U+1201 ... means
; key = $h the elements are U+1200, U+1201 and so on
; Every keyvalue must be unique within the matrix and must not be repeated
; fill in "dead spots" in matrix with default value
GroupBasicMatrix = 
(   ;    -       u       i       a       y       e       o       O       W       Wu      Wi      We      Wo      WI     |
    $]   ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d ,U+005d |
    $[   ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b ,U+005b |
    $#   ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 ,U+0023 |
    $=   ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d ,U+003d |
    $h   ,U+1200 ,U+1201 ,U+1202 ,U+1203 ,U+1204 ,U+1205 ,U+1206 ,U+1207 ,U+1200 ,U+1200 ,U+1200 ,U+1200 ,U+1200 ,U+1200 |
    $l   ,U+1208 ,U+1209 ,U+120a ,U+120b ,U+120c ,U+120d ,U+120e ,U+2d80 ,U+120f ,U+1208 ,U+1208 ,U+1208 ,U+1208 ,U+1208 |
    $H   ,U+1210 ,U+1211 ,U+1212 ,U+1213 ,U+1214 ,U+1215 ,U+1216 ,U+1210 ,U+1217 ,U+1217 ,U+1217 ,U+1217 ,U+1217 ,U+1217 |
    $m   ,U+1218 ,U+1219 ,U+121a ,U+121b ,U+121c ,U+121d ,U+121e ,U+2d81 ,U+121f ,U+1383 ,U+1381 ,U+1382 ,U+1380 ,U+1359 |
    $r   ,U+1228 ,U+1229 ,U+122a ,U+122b ,U+122c ,U+122d ,U+122e ,U+2d82 ,U+122f ,U+122f ,U+122f ,U+122f ,U+122f ,U+1358 |
    $s   ,U+1230 ,U+1231 ,U+1232 ,U+1233 ,U+1234 ,U+1235 ,U+1236 ,U+2d83 ,U+1237 ,U+1237 ,U+1237 ,U+1237 ,U+1237 ,U+1237 |
    $S   ,U+1238 ,U+1239 ,U+123a ,U+123b ,U+123c ,U+123d ,U+123e ,U+2d84 ,U+123f ,U+123f ,U+123f ,U+123f ,U+123f ,U+123f |
    $q   ,U+1240 ,U+1241 ,U+1242 ,U+1243 ,U+1244 ,U+1245 ,U+1246 ,U+1247 ,U+124b ,U+124d ,U+124a ,U+124c ,U+1248 ,U+124b |
    $Q   ,U+1250 ,U+1251 ,U+1252 ,U+1253 ,U+1254 ,U+1255 ,U+1256 ,U+1250 ,U+125b ,U+125d ,U+125a ,U+125c ,U+1258 ,U+125b |
    $b   ,U+1260 ,U+1261 ,U+1262 ,U+1263 ,U+1264 ,U+1265 ,U+1266 ,U+2d85 ,U+1267 ,U+1387 ,U+1385 ,U+1386 ,U+1384 ,U+1267 |
    $v   ,U+1268 ,U+1269 ,U+126a ,U+126b ,U+126c ,U+126d ,U+126e ,U+1268 ,U+126f ,U+126f ,U+126f ,U+126f ,U+126f ,U+126f |
    $t   ,U+1270 ,U+1271 ,U+1272 ,U+1273 ,U+1274 ,U+1275 ,U+1276 ,U+2d86 ,U+1277 ,U+1277 ,U+1277 ,U+1277 ,U+1277 ,U+1277 |
    $c   ,U+1278 ,U+1279 ,U+127a ,U+127b ,U+127c ,U+127d ,U+127e ,U+2d87 ,U+127f ,U+127f ,U+127f ,U+127f ,U+127f ,U+127f |
    $n   ,U+1290 ,U+1291 ,U+1292 ,U+1293 ,U+1294 ,U+1295 ,U+1296 ,U+2d88 ,U+1297 ,U+1297 ,U+1297 ,U+1297 ,U+1297 ,U+1297 |
    $N   ,U+1298 ,U+1299 ,U+129a ,U+129b ,U+129c ,U+129d ,U+129e ,U+2d89 ,U+129f ,U+129f ,U+129f ,U+129f ,U+129f ,U+129f |
    $x   ,U+12a0 ,U+12a1 ,U+12a2 ,U+12a3 ,U+12a4 ,U+12a5 ,U+12a6 ,U+2d8a ,U+12a7 ,U+12a7 ,U+12a7 ,U+12a7 ,U+12a7 ,U+12a7 |
    $k   ,U+12a8 ,U+12a9 ,U+12aa ,U+12ab ,U+12ac ,U+12ad ,U+12ae ,U+12af ,U+12b3 ,U+12b5 ,U+12b2 ,U+12b4 ,U+12b0 ,U+12b3 |
    $w   ,U+12c8 ,U+12c9 ,U+12ca ,U+12cb ,U+12cc ,U+12cd ,U+12ce ,U+12cf ,U+12c8 ,U+12c8 ,U+12c8 ,U+12c8 ,U+12c8 ,U+12c8 |
    $X   ,U+12d0 ,U+12d1 ,U+12d2 ,U+12d3 ,U+12d4 ,U+12d5 ,U+12d6 ,U+12d0 ,U+12d0 ,U+12d0 ,U+12d0 ,U+12d0 ,U+12d0 ,U+12d0 |
    $z   ,U+12d8 ,U+12d9 ,U+12da ,U+12db ,U+12dc ,U+12dd ,U+12de ,U+2d8b ,U+12df ,U+12df ,U+12df ,U+12df ,U+12df ,U+12df |
    $Z   ,U+12e0 ,U+12e1 ,U+12e2 ,U+12e3 ,U+12e4 ,U+12e5 ,U+12e6 ,U+12e0 ,U+12e7 ,U+12e7 ,U+12e7 ,U+12e7 ,U+12e7 ,U+12e7 |
    $Y   ,U+12e8 ,U+12e9 ,U+12ea ,U+12eb ,U+12ec ,U+12ed ,U+12ee ,U+12ef ,U+12e8 ,U+12e8 ,U+12e8 ,U+12e8 ,U+12e8 ,U+12e8 |
    $d   ,U+12f0 ,U+12f1 ,U+12f2 ,U+12f3 ,U+12f4 ,U+12f5 ,U+12f6 ,U+2d8c ,U+12f7 ,U+12f7 ,U+12f7 ,U+12f7 ,U+12f7 ,U+12f7 |
    $D   ,U+12f8 ,U+12f9 ,U+12fa ,U+12fb ,U+12fc ,U+12fd ,U+12fe ,U+2d8d ,U+12ff ,U+12ff ,U+12ff ,U+12ff ,U+12ff ,U+12ff |
    $j   ,U+1300 ,U+1301 ,U+1302 ,U+1303 ,U+1304 ,U+1305 ,U+1306 ,U+2d8e ,U+1307 ,U+1307 ,U+1307 ,U+1307 ,U+1307 ,U+1307 |
    $g   ,U+1308 ,U+1309 ,U+130a ,U+130b ,U+130c ,U+130d ,U+130e ,U+130f ,U+1313 ,U+1315 ,U+1312 ,U+1314 ,U+1310 ,U+1313 |
    $G   ,U+1318 ,U+1319 ,U+131a ,U+131b ,U+131c ,U+131d ,U+131e ,U+1318 ,U+131f ,U+2d96 ,U+2d94 ,U+2d95 ,U+2d93 ,U+131f |
    $T   ,U+1320 ,U+1321 ,U+1322 ,U+1323 ,U+1324 ,U+1325 ,U+1326 ,U+2d8f ,U+1327 ,U+1327 ,U+1327 ,U+1327 ,U+1327 ,U+1327 |
    $C   ,U+1328 ,U+1329 ,U+132a ,U+132b ,U+132c ,U+132d ,U+132e ,U+2d90 ,U+132f ,U+132f ,U+132f ,U+132f ,U+132f ,U+132f |
    $P   ,U+1330 ,U+1331 ,U+1332 ,U+1333 ,U+1334 ,U+1335 ,U+1336 ,U+2d91 ,U+1337 ,U+1337 ,U+1337 ,U+1337 ,U+1337 ,U+1337 |
    $f   ,U+1348 ,U+1349 ,U+134a ,U+134b ,U+134c ,U+134d ,U+134e ,U+1348 ,U+134f ,U+138b ,U+1389 ,U+138a ,U+1388 ,U+135a |
    $p   ,U+1350 ,U+1351 ,U+1352 ,U+1353 ,U+1354 ,U+1355 ,U+1356 ,U+2d92 ,U+1357 ,U+138f ,U+138d ,U+138e ,U+138c ,U+1357 |
    $J   ,U+1220 ,U+1221 ,U+1222 ,U+1223 ,U+1224 ,U+1225 ,U+1226 ,U+1220 ,U+1227 ,U+1227 ,U+1227 ,U+1227 ,U+1227 ,U+1227 |
    $L   ,U+1280 ,U+1281 ,U+1282 ,U+1283 ,U+1284 ,U+1285 ,U+1286 ,U+1287 ,U+128b ,U+128d ,U+128a ,U+128c ,U+1288 ,U+128b |
    $K   ,U+12b8 ,U+12b9 ,U+12ba ,U+12bb ,U+12bc ,U+12bd ,U+12be ,U+12b8 ,U+12c3 ,U+12c5 ,U+12c2 ,U+12c4 ,U+12c0 ,U+12c3 |
    $F   ,U+1338 ,U+1339 ,U+133a ,U+133b ,U+133c ,U+133d ,U+133e ,U+1338 ,U+133f ,U+133f ,U+133f ,U+133f ,U+133f ,U+133f |
    $V   ,U+1340 ,U+1341 ,U+1342 ,U+1343 ,U+1344 ,U+1345 ,U+1346 ,U+1347 ,U+1340 ,U+1340 ,U+1340 ,U+1340 ,U+1340 ,U+1340 |
    $S$# ,U+2da0 ,U+2da1 ,U+2da2 ,U+2da3 ,U+2da4 ,U+2da5 ,U+2da6 ,U+2da0 ,U+2da0 ,U+2da0 ,U+2da0 ,U+2da0 ,U+2da0 ,U+2da0 |
    $c$# ,U+2da8 ,U+2da9 ,U+2daa ,U+2dab ,U+2dac ,U+2dad ,U+2dae ,U+2da8 ,U+2da8 ,U+2da8 ,U+2da8 ,U+2da8 ,U+2da8 ,U+2da8 |
    $Z$# ,U+2db0 ,U+2db1 ,U+2db2 ,U+2db3 ,U+2db4 ,U+2db5 ,U+2db6 ,U+2db0 ,U+2db0 ,U+2db0 ,U+2db0 ,U+2db0 ,U+2db0 ,U+2db0 |
    $C$# ,U+2db8 ,U+2db9 ,U+2dba ,U+2dbb ,U+2dbc ,U+2dbd ,U+2dbe ,U+2db8 ,U+2db8 ,U+2db8 ,U+2db8 ,U+2db8 ,U+2db8 ,U+2db8 |
    $q$# ,U+2dc0 ,U+2dc1 ,U+2dc2 ,U+2dc3 ,U+2dc4 ,U+2dc5 ,U+2dc6 ,U+2dc0 ,U+2dc0 ,U+2dc0 ,U+2dc0 ,U+2dc0 ,U+2dc0 ,U+2dc0 |
    $k$# ,U+2dc8 ,U+2dc9 ,U+2dca ,U+2dcb ,U+2dcc ,U+2dcd ,U+2dce ,U+2dc8 ,U+2dc8 ,U+2dc8 ,U+2dc8 ,U+2dc8 ,U+2dc8 ,U+2dc8 |
    $K$# ,U+2dd0 ,U+2dd1 ,U+2dd2 ,U+2dd3 ,U+2dd4 ,U+2dd5 ,U+2dd6 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 |
    $H$# ,U+2dd0 ,U+2dd1 ,U+2dd2 ,U+2dd3 ,U+2dd4 ,U+2dd5 ,U+2dd6 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 ,U+2dd0 |
    $g$# ,U+2dd8 ,U+2dd9 ,U+2dda ,U+2ddb ,U+2ddc ,U+2ddd ,U+2dde ,U+2dd8 ,U+2dd8 ,U+2dd8 ,U+2dd8 ,U+2dd8 ,U+2dd8 ,U+2dd8 |
    $C$= ,U+ab20 ,U+ab21 ,U+ab22 ,U+ab23 ,U+ab24 ,U+ab25 ,U+ab26 ,U+ab20 ,U+ab20 ,U+ab20 ,U+ab20 ,U+ab20 ,U+ab20 ,U+ab20 |
    $P$= ,U+ab28 ,U+ab29 ,U+ab2a ,U+ab2b ,U+ab2c ,U+ab2d ,U+ab2e ,U+ab28 ,U+ab28 ,U+ab28 ,U+ab28 ,U+ab28 ,U+ab28 ,U+ab28 |
    $s$= ,U+ab05 ,U+ab01 ,U+ab02 ,U+ab03 ,U+ab04 ,U+ab05 ,U+ab06 ,U+ab05 ,U+ab05 ,U+ab05 ,U+ab05 ,U+ab05 ,U+ab05 ,U+ab05 |
    $z$= ,U+ab15 ,U+ab11 ,U+ab12 ,U+ab13 ,U+ab14 ,U+ab15 ,U+ab16 ,U+ab15 ,U+ab15 ,U+ab15 ,U+ab15 ,U+ab15 ,U+ab15 ,U+ab15 |
    $D$= ,U+ab0d ,U+ab09 ,U+ab0a ,U+ab0b ,U+ab0c ,U+ab0d ,U+ab0e ,U+ab0d ,U+ab0d ,U+ab0d ,U+ab0d ,U+ab0d ,U+ab0d ,U+ab0d |
    $s$[ ,U+1220 ,U+1221 ,U+1222 ,U+1223 ,U+1224 ,U+1225 ,U+1226 ,U+1220 ,U+1227 ,U+1227 ,U+1227 ,U+1227 ,U+1227 ,U+1227 |
    $h$[ ,U+1280 ,U+1281 ,U+1282 ,U+1283 ,U+1284 ,U+1285 ,U+1286 ,U+1287 ,U+128b ,U+128d ,U+128a ,U+128c ,U+1288 ,U+128b |
    $H$[ ,U+12b8 ,U+12b9 ,U+12ba ,U+12bb ,U+12bc ,U+12bd ,U+12be ,U+12b8 ,U+12c3 ,U+12c5 ,U+12c2 ,U+12c4 ,U+12c0 ,U+12c3 |
    $t$[ ,U+1338 ,U+1339 ,U+133a ,U+133b ,U+133c ,U+133d ,U+133e ,U+1338 ,U+133f ,U+133f ,U+133f ,U+133f ,U+133f ,U+133f |
    $T$[ ,U+1340 ,U+1341 ,U+1342 ,U+1343 ,U+1344 ,U+1345 ,U+1346 ,U+1347 ,U+1340 ,U+1340 ,U+1340 ,U+1340 ,U+1340 ,U+1340 |
)

; Used with ReplaceLastKey(group)
; Value: LastOutput (LO) is replaced with new value (nV)
GroupStar =
( ;LO  nV
  $1 U+1369|  $2 U+136a|  $3 U+136b|  $4 U+136c|  $5 U+136d| |
  $6 U+136e|  $7 U+136f|  $8 U+1370|  $9 U+1371|  U+1228 U+1358|  U+1218 U+1359|  U+1348 U+135a| |; specials ፘ  ፙ and ፚ
)

GroupNumber =
(
  U+136a U+1373|  U+136b U+1374|  U+136c U+1375|  U+136d U+1376| |
  U+136e U+1377|  U+136f U+1378|  U+1370 U+1379|  U+1371 U+137a| |
  U+1369 U+1372 U+137b U+e494 U+137c| | ; 10 100 1000 10000
)

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupHash = ( $S $c $Z $C $q $k $H $K $g )

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupSquareOpen = ( $s $h $H $t $T )

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupEqual = ( $C $P $s $z $D )

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupDeadKey = ( $A $B $E $M $R $U )

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupPunctuation = ( $< $> $- $. $: $; $, $/ $) $' $" )

GroupPunctEx = ( $. U+1362|  $: U+1361|  $, U+1365|  $; U+1364| )

; Used with ReplaceDoubleKey(group)
; Value: LastOutput(LO) followed by InputKey(K) results to newValue(nV)
GroupPunctD =
(
  U+1361 $. U+1367| | U+1361 $: U+1368| |
  U+1361 $- U+1366| | U+1365 $, U+1363| |
  U+1362 $. U+002E| | U+002E $. U+2022| | U+2022 $. U+1362| |
  U+1362 $/ U+1360| | U+1218 $) U+e496| |
      $> $> U+00bb| |     $< $< U+00ab| |
      $> $" U+00bb| |     $< $" U+00ab| |
      $> $' U+203a| |     $< $' U+2039| |
)

; Used with ReplaceDoubleKey(group)
; Value: LastOutput(LO) followed by InputKey(K) results to newValue(nV)
GroupDiacritic =
(
      U+1362 $: U+135e| | U+1362 $' U+135f| | U+1362 $" U+135d| |
      U+1362 $1 U+030f| | U+1362 $2 U+0300| | U+1362 $3 U+0304| |
      U+1362 $4 U+0301| | U+1362 $5 U+030b| | U+1362 $6 U+0302| |
      U+1362 $7 U+030c| | U+1362 $8 U+0307| | U+1362 $9 U+0308| |
      U+1362 $0 U+0303| |
)

; Used with InGroup(group)
; It is just checked if a value is within a specified group
GroupDiacriticTrigger = ( $: $' $" $1 $2 $3 $4 $5 $6 $7 $8 $9 $0 )

}

;========================================================
;  Input routine for processing keystrokes:
;========================================================
KeyDown(which)
{
  Global
  StringCaseSense, On

;  msgbox matrixkey XX%MatrixKey%XX
;  msgbox lastkey XX%LastKey%XX
;  msgbox lastoutput XX%LastOutput%XX
;  msgbox which XX%which%XX
;  msgbox lastwhich XX%LastWhich%XX

   ; MatrixOut(Group, key, default, offset, new)
    ; Values:
    ;        group   = the matrix which is used
    ;        key     = the key which is searched for
    ;             if this value is empty then the last assigned key will be used
    ;        default = if nothing is found this value is put out if not empty
    ;        offset  =  the offset number for the element
    ;        new     = if 1 the the last key is replaced otherwise inserted

  ; Modifier keys:

  ; throw away deadkeys
  if (InGroup(GroupDeadKey, which) == true)
  {
    KeyFired := true ; deadkey
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$u")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 10, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, "", "U+12a1", 2, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$i")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 11, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, "", "U+12a2", 3, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$a")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 9, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, "", "U+12a3", 4, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$y")
  {
    if (LastWhich <> "&&&" && LastWhich <> "")
    {
      MatrixOut(GroupBasicMatrix, "", "", 5, 1)  ; don't have default value to avoid confusion
    }
    else
    {
      KeyFired := true
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$e")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 12, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, "", "U+12a5", 6, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$o")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 13, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, "", "U+12a6", 7, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$O")
  {
    MatrixOut(GroupBasicMatrix, "", "U+2d8a", 8, 1)
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$W")
  {
    MatrixOut(GroupBasicMatrix, "", "U+12a7", 9, 1)
    LastWhich := "$W"
    ; do NOT assign nonsense value to matrixkey since may need diphthong
  }

  else if (which == "$I")
  {
    if (LastWhich == "$W")
    {
      MatrixOut(GroupBasicMatrix, "", "", 14, 1)
    }
    else
    {
      ;if WI not found, just return W (base diphthong
      MatrixOut(GroupBasicMatrix, "", "U+12a7", 9, 1)
    }
    LastWhich := "&&&"
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$#")
  {
    ;2017-04-02 TODO: H[# not accounted for, must use K#
    if (InGroup(GroupHash, MatrixKey) == true)
    {
      MatrixKey = %MatrixKey%%which%
      MatrixOut(GroupBasicMatrix, MatrixKey, which, 1, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, which, which, 1, 0)
    }
    LastWhich := which
    ;MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

  else if (which == "$=")
  {
    if (InGroup(GroupEqual, MatrixKey) == true)
    {
      MatrixKey = %MatrixKey%%which%
      MatrixOut(GroupBasicMatrix, MatrixKey, which, 1, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, which, which, 1, 0)
    }
    LastWhich := which
    ;MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

; 2016-01-11 rik: 2 options to trigger "alt keys" (Power Ge'ez used CAPS LOCK)
; Option 1: use alternative capital letters like SIL Ethiopic (see matrix above)
; Option 2: use "[" trigger (eg. s[ makes ሠ)
  else if (which == "$[")
  {
    if (InGroup(GroupSquareOpen, MatrixKey) == true)
    {
      MatrixKey = %MatrixKey%%which%
      MatrixOut(GroupBasicMatrix, MatrixKey, which, 1, 1)
    }
    else
    {
      MatrixOut(GroupBasicMatrix, which, which, 1, 0)
    }
    LastWhich := which
    ;MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
  }

 else if (LastOutput == "U+1362" && InGroup(GroupDiacriticTrigger, which))
  {
    ReplaceDoubleKey(GroupDiacritic)
    LastWhich := which
  }

  else if (InGroup(GroupPunctuation, which) == true)
  {
    if (ReplaceDoubleKey(GroupPunctD) == false)
    {
      ExchangeKey(GroupPunctEx)
    }
    MatrixKey := "&&&"  ; Assign nonsense value to matrix key to avoid unwanted modifications
    LastWhich := which
  }

  else if (which == "$*")
  {
    ReplaceLastKey(GroupStar)
    LastWhich := which
  }

  else if (which == "$0")
  {
    ReplaceLastKey(GroupNumber)
    LastWhich := which
  }

  else
  {
    MatrixOut(GroupBasicMatrix, which, which, 1, 0)
    LastWhich := which
  }
}
