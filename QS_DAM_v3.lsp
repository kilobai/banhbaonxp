;;;=============================================================================
;;;  QS_DAM.lsp  -  v3.1  (1 file duy nhat, DCL tu sinh)
;;;  v3.1: - SHOP THEP DAI giong DCE (dam.dwg): hinh 1:1 kich thuoc ngoai, dim tung doan, tag
;;;          Dce_KhtThepDai2 (SH / DKVAKC / VITRI) + xdata DcePro, QS_DAM ; dai kin kieu DCE (chong + 1 moc).
;;;        - Dai trong kieu DCE: dai 1 nhanh (moc tren 135/6d, chan duoi 90/12d) tai moi thanh giua lop 1
;;;          tren (QS_DAMSET trang 2: 1 nhanh / dai kin). So hieu dai tach theo phi + be rong dam.
;;;        - Moi dai gia cuong dam phu co them bo dai trong / dai 1 nhanh (tuy chon). Chieu dai dai C /
;;;          dai 1 nhanh: cong doan thang bo qua uon (nhu DCE) hoac theo tim (tuy chon).
;;;        - Bo cuc shop tuy chinh (QS_DAMSET trang 5): shop tren tren/duoi MC doc, dai thep GIA rieng,
;;;          vi tri shop dai (phai shop tren / phai shop duoi / duoi), KC hinh, so hinh / hang, vi tri bang.
;;;        - Thep cho 2 dau tren shop: duong MACH NGUNG, ky hieu COUPLER, dem coupler vao bang thong ke.
;;;        - Coupler co the keo ra ngoai mep dam 1 doan, so le 2 nhom: L cho = "100/300" (1/2 so thanh 100,
;;;          1/2 so thanh 300) ; "AUTO" -> QS_DAMSET trang 3 (CPLL).
;;;        - Ten dam cho noi (Excel S8 / T8, V1: CHO_TEN): ghi "THEP CHO / COUPLER NOI DAM ..." tren MC doc,
;;;          dai shop va ten dam trong vung net khuat zone sau. Sua ma unicode chu MACH NGUNG tren shop.
;;;        - Doc sheet nhap lieu QS_DAM_V2 (QS_DAM_NhapLieu.xlsx moi): bo cuc o giong het sheet
;;;          DCE_Pro_Beam (dan so lieu DCE sang dung duoc ngay) + thep cho 2 dau (S3:T7),
;;;          tai san / san lat (Y2:Y3). Van doc sheet QS_DAM_V1 va DCE_Pro_Beam nhu cu.
;;;  v3.0: - Cai dat day du theo bang DCE (4 trang): moc dai ngoai / trong / C / U theo goc
;;;          90-135-180 va L moc theo d ("12/6", "8-12/10-10"), Btbv dai 4 phia, vai bo,
;;;          hien thi MCN/MCD, be ke, lam tron TKT, cat chan, KC join, Dim DV ...
;;;        - Thep cho 2 dau dam (cho thang / coupler / so le) + mach ngung, shop cat dung.
;;;        - Moi noi bat buoc (cat thep o nhip), noi doan thang hang (KC Join).
;;;        - Thong ke thep dai / dai C / C do (chieu dai theo duong tim + moc) trong QS_SHOPDAM.
;;;        - Doc sheet nhap lieu moi QS_DAM (QS_DAM_NhapLieu.xlsx) + van doc sheet DCE_Pro_Beam.
;;;        - Lenh QS_DAMNOI: bang chieu dai noi theo phi (trong / ngoai vung).
;;;  v2.0: trinh bay GIONG BAN VE DCE (dam.dwg): block tag Dce_Kht*, truc Dce_KhTenTruc,
;;;        cao do Dce_CaoTrinh, ky hieu MC DCE_MatCatA, ten dam Dce_KhTenDam, dim Dce_xxMV,
;;;        cot cut 1000/850 + zigzag, net khuat san/dam giao, thanh vat goc + gach dau thanh,
;;;        MC ngang ty le 1:1 ghi chu theo 1:25, shop co vung DUOC NOI hatch + tag (L=...).
;;;        Layer QS_* cung mau / net / net in voi layer DCE_* tuong ung.
;;;  Tac gia : Nguyen Xuan Phat  |  banhbaonxp@gmail.com
;;;
;;;  LENH:
;;;    QS_VEDAM   - Nhan dang thong so dam (Excel sheet DCE_Pro_Beam dang mo,
;;;                 hoac block DCE / dam QS_DAM co san trong ban ve) -> ve mat
;;;                 cat doc, truc, thep chu, thep tang cuong, thep gia, dai,
;;;                 dim, mat cat ngang. Thanh thep gan xdata "DcePro" (tuong
;;;                 thich QS_DBimThep) + xdata "QS_DAM".
;;;    QS_SHOPDAM - Quet chon mat cat doc (ve bang QS_VEDAM hoac DCE) -> nhan
;;;                 dang thanh T/B/G, chia vung duoc phep noi, cat thep theo
;;;                 L cay + chieu dai noi theo phi va theo lop tren/duoi, noi
;;;                 so le, uu tien thu vien L -> ve shop thep lop tren / lop
;;;                 duoi, bang thong ke doan cat, xuat CSV.
;;;    QS_DAMSET  - Cai dat 4 trang (hop thoai DCL; neu DCL loi -> sua tren dong lenh).
;;;    QS_DAMNOI  - Bang chieu dai noi thep theo phi.
;;;    QS_DAMHELP - In huong dan.
;;;
;;;  QUY UOC SO LIEU (giong sheet DCE_Pro_Beam):
;;;    Dong 11: cot Goi = be rong goi (mm), cot Nhip = chieu dai THONG THUY (mm)
;;;    Dong 13..17: thep tang cuong TREN lop 1..5 tai GOI ("3t28" hoac "3t28;5t28" = trai;phai)
;;;    Dong 22..18: thep tang cuong DUOI lop 1..5 tai NHIP
;;;    Dong 24 (nhip): thep gia "2x2t12" | Dong 26: goi = ten truc, nhip = dai "10-100/150"
;;;    Dong 27 (goi): do lech truc so voi tam cot | Dong 28/29 (goi): KT + vi tri dam giao
;;;    trong nhip ben phai, Dong 29 (nhip): dai gia cuong "10t10a50"
;;;    Dong 12, 23, 25 (giat cap, doi tiet dien): CHUA HO TRO -> canh bao, bo qua.
;;;
;;;  CAC GIA TRI MAC DINH (chieu dai noi, neo, he so vung) la gia tri CHUA XAC NHAN
;;;  - ky su phu trach phai kiem tra / sua trong QS_DAMSET truoc khi phat hanh.
;;;=============================================================================

(vl-load-com)

(setq *QSD-VER* "3.1")
(setq *QSD-APP* "QS_DAM")
(setq *QSD-CFGKEY* "QS_DAM_CFG_V1")

;;;-----------------------------------------------------------------------------
;;; 0. CAU HINH MAC DINH  (key  gia-tri  mo-ta  kieu)
;;;    kieu: N = so > 0, Z = so >= 0, K = he so 0..1, S = chuoi, B = 0/1, M = che do vung noi,
;;;          L = chon trong danh sach (phan tu thu 5)
;;;-----------------------------------------------------------------------------
(setq *QSD-DEF*
 (list
  ;; ===== TRANG 1: HIEN THI / MAT CAT DOC =====
  (list "TLDOC"   "50"    "Ty le mat cat doc 1:"                          "N")
  (list "TLNGANG" "25"    "Ty le mat cat ngang 1:"                        "N")
  (list "FORM"    "1"     "Form hinh thuc ban ve (1 = giong DCE)"          "N")
  (list "LTS"     "50"    "Linetype scale (net truc / net khuat)"          "N")
  (list "DIMMEPCOT" "1"   "Dim mep cot den truc"                           "B")
  (list "KEOTHEP50" "0"   "Keo thep vi tri cat > 50% (mm)"                 "Z")
  (list "GHITLMCN" "0"    "Ghi ty le ve o MCN dam"                         "B")
  (list "VITRIMC" "NGOAI" "Vi tri ghi MC 1-1; 2-2..."                      "L" '("NGOAI" "TRONG"))
  (list "CHENHMEP" "50/50" "Chenh mep tren & duoi max (mm)"                "S")
  (list "NHANTHEP" "1/6"  "Nhan thep khi chenh H/B <="                     "S")
  (list "A1VE"    "70"    "Btbv MC doc: tim thep lop 1 -> mep BT (mm)"     "N")
  (list "DAIVE"   "70"    "MC doc: net dai dau -> mep goi (mm)"            "Z")
  (list "DLVE"    "50"    "KC giua 2 lop thep - MC doc (mm)"               "N")
  (list "CEND"    "70"    "Btbv dau thanh -> mep goi bien (mm)"            "Z")
  (list "DAIDAU"  "50"    "Dai dau tien cach mep goi - tinh SL (mm)"       "Z")
  (list "KDAI"    "0.25"  "Vung dai day = k x Ln (khi so lieu de trong)"   "K")
  (list "ROUNDL"  "50"    "Lam tron doan thep tang cuong (mm)"             "N")
  (list "TICKL"   "70"    "Doan ky hieu cat thep (mm)"                     "Z")
  (list "TICKA"   "30"    "Goc quay ky hieu cat thep (do)"                 "Z")
  (list "SLDAIMCD" "TWO"  "SL dai tren mat cat doc (One/Two Link)"         "L" '("ONE" "TWO"))
  (list "KHONGTRUDAI" "1" "Khong tru bo thep dai o vi tri dam giao nhip"   "B")
  (list "VEDAIGC" "0"     "Ve dai gia cuong tai nhip ca dai phia trong"    "B")
  (list "GHICAODO" "1"    "Ghi cao do MCN"                                 "B")
  (list "DIMHSAN" "0"     "Dim H san (MCN)"                                "B")
  (list "DIMBTBV" "0"     "Dim Btbv (MCN)"                                 "B")
  (list "ANTENNHIP" "1"   "An ten nhip dam"                                "B")
  (list "GHIKTNHIP" "0"   "Ghi kich thuoc tung nhip"                       "B")
  (list "THEPSHKHAC" "0"  "Thep giong nhau SH khac nhau"                   "B")
  (list "ANMCD"   "0"     "An MCD (chi ve MCN)"                            "B")
  (list "TAGCDO"  "1"     "Tag C do thep gia / lop tang cuong"             "B")
  (list "GHICHIEUDAI" "0" "Ghi chieu dai thanh trong tag"                  "B")
  (list "GHISL"   "1"     "Ghi SL thanh trong tag"                         "B")
  (list "TKBETONG" "0"    "Thong ke be tong"                               "B")
  (list "DANHTENMCN" "1"  "Danh ten o MCN don gian"                        "B")
  (list "DIMMCNPHAI" "0"  "Dim MCN ben phai"                               "B")
  (list "DANHGOINHIP" "0" "Danh Goi - Nhip o MCN"                          "B")
  (list "MCNGANG" "1"     "Ve mat cat ngang"                               "B")
  (list "VEMCN"   "SIEURUTGON" "Ve mat cat ngang (muc do)"                 "L" '("SIEURUTGON" "RUTGON" "DAYDU"))
  (list "GHITRUCMCN" "0"  "Ghi ten truc o mat cat ngang"                   "B")
  (list "TATSODO" "0"     "Tat so do dam"                                  "B")
  ;; ===== TRANG 2: DAI / MOC / MAT CAT NGANG =====
  (list "LMOCNGOAI" "6" "L moc dai ngoai (x d): a hoac a/b hoac d-a/d-a" "S")
  (list "DNGUONG" "10"    "d nguong 2 chieu dai moc: d<= dung a, d> dung b" "N")
  (list "LMOCMIN" "40"    "L moc toi thieu (mm)"                           "Z")
  (list "GOCQ"    "135"   "Goc Q dai kin (moc dai ngoai, do)"              "L" '("90" "135" "180"))
  (list "LMOCTRONG" "12"  "L moc dai trong (x d)"                          "S")
  (list "GOCTRONG" "90"   "Goc moc dai trong (do)"                         "L" '("90" "135" "180"))
  (list "GOCCL"   "135"   "Goc quay dai C - TRAI (do)"                     "L" '("90" "135" "180"))
  (list "GOCCR"   "90"    "Goc quay dai C - PHAI (do)"                     "L" '("90" "135" "180"))
  (list "LMOCCL"  "6"     "L moc dai C - TRAI (x d)"                       "S")
  (list "LMOCCR"  "12"    "L moc dai C - PHAI (x d)"                       "S")
  (list "KHEHOC"  "20"    "Khe ho dai C toi thieu (mm)"                    "Z")
  (list "BEMOCC"  "16"    "Be moc dai C khi Dk < (mm)"                     "N")
  (list "MOCUBAO" "10"    "Moc dai U bao (x d)"                            "S")
  (list "GOCUBAO" "135"   "Goc moc dai U bao / U trong (do)"               "L" '("90" "135" "180"))
  (list "MOCUTRONG" "10"  "Moc dai U trong (x d)"                          "S")
  (list "BTBVT"   "65"    "Btbv dai TREN (mm)"                             "Z")
  (list "BTBVB"   "65"    "Btbv dai DUOI (mm)"                             "Z")
  (list "BTBVL"   "65"    "Btbv dai TRAI (mm)"                             "Z")
  (list "BTBVR"   "65"    "Btbv dai PHAI (mm)"                             "Z")
  (list "RDAI"    "20"    "Ban kinh goc bo tron dai (mm)"                  "Z")
  (list "DAIKIEU" "DCE"   "Hinh dai kin: DCE (1 doan chong + 1 moc) / 2 moc" "L" '("DCE" "2MOC"))
  (list "LCHONG"  "12"    "Doan chong dai kin kieu DCE (x d)"              "S")
  (list "DAILECH" "1"     "Ve lech nhanh chong dai kin (thay 2 nhanh)"     "B")
  (list "DAITRONGKIEU" "1NHANH" "Dai trong: 1 nhanh moi thanh giua / dai kin" "L" '("1NHANH" "KIN"))
  (list "GOC1N"   "135"   "Goc moc dai 1 nhanh - dau tren (do)"            "L" '("90" "135" "180"))
  (list "LMOC1N"  "6"     "L moc dai 1 nhanh - dau tren (x d)"             "S")
  (list "LCHAN1N" "12"    "L chan dai 1 nhanh - dau duoi (x d)"            "S")
  (list "DAITRONGGC" "1"  "Cong dai trong / 1 nhanh tai dai gia cuong dam phu" "B")
  (list "LCKIEU"  "CONGDOAN" "Chieu dai dai C / 1 nhanh"                   "L" '("CONGDOAN" "TIM"))
  (list "DLMC"    "50"    "KC giua 2 lop thep - MC ngang (mm)"             "N")
  (list "DAIVB"   "20"    "Doan keo thep dai vai bo (x d)"                 "Z")
  (list "GOCVB"   "60"    "Goc dai vai bo khi H >= Hvb (do)"               "L" '("45" "60"))
  (list "HVB"     "700"   "Hvb - chieu cao dam dung goc tren (mm)"         "Z")
  (list "GHISLKR" "0"     "Ghi so luong thep co khoang rai (21%%c10a100)"  "B")
  (list "ROUNDUPSL" "0"   "Lam tron SL len (RoundUp)"                      "B")
  ;; ===== TRANG 3: NEO / BE KE =====
  (list "HOOKD"   "5"     "Be ke toi thieu (x d)"                          "Z")
  (list "HOOKMIN" "100"   "Be ke toi thieu (mm)"                           "Z")
  (list "NEODU"   "0"     "Neo du"                                         "B")
  (list "KEOGIAHETCOT" "0" "Keo thep gia het cot"                          "B")
  (list "NEOTRONGCOT" "0" "Neo thep luon trong cot"                        "B")
  (list "CATGOI"  "100/100/100" "Cat thep khi L(goi) (T/B/G) > (x d)"      "S")
  (list "KBKDUOIQUA" "0"  "Khong be ke thep lop duoi qua mat tren dam"     "B")
  (list "KBKDUOI" "KHONG" "Khong be ke thep lop duoi"                      "L" '("KHONG" "2DAU" "TOANBO"))
  (list "BKDUOI"  "0"     "Be ke thep duoi"                                "B")
  (list "BKDUOIL" "40d"   "Be ke thep duoi - chieu dai"                    "S")
  (list "BKDUOIKIEU" "KEOHETCOT" "Be ke thep duoi - kieu"                  "L" '("KEOHETCOT" "THEOL"))
  (list "CHIKEOCHAYDUOI" "0" "Chi keo het cot thep chay suot lop duoi"    "B")
  (list "LUONKEODUOI" "0" "Luon keo thep lop duoi 2 dau dam den het cot"   "B")
  (list "KBKTRENQUA" "0"  "Khong be ke thep lop tren qua mat duoi dam"     "B")
  (list "BKTREN"  "0"     "Be ke thep tren 2 dau"                          "B")
  (list "BKTRENQUA" "MEPDUOI" "Be ke thep tren qua ... dam"                "L" '("MEPDUOI" "TIMDAM"))
  (list "BKTRENKIEU" "KEOHETCOT" "Be ke thep tren - kieu"                  "L" '("KEOHETCOT" "THEOL"))
  (list "BKTRENL" "45d"   "Be ke thep tren - chieu dai"                    "S")
  (list "CHIKEOCHAYTREN" "0" "Chi keo het cot thep chay suot lop tren"    "B")
  (list "LUONKEOTREN" "0" "Luon keo thep lop tren 2 dau dam den het cot"   "B")
  (list "LAMTRON" "1/50/50" "Thong so lam tron (mm)"                       "S")
  ;; --- thep cho 2 dau dam (mac dinh khi so lieu dam khong ghi) ---
  (list "CHOTRAI" "KHONG" "Thep cho dau TRAI"                              "L" '("KHONG" "THANG" "COUPLER"))
  (list "CHOPHAI" "KHONG" "Thep cho dau PHAI"                              "L" '("KHONG" "THANG" "COUPLER"))
  (list "CHOLOP"  "TBG"   "Thep cho: lop ap dung (T tren, B duoi, G gia)"  "L" '("TBG" "TB" "T" "B"))
  (list "CHOTHEP" "TATCA" "Thep cho: tat ca thanh toi dau dam / chi chay suot" "L" '("TATCA" "CHAY"))
  (list "CHOL"    "AUTO"  "L cho: AUTO = L noi ngoai vung | 40d | 1200"     "S")
  (list "CHOSOLE" "0"     "Thep cho so le 50% (nhom 2 dai them L + KC)"    "B")
  (list "CPLL"    "0"     "Coupler: doan ra ngoai mep dam (mm), 100/300 = so le" "S")
  (list "NEOT"    "10-500/12-600/14-690/16-790/18-890/20-990/22-1090/25-1230/28-1380/32-1580" "Neo thep TREN (d-L)" "S")
  (list "NEOB"    "10-350/12-420/14-480/16-550/18-620/20-690/22-760/25-860/28-960/32-1100"   "Neo thep DUOI (d-L)" "S")
  (list "NEOG"    "10-350/12-420/14-480/16-550/18-620/20-690/22-760/25-860/28-960/32-1100"   "Neo thep GIA (d-L)"  "S")
  (list "KGOI"    "0.25|0.25|0.15" "He so thep mu goi (| L truc tu mep, \\ tu tim, / Ln)"     "S")
  (list "KNHIP"   "0.15\\0.25\\0.1" "He so thep tang cuong nhip (cung quy uoc)"  "S")
  ;; ===== TRANG 4: CAT THEP SHOP =====
  (list "LSTOCK"  "11700" "Chieu dai 1 cay thep (mm)"                      "N")
  (list "THUVIEN" "10400,9750,9360,9100,8775,7020,6500,5200,4680,2600" "Thu vien L uu tien (mm)" "S")
  (list "UUTIENTV" "1"    "Uu tien L trong thu vien"                       "B")
  (list "TOPMODE" "NHIP"  "Vung noi thep TREN"                             "M")
  (list "TOPK"    "0.25"  "Thep TREN: cach mep k x L"                      "K")
  (list "BOTMODE" "GOI"   "Vung noi thep DUOI"                             "M")
  (list "BOTK"    "0.25"  "Thep DUOI: cach mep k x L"                      "K")
  (list "GIAMODE" "TATCA" "Vung noi thep GIA"                              "M")
  (list "GIAK"    "0.25"  "Thep GIA: cach mep k x L"                       "K")
  (list "TIMCOT"  "0"     "Tinh vung tu TIM COT (0 = tu mep)"              "B")
  (list "KHONGCOT" "0"    "Khong noi thep trong vung cot"                  "B")
  (list "SOLE"    "1"     "Cat so le cung 1 lop thep"                      "B")
  (list "GAPD"    "10"    "KC toi thieu giua 2 moi noi (x d)"              "Z")
  (list "RNDCAT"  "5"     "Lam tron doan cat la boi so cua (mm)"           "N")
  (list "LMIN"    "1000"  "Doan thep cat ngan nhat (mm)"                   "N")
  (list "CATCHAN" "0"     "Cat chan thep uu tien shop"                     "B")
  (list "CATCHANT" "1"    "Cat chan: ap dung lop TREN"                     "B")
  (list "CATCHANB" "1"    "Cat chan: ap dung lop DUOI"                     "B")
  (list "KCJOIN"  "300"   "KC Join 2 diem - noi doan thang hang (mm)"      "Z")
  (list "RNDTKT"  "5"     "Lam tron TKT tong (mm)"                         "N")
  (list "RNDTKTCT" "1"    "Lam tron TKT cac doan chi tiet"                 "B")
  (list "HATCHPAT" "ANSI31" "Loai hatch vung duoc noi"                     "S")
  (list "HATCHSC" "200"   "Scale hatch"                                    "N")
  (list "DIMDV"   "1"     "Dim DV (dim doan cat tren shop)"                "B")
  (list "COUPLER" "0"     "Noi coupler khi d >= (0 = khong)"               "Z")
  (list "ROWK"    "4"     "Khoang cach hang shop (x chieu cao chu)"        "N")
  (list "BANG"    "1"     "Ve bang thong ke doan cat + thong ke dai"       "B")
  (list "CSV"     "1"     "Xuat file CSV doan cat"                         "B")
  ;; ===== TRANG 5: BO CUC SHOP (mac dinh giong ban ve DCE dam.dwg) =====
  (list "SHOPTRENVT" "TREN" "Shop thep TREN dat phia (so voi MC doc)"      "L" '("TREN" "DUOI"))
  (list "DOLECHSHOP" "650" "KC mep MC doc -> khung shop TREN (mm)"         "Z")
  (list "KCSHOPDUOI" "650" "KC mep MC doc -> khung shop DUOI (mm)"         "Z")
  (list "SHOPGIA" "RIENG" "Shop thep GIA: dai rieng / gop duoi / gop tren" "L" '("RIENG" "DUOI" "TREN"))
  (list "HOIDIEM" "0"     "Hoi diem dat shop (0 = tu dong theo bo cuc)"    "B")
  (list "SHOPDAI" "PHAITREN" "Vi tri shop thep dai"                        "L" '("PHAITREN" "PHAIDUOI" "DUOI" "KHONG"))
  (list "DAIKCKHUNG" "810" "Shop dai: KC khung shop -> hinh dau (mm)"     "Z")
  (list "DAILUI"  "350"   "Shop dai: lui tu mep khung (mm)"                "Z")
  (list "DAIKC"   "1000"  "Shop dai: KC giua 2 hinh (mm)"                  "N")
  (list "DAIMOIHANG" "0"  "Shop dai: so hinh / hang (0 = 1 hang)"          "Z")
  (list "DAIDIM"  "1"     "Shop dai: dim tung doan"                        "B")
  (list "BANGVT"  "DUOI"  "Vi tri bang thong ke"                           "L" '("DUOI" "PHAI"))
  (list "CHOSHOP" "1"     "Shop: ve mach ngung / coupler thep cho 2 dau"   "B")
  ;; ===== BANG CHIEU DAI NOI (lenh QS_DAMNOI) =====
  (list "UUTIENLAPMM" "1" "Uu tien noi theo bang du lieu mm"               "B")
  (list "LAPMM1"  "10-490/340/340/500;12-650/450/450/650;14-800/560/560/800;16-980/680/680/980;18-1130/790/790/1130;20-1290/900/900/1290;22-1450/1010/1010/1450;25-1690/1180/1180/1690;28-1900/1330/1330/1900;32-2200/1540/1540/2200"
        "L noi TRONG vung (d-T/B/G/Random mm)" "S")
  (list "LAPMM2"  "10-490/340/340/500;12-650/450/450/650;14-800/560/560/800;16-980/680/680/980;18-1130/790/790/1130;20-1290/900/900/1290;22-1450/1010/1010/1450;25-1690/1180/1180/1690;28-1900/1330/1330/1900;32-2200/1540/1540/2200"
        "L noi NGOAI vung (d-T/B/G/Random mm)" "S")
  (list "LAPKD1"  "50/35/35/50" "L noi TRONG vung (x d: T/B/G/Random)"     "S")
  (list "LAPKD2"  "50/35/35/50" "L noi NGOAI vung (x d: T/B/G/Random)"     "S")
 )
)
(setq *QSD-MODES* '(("NHIP" . "Nhip (giua nhip)") ("GOI" . "Goi (quanh goi)") ("TATCA" . "Tat ca (khong han che)")))

;;;-----------------------------------------------------------------------------
;;; 1. HAM TIEN ICH
;;;-----------------------------------------------------------------------------
(defun QSD:Err (msg) (princ (strcat "\n*** QS_DAM: " msg)) nil)
(defun QSD:Msg (msg) (princ (strcat "\n" msg)) nil)

(defun QSD:Trim (s) (if (= (type s) 'STR) (vl-string-trim " \t\r\n" s) ""))

;; Tach chuoi theo chuoi phan cach (giu phan tu rong)
(defun QSD:Split (s sep / res p n)
  (setq res nil n (strlen sep))
  (if (or (null s) (= s "")) (list "")
    (progn
      (while (setq p (vl-string-search sep s))
        (setq res (cons (substr s 1 p) res))
        (setq s (substr s (+ p n 1))))
      (reverse (cons s res)))))

(defun QSD:Join (lst sep / r)
  (setq r nil)
  (foreach s lst (setq r (if r (strcat r sep s) s)))
  (if r r ""))

(defun QSD:Replace (s old new / p res n)
  (setq res "" n (strlen old))
  (if (or (null s) (= old "")) s
    (progn
      (while (setq p (vl-string-search old s))
        (setq res (strcat res (substr s 1 p) new)
              s (substr s (+ p n 1))))
      (strcat res s))))

;; so -> chuoi gon (300 -> "300", -149.2 -> "-149.2")
(defun QSD:NumStr (x / s)
  (cond
    ((null x) "")
    ((= (type x) 'STR) x)
    ((equal x (fix x) 1e-9) (itoa (fix x)))
    ((equal x (float (fix (+ x (if (< x 0) -0.5 0.5)))) 1e-6) (itoa (fix (+ x (if (< x 0) -0.5 0.5)))))
    (T (setq s (rtos x 2 4))
       (while (and (vl-string-search "." s) (= (substr s (strlen s)) "0"))
         (setq s (substr s 1 (1- (strlen s)))))
       (if (= (substr s (strlen s)) ".") (setq s (substr s 1 (1- (strlen s)))))
       s)))

;; chuoi -> so, nil neu khong phai so
(defun QSD:Num (s)
  (cond ((numberp s) s)
        ((= (type s) 'STR) (setq s (QSD:Trim s)) (if (= s "") nil (distof s 2)))
        (T nil)))
(defun QSD:NumD (s def / v) (setq v (QSD:Num s)) (if v v def))

(defun QSD:Floor (x / f) (setq f (fix x)) (if (and (< x 0) (/= x f)) (1- f) f))
(defun QSD:Ceil  (x / f) (setq f (fix x)) (if (and (> x 0) (/= x f)) (1+ f) f))
(defun QSD:RoundUp (x step) (if (> step 0) (* step (QSD:Ceil (- (/ x step) 1e-9))) x))
(defun QSD:RoundDn (x step) (if (> step 0) (* step (QSD:Floor (+ (/ x step) 1e-9))) x))
(defun QSD:Round (x step) (if (> step 0) (* step (QSD:Floor (+ (/ x step) 0.5))) x))

;; sap xep an toan (vl-sort co the lam mat phan tu so trung nhau)
(defun QSD:Sort (lst fn) (mapcar '(lambda (i) (nth i lst)) (vl-sort-i lst fn)))

(defun QSD:Take (lst n / r) (while (and lst (> n 0)) (setq r (cons (car lst) r) lst (cdr lst) n (1- n))) (reverse r))
(defun QSD:Drop (lst n) (while (and lst (> n 0)) (setq lst (cdr lst) n (1- n))) lst)
(defun QSD:Last (lst) (car (reverse lst)))

(defun QSD:Get (key al) (cdr (assoc key al)))
(defun QSD:Put (key val al / p)
  (if (setq p (assoc key al)) (subst (cons key val) p al) (append al (list (cons key val)))))

;; lay dong cuoi cung khi chuoi nhieu dong (ten truc "PA\r\nE" -> "E")
(defun QSD:LastLine (s / l)
  (setq s (QSD:Replace (QSD:Replace (QSD:Replace s "\\P" "\n") "\r" "\n") "^M^J" "\n"))
  (setq l (vl-remove-if '(lambda (x) (= (QSD:Trim x) "")) (QSD:Split s "\n")))
  (if l (QSD:Trim (QSD:Last l)) ""))

;; chuoi an toan de lam ten file / ten block
(defun QSD:SafeName (s)
  (vl-string-translate "\\/:*?\"<>|;,. " "_____________" (QSD:Trim s)))

;;;-----------------------------------------------------------------------------
;;; 2. CAU HINH: luu trong ban ve (NOD / XRECORD) + mac dinh may (getenv)
;;;-----------------------------------------------------------------------------
(defun QSD:CfgDefaults ( / r)
  (foreach d *QSD-DEF* (setq r (cons (cons (car d) (cadr d)) r)))
  (reverse r))

(defun QSD:CfgSerialize (cfg / r)
  (setq r nil)
  (foreach p cfg (setq r (cons (strcat (car p) "=" (cdr p)) r)))
  (QSD:Join (reverse r) "~~"))

(defun QSD:CfgParse (s base / p k v)
  (foreach it (QSD:Split s "~~")
    (if (setq p (vl-string-search "=" it))
      (progn
        (setq k (substr it 1 p) v (substr it (+ p 2)))
        (if (assoc k base) (setq base (QSD:Put k v base))))))
  base)

(defun QSD:XrecGet (name / d s)
  (setq d (dictsearch (namedobjdict) name))
  (setq s "")
  (foreach p d (if (= (car p) 1) (setq s (strcat s (cdr p)))))
  (if (= s "") nil s))

(defun QSD:XrecPut (name s / old chunks dl xr)
  (setq chunks nil)
  (while (> (strlen s) 240) (setq chunks (cons (substr s 1 240) chunks) s (substr s 241)))
  (setq chunks (reverse (cons s chunks)))
  (if (setq old (dictsearch (namedobjdict) name))
    (dictremove (namedobjdict) name))
  (setq dl (list '(0 . "XRECORD") '(100 . "AcDbXrecord")))
  (foreach c chunks (setq dl (append dl (list (cons 1 c)))))
  (if (setq xr (entmakex dl)) (dictadd (namedobjdict) name xr))
  xr)

(defun QSD:CfgLoad ( / cfg s)
  (setq cfg (QSD:CfgDefaults))
  (if (setq s (vl-catch-all-apply 'getenv (list *QSD-CFGKEY*)))
    (if (and (= (type s) 'STR) (/= s "")) (setq cfg (QSD:CfgParse s cfg))))
  (if (setq s (QSD:XrecGet *QSD-CFGKEY*)) (setq cfg (QSD:CfgParse s cfg)))
  (setq *QSD-CFG* cfg))

(defun QSD:CfgSave (cfg / s)
  (setq s (QSD:CfgSerialize cfg))
  (QSD:XrecPut *QSD-CFGKEY* s)
  (vl-catch-all-apply 'setenv (list *QSD-CFGKEY* s))
  (setq *QSD-CFG* cfg))

(defun QSD:Cfg (k) (if (null *QSD-CFG*) (QSD:CfgLoad)) (QSD:NumStr (QSD:Get k *QSD-CFG*)))
(defun QSD:CfgN (k / d)
  (setq d (cadr (assoc k *QSD-DEF*)))
  (QSD:NumD (QSD:Cfg k) (QSD:NumD d 0.0)))
(defun QSD:CfgB (k) (= (QSD:Cfg k) "1"))

;; kiem tra 1 gia tri theo kieu -> nil neu hop le, chuoi loi neu sai
(defun QSD:CfgCheck (key val / d kind n)
  (setq d (assoc key *QSD-DEF*) kind (nth 3 d) n (QSD:Num val))
  (cond
    ((null d) nil)
    ((= kind "N") (if (and n (> n 0)) nil (strcat (nth 2 d) ": phai la so > 0")))
    ((= kind "Z") (if (and n (>= n 0)) nil (strcat (nth 2 d) ": phai la so >= 0")))
    ((= kind "K") (if (and n (>= n 0) (<= n 1)) nil (strcat (nth 2 d) ": phai trong khoang 0..1")))
    ((= kind "B") (if (member val '("0" "1")) nil (strcat (nth 2 d) ": chi nhan 0 / 1")))
    ((= kind "M") (if (assoc val *QSD-MODES*) nil (strcat (nth 2 d) ": NHIP / GOI / TATCA")))
    ((= kind "S")
     (cond ((wcmatch key "LAPMM?")
            (if (QSD:ParseLapMM val) nil (strcat (nth 2 d) ": sai dang d-T/B/G/R;d-T/B/G/R...")))
           ((wcmatch key "LAPKD?")
            (if (= (length (QSD:ParseFracs val)) 4) nil (strcat (nth 2 d) ": nhap 4 he so T/B/G/Random")))
           ((wcmatch key "NEO?")
            (if (QSD:ParseTable val) nil (strcat (nth 2 d) ": sai dang d-L/d-L...")))
           ((= key "THUVIEN") nil)
           ((wcmatch key "KGOI,KNHIP") (if (QSD:ParseFracs val) nil (strcat (nth 2 d) ": vd 0.25|0.25|0.15")))
           ((wcmatch key "LMOC*,MOCU*,LCHONG,LCHAN1N")
            (if (QSD:KDOk val) nil (strcat (nth 2 d) ": vd 12 | 12/6 | 8-12/10-10/12-8")))
           ((= key "CPLL") (if (QSD:NumsOk val "/" 0) nil (strcat (nth 2 d) ": vd 0 | 100 | 100/300")))
           ((= key "CATGOI") (if (QSD:NumsOk val "/" 3) nil (strcat (nth 2 d) ": vd 100/100/100")))
           ((= key "LAMTRON") (if (QSD:NumsOk val "/" 3) nil (strcat (nth 2 d) ": vd 1/50/50")))
           ((= key "CHENHMEP") (if (QSD:NumsOk val "/" 2) nil (strcat (nth 2 d) ": vd 50/50")))
           ((= key "NHANTHEP") (if (QSD:NumsOk val "/" 0) nil (strcat (nth 2 d) ": vd 1/6")))
           ((= key "CHOL")
            (if (or (= (strcase (QSD:Trim val)) "AUTO") (QSD:Num (vl-string-right-trim "dDmM" (QSD:Trim val)))) nil
              (strcat (nth 2 d) ": AUTO | 40d | 1200")))
           ((wcmatch key "BK*L")
            (if (QSD:Num (vl-string-right-trim "dDmM" (QSD:Trim val))) nil (strcat (nth 2 d) ": vd 40d | 500mm")))
           (T nil)))
    ((= kind "L") (if (member val (nth 4 d)) nil (strcat (nth 2 d) ": chon " (QSD:Join (nth 4 d) " / "))))
    (T nil)))

;; chuoi so phan cach sep: n = so phan tu bat buoc (0 = >= 1)
(defun QSD:NumsOk (s sep n / l)
  (setq l (mapcar 'QSD:Num (QSD:Split (QSD:Trim s) sep)))
  (and l (not (member nil l)) (or (= n 0) (= (length l) n))))

;;; ---- he so chieu dai moc (x d) co the phu thuoc d ----
;;;  "12"            -> 12d moi phi
;;;  "12/6"          -> d <= DNGUONG : 12d ; d > DNGUONG : 6d
;;;  "8-12/10-10/12-8" (d-k) -> phi dung bang ; phi khong co -> phi lon hon gan nhat, qua bang -> dong cuoi
(defun QSD:KDTable (s / r p d k)
  (setq r nil)
  (foreach it (QSD:Split (QSD:Replace (strcase (QSD:Trim s) T) " " "") "/")
    (if (setq p (vl-string-search "-" it))
      (progn (setq d (QSD:Num (substr it 1 p)) k (QSD:Num (vl-string-right-trim "d" (substr it (+ p 2)))))
             (if (and d k) (setq r (cons (list d k) r))))))
  (QSD:Sort r '(lambda (a b) (< (car a) (car b)))))
(defun QSD:KDOk (s / l)
  (setq s (QSD:Trim s))
  (cond ((= s "") nil)
        ((vl-string-search "-" s) (if (QSD:KDTable s) T nil))
        (T (QSD:NumsOk (vl-string-right-trim "dD" s) "/" 0))))
(defun QSD:KD (s d / l r)
  (setq s (vl-string-right-trim "dD" (QSD:Trim (if (= (type s) 'STR) s ""))))
  (cond
    ((= s "") 0.0)
    ((vl-string-search "-" s)
     (setq l (QSD:KDTable s) r nil)
     (foreach it l (if (and (null r) (>= (car it) (- d 1e-6))) (setq r (cadr it))))
     (if r r (if l (cadr (QSD:Last l)) 0.0)))
    ((vl-string-search "/" s)
     (setq l (mapcar 'QSD:Num (QSD:Split s "/")))
     (cond ((<= d (+ (QSD:CfgN "DNGUONG") 1e-6)) (QSD:NumD (car l) 0.0))
           (T (QSD:NumD (cadr l) (QSD:NumD (car l) 0.0)))))
    (T (QSD:NumD s 0.0))))
;; chieu dai doan moc thang (mm) = max(k.d , L moc min)
(defun QSD:HookLen (key d) (max (* (QSD:KD (QSD:Cfg key) d) d) (QSD:CfgN "LMOCMIN")))

;;;-----------------------------------------------------------------------------
;;; 3. DOC KY HIEU THEP
;;;-----------------------------------------------------------------------------
;; bang "10-500mm/12-600mm/..." -> ((10 . 500.0) (12 . 600.0) ...)
(defun QSD:ParseTable (s / r it p d l)
  (setq r nil)
  (if (= (type s) 'STR)
    (foreach it (QSD:Split (strcase (QSD:Replace (QSD:Trim s) " " "") T) "/")
      (setq it (QSD:Replace it "mm" ""))
      (if (setq p (vl-string-search "-" it))
        (progn
          (setq d (QSD:Num (substr it 1 p)) l (QSD:Num (substr it (+ p 2))))
          (if (and d l (> d 0) (> l 0)) (setq r (cons (cons (fix (+ d 0.01)) (float l)) r)))))))
  (QSD:Sort (reverse r) '(lambda (a b) (< (car a) (car b)))))

;; bang noi "10-490/340/340/500;12-..." -> ((10 490 340 340 500) ...) ; thieu Random -> = T
(defun QSD:ParseLapMM (s / r it p d v)
  (setq r nil)
  (if (= (type s) 'STR)
    (foreach it (QSD:Split (QSD:Replace (QSD:Trim s) " " "") ";")
      (if (setq p (vl-string-search "-" it))
        (progn
          (setq d (QSD:Num (substr it 1 p)) v (mapcar 'QSD:Num (QSD:Split (substr it (+ p 2)) "/")))
          (if (and d (> d 0) (>= (length v) 3) (not (member nil v)) (> (apply 'min v) 0))
            (setq r (cons (list (fix (+ d 0.01)) (nth 0 v) (nth 1 v) (nth 2 v) (if (nth 3 v) (nth 3 v) (nth 0 v))) r)))))))
  (QSD:Sort (reverse r) '(lambda (a b) (< (car a) (car b)))))

;; tra bang theo d; khong co d -> noi suy theo ty le L/d cua phi gan nhat
(defun QSD:TableGet (tbl d / p best)
  (cond
    ((null tbl) (* 40.0 d))
    ((setq p (assoc (fix (+ d 0.01)) tbl)) (cdr p))
    (T (setq best (car tbl))
       (foreach it tbl (if (< (abs (- (car it) d)) (abs (- (car best) d))) (setq best it)))
       (* d (/ (cdr best) (car best))))))

;; "0.25|0.25|0.15" hoac "0.15\0.25\0.1" -> (0.25 0.25 0.15)
(defun QSD:ParseFracs (s / r)
  (setq r nil)
  (if (= (type s) 'STR)
    (foreach it (QSD:Split (vl-string-translate "\\/;," "||||" (QSD:Trim s)) "|")
      (if (QSD:Num it) (setq r (cons (QSD:Num it) r)))))
  (reverse r))
(defun QSD:FracK (lst layer)
  (cond ((null lst) 0.25) ((<= layer (length lst)) (nth (1- layer) lst)) (T (QSD:Last lst))))

;; bo ky hieu duong kinh ve "t": 3T28, 3d28, 3%%c28, 3(O-gach)28, 3phi28 -> "3t28"
(defun QSD:NormBar (s / o)
  (setq s (strcase (QSD:Trim s) T))
  (setq s (QSD:Replace s " " ""))
  (foreach o (list "%%c" "\\u+00d8" "\\u+2205" "\\u+00f8" "phi" "fi" "d" "f" "r")
    (setq s (QSD:Replace s o "t")))
  (setq o (vl-catch-all-apply 'chr (list 216)))
  (if (= (type o) 'STR) (setq s (QSD:Replace s (strcase o T) "t")))
  (setq o (vl-catch-all-apply 'chr (list 248)))
  (if (= (type o) 'STR) (setq s (QSD:Replace s o "t")))
  s)

;; "3t28" -> (3 28) ; "3t28+2t25" -> ((3 28) (2 25)) qua QSD:ParseBars
(defun QSD:ParseBar1 (s / p n d)
  (setq s (QSD:NormBar s))
  (if (setq p (vl-string-search "t" s))
    (progn
      (setq n (QSD:Num (substr s 1 p)) d (QSD:Num (substr s (+ p 2))))
      (if (and n d (> n 0) (> d 0)) (list (fix (+ n 0.01)) (fix (+ d 0.01))) nil))
    nil))
(defun QSD:ParseBars (s / r x)
  (setq r nil)
  (if (and (= (type s) 'STR) (/= (QSD:Trim s) "") (/= (QSD:Trim s) "-"))
    (foreach it (QSD:Split (QSD:Trim s) "+")
      (if (setq x (QSD:ParseBar1 it)) (setq r (cons x r)))))
  (reverse r))

;; o thep goi "3t28;5t28" -> (trai phai) moi ben la list ParseBars ; "3t28" -> ca 2 ben
(defun QSD:ParseLR (s / l)
  (setq s (QSD:Trim s))
  (if (vl-string-search ";" s)
    (progn (setq l (QSD:Split s ";"))
           (list (QSD:ParseBars (car l)) (QSD:ParseBars (cadr l))))
    (list (QSD:ParseBars s) (QSD:ParseBars s))))

;; thep gia "2x2t12" -> (soHang soThanh/hang d) ; "2t12" -> (1 2 12)
(defun QSD:ParseGia (s / p r b)
  (setq s (QSD:NormBar s))
  (if (setq p (vl-string-search "x" s))
    (progn (setq r (QSD:Num (substr s 1 p)) b (QSD:ParseBar1 (substr s (+ p 2))))
           (if (and r b (> r 0)) (list (fix (+ r 0.01)) (car b) (cadr b)) nil))
    (if (setq b (QSD:ParseBar1 s)) (list 1 (car b) (cadr b)) nil)))

;; dai "10-100/150" -> (d s1 s2) ; "10-100" -> (d s1 s1) ; "8a150" -> (8 150 150)
(defun QSD:ParseDai (s / p d rest l s1 s2)
  (setq s (strcase (QSD:Replace (QSD:Trim s) " " "") T))
  (setq s (QSD:Replace (QSD:Replace s "%%c" "") "a" "-"))
  (if (setq p (vl-string-search "-" s))
    (progn
      (setq d (QSD:Num (substr s 1 p)) rest (substr s (+ p 2)))
      (setq l (QSD:Split rest "/") s1 (QSD:Num (car l)) s2 (if (cadr l) (QSD:Num (cadr l)) s1))
      (if (and d s1 (> d 0) (> s1 0)) (list d s1 (if (and s2 (> s2 0)) s2 s1)) nil))
    nil))

;; dai gia cuong "10t10a50" -> (n d s)
(defun QSD:ParseDaiGC (s / p b sp)
  (setq s (strcase (QSD:Replace (QSD:Trim s) " " "") T))
  (if (setq p (vl-string-search "a" s))
    (progn (setq b (QSD:ParseBar1 (substr s 1 p)) sp (QSD:Num (substr s (+ p 2))))
           (if (and b sp (> sp 0)) (list (car b) (cadr b) sp) nil))
    nil))

(defun QSD:BarTxt (n d) (strcat (if (QSD:CfgB "GHISL") (itoa n) "") "%%c" (itoa d)))
(defun QSD:BarTxtN (n d) (strcat (itoa n) "%%c" (itoa d)))

;;;-----------------------------------------------------------------------------
;;; 4. SO LIEU DAM THO (giong sheet DCE_Pro_Beam)
;;;    raw = (("HEAD" . alist) ("GRID" . 20 dong x N cot))
;;;    GRID: dong 11..30, cot bat dau tu cot C (C = goi 1, D = nhip 1, E = goi 2 ...)
;;;-----------------------------------------------------------------------------
(setq *QSD-HEADKEYS*
 '("NAME" "B" "H" "NCK" "COTE" "HS" "LNGAN"            ; F2..F8
   "KGOI" "KNHIP" "NEOT" "NEOB" "NEOG" "TRUCMCN" "LECHMCN" ; J2..J8
   "DKC" "KCC" "DAIC" "DKDAIC" "KCDAIC" "GIATCD" "BTLOT"   ; N2..N8
   "TOP" "BOT"                                          ; B11, B12
   "CHOTRAI" "CHOPHAI"))                                ; QS_DAM: thep cho "KIEU|LOP|THEP|L|SOLE"

(defun QSD:RawHead (raw) (QSD:Get "HEAD" raw))
(defun QSD:RawGrid (raw) (QSD:Get "GRID" raw))
(defun QSD:H (raw k / v) (setq v (QSD:Get k (QSD:RawHead raw))) (if v (QSD:Trim v) ""))
(defun QSD:Cell (raw row col / r v)
  (setq r (nth (- row 11) (QSD:RawGrid raw)))
  (setq v (if (and r (>= col 0)) (nth col r) nil))
  (if (= (type v) 'STR) (QSD:Trim v) ""))

;; tach chuoi xdata DCE theo dau vo cuc (U+221E) - chap nhan ca dang ma \U+221E
(defun QSD:DceFields (s / c l)
  (setq s (QSD:Replace (QSD:Replace s "\\U+221E" "<<SEP>>") "\\u+221e" "<<SEP>>"))
  (setq c (vl-catch-all-apply 'chr (list 8734)))
  (if (and (= (type c) 'STR) (= (strlen c) 1)) (setq s (QSD:Replace s c "<<SEP>>")))
  (setq l (QSD:Split s "<<SEP>>"))
  (mapcar 'QSD:Trim (cdr l)))          ; bo phan truoc dau phan cach dau tien

;; noi tat ca chuoi 1000 cua 1 app xdata
(defun QSD:XdStrings (ent app / xd r)
  (setq xd (cdr (assoc -3 (entget ent (list app)))))
  (setq r nil)
  (foreach a xd
    (if (= (strcase (car a)) (strcase app))
      (foreach p (cdr a) (if (= (car p) 1000) (setq r (cons (cdr p) r))))))
  (reverse r))
(defun QSD:XdConcat (ent app) (apply 'strcat (cons "" (QSD:XdStrings ent app))))

;; block DCE (INSERT co xdata LuuThongSoChung_SYS) -> raw
(defun QSD:RawFromDce (ent / head f keys grid row s)
  (setq f (QSD:DceFields (QSD:XdConcat ent "LuuThongSoChung_SYS")))
  (if (< (length f) 3) nil
    (progn
      (setq head nil keys *QSD-HEADKEYS*)
      (foreach k keys
        (setq head (cons (cons k (if f (car f) "")) head) f (cdr f)))
      (setq grid nil row 11)
      (repeat 20
        (setq s (QSD:XdConcat ent (strcat "LuuThongSoDong" (itoa row) "_SYS")))
        (setq grid (cons (if (= s "") nil (QSD:DceFields s)) grid) row (1+ row)))
      (list (cons "HEAD" (reverse head)) (cons "GRID" (reverse grid))))))

;; raw <-> chuoi (luu vao xdata cua ten dam QS_DAM)
(defun QSD:RawSerialize (raw / h g)
  (setq h (mapcar '(lambda (k) (QSD:H raw k)) *QSD-HEADKEYS*))
  (setq g (mapcar '(lambda (r) (QSD:Join (mapcar '(lambda (x) (if (= (type x) 'STR) x "")) r) "~~"))
                  (QSD:RawGrid raw)))
  (strcat (QSD:Join h "~~") "@@" (QSD:Join g "##")))

(defun QSD:RawParse (s / p hs gs head keys grid)
  (if (setq p (vl-string-search "@@" s))
    (progn
      (setq hs (QSD:Split (substr s 1 p) "~~") gs (QSD:Split (substr s (+ p 3)) "##"))
      (setq head nil keys *QSD-HEADKEYS*)
      (foreach k keys (setq head (cons (cons k (if hs (car hs) "")) head) hs (cdr hs)))
      (setq grid (mapcar '(lambda (r) (QSD:Split r "~~")) gs))
      (while (< (length grid) 20) (setq grid (append grid (list nil))))
      (list (cons "HEAD" (reverse head)) (cons "GRID" grid)))
    nil))

;;;-----------------------------------------------------------------------------
;;; 5. DOC EXCEL (sheet DCE_Pro_Beam trong workbook dang mo)
;;;-----------------------------------------------------------------------------
(defun QSD:VarToStr (v / x)
  (setq x (if (= (type v) 'VARIANT) (vl-catch-all-apply 'vlax-variant-value (list v)) v))
  (cond ((vl-catch-all-error-p x) "")
        ((null x) "")
        ((numberp x) (QSD:NumStr x))
        ((= (type x) 'STR) (QSD:Trim (QSD:Replace x "_x000D_" "")))
        (T "")))

;; thep cho 1 dau dam: (kieu lop thanh L sole [ten dam noi]) nhu tren Excel -> "KIEU|LOP|THEP|L|SOLE|TEN"
(defun QSD:ChoStr (l / kd th so)
  (setq kd (strcase (nth 0 l)) th (strcase (nth 2 l)) so (strcase (nth 4 l)))
  (strcat (cond ((wcmatch kd "*THANG*") "THANG") ((wcmatch kd "COUP*") "COUPLER") ((wcmatch kd "KH*") "KHONG") (T ""))
          "|" (strcase (nth 1 l))
          "|" (cond ((wcmatch th "CH*") "CHAY") ((wcmatch th "TAT*") "TATCA") (T ""))
          "|" (nth 3 l)
          "|" (cond ((wcmatch so "C*") "1") ((wcmatch so "KH*") "0") (T ""))
          "|" (if (nth 5 l) (vl-string-translate "|" "/" (QSD:Trim (nth 5 l))) "")))
;; ten dam cho noi tai dau side (giu nguyen chu hoa / thuong)
(defun QSD:ChoTen (raw side / l)
  (setq l (QSD:Split (QSD:H raw (if (= side "L") "CHOTRAI" "CHOPHAI")) "|"))
  (QSD:Trim (if (nth 5 l) (nth 5 l) "")))
;; ghi chu thep cho: "THEP CHO / COUPLER [NOI DAM ten]"
(defun QSD:ChoLab (beam side kd / tn)
  (setq tn (cdr (assoc side (QSD:Get "CHOTEN" beam))))
  (strcat (if (= kd "COUPLER") "COUPLER" "TH\\U+00C9P CH\\U+1EDC")
          (if (and tn (/= tn "")) (strcat " N\\U+1ED0I D\\U+1EA6M " tn) "")))

;;; ---- sheet nhap lieu QS_DAM_V2: bo cuc o giong het DCE_Pro_Beam (doc bang bo doc DCE) + phan mo rong:
;;;      S3..S7 / T3..T7 = thep cho dau TRAI / PHAI (kieu, lop, thanh, L, so le)
;;;      Y2 = tai san (2 ben / Trai / Phai / Khong), Y3 = san lat (Khong / Co) - chi ap dung khi F7 la so
(defun QSD:QsV2Extra (raw rows / hd hs sd)
  (defun QSD:_c2 (r c) (QSD:VarToStr (nth (1- c) (nth (1- r) rows))))
  (setq hd (QSD:RawHead raw) hs (QSD:Get "HS" hd))
  (if (and (QSD:Num hs) (not (vl-string-search "/" hs)))
    (setq sd (strcase (QSD:_c2 2 25))
          hs (strcat (if (wcmatch (strcase (QSD:_c2 3 25)) "C*") "_" "") hs
                     (cond ((wcmatch sd "TR*") "/1") ((wcmatch sd "PH*") "/2") ((wcmatch sd "KH*") "/0") (T "")))
          hd (QSD:Put "HS" hs hd)))
  (setq hd (QSD:Put "CHOTRAI" (QSD:ChoStr (mapcar '(lambda (r) (QSD:_c2 r 19)) '(3 4 5 6 7 8))) hd))
  (setq hd (QSD:Put "CHOPHAI" (QSD:ChoStr (mapcar '(lambda (r) (QSD:_c2 r 20)) '(3 4 5 6 7 8))) hd))
  (QSD:Put "HEAD" hd raw))

;;; ---- sheet nhap lieu QS_DAM_V1 (ban cu): cot A = ma dong, cot D.. = Goi1, Nhip1, Goi2 ... ----
(defun QSD:QsRowMap (rows / m i k)
  (setq m nil i 1)
  (foreach r rows
    (setq k (QSD:VarToStr (car r)))
    (if (and (/= k "") (not (assoc k m))) (setq m (cons (cons k i) m)))
    (setq i (1+ i)))
  m)
(defun QSD:RawFromQsRows (rows / m head grid k row j ns lst sup w lo hs sd ch cut)
  (setq m (QSD:QsRowMap rows))
  ;; o (ma, cot 1-based)
  (defun QSD:_q (key c / i)
    (if (setq i (cdr (assoc key m))) (QSD:VarToStr (nth (1- c) (nth (1- i) rows))) ""))
  (defun QSD:_g (key) (QSD:_q key 4))
  (defun QSD:_k (key k) (QSD:_q key (+ 4 k)))          ; k = chi so cot raw (0 = goi 1)
  (defun QSD:_is (v pat) (wcmatch (strcase v) pat))
  ;; ---- thong tin chung ----
  (setq sd (QSD:_g "SAN_PHIA") hs (QSD:_g "HS"))
  (setq hs (if (= hs "") ""
             (strcat (if (QSD:_is (QSD:_g "SAN_LAT") "C*") "_" "") hs
                     (cond ((QSD:_is sd "TR*") "/1") ((QSD:_is sd "PH*") "/2") ((QSD:_is sd "KH*") "/0") (T "")))))
  (defun QSD:_cho (c)
    (QSD:ChoStr (mapcar '(lambda (k) (QSD:_q k c)) '("CHO_KIEU" "CHO_LOP" "CHO_THEP" "CHO_L" "CHO_SOLE" "CHO_TEN"))))
  (setq head
    (list (cons "NAME" (QSD:_g "NAME")) (cons "B" (QSD:_g "B")) (cons "H" (QSD:_g "H")) (cons "NCK" (QSD:_g "NCK"))
          (cons "COTE" (QSD:_g "COTE")) (cons "HS" hs) (cons "LNGAN" (QSD:_g "LNGAN"))
          (cons "KGOI" (QSD:_g "KGOI")) (cons "KNHIP" (QSD:_g "KNHIP")) (cons "NEOT" "") (cons "NEOB" "") (cons "NEOG" "") (cons "TRUCMCN" "")
          (cons "LECHMCN" (if (QSD:_is (QSD:_g "DIMTT") "C*") "LTT" ""))
          (cons "DKC" (if (QSD:_is (QSD:_g "CDO_MODE") "KH*") "" (QSD:_g "CDO_D")))
          (cons "KCC" (cond ((QSD:_is (QSD:_g "CDO_MODE") "KH*") "")
                            ((QSD:_is (QSD:_g "CDO_MODE") "LU*") (strcat "-" (QSD:_g "CDO_A")))
                            (T (QSD:_g "CDO_A"))))
          (cons "DAIC" (cond ((QSD:_is (QSD:_g "CTIE_MODE") "KH*") "NONE") ((QSD:_is (QSD:_g "CTIE_MODE") "SO*") "SO LE")
                             ((= (QSD:_g "CTIE_MODE") "") "") (T "TOAN BO")))
          (cons "DKDAIC" (QSD:_g "CTIE_D"))
          (cons "KCDAIC" (strcat (QSD:_g "CTIE_A") (if (and (/= (QSD:_g "CTIE_A") "") (QSD:_is (QSD:_g "CTIE_HUONG") "X*")) "mm" "")))
          (cons "GIATCD" "") (cons "BTLOT" (QSD:_g "BTLOT"))
          (cons "TOP" (QSD:_g "TOP")) (cons "BOT" (QSD:_g "BOT"))
          (cons "CHOTRAI" (QSD:_cho 4)) (cons "CHOPHAI" (QSD:_cho 7))))
  ;; ---- luoi goi / nhip -> dong 11..30 ----
  (setq ns 0 k 1)
  (while (and (< k 33) (QSD:Num (QSD:_k "KT" k))) (setq ns (1+ ns) k (+ k 2)))
  (defun QSD:_qc (r k / g n v c)
    (setq g (= (rem k 2) 0))
    (cond
      ((= r 11)
       (if g
         (progn
           (setq w (QSD:_k "KT" k) lo (strcase (QSD:_k "LOAIGOI" k)))
           (cond ((= w "") "")
                 ((wcmatch lo "CON*") "0")
                 ((and (wcmatch lo "DAM*") (/= (QSD:_k "HDO" k) "")) (strcat w "x" (QSD:_k "HDO" k)))
                 ((or (/= (QSD:_k "WTREN" k) "") (/= (QSD:_k "LECHTREN" k) ""))
                  (strcat w "/" (if (= (QSD:_k "WTREN" k) "") w (QSD:_k "WTREN" k)) "/"
                          (if (= (QSD:_k "LECHTREN" k) "") "0" (QSD:_k "LECHTREN" k))))
                 (T w)))
         (QSD:_k "KT" k)))
      ((= r 12) (if g (QSD:_k "DAICOT" k) (QSD:_k "BNHIP" k)))
      ((and (>= r 13) (<= r 16)) (QSD:_k (strcat "T" (itoa (- r 12))) k))
      ((and (>= r 20) (<= r 22)) (QSD:_k (strcat "B" (itoa (- 23 r))) k))
      ((= r 23) (if g (cond ((QSD:_is (QSD:_k "ANCOT" k) "*CA*") "3") ((QSD:_is (QSD:_k "ANCOT" k) "*TREN*") "1")
                            ((QSD:_is (QSD:_k "ANCOT" k) "*DUOI*") "2") (T ""))
                  (if (= (setq v (QSD:_k "DOITOP" k)) "") "" (strcat "0;" v))))
      ((= r 24) (if g (QSD:_k "DGCOT_KT" k) (if (= (setq v (QSD:_k "GIA_N" k)) "") (QSD:_g "GIA") v)))
      ((= r 25) (if g (QSD:_k "DGCOT_LECH" k) (if (= (setq v (QSD:_k "DOIBOT" k)) "") "" (strcat "0;" v))))
      ((= r 26) (if g (QSD:_k "TRUC" k) (QSD:_k "DAI" k)))
      ((= r 27) (if g (QSD:_k "LECHTRUC" k)
                  (progn (setq v (QSD:_k "DAITRONG" k) c (strcase (QSD:_k "CAT" k)))
                         (if (or (= c "") (wcmatch c "KH*")) v (if (= v "") c (strcat v "/" c))))))
      ((= r 28) (if g (QSD:_k "DGN_KT" (1+ k)) (if (QSD:_is (QSD:_k "KIEUDAI" k) "T*") "T.LINK" "")))
      ((= r 29) (if g (QSD:_k "DGN_VT" (1+ k)) (QSD:_k "DGN_GC" k)))
      ((= r 30) (if g "" (QSD:_k "VAIBO" k)))
      (T "")))
  (setq grid nil row 11)
  (repeat 20
    (setq lst nil k 0)
    (repeat 33 (setq lst (cons (if (<= k (* 2 ns)) (QSD:_qc row k) "") lst) k (1+ k)))
    (setq grid (cons (reverse lst) grid) row (1+ row)))
  (list (cons "HEAD" head) (cons "GRID" (reverse grid))))

(defun QSD:RawFromExcel ( / xl wb sh shs rng val rows cell head grid r c row keys addr qs raw)
  (setq xl (vl-catch-all-apply 'vlax-get-object (list "Excel.Application")))
  (cond
    ((or (null xl) (vl-catch-all-error-p xl))
     (QSD:Err "Khong tim thay Excel dang chay. Mo file Excel (sheet QS_DAM hoac DCE_Pro_Beam) truoc."))
    ((or (vl-catch-all-error-p (setq wb (vl-catch-all-apply 'vlax-get-property (list xl 'ActiveWorkbook))))
         (null wb))
     (QSD:Err "Excel chua mo workbook nao."))
    (T
     (setq shs (vlax-get-property wb 'Worksheets))
     ;; uu tien: sheet dang mo la sheet nhap lieu QS_DAM (o A1 = "QS_DAM...") -> doc kieu moi
     ;; qs = 1: sheet QS_DAM_V1 (ma dong o cot A) ; 2: QS_DAM_V2 (bo cuc DCE + thep cho) ; nil: DCE_Pro_Beam
     (setq sh (vlax-get-property wb 'ActiveSheet) qs nil)
     (setq rng (vl-catch-all-apply 'vlax-get-property (list sh 'Range "A1")))
     (if (not (vl-catch-all-error-p rng))
       (setq addr (strcase (QSD:VarToStr (vl-catch-all-apply 'vlax-get-property (list rng 'Value2))))
             qs (cond ((wcmatch addr "QS_DAM_V2*") 2) ((wcmatch addr "QS_DAM*") 1) (T nil))))
     (if (not qs)
       (progn
         (setq sh (vl-catch-all-apply 'vlax-get-property (list shs 'Item "DCE_Pro_Beam")))
         (if (or (vl-catch-all-error-p sh) (null sh))
           (progn (QSD:Msg "   (khong co sheet DCE_Pro_Beam -> doc sheet dang hien hanh)")
                  (setq sh (vlax-get-property wb 'ActiveSheet))))))
     (if qs (QSD:Msg (strcat "   Doc sheet nhap lieu QS_DAM" (if (= qs 2) " (V2)" " (V1)") ": " (vlax-get-property sh 'Name))))
     (setq rng (vl-catch-all-apply 'vlax-get-property (list sh 'Range (if (= qs 1) "A1:AC150" "A1:AI30"))))
     (setq val (if (vl-catch-all-error-p rng) rng (vl-catch-all-apply 'vlax-get-property (list rng 'Value2))))
     (if (vl-catch-all-error-p val)
       (QSD:Err "Khong doc duoc vung A1:AI30.")
       (progn
         (setq rows (vlax-safearray->list (vlax-variant-value val)))
         (if (= qs 1) (setq raw (QSD:RawFromQsRows rows)))
         (if (/= qs 1) (progn
         ;; cell (row col) 1-based
         (defun QSD:_cell (r c) (QSD:VarToStr (nth (1- c) (nth (1- r) rows))))
         (setq keys *QSD-HEADKEYS* head nil)
         (foreach a '((2 6) (3 6) (4 6) (5 6) (6 6) (7 6) (8 6)
                      (2 10) (3 10) (4 10) (5 10) (6 10) (7 10) (8 10)
                      (2 14) (3 14) (4 14) (5 14) (6 14) (7 14) (8 14)
                      (11 2) (12 2))
           (setq head (cons (cons (car keys) (QSD:_cell (car a) (cadr a))) head) keys (cdr keys)))
         (setq grid nil r 11)
         (repeat 20
           (setq row nil c 3)
           (repeat 33 (setq row (cons (QSD:_cell r c) row) c (1+ c)))
           (setq grid (cons (reverse row) grid) r (1+ r)))
         (setq raw (list (cons "HEAD" (reverse head)) (cons "GRID" (reverse grid))))
         (if (= qs 2) (setq raw (QSD:QsV2Extra raw rows)))))
         (vl-catch-all-apply 'vlax-release-object (list rng))
         (vl-catch-all-apply 'vlax-release-object (list sh))
         (vl-catch-all-apply 'vlax-release-object (list wb))
         (vl-catch-all-apply 'vlax-release-object (list xl))
         raw))))
  )

;;;-----------------------------------------------------------------------------
;;; 6. MO HINH DAM (tinh toan thuan, toa do TUONG DOI:
;;;    x = 0 tai mep ngoai goi 1, y = 0 tai mat tren dam, y am di xuong)
;;;
;;;  bar  = (type layer n d x1 x2 leg1 leg2 kind idx mark)
;;;         type "T"/"B"/"G"; leg < 0 = be xuong, > 0 = be len
;;;  sup  = (i xL xR w axisX axisName wTren lechTren kieu an sauDam daiCot damGiaoCot)
;;;         kieu "C" cot / "D" goi la dam / "0" console ; an 0..3 (dong 23)
;;;  span = (j xL xR Ln b catThep daiTrong tlink)
;;;-----------------------------------------------------------------------------
(defun QSD:Bar (tp lay n d x1 x2 l1 l2 kind idx) (list tp lay n d x1 x2 l1 l2 kind idx ""))
(defun QSD:BarLen (b) (+ (abs (- (nth 5 b) (nth 4 b))) (abs (nth 6 b)) (abs (nth 7 b))))
(defun QSD:HookMin (d) (max (* (QSD:CfgN "HOOKD") d) (QSD:CfgN "HOOKMIN")))
;; chieu dai be ke o dau thanh neo vao goi: horiz = doan thang nam trong goi
(defun QSD:AnchorLeg (neo d horiz) (max (- neo horiz) (QSD:HookMin d)))

;;; ---- neo (J4..J6): "40" | "10;12;14;16-30d/40d" | "10;12-300mm/18;20-400mm/500mm" | "10-500mm/12-600mm/..." ----
(defun QSD:NeoVal (s / v)
  (setq s (strcase (QSD:Trim s) T))
  (cond ((wcmatch s "*mm") (list (QSD:Num (substr s 1 (- (strlen s) 2))) "mm"))
        ((wcmatch s "*d")  (list (QSD:Num (substr s 1 (1- (strlen s)))) "d"))
        ((setq v (QSD:Num s)) (list v (if (<= v 100) "d" "mm")))
        (T nil)))
(defun QSD:ParseNeo (s / r def p ds v)
  (setq r nil def nil)
  (if (= (type s) 'STR)
    (foreach it (QSD:Split (QSD:Replace (QSD:Trim s) " " "") "/")
      (if (setq p (vl-string-search "-" it))
        (progn
          (setq ds (mapcar 'QSD:Num (QSD:Split (substr it 1 p) ";")) v (QSD:NeoVal (substr it (+ p 2))))
          (if (and v (car v)) (foreach d ds (if d (setq r (cons (cons (fix (+ d 0.01)) v) r))))))
        (if (and (setq v (QSD:NeoVal it)) (car v)) (setq def v)))))
  (list (reverse r) def))
(defun QSD:NeoGet (tbl d / p v best)
  (setq p (assoc (fix (+ d 0.01)) (car tbl)))
  (setq v (cond (p (cdr p)) ((cadr tbl) (cadr tbl)) (T nil)))
  (cond
    (v (if (= (cadr v) "d") (* (car v) d) (float (car v))))
    ((car tbl)                                   ; noi suy theo phi gan nhat (dang d-L cu)
     (setq best (car (car tbl)))
     (foreach it (car tbl) (if (< (abs (- (car it) d)) (abs (- (car best) d))) (setq best it)))
     (if (= (caddr best) "d") (* (cadr best) d) (* d (/ (cadr best) (car best)))))
    (T (* 40.0 d))))

;;; ---- he so J2 / J3: "a|b|c" "a\b\c" "a/b/c", a co the "0.3;0.25" (theo lop), "0.3+15d" ----
(defun QSD:KField (s / p)
  (setq s (strcase (QSD:Trim s) T))
  (if (setq p (vl-string-search "+" s))
    (list (QSD:NumD (substr s 1 p) 0.0) (QSD:NumD (QSD:Replace (substr s (+ p 2)) "d" "") 0.0))
    (list (QSD:NumD s 0.0) 0.0)))
(defun QSD:ParseK (s def / sep l)
  (if (or (null s) (= (QSD:Trim s) "")) (setq s def))
  (setq s (QSD:Trim s))
  (setq sep (cond ((vl-string-search "\\" s) "\\") ((vl-string-search "|" s) "|") (T "/")))
  (setq l (QSD:Split s sep))
  (list sep
        (mapcar 'QSD:KField (QSD:Split (car l) ";"))
        (if (cadr l) (QSD:KField (cadr l)) (list 0.25 0.0))
        (if (caddr l) (QSD:KField (caddr l)) (list 0.15 0.0))))
(defun QSD:KLayer (k lay) (if (<= lay (length (cadr k))) (nth (1- lay) (cadr k)) (QSD:Last (cadr k))))

;; so khoang rai: RoundUp (tuy chon) hoac lam tron gan nhat
(defun QSD:CntDiv (len sp / q)
  (setq q (/ len sp))
  (max 1 (if (QSD:CfgB "ROUNDUPSL") (QSD:Ceil (- q 1e-6)) (fix (+ q 0.5)))))

;; tam goi (khong phai truc)
(defun QSD:SupC (su) (/ (+ (nth 1 su) (nth 2 su)) 2.0))
;; (L refTrai refPhai) cua nhip j theo kieu phan cach
(defun QSD:SpanRef (sups sp sep / a b)
  (setq a (nth (car sp) sups) b (nth (1+ (car sp)) sups))
  (cond
    ((= sep "\\") (list (- (QSD:SupC b) (QSD:SupC a)) (QSD:SupC a) (QSD:SupC b)))
    ((= sep "|")  (list (- (QSD:SupC b) (QSD:SupC a)) (nth 1 sp) (nth 2 sp)))
    (T (list (nth 3 sp) (nth 1 sp) (nth 2 sp)))))

;; dong 11 goi: "300" | "0" | "220x500" (goi la dam) | "1000/220" | "1000x800/200/-400"
(defun QSD:ParseSup (s / l a w k dep)
  (setq l (QSD:Split (strcase (QSD:Replace (QSD:Trim s) " " "") T) "/"))
  (setq a (QSD:Split (car l) "x") w (QSD:NumD (car a) 0.0) k (if (<= w 0) "0" "C") dep nil)
  (if (and (cadr a) (vl-string-search "x" (car l)) (null (cadr l)) (< w 600) (QSD:Num (cadr a)) (> (QSD:Num (cadr a)) w))
    (setq k "D" dep (QSD:Num (cadr a))))
  (list (max 0.0 w) (if (cadr l) (QSD:NumD (cadr l) w) w) (if (caddr l) (QSD:NumD (caddr l) 0.0) 0.0) k dep))

;; dong 23/25 nhip: "0;5t28" | "100;25" -> (offset thep|nil dkMoi|nil)
(defun QSD:ParseStep (s / l b)
  (setq l (QSD:Split (QSD:Trim s) ";"))
  (list (QSD:NumD (car l) 0.0)
        (if (cadr l) (QSD:ParseBars (cadr l)) nil)
        (if (and (cadr l) (null (QSD:ParseBars (cadr l)))) (QSD:Num (cadr l)) nil)))

;; dai gia cuong dam giao "8d8a50" "8u8a50" "8t8a50L" -> (n d s ben)
(defun QSD:ParseGC (s / side r)
  (setq s (strcase (QSD:Trim s)))
  (setq side (cond ((wcmatch s "*L") "L") ((wcmatch s "*R") "R") (T "")))
  (if (/= side "") (setq s (substr s 1 (1- (strlen s)))))
  (setq s (vl-string-translate "DU" "TT" s))
  (if (setq r (QSD:ParseDaiGC s)) (append r (list side)) nil))

;; thep chay suot theo nhip -> cac nhom thanh (runs) ; spanBars = list theo nhip cua ((n d) ...)
(defun QSD:MainRuns (spanBars / ds cnt mx runs l j j0 sig res p)
  (setq ds nil)
  (foreach sb spanBars (foreach g sb (if (not (member (cadr g) ds)) (setq ds (append ds (list (cadr g)))))))
  (setq res nil)
  (foreach d ds
    (setq cnt (mapcar '(lambda (sb / c) (setq c 0) (foreach g sb (if (= (cadr g) d) (setq c (+ c (car g))))) c) spanBars))
    (setq mx (apply 'max cnt) runs nil l 1)
    (repeat mx
      (setq j 0 j0 nil)
      (foreach c (append cnt '(0))
        (if (>= c l) (if (null j0) (setq j0 j))
          (if j0 (progn (setq sig (list j0 (1- j)))
                        (if (setq p (assoc sig runs)) (setq runs (subst (cons sig (1+ (cdr p))) p runs))
                          (setq runs (append runs (list (cons sig 1)))))
                        (setq j0 nil))))
        (setq j (1+ j)))
      (setq l (1+ l)))
    (foreach r runs (setq res (append res (list (list (car (car r)) (cadr (car r)) (cdr r) d))))))
  res)   ; ((j0 j1 n d) ...)

;;; ---- thep cho 2 dau dam (cho thep qua zone / dot do khac) ----
;;  spec "KIEU|LOP|THEP|L|SOLE" (thieu -> lay cai dat): KIEU KHONG/THANG/COUPLER, LOP "TBG", THEP TATCA/CHAY,
;;  L "AUTO" (= L noi ngoai vung theo bang) | "40d" | "1200", SOLE 0/1
(defun QSD:ChoSpec (raw side / l k)
  (setq l (QSD:Split (strcase (QSD:H raw (if (= side "L") "CHOTRAI" "CHOPHAI"))) "|"))
  (defun QSD:_cs (i key / v) (setq v (QSD:Trim (if (nth i l) (nth i l) ""))) (if (= v "") (strcase (QSD:Cfg key)) v))
  (list (QSD:_cs 0 (if (= side "L") "CHOTRAI" "CHOPHAI")) (QSD:_cs 1 "CHOLOP") (QSD:_cs 2 "CHOTHEP")
        (QSD:_cs 3 "CHOL") (QSD:_cs 4 "CHOSOLE")))
(defun QSD:ChoLen (spec tp d / v)
  (setq v (nth 3 spec))
  (cond ((= v "AUTO") (QSD:LapLen tp d nil))
        ((wcmatch v "*D") (* (QSD:NumD (vl-string-right-trim "D" v) 40.0) d))
        (T (QSD:NumD (vl-string-right-trim "M" v) (* 40.0 d)))))
;; coupler: doan thanh keo ra ngoai mep dam (L1 L2) ; "100/300" = so le 2 nhom ; "AUTO" / trong -> cai dat CPLL
(defun QSD:CplLens (spec / v l)
  (setq v (vl-string-right-trim "M" (QSD:Trim (nth 3 spec))))
  (if (or (= v "") (= v "AUTO") (not (QSD:NumsOk v "/" 0))) (setq v (QSD:Cfg "CPLL")))
  (setq l (mapcar 'QSD:Num (QSD:Split v "/")))
  (list (max 0.0 (QSD:NumD (car l) 0.0)) (max 0.0 (QSD:NumD (if (cadr l) (cadr l) (car l)) 0.0))))
;; tra ve (bars cho) ; cho = list (side kieu tp y-lop L) de ve
(defun QSD:ApplyCho (raw bars sups ltot / out info side spec lim b tp L n nA ok a cl)
  (setq info nil)
  (foreach side '("L" "R")
    (setq spec (QSD:ChoSpec raw side) out nil)
    (if (member (car spec) '("THANG" "COUPLER"))
      (progn
        (setq lim (if (= side "L") (nth 2 (car sups)) (nth 1 (QSD:Last sups))))
        (foreach b bars
          (setq tp (nth 0 b))
          (setq ok (and (vl-string-search tp (nth 1 spec))
                        (or (= (nth 2 spec) "TATCA") (= (nth 8 b) "CHAY"))
                        (if (= side "L") (< (nth 4 b) lim) (> (nth 5 b) lim))))
          (if ok
            (progn
              (setq cl (if (= (car spec) "COUPLER") (QSD:CplLens spec) nil))
              (setq L (if cl (car cl) (QSD:ChoLen spec tp (nth 3 b))) n (nth 2 b))
              (setq info (cons (list side (car spec) tp (nth 1 b) (nth 3 b) L) info))
              (defun QSD:_mv (bb len)
                (if (= side "L")
                  (list (nth 0 bb) (nth 1 bb) (nth 2 bb) (nth 3 bb) (- len) (nth 5 bb) 0.0 (nth 7 bb) (nth 8 bb) (nth 9 bb))
                  (list (nth 0 bb) (nth 1 bb) (nth 2 bb) (nth 3 bb) (nth 4 bb) (+ ltot len) (nth 6 bb) 0.0 (nth 8 bb) (nth 9 bb))))
              (cond
                ;; coupler ra ngoai mep so le 2 nhom: ceil(n/2) thanh L1, con lai L2
                ((and cl (> n 1) (> (abs (- (cadr cl) (car cl))) 0.5))
                  (setq nA (QSD:Ceil (/ n 2.0)))
                  (setq a (QSD:_mv b (car cl)))
                  (setq out (cons (list (nth 0 a) (nth 1 a) nA (nth 3 a) (nth 4 a) (nth 5 a) (nth 6 a) (nth 7 a) (nth 8 a) (nth 9 a)) out))
                  (setq a (QSD:_mv b (cadr cl)))
                  (setq info (cons (list side "COUPLER" tp (nth 1 b) (nth 3 b) (cadr cl)) info))
                  (setq out (cons (list (nth 0 a) (nth 1 a) (- n nA) (nth 3 a) (nth 4 a) (nth 5 a) (nth 6 a) (nth 7 a) (nth 8 a) (nth 9 a)) out)))
                ((and (= (nth 4 spec) "1") (= (car spec) "THANG") (> n 1))
                (progn
                  (setq nA (QSD:Ceil (/ n 2.0)))
                  (setq a (QSD:_mv b L))
                  (setq out (cons (list (nth 0 a) (nth 1 a) nA (nth 3 a) (nth 4 a) (nth 5 a) (nth 6 a) (nth 7 a) (nth 8 a) (nth 9 a)) out))
                  (setq a (QSD:_mv b (+ L L (* (QSD:CfgN "GAPD") (nth 3 b)))))
                  (setq info (cons (list side "SOLE" tp (nth 1 b) (nth 3 b) (+ L L (* (QSD:CfgN "GAPD") (nth 3 b)))) info))
                  (setq out (cons (list (nth 0 a) (nth 1 a) (- n nA) (nth 3 a) (nth 4 a) (nth 5 a) (nth 6 a) (nth 7 a) (nth 8 a) (nth 9 a)) out))))
                (T (setq out (cons (QSD:_mv b L) out)))))
            (setq out (cons b out))))
        (setq bars (reverse out)))))
  (list bars (reverse info)))

(defun QSD:BuildBeam (raw / warn b h ltot sups spans x w ln i j ns cend neoT neoB neoG kT kB rl bars s lr ext d
                         nl nr ds cm xl xr f0 dai zones gia k segs sb off sz lst w0 wl kd dd n1 n2 lz sp su
                         hsraw hs sides inv nck cutall sd sp2 cur spanBarsT spanBarsB st ref refs L1 a1 ex
                         sizes poss gcs hng hangers cuts inner tl cols cdo ctie lot ltt dk p q stepwarn cho)
  (setq warn nil)
  (if (vl-string-search "/" (QSD:H raw "B")) (setq warn (cons "CHUA HO TRO: mong bang (F3/F4 dang a/b/c) -> lay so dau" warn)))
  (setq b (QSD:NumD (car (QSD:Split (QSD:H raw "B") "/")) 0.0) h (QSD:NumD (car (QSD:Split (QSD:H raw "H") "/")) 0.0))
  (if (or (<= b 0) (<= h 0)) (setq warn (cons "LOI: thieu b / h dam" warn)))
  ;; ---- F5 so cau kien "1/T/B" ----
  (setq l (QSD:Split (strcase (QSD:H raw "NCK")) "/"))
  (setq nck (max 1 (fix (QSD:NumD (car l) 1.0))) cutall (cdr l))
  ;; ---- F7 san: "150" "150/0" "150/1" "150/2" "_150" ----
  (setq hsraw (QSD:H raw "HS") inv (wcmatch hsraw "_*"))
  (if inv (setq hsraw (substr hsraw 2)))
  (setq l (QSD:Split hsraw "/") hs (QSD:NumD (car l) 0.0)
        sides (cond ((null (cadr l)) 3) ((= (cadr l) "0") 0) ((= (cadr l) "1") 1) ((= (cadr l) "2") 2) (T 3)))
  ;; ---- goi / nhip ----
  (setq sups nil spans nil x 0.0 i 0 ns 0)
  (while (and (setq ln (QSD:Num (QSD:Cell raw 11 (1+ (* 2 i))))) (> ln 0)) (setq ns (1+ ns) i (1+ i)))
  (if (= ns 0) (setq warn (cons "LOI: dong 11 khong co chieu dai nhip" warn)))
  (setq i 0)
  (repeat (1+ ns)
    (setq su (QSD:ParseSup (QSD:Cell raw 11 (* 2 i))) w (car su))
    (setq sz (QSD:Split (strcase (QSD:Replace (QSD:Cell raw 24 (* 2 i)) " " "") T) "x"))
    (setq sups (cons (list i x (+ x w) w
                           (+ x (/ w 2.0) (QSD:NumD (QSD:Cell raw 27 (* 2 i)) 0.0))
                           (QSD:LastLine (QSD:Cell raw 26 (* 2 i)))
                           (cadr su) (caddr su) (nth 3 su)
                           (fix (QSD:NumD (QSD:Cell raw 23 (* 2 i)) 0.0)) (nth 4 su)
                           (QSD:Cell raw 12 (* 2 i))
                           (if (and (= (length sz) 2) (QSD:Num (car sz)) (QSD:Num (cadr sz)))
                             (list (QSD:Num (car sz)) (QSD:Num (cadr sz)) (QSD:NumD (QSD:Cell raw 25 (* 2 i)) 0.0)) nil))
                     sups))
    (setq x (+ x w))
    (if (< i ns)
      (progn
        (setq ln (QSD:Num (QSD:Cell raw 11 (1+ (* 2 i)))))
        ;; dong 27 nhip: dai trong "6-100/200" va/hoac cat thep "T" "B" "TL" "TR" "BL" "BR"
        (setq cuts nil inner nil l nil)
        (foreach t1 (QSD:Split (strcase (QSD:Cell raw 27 (1+ (* 2 i)))) "/")
          (if (member t1 '("T" "B" "TL" "TR" "BL" "BR")) (setq cuts (cons t1 cuts))
            (if (/= t1 "") (setq l (append l (list t1))))))
        (if l (setq inner (QSD:ParseDai (QSD:Join l "/"))))
        (foreach c cutall (if (member c '("T" "B")) (setq cuts (cons c cuts))))
        (setq spans (cons (list i x (+ x ln) ln (QSD:NumD (QSD:Cell raw 12 (1+ (* 2 i))) b) cuts inner
                                (wcmatch (strcase (QSD:Cell raw 28 (1+ (* 2 i)))) "T.LINK*"))
                          spans))
        (setq x (+ x ln))))
    (setq i (1+ i)))
  (setq sups (reverse sups) spans (reverse spans) ltot x)
  (setq cend (QSD:CfgN "CEND") rl (QSD:CfgN "ROUNDL"))
  (setq neoT (QSD:ParseNeo (if (/= (QSD:H raw "NEOT") "") (QSD:H raw "NEOT") (QSD:Cfg "NEOT"))))
  (setq neoB (QSD:ParseNeo (if (/= (QSD:H raw "NEOB") "") (QSD:H raw "NEOB") (QSD:Cfg "NEOB"))))
  (setq neoG (QSD:ParseNeo (if (/= (QSD:H raw "NEOG") "") (QSD:H raw "NEOG") (QSD:Cfg "NEOG"))))
  (setq kT (QSD:ParseK (QSD:H raw "KGOI") (QSD:Cfg "KGOI")) kB (QSD:ParseK (QSD:H raw "KNHIP") (QSD:Cfg "KNHIP")))
  (setq w0 (if sups (nth 3 (car sups)) 0.0) wl (if sups (nth 3 (QSD:Last sups)) 0.0))
  (setq bars nil)
  ;; ham kep 2 dau thanh vao dam, tu them be ke neo o goi bien
  ;; dau thanh neo trong goi: lui vao theo lop (lop1 = CEND, moi lop +DLVE, thep duoi +25) giong DCE
  (defun QSD:_eo (tp lay) (+ cend (* (1- lay) (QSD:CfgN "DLVE")) (if (= tp "B") 25.0 0.0)))
  (defun QSD:_clamp (tp lay n d x1 x2 l1 l2 kind idx tbl sg / eo)
    (setq eo (QSD:_eo tp lay))
    (if (<= x1 eo) (setq x1 eo l1 (* sg (QSD:AnchorLeg (QSD:NeoGet tbl d) d (max 0.0 (- w0 eo))))))
    (if (>= x2 (- ltot eo)) (setq x2 (- ltot eo) l2 (* sg (QSD:AnchorLeg (QSD:NeoGet tbl d) d (max 0.0 (- wl eo))))))
    (if (> (- x2 x1) 1.0)
      (setq bars (cons (QSD:Bar tp lay n d x1 x2 l1 l2 kind idx) bars))))
  (defun QSD:_ext (kf L d) (+ (* (car kf) L) (* (cadr kf) d)))
  (if (> ns 0)
   (progn
  ;; ---- thep chay suot tren / duoi, doi thep theo nhip (dong 23 / 25 cot nhip) ----
  (foreach tp '("T" "B")
    (setq cur (QSD:ParseBars (QSD:H raw (if (= tp "T") "TOP" "BOT"))) lst nil)
    (if (null cur) (setq warn (cons (strcat "Canh bao: khong co thep chay suot " (if (= tp "T") "TREN (B11)" "DUOI (B12)")) warn)))
    (if (and (= tp "B") (or (vl-string-search "/" (QSD:H raw "BOT")) (vl-string-search "\\" (QSD:H raw "BOT"))))
      (setq warn (cons "CHUA HO TRO: B12 dang mong bang" warn)))
    (foreach sp spans
      (setq s (QSD:Cell raw (if (= tp "T") 23 25) (1+ (* 2 (car sp)))))
      (if (/= s "")
        (progn
          (setq st (QSD:ParseStep s))
          (if (/= (car st) 0.0)
            (setq warn (cons (strcat "CHUA HO TRO: giat " (if (= tp "T") "mep tren" "mep duoi") " nhip " (itoa (1+ (car sp)))
                                     " = " (QSD:NumStr (car st)) " -> ve phang, chi doi thep") warn)))
          (cond ((cadr st) (setq cur (cadr st)))
                ((caddr st) (setq cur (mapcar '(lambda (g) (list (car g) (fix (+ 0.01 (caddr st))))) cur))))))
      (setq lst (append lst (list cur))))
    (foreach r (QSD:MainRuns lst)
      ;; r = (j0 j1 n d)
      (setq d (nth 3 r) j (car r) k (cadr r))
      (setq xl (if (= j 0) 0.0 (+ (nth 1 (nth j sups)) (QSD:_eo tp 1)))
            xr (if (= k (1- ns)) ltot (- (nth 2 (nth (1+ k) sups)) (QSD:_eo tp 1))))
      (QSD:_clamp tp 1 (nth 2 r) d xl xr
                  (if (= j 0) 0.0 (* (if (= tp "T") -1.0 1.0) (QSD:AnchorLeg (QSD:NeoGet (if (= tp "T") neoT neoB) d) d (- (nth 2 (nth j sups)) xl))))
                  (if (= k (1- ns)) 0.0 (* (if (= tp "T") -1.0 1.0) (QSD:AnchorLeg (QSD:NeoGet (if (= tp "T") neoT neoB) d) d (- xr (nth 1 (nth (1+ k) sups))))))
                  "CHAY" j (if (= tp "T") neoT neoB) (if (= tp "T") -1.0 1.0))))
  ;; ---- thep tang cuong TREN tai GOI: dong 13..17 cot goi (J2 a, theo lop) ----
  (foreach sp sups
    (setq i (car sp) k 1)
    (repeat 5
      (setq s (QSD:Cell raw (+ 12 k) (* 2 i)))
      (if (and (/= s "") (/= s "-"))
        (progn
          (setq lr (QSD:ParseLR s))
          (cond ((= i 0)  (setq lr (list nil (cadr lr))))
                ((= i ns) (setq lr (list (car lr) nil))))
          (setq ds nil)
          (foreach t1 (append (car lr) (cadr lr)) (if (not (member (cadr t1) ds)) (setq ds (cons (cadr t1) ds))))
          (foreach d (reverse ds)
            (setq nl 0 nr 0)
            (foreach t1 (car lr)  (if (= (cadr t1) d) (setq nl (+ nl (car t1)))))
            (foreach t1 (cadr lr) (if (= (cadr t1) d) (setq nr (+ nr (car t1)))))
            (setq xl (if (> i 0) (progn (setq ref (QSD:SpanRef sups (nth (1- i) spans) (car kT)))
                                        (QSD:RoundDn (- (caddr ref) (QSD:_ext (QSD:KLayer kT k) (car ref) d)) rl)) 0.0))
            (setq xr (if (< i ns) (progn (setq ref (QSD:SpanRef sups (nth i spans) (car kT)))
                                         (QSD:RoundUp (+ (cadr ref) (QSD:_ext (QSD:KLayer kT k) (car ref) d)) rl)) ltot))
            (setq cm (if (and (> nl 0) (> nr 0)) (min nl nr) 0))
            (if (> cm 0) (QSD:_clamp "T" k cm d xl xr 0.0 0.0 "GOI" i neoT -1.0))
            ;; thanh chi 1 ben: xuyen qua goi, be xuong neo tai mep goi phia kia (giong DCE)
            (if (> (- nl cm) 0)
              (progn (setq x (- (nth 2 sp) (QSD:_eo "T" k)))
                     (QSD:_clamp "T" k (- nl cm) d xl x 0.0 (- (QSD:AnchorLeg (QSD:NeoGet neoT d) d (- x (nth 1 sp)))) "GOI" i neoT -1.0)))
            (if (> (- nr cm) 0)
              (progn (setq x (+ (nth 1 sp) (QSD:_eo "T" k)))
                     (QSD:_clamp "T" k (- nr cm) d x xr (- (QSD:AnchorLeg (QSD:NeoGet neoT d) d (- (nth 2 sp) x))) 0.0 "GOI" i neoT -1.0))))))
      (setq k (1+ k))))
  ;; ---- thep tang cuong TREN o BUNG nhip: dong 13..17 cot nhip (J2 c) ----
  (foreach sp spans
    (setq j (car sp) k 1)
    (repeat 5
      (setq s (QSD:Cell raw (+ 12 k) (1+ (* 2 j))))
      (if (and (/= s "") (/= s "-"))
        (foreach t1 (QSD:ParseBars (car (QSD:Split s ";")))
          (setq ref (QSD:SpanRef sups sp (car kT)) ex (QSD:_ext (nth 3 kT) (car ref) (cadr t1)))
          (QSD:_clamp "T" k (car t1) (cadr t1) (QSD:RoundDn (+ (cadr ref) ex) rl) (QSD:RoundUp (- (caddr ref) ex) rl)
                      0.0 0.0 "NHIP" j neoT -1.0)))
      (setq k (1+ k))))
  ;; ---- thep tang cuong DUOI o BUNG nhip: dong 22 = lop1 ... 18 = lop5, cot nhip (J3 a ; nhip dau/cuoi J3 c) ----
  (foreach sp spans
    (setq j (car sp) k 1)
    (repeat 5
      (setq s (QSD:Cell raw (- 23 k) (1+ (* 2 j))))
      (if (and (/= s "") (/= s "-"))
        (foreach t1 (QSD:ParseBars (car (QSD:Split s ";")))
          (setq ref (QSD:SpanRef sups sp (car kB)) d (cadr t1))
          (setq xl (+ (cadr ref) (if (= j 0) (QSD:_ext (nth 3 kB) (car ref) d) (QSD:_ext (car (cadr kB)) (car ref) d))))
          (setq xr (- (caddr ref) (if (= j (1- ns)) (QSD:_ext (nth 3 kB) (car ref) d) (QSD:_ext (car (cadr kB)) (car ref) d))))
          (setq xl (QSD:RoundDn xl rl) xr (QSD:RoundUp xr rl))
          (if (> (- xr xl) (* 2 rl))
            (QSD:_clamp "B" k (car t1) d xl xr 0.0 0.0 "NHIP" j neoB 1.0)
            (setq warn (cons (strcat "Canh bao: nhip " (itoa (1+ j)) " lop " (itoa k) " qua ngan, bo qua " s) warn)))))
      (setq k (1+ k))))
  ;; ---- thep tang cuong DUOI tai GOI: dong 22..18 cot goi (J3 b) ----
  (foreach sp sups
    (setq i (car sp) k 1)
    (repeat 5
      (setq s (QSD:Cell raw (- 23 k) (* 2 i)))
      (if (and (/= s "") (/= s "-"))
        (foreach t1 (QSD:ParseBars (car (QSD:Split s ";")))
          (setq d (cadr t1))
          (setq xl (if (> i 0) (progn (setq ref (QSD:SpanRef sups (nth (1- i) spans) (car kB)))
                                      (QSD:RoundDn (- (caddr ref) (QSD:_ext (caddr kB) (car ref) d)) rl)) 0.0))
          (setq xr (if (< i ns) (progn (setq ref (QSD:SpanRef sups (nth i spans) (car kB)))
                                       (QSD:RoundUp (+ (cadr ref) (QSD:_ext (caddr kB) (car ref) d)) rl)) ltot))
          (QSD:_clamp "B" k (car t1) d xl xr 0.0 0.0 "GOI" i neoB 1.0)))
      (setq k (1+ k))))
  ;; ---- thep gia (dong 24, cot nhip): "2x2t12" | "4f12" (= 2 lop x 2) ; gop nhip lien tiep ----
  (setq segs nil)
  (foreach sp spans
    (setq s (QSD:Cell raw 24 (1+ (* 2 (car sp)))) gia (QSD:ParseGia s))
    (if (and gia (= (car gia) 1) (not (vl-string-search "x" (strcase s T))) (> (cadr gia) 2) (= (rem (cadr gia) 2) 0))
      (setq gia (list (/ (cadr gia) 2) 2 (caddr gia))))
    (if (and gia (not (vl-string-search "x" (strcase s T))) (= (cadr gia) 2) (= (car gia) 1)) (setq gia (list 1 2 (caddr gia))))
    (if gia
      (if (and segs (equal (car (car segs)) gia) (= (nth 2 (car segs)) (1- (car sp))))
        (setq segs (cons (list gia (nth 1 (car segs)) (car sp)) (cdr segs)))
        (setq segs (cons (list gia (car sp) (car sp)) segs)))))
  (foreach sg (reverse segs)
    (setq gia (car sg) d (nth 2 gia) k 1)
    (repeat (car gia)
      (QSD:_clamp "G" k (cadr gia) d
                (- (nth 1 (nth (nth 1 sg) spans)) (QSD:NeoGet neoG d))
                (+ (nth 2 (nth (nth 2 sg) spans)) (QSD:NeoGet neoG d))
                0.0 0.0 "GIA" (nth 1 sg) neoG -1.0)
      (setq k (1+ k))))
  ;; ---- dai theo nhip (dong 26 cot nhip) ; vung dai day = J2 b (he so x L hoac mm) ; dam ngan F8 ----
  (setq zones nil dd (QSD:CfgN "DAIDAU"))
  (foreach sp spans
    (setq j (car sp) dai (QSD:ParseDai (QSD:Cell raw 26 (1+ (* 2 j)))))
    (if dai
      (progn
        (setq xl (+ (nth 1 sp) dd) xr (- (nth 2 sp) dd) ln (- xr xl))
        (setq ref (QSD:SpanRef sups sp (car kT)))
        (setq lz (if (> (car (caddr kT)) 1.0) (car (caddr kT)) (* (car (caddr kT)) (car ref))))
        (setq a1 (QSD:RoundUp (+ (cadr ref) lz) rl) L1 (QSD:RoundDn (- (caddr ref) lz) rl))
        (if (or (equal (nth 1 dai) (nth 2 dai) 1e-6)
                (< (nth 3 sp) (* 1000.0 (QSD:NumD (QSD:H raw "LNGAN") 0.0)))
                (>= (+ a1 (nth 2 dai)) L1))
          (progn
            (setq n1 (1+ (QSD:CntDiv ln (nth 1 dai))))
            (setq zones (cons (list j (car dai) (nth 1 dai) (nth 1 sp) (nth 2 sp) xl xr (max 2 n1)) zones)))
          (progn
            (setq n1 (1+ (QSD:CntDiv (- a1 xl) (nth 1 dai))))
            (setq n2 (max 0 (1- (QSD:CntDiv (- L1 a1) (nth 2 dai)))))
            (setq zones (cons (list j (car dai) (nth 1 dai) (nth 1 sp) a1 xl a1 n1) zones))
            (if (> n2 0)
              (setq zones (cons (list j (car dai) (nth 2 dai) a1 L1 (+ a1 (nth 2 dai)) (- L1 (nth 2 dai)) n2) zones)))
            (setq n1 (1+ (QSD:CntDiv (- xr L1) (nth 1 dai))))
            (setq zones (cons (list j (car dai) (nth 1 dai) L1 (nth 2 sp) L1 xr n1) zones)))))
      (if (/= (QSD:Cell raw 26 (1+ (* 2 j))) "")
        (setq warn (cons (strcat "Canh bao: khong doc duoc dai nhip " (itoa (1+ j)) ": " (QSD:Cell raw 26 (1+ (* 2 j)))) warn)))))
  ;; ---- dam giao trong nhip (dong 28/29 cot goi i -> nhip i, nhieu dam "a/b") + vai bo (dong 30) ----
  (setq sb nil hangers nil)
  (foreach sp spans
    (setq j (car sp))
    (setq sizes (QSD:Split (strcase (QSD:Replace (QSD:Cell raw 28 (* 2 j)) " " "") T) "/")
          poss (mapcar 'QSD:Num (QSD:Split (QSD:Cell raw 29 (* 2 j)) "/"))
          gcs (mapcar 'QSD:ParseGC (QSD:Split (QSD:Cell raw 29 (1+ (* 2 j))) "/"))
          hng (QSD:ParseBars (QSD:Cell raw 30 (1+ (* 2 j)))) k 0)
    (foreach off poss
      (setq sz (QSD:Split (if (nth k sizes) (nth k sizes) (QSD:Last sizes)) "x"))
      (if (and off (QSD:Num (car sz)))
        (progn
          (setq x (+ (QSD:SupC (nth j sups)) off))
          (if (and (> x (nth 1 sp)) (< x (nth 2 sp)))
            (progn
              (setq sb (cons (list j x (QSD:Num (car sz)) (if (QSD:Num (cadr sz)) (QSD:Num (cadr sz)) h)
                                   (if (nth k gcs) (nth k gcs) (QSD:Last gcs))) sb))
              (foreach hg hng (setq hangers (cons (list j x (QSD:Num (car sz)) (car hg) (cadr hg)) hangers))))
            (setq warn (cons (strcat "Canh bao: dam giao nhip " (itoa (1+ j)) " nam ngoai nhip, bo qua") warn)))))
      (setq k (1+ k))))
  ;; ---- dai trong cot (dong 12 cot goi): "200" | "+200" ----
  (setq cols nil)
  (foreach su sups
    (if (and (> (nth 3 su) 0) (QSD:Num (vl-string-trim "+" (nth 11 su))))
      (setq cols (cons (list (car su) (QSD:Num (vl-string-trim "+" (nth 11 su))) (wcmatch (nth 11 su) "+*")) cols))))
   ))
  ;; ---- thep C do lop tang cuong (N2/N3), dai C noi thep gia (N4..N6), BT lot (N8), J8 ----
  (setq s (strcase (QSD:H raw "KCC") T))
  (setq cdo (list (QSD:Num (QSD:H raw "DKC"))
                  (abs (QSD:NumD (QSD:Replace s "mm" "") 0.0))
                  (cond ((wcmatch s "*mm") "MM") ((> (QSD:NumD s 0.0) 0) "AUTO") ((< (QSD:NumD s 0.0) 0) "LUON") (T "KHONG"))))
  (setq s (strcase (QSD:H raw "KCDAIC") T))
  (setq ctie (list (QSD:H raw "DAIC") (QSD:Num (QSD:H raw "DKDAIC"))
                   (QSD:Num (car (QSD:Split (QSD:Replace s "mm" "") "/"))) (wcmatch s "*mm")))
  (setq l (QSD:Split (QSD:H raw "BTLOT") "/"))
  (setq lot (if (QSD:Num (car l)) (list (QSD:Num (car l)) (QSD:NumD (cadr l) 0.0)) nil))
  (setq ltt (vl-string-search "LTT" (strcase (QSD:H raw "LECHMCN"))))
  ;; ---- thep cho 2 dau dam ----
  (setq cho (QSD:ApplyCho raw (reverse bars) sups ltot) bars (reverse (car cho)) cho (cadr cho))
  ;; ---- danh so hieu thep ----
  (setq bars (reverse bars) i 1 lst nil)
  (foreach bb bars
    (setq lst (cons (append (QSD:Take bb 10) (list (itoa i))) lst) i (1+ i)))
  (list (cons "RAW" raw) (cons "NAME" (QSD:H raw "NAME")) (cons "B" b) (cons "H" h) (cons "NCK" nck)
        (cons "HS" hs) (cons "SLABSIDE" sides) (cons "SLABINV" inv) (cons "COTE" (QSD:H raw "COTE"))
        (cons "L" ltot) (cons "SUPS" sups) (cons "SPANS" spans) (cons "BARS" (reverse lst))
        (cons "ZONES" (reverse zones)) (cons "SB" (reverse sb)) (cons "HANGERS" (reverse hangers))
        (cons "COLSTIR" cols) (cons "CDO" cdo) (cons "CTIE" ctie) (cons "LOT" lot) (cons "LTT" ltt)
        (cons "KT" kT) (cons "KB" kB) (cons "CHO" cho)
        (cons "CHOTEN" (list (cons "L" (QSD:ChoTen raw "L")) (cons "R" (QSD:ChoTen raw "R"))))
        (cons "WARN" (reverse warn))))

;; bo rong dam tai vi tri x (dong 12 cot nhip)
(defun QSD:WidthAt (beam x / r)
  (setq r (QSD:Get "B" beam))
  (foreach sp (QSD:Get "SPANS" beam) (if (and (>= x (nth 1 sp)) (<= x (nth 2 sp))) (setq r (nth 4 sp))))
  r)

;;;-----------------------------------------------------------------------------
;;; 7. HAM VE CO BAN (entmake - chay duoc tren AutoCAD va ZWCAD)
;;;    Quy cach trinh bay theo dung ban ve DCE mau (dam.dwg):
;;;    layer / mau / net / block tag / dim / ky hieu mat cat / cao do.
;;;-----------------------------------------------------------------------------
(defun QSD:Doc () (vla-get-ActiveDocument (vlax-get-acad-object)))
(defun QSD:MSpace () (vla-get-ModelSpace (QSD:Doc)))
(defun QSD:P (x y) (list (+ *QSD-BX* x) (+ *QSD-BY* y) 0.0))
(defun QSD:P2 (x y) (list (+ *QSD-BX* x) (+ *QSD-BY* y)))
(defun QSD:TL () (QSD:CfgN "TLDOC"))
(defun QSD:TN () (QSD:CfgN "TLNGANG"))
(defun QSD:TH () (* 2.5 (QSD:TL)))

;; linetype giong DCE (tu tao neu chua co, khong can file .lin)
(defun QSD:MkLtype (name desc total dashes / dl)
  (if (not (tblsearch "LTYPE" name))
    (progn
      (setq dl (list '(0 . "LTYPE") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLinetypeTableRecord")
                     (cons 2 name) '(70 . 0) (cons 3 desc) '(72 . 65) (cons 73 (length dashes)) (cons 40 total)))
      (foreach d dashes (setq dl (append dl (list (cons 49 d) '(74 . 0)))))
      (entmake dl)))
  (tblsearch "LTYPE" name))

(defun QSD:MkLayer (name col lt lw / )
  (if (not (tblsearch "LAYER" name))
    (entmake (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbLayerTableRecord")
                   (cons 2 name) '(70 . 0) (cons 62 col)
                   (cons 6 (if (and lt (tblsearch "LTYPE" lt)) lt "Continuous"))
                   (cons 370 lw))))
  name)

;;; ---- dinh nghia block (hinh hoc chep tu block DCE; neu ban ve da co block cung ten thi dung lai) ----
(defun QSD:AttDef (tag def x y h just col / j72 j74)
  (setq j72 (cond ((= just "C") 1) ((= just "R") 2) ((= just "M") 1) (T 0)) j74 (if (= just "M") 2 0))
  (list '(0 . "ATTDEF") '(8 . "0") (cons 10 (list x y 0.0)) (cons 40 h) (cons 1 def) (cons 3 tag) (cons 2 tag)
        '(70 . 0) '(7 . "Dce_Text") '(41 . 0.7) (cons 62 col) (cons 72 j72) (cons 11 (list x y 0.0)) (cons 74 j74)))
(defun QSD:BCircle (x y r) (list '(0 . "CIRCLE") '(8 . "0") '(62 . 0) (cons 10 (list x y 0.0)) (cons 40 r)))
(defun QSD:BLine (x1 y1 x2 y2 col) (list '(0 . "LINE") '(8 . "0") (cons 62 col) (cons 10 (list x1 y1 0.0)) (cons 11 (list x2 y2 0.0))))
(defun QSD:BSolid (p1 p2 p3 col)
  (list '(0 . "SOLID") '(8 . "0") (cons 62 col) (cons 10 p1) (cons 11 p2) (cons 12 p3) (cons 13 p3)))

(defun QSD:MkBlock (name ents / )
  (if (not (tblsearch "BLOCK" name))
    (progn
      (entmake (list '(0 . "BLOCK") (cons 2 name) '(70 . 2) '(10 0.0 0.0 0.0)))
      (foreach e ents (entmake e))
      (entmake '((0 . "ENDBLK")))))
  name)

(defun QSD:MkBlocks ( / )
  (QSD:MkBlock "Dce_KhtMcThepChu"
    (list (QSD:BCircle -2.5 0.0 2.5)
          (QSD:AttDef "SH" "NN" -2.64 -1.0 2.5 "C" 11)
          (QSD:AttDef "DKVAKC" "555a333" 0.54 1.0 2.5 "L" 3)
          (QSD:AttDef "DKVAKC2" "" 2.54 -3.5 2.5 "L" 3)))
  (QSD:MkBlock "Dce_KhtMcThepTangCuong"
    (list (QSD:BCircle 2.5 0.0 2.5)
          (QSD:AttDef "SH" "NN" 2.46 -1.0 2.5 "C" 11)
          (QSD:AttDef "DKVAKC" "555a333" -0.25 1.0 2.5 "R" 3)
          (QSD:AttDef "DKVAKC2" "" -2.25 -3.5 2.5 "R" 3)))
  (QSD:MkBlock "Dce_KhtThepDai"
    (list (QSD:BCircle -5.6 -3.5 2.5)
          (QSD:AttDef "SH" "NN" -5.73 -4.5 2.5 "C" 11)
          (QSD:AttDef "DKVAKC" "555a333" -2.56 -4.5 2.5 "L" 3)
          (QSD:AttDef "VITRI" "" 15.57 -4.5 2.5 "C" 11)))
  (QSD:MkBlock "Dce_KhtThepDai2"
    (list (QSD:BCircle -7.6 -3.5 2.5)
          (QSD:AttDef "SH" "NN" -7.73 -4.5 2.5 "C" 11)
          (QSD:AttDef "DKVAKC" "555a333" -4.56 -4.5 2.5 "L" 3)
          (QSD:AttDef "VITRI" "" 12.83 -4.5 2.5 "C" 11)))
  (QSD:MkBlock "Dce_KhTenTruc"
    (list (list '(0 . "CIRCLE") '(8 . "0") '(62 . 8) '(10 0.0 -3.5 0.0) '(40 . 2.5))
          (QSD:BLine 0.0 0.0 0.0 -1.0 8) (QSD:BLine 0.0 -6.0 0.0 -7.0 8)
          (QSD:BLine 2.5 -3.5 3.5 -3.5 8) (QSD:BLine -3.5 -3.5 -2.5 -3.5 8)
          (QSD:AttDef "TRUC" "AA" 0.0 -4.5 2.5 "C" 11)))
  (QSD:MkBlock "Dce_KhTenDam"
    (list (QSD:AttDef "TENDAM" "SECTION 1" 0.0 0.74 2.5 "C" 2)
          (QSD:AttDef "TL" "SCALE 1 : " 0.0 -2.0 1.25 "C" 3)))
  (QSD:MkBlock "Dce_KhMatCat"
    (list (QSD:AttDef "TENMATCAT" "SECTION 1" 0.0 0.74 2.5 "C" 2)
          (QSD:AttDef "TL" "SCALE 1 : " 0.0 -2.0 1.25 "C" 3)))
  (QSD:MkBlock "Dce_CaoTrinh"
    (list (QSD:BLine -11.56 6.69 -11.56 0.0 8)
          (QSD:BLine -13.15 3.14 -0.09 3.14 8)
          (QSD:BLine 0.0 0.0 -13.2 0.0 8)
          (QSD:BLine -11.56 0.0 -9.95 1.6 8) (QSD:BLine -9.95 1.6 -11.56 1.6 8)
          (QSD:BSolid '(-11.56 0.0 0.0) '(-13.17 1.6 0.0) '(-11.56 1.6 0.0) 8)
          (QSD:AttDef "CT" "%%p0.000" -10.15 4.07 2.5 "L" 3)))
  (QSD:MkBlock "DCE_MatCatA"
    (list (QSD:BSolid '(0.0 5.5 0.0) '(1.18 2.75 0.0) '(0.0 0.0 0.0) 3)
          (QSD:BLine 0.0 5.5 0.0 0.0 3)
          (QSD:AttDef "1" "NN" -2.33 1.7 2.5 "C" 11)))
  (QSD:MkBlock "Dce_KhtMcThepTangCuongLoai2"
    (list (QSD:BCircle 2.5 0.0 2.5)
          (QSD:AttDef "SH" "NN" 2.5 -1.0 2.5 "C" 11)
          (QSD:AttDef "DKVAKC" "555a333" -0.5 -1.0 2.5 "R" 3)))
  (QSD:MkBlock "Dce_McThepChu"
    (list (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(8 . "0") '(62 . 0) '(100 . "AcDbPolyline")
                '(90 . 2) '(70 . 1) '(43 . 0.0833) '(10 -0.5 0.0) '(42 . 1.0) '(10 0.5 0.0) '(42 . 1.0))
          (QSD:BLine -0.35 0.35 0.35 -0.35 0) (QSD:BLine 0.35 0.35 -0.35 -0.35 0)
          (QSD:BLine -0.5 0.0 0.5 0.0 0) (QSD:BLine 0.0 0.5 0.0 -0.5 0)))
  (princ))

;; kieu dim giong Dce_xxMV (tao bang dim tam + CopyFrom; loi -> dung override tren tung dim)
(defun QSD:DimStyleName (sc) (strcat "Dce_" (itoa (fix (+ sc 0.5))) "MV"))
(defun QSD:DimOverride (o sc)
  (foreach pr (list (list 'vla-put-ScaleFactor sc) (list 'vla-put-TextHeight 2.5) (list 'vla-put-ArrowheadSize 1.5)
                    (list 'vla-put-Arrowhead1Type 4) (list 'vla-put-Arrowhead2Type 4)
                    (list 'vla-put-ExtensionLineExtend 1.0) (list 'vla-put-ExtensionLineOffset 2.0)
                    (list 'vla-put-TextGap 1.0) (list 'vla-put-PrimaryUnitsPrecision 0)
                    (list 'vla-put-VerticalTextPosition 1) (list 'vla-put-TextInsideAlign :vlax-false)
                    (list 'vla-put-TextOutsideAlign :vlax-false) (list 'vla-put-TextColor 3)
                    (list 'vla-put-DimensionLineColor 8) (list 'vla-put-ExtensionLineColor 8)
                    (list 'vla-put-TextStyle "Dce_Text") (list 'vla-put-Fit 3))
    (vl-catch-all-apply (car pr) (list o (cadr pr)))))

(defun QSD:EnsureDimStyle (sc / nm ms o st)
  (setq nm (QSD:DimStyleName sc))
  (if (not (tblsearch "DIMSTYLE" nm))
    (progn
      (setq ms (QSD:MSpace))
      (setq o (vl-catch-all-apply 'vla-AddDimRotated
                (list ms (vlax-3d-point '(0.0 0.0 0.0)) (vlax-3d-point '(1000.0 0.0 0.0)) (vlax-3d-point '(0.0 500.0 0.0)) 0.0)))
      (if (not (vl-catch-all-error-p o))
        (progn
          (QSD:DimOverride o sc)
          (setq st (vl-catch-all-apply 'vla-Add (list (vla-get-DimStyles (QSD:Doc)) nm)))
          (if (not (vl-catch-all-error-p st)) (vl-catch-all-apply 'vla-CopyFrom (list st o)))
          (vl-catch-all-apply 'vla-Delete (list o))))))
  nm)

(defun QSD:Setup ( / tl tn)
  (QSD:MkLtype "DASHDOT2_DBIM" "Dash dot (.5x) _._._._._._." 12.7 '(6.35 -3.175 0.0 -3.175))
  (QSD:MkLtype "HIDDEN_DBIM" "Hidden __ __ __ __" 2.3807 '(1.587 -0.7937))
  (QSD:MkLayer "QS_BaoBeTong" 4 nil 18)
  (QSD:MkLayer "QS_ThepChu" 1 nil 35)
  (QSD:MkLayer "QS_ThepDai" 32 nil 25)
  (QSD:MkLayer "QS_Dim" 8 nil 9)
  (QSD:MkLayer "QS_Block" 8 nil 9)
  (QSD:MkLayer "QS_Text" 7 nil 13)
  (QSD:MkLayer "QS_Truc" 8 "DASHDOT2_DBIM" 13)
  (QSD:MkLayer "QS_NetKhuat" 8 "HIDDEN_DBIM" 9)
  (QSD:MkLayer "QS_MCZiCZac" 144 nil 13)
  (QSD:MkLayer "QS_Hatch" 8 nil 13)
  (QSD:MkLayer "QS_Symbol" 8 nil 9)
  (QSD:MkLayer "QS_ThepShop" 1 nil 35)
  (if (not (tblsearch "STYLE" "Dce_Text"))
    (entmake (list '(0 . "STYLE") '(100 . "AcDbSymbolTableRecord") '(100 . "AcDbTextStyleTableRecord")
                   '(2 . "Dce_Text") '(70 . 0) '(40 . 0.0) '(41 . 0.7) '(50 . 0.0) '(71 . 0)
                   '(42 . 2.5) '(3 . "arial.ttf") '(4 . ""))))
  (if (not (tblsearch "APPID" *QSD-APP*)) (regapp *QSD-APP*))
  (if (not (tblsearch "APPID" "DcePro")) (regapp "DcePro"))
  (QSD:MkBlocks)
  (setq tl (QSD:TL) tn (QSD:TN))
  (QSD:EnsureDimStyle tl)
  (QSD:EnsureDimStyle tn)
  (princ))

(defun QSD:LtsG (lay) (if (member lay '("QS_Truc" "QS_NetKhuat")) (list (cons 48 (QSD:CfgN "LTS"))) nil))
(defun QSD:Line (x1 y1 x2 y2 lay)
  (entmakex (append (list '(0 . "LINE") (cons 8 lay)) (QSD:LtsG lay) (list (cons 10 (QSD:P x1 y1)) (cons 11 (QSD:P x2 y2))))))

;; pts = list (x y [bulge]) tuong doi ; tra ve ename
(defun QSD:PL (pts lay closed wid / dl)
  (setq dl (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)) (QSD:LtsG lay)
                 (list '(100 . "AcDbPolyline") (cons 90 (length pts)) (cons 70 (if closed 1 0)) (cons 43 wid))))
  (foreach p pts
    (setq dl (append dl (list (cons 10 (QSD:P2 (car p) (cadr p))))))
    (if (caddr p) (setq dl (append dl (list (cons 42 (caddr p)))))))
  (entmakex dl))

;; just: "L" "C" "R" "M"
(defun QSD:Text (x y s h lay just rot / p j72 j73)
  (setq p (QSD:P x y))
  (setq j72 (cond ((= just "C") 1) ((= just "R") 2) ((= just "M") 1) (T 0))
        j73 (if (= just "M") 2 0))
  (entmakex (list '(0 . "TEXT") (cons 8 lay) (cons 10 p) (cons 11 p) (cons 40 h) (cons 1 s)
                  '(7 . "Dce_Text") '(41 . 0.7) (cons 50 rot) (cons 72 j72) (cons 73 j73))))

(defun QSD:MText (x y s h lay)
  (entmakex (list '(0 . "MTEXT") '(100 . "AcDbEntity") (cons 8 lay) '(100 . "AcDbMText")
                  (cons 10 (QSD:P x y)) (cons 40 h) '(71 . 5) '(72 . 5) (cons 1 s) '(7 . "Dce_Text"))))

(defun QSD:Circle (x y r lay)
  (entmakex (list '(0 . "CIRCLE") (cons 8 lay) (cons 10 (QSD:P x y)) (cons 40 r))))

(defun QSD:Ellipse (x y rx ratio lay)
  (entmakex (list '(0 . "ELLIPSE") '(100 . "AcDbEntity") (cons 8 lay) '(100 . "AcDbEllipse")
                  (cons 10 (QSD:P x y)) (list 11 rx 0.0 0.0) (cons 40 ratio)
                  '(41 . 0.0) (cons 42 (* 2 pi)))))

;; chen block + attribute (entmake INSERT/ATTRIB/SEQEND) ; atts = (("TAG" . "gia tri") ...)
(defun QSD:Insert (name x y sc lay atts / blk e ed ins p a q v j72 j74 has)
  (setq blk (tblobjname "BLOCK" name) has nil e (if blk (entnext blk)))
  (while e (if (= (cdr (assoc 0 (entget e))) "ATTDEF") (setq has T)) (setq e (entnext e)))
  (setq ins (QSD:P x y))
  (entmake (list '(0 . "INSERT") (cons 8 lay) (cons 2 name) (cons 10 ins) (cons 41 sc) (cons 42 sc) (cons 43 sc)
                 '(50 . 0.0) (cons 66 (if has 1 0))))
  (if has
    (progn
      (setq e (entnext blk))
      (while e
        (setq ed (entget e))
        (if (= (cdr (assoc 0 ed)) "ATTDEF")
          (progn
            (setq p (cdr (assoc 10 ed)) q (cdr (assoc 11 ed)) j72 (cdr (assoc 72 ed)) j74 (cdr (assoc 74 ed)))
            (if (null q) (setq q p))
            (setq v (cdr (assoc (cdr (assoc 2 ed)) atts)))
            (if (null v) (setq v (if (member (cdr (assoc 2 ed)) '("SH" "1" "TRUC" "CT" "TENDAM" "TENMATCAT")) (cdr (assoc 1 ed)) "")))
            (entmake (list '(0 . "ATTRIB") (cons 8 lay)
                           (cons 10 (list (+ (car ins) (* sc (car p))) (+ (cadr ins) (* sc (cadr p))) 0.0))
                           (cons 40 (* sc (cdr (assoc 40 ed)))) (cons 1 v) (cons 2 (cdr (assoc 2 ed)))
                           '(70 . 0) (cons 7 (cdr (assoc 7 ed))) (cons 41 (cond ((cdr (assoc 41 ed))) (T 0.7)))
                           (cons 62 (cond ((cdr (assoc 62 ed))) (T 256)))
                           (cons 72 (if j72 j72 0)) (cons 74 (if j74 j74 0))
                           (cons 11 (list (+ (car ins) (* sc (car q))) (+ (cadr ins) (* sc (cadr q))) 0.0))))))
        (setq e (entnext e)))
      (entmake '((0 . "SEQEND")))))
  (entlast))

;; dim ngang / doc theo kieu Dce_xxMV
(defun QSD:Dim (x1 y1 x2 y2 xl yl rot ovr sc / o nm)
  (if (> (distance (list x1 y1) (list x2 y2)) 0.5)
    (progn
      (setq o (vl-catch-all-apply 'vla-AddDimRotated
                (list (QSD:MSpace) (vlax-3d-point (QSD:P x1 y1)) (vlax-3d-point (QSD:P x2 y2))
                      (vlax-3d-point (QSD:P xl yl)) rot)))
      (if (not (vl-catch-all-error-p o))
        (progn
          (vl-catch-all-apply 'vla-put-Layer (list o "QS_Dim"))
          (setq nm (QSD:DimStyleName sc))
          (if (tblsearch "DIMSTYLE" nm)
            (vl-catch-all-apply 'vla-put-StyleName (list o nm))
            (QSD:DimOverride o sc))
          (if (and ovr (/= ovr "")) (vl-catch-all-apply 'vla-put-TextOverride (list o ovr)))
          (vlax-vla-object->ename o))
        nil))
    nil))
(defun QSD:DimH (x1 x2 yb yl sc ovr) (QSD:Dim x1 yb x2 yb x2 yl 0.0 ovr sc))

;; hatch ANSI31 trong hinh chu nhat (vla-AddHatch; loi -> ke tay net cheo)
(defun QSD:HatchRect (xa xb yb yt lay / sc pl o arr r c y0 y1 sp)
  (setq sc (QSD:CfgN "HATCHSC"))
  (setq pl (QSD:PL (list (list xa yb) (list xb yb) (list xb yt) (list xa yt)) lay T 0.0))
  (setq r (vl-catch-all-apply
            '(lambda ( / )
               (setq o (vla-AddHatch (QSD:MSpace) 1 (QSD:Cfg "HATCHPAT") :vlax-false))
               (setq arr (vlax-make-safearray vlax-vbObject '(0 . 0)))
               (vlax-safearray-put-element arr 0 (vlax-ename->vla-object pl))
               (vla-AppendOuterLoop o arr)
               (vla-put-PatternScale o sc)
               (vla-put-Layer o lay)
               (vla-Evaluate o) o)
            nil))
  (if pl (entdel pl))
  (if (vl-catch-all-error-p r)
    (progn
      (if o (vl-catch-all-apply 'vla-Delete (list o)))
      (setq sp (* 12.7 (QSD:TL)) c (- xa yt))
      (while (< c (- xb yb))
        (setq y0 (max yb (- xa c)) y1 (min yt (- xb c)))
        (if (> (- y1 y0) 1.0) (QSD:Line (+ y0 c) y0 (+ y1 c) y1 lay))
        (setq c (+ c sp)))))
  (princ))

;; gan xdata (thay the xdata cu cung app)
(defun QSD:SetXd (ent app items / ed)
  (if (and ent (setq ed (entget ent)))
    (progn
      (if (not (tblsearch "APPID" app)) (regapp app))
      (entmod (append ed (list (list -3 (cons app items)))))))
  ent)
(defun QSD:Handle (ent) (cdr (assoc 5 (entget ent))))

(defun QSD:NewId ( / )
  (setq *QSD-IDN* (if *QSD-IDN* (1+ *QSD-IDN*) 0))
  (strcat "D" (vl-string-translate "." "_" (rtos (getvar "CDATE") 2 6)) "_" (itoa *QSD-IDN*)))

;; zigzag cat ngang (dau cot) tai y, tu xa den xb
(defun QSD:ZigH (xa xb y dir / xc)
  (setq xc (/ (+ xa xb) 2.0))
  (QSD:PL (list (list (- xa 35.0) y) (list (- xc 35.0) y) (list (- xc 35.0) (- y (* dir 35.0)))
                (list (+ xc 35.0) (+ y (* dir 35.0))) (list (+ xc 35.0) y) (list (+ xb 35.0) y))
          "QS_MCZiCZac" nil 0.0))
;; zigzag doc (dau canh san o mat cat ngang)
(defun QSD:ZigV (x ya yb / yc)
  (setq yc (/ (+ ya yb) 2.0))
  (QSD:PL (list (list x (+ ya 33.0)) (list x (+ yc 33.0)) (list (- x 33.0) (+ yc 33.0))
                (list (+ x 33.0) (- yc 33.0)) (list x (- yc 33.0)) (list x (- yb 33.0)))
          "QS_MCZiCZac" nil 0.0))

;; chuoi cao do "-0.100" / "+3.600" / "%%p0.000"
(defun QSD:CoteTxt (s / v)
  (setq v (QSD:Num s))
  (cond ((null v) (if (= s "") "%%p0.000" s))
        ((equal v 0.0 1e-9) "%%p0.000")
        ((> v 0) (strcat "+" (rtos v 2 3)))
        (T (rtos v 2 3))))

;;;-----------------------------------------------------------------------------
;;; 8. THANH THEP DANG DCE: vat goc 30 + gach dau thanh 70 (30 do)
;;;    din = -1: gach huong xuong (thep tren), +1: huong len (thep duoi)
;;;-----------------------------------------------------------------------------
(defun QSD:Sgn (v) (if (< v 0) -1.0 1.0))
(defun QSD:BarPts (x1 x2 y l1 l2 din / pts s tc ts a)
  (setq a (* pi (/ (QSD:CfgN "TICKA") 180.0)) tc (* (QSD:CfgN "TICKL") (cos a)) ts (* (QSD:CfgN "TICKL") (sin a)))
  (setq pts nil)
  (if (/= l1 0.0)
    (progn (setq s (QSD:Sgn l1))
           (setq pts (list (list (+ x1 ts) (- (+ y l1) (* s tc))) (list x1 (+ y l1))
                           (list x1 (- y (* s -30.0))) (list (+ x1 30.0) y))))
    (setq pts (list (list (+ x1 tc) (+ y (* din ts))) (list x1 y))))
  (if (/= l2 0.0)
    (progn (setq s (QSD:Sgn l2))
           (setq pts (append pts (list (list (- x2 30.0) y) (list x2 (+ y (* s 30.0)))
                                       (list x2 (+ y l2)) (list (- x2 ts) (- (+ y l2) (* s tc)))))))
    (setq pts (append pts (list (list x2 y) (list (- x2 tc) (+ y (* din ts)))))))
  (if (= (QSD:CfgN "TICKL") 0) (setq pts (vl-remove-if '(lambda (p) nil) pts)))
  pts)

;; cao do y (tuong doi) cua 1 thanh o mat cat doc
(defun QSD:BarY (beam bar / tp lay a1 dl h rows)
  (setq tp (nth 0 bar) lay (nth 1 bar) a1 (QSD:CfgN "A1VE") dl (QSD:CfgN "DLVE") h (QSD:Get "H" beam))
  (cond
    ((= tp "T") (- (+ a1 (* (1- lay) dl))))
    ((= tp "B") (+ (- h) a1 (* (1- lay) dl)))
    (T (setq rows 0)
       (foreach b2 (QSD:Get "BARS" beam)
         (if (and (= (nth 0 b2) "G") (= (nth 9 b2) (nth 9 bar))) (setq rows (max rows (nth 1 b2)))))
       (- (+ a1 (* (- h (* 2 a1)) (/ (float lay) (1+ rows))))))))

;; so hieu cac loai thep phu (tiep sau so hieu thep chu):
;; "S<d>" dai chinh, "GC<d>" dai gia cuong dam giao, "IN<d>" dai trong, "V<d>" vai bo, "CDO" thep C do, "CTIE" dai C noi thep gia
(defun QSD:StirMarks (beam / n r add sd cdo ctie sp nl)
  (setq n (length (QSD:Get "BARS" beam)) r nil)
  (defun QSD:_add (k) (if (not (assoc k r)) (setq n (1+ n) r (append r (list (cons k (itoa n)))))))
  ;; dai / dai gia cuong: moi (phi, be rong dam) 1 so hieu (nhip doi b -> hinh khac -> so hieu khac, giong DCE)
  (foreach z (QSD:Get "ZONES" beam) (QSD:_add (QSD:SKey "S" (nth 1 z) (QSD:WidthAt beam (/ (+ (nth 3 z) (nth 4 z)) 2.0)))))
  (if (QSD:Get "COLSTIR" beam)
    (QSD:_add (QSD:SKey "S" (if (QSD:Get "ZONES" beam) (nth 1 (car (QSD:Get "ZONES" beam))) 8.0) (QSD:Get "B" beam))))
  (foreach s (QSD:Get "SB" beam) (if (nth 4 s) (QSD:_add (QSD:SKey "S" (cadr (nth 4 s)) (QSD:WidthAt beam (nth 1 s))))))
  (setq sd (if (QSD:Get "ZONES" beam) (nth 1 (car (QSD:Get "ZONES" beam))) 8.0))
  ;; dai trong: nhip co dong 27, hoac tu dong khi lop 1 tren co >= 4 thanh (giong MC ngang / thong ke)
  (foreach z (QSD:Get "ZONES" beam)
    (setq sp (nth (car z) (QSD:Get "SPANS" beam)) nl 0)
    (foreach bb (QSD:BarsAt beam (/ (+ (nth 3 z) (nth 4 z)) 2.0))
      (if (and (= (car bb) "T") (= (nth 1 bb) 1)) (setq nl (+ nl (nth 2 bb)))))
    (if (and (>= nl 3) (or (nth 6 sp) (>= nl 4)))
      (QSD:_add (QSD:InKey (if (nth 6 sp) (car (nth 6 sp)) (nth 1 z))
                           (QSD:WidthAt beam (/ (+ (nth 3 z) (nth 4 z)) 2.0)) nl))))
  (foreach hg (QSD:Get "HANGERS" beam) (QSD:_add (strcat "V" (itoa (nth 4 hg)))))
  (setq cdo (QSD:Get "CDO" beam) ctie (QSD:Get "CTIE" beam))
  ;; thep C do / dai C noi thep gia: 1 so hieu cho moi be rong dam (be rong tai giua thanh mang, giong thong ke)
  (if (and cdo (/= (nth 2 cdo) "KHONG"))
    (foreach bb (QSD:Get "BARS" beam)
      (if (and (member (car bb) '("T" "B")) (= (nth 1 bb) 2)) (QSD:_add (QSD:SKey "CDO" 0 (QSD:BarW beam bb))))))
  (if (and ctie (/= (QSD:Trim (car ctie)) "") (/= (strcase (QSD:Trim (car ctie))) "NONE"))
    (foreach bb (QSD:Get "BARS" beam)
      (if (and (= (car bb) "G") (or (not (wcmatch (strcase (car ctie)) "SO LE*")) (= (rem (nth 1 bb) 2) 1)))
        (QSD:_add (QSD:SKey "CTIE" 0 (QSD:BarW beam bb))))))
  r)
(defun QSD:SM (sm k) (cond ((cdr (assoc k sm))) (T "")))
;; be rong dam tai giua 1 thanh ; thanh dau tien loai tp / lop lay trong bars (mac dinh def)
(defun QSD:BarW (beam bb) (QSD:WidthAt beam (/ (+ (nth 4 bb) (nth 5 bb)) 2.0)))
(defun QSD:BarWAt (beam bars tp lay def / r)
  (foreach bb bars (if (and (null r) (= (car bb) tp) (= (nth 1 bb) lay)) (setq r (QSD:BarW beam bb))))
  (if r r def))
(defun QSD:SKey (pre d b) (strcat pre (QSD:NumStr d) "|" (QSD:NumStr b)))

;; chu thich dai: "%%c10a100" hoac "21%%c10a100" (tuy chon ghi so luong)
(defun QSD:DaiTxt (n d s) (strcat (if (and n (QSD:CfgB "GHISLKR")) (itoa n) "") "%%c" (QSD:NumStr d) "a" (QSD:NumStr s)))

;; tag 1 thanh: leader tu (x, ybar) -> (x, ytag) -> (x +/- 9TL, ytag) + block
;; leader sang PHAI -> block chu ben trai, vong tron ben phai (Dce_KhtMcThepTangCuong) ; sang TRAI -> Dce_KhtMcThepChu
(defun QSD:TagBar (bb hdl x ybar ytag dir sc name nck / xe ent)
  (setq xe (+ x (* dir 9.0 sc)))
  (QSD:PL (list (list x ybar) (list x ytag) (list xe ytag)) "QS_Dim" nil 0.0)
  (setq ent (QSD:Insert (if (> dir 0) "Dce_KhtMcThepTangCuong" "Dce_KhtMcThepChu") xe ytag sc "QS_Block"
                        (list (cons "SH" (nth 10 bb))
                              (cons "DKVAKC" (strcat (if *QSD-GIATAG* (strcat (itoa (car *QSD-GIATAG*)) "x") "")
                                                     (QSD:BarTxt (nth 2 bb) (nth 3 bb))
                                                     (if (QSD:CfgB "GHICHIEUDAI")
                                                       (strcat " L=" (QSD:NumStr (QSD:RoundUp (QSD:BarLen bb) (QSD:CfgN "RNDTKT")))) ""))))))
  (setq *QSD-GIATAG* nil)
  (if (and ent hdl)
    (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" name "(1)_" (nth 10 bb) "(2)_" hdl "(3)_"
                                                     (itoa (nth 3 bb)) "(4)_" (itoa nck) "(5)_" (itoa (nth 2 bb)))))))
  ent)

;; tag don gian (khong gan thanh): leader pts + block
(defun QSD:TagPts (pts blk sc sh txt txt2)
  (QSD:PL pts "QS_Dim" nil 0.0)
  (QSD:Insert blk (car (QSD:Last pts)) (cadr (QSD:Last pts)) sc "QS_Block"
              (list (cons "SH" sh) (cons "DKVAKC" txt) (cons "DKVAKC2" (if txt2 txt2 "")))))

;;;-----------------------------------------------------------------------------
;;; 9. VE MAT CAT DOC (giong DCE)
;;;-----------------------------------------------------------------------------
(defun QSD:DrawElev (beam id / tl h hs inv ltot sups spans bars name nck colU colD ybot yDimT yDimB yAx yArr yLtt
                         y ent hdl hdls xs sm z zc k n x dir sb gc xl xr i sp su lst c wt yb1 yt1 ang dx bh hd pts
                         lot a1 sd dv x0 sg lm xe xsh cp tn)
  (setq tl (QSD:TL) h (QSD:Get "H" beam) hs (QSD:Get "HS" beam) inv (QSD:Get "SLABINV" beam) ltot (QSD:Get "L" beam)
        sups (QSD:Get "SUPS" beam) spans (QSD:Get "SPANS" beam) bars (QSD:Get "BARS" beam)
        name (QSD:Get "NAME" beam) nck (QSD:Get "NCK" beam) a1 (QSD:CfgN "A1VE") dv (QSD:CfgN "DAIVE"))
  (setq colU 1000.0 colD 850.0 ybot (- (+ h colD)))
  (setq yDimT (+ colU (* 10 tl)) yArr (+ colU (* 15 tl))
        yDimB (- ybot (* 7 tl)) yAx (- ybot (* 12 tl)) yLtt nil)
  (if (or (QSD:Get "LTT" beam) (QSD:CfgB "GHIKTNHIP")) (setq yLtt yAx yAx (- yAx (* 5 tl))))
  (setq sm (QSD:StirMarks beam))
  ;; ---- be tong: dam giua cac goi ----
  (foreach sp spans
    (QSD:Line (nth 1 sp) 0.0 (nth 2 sp) 0.0 "QS_BaoBeTong")
    (QSD:Line (nth 1 sp) (- h) (nth 2 sp) (- h) "QS_BaoBeTong"))
  ;; ---- goi: cot (tren / duoi, bo rong + lech rieng), goi la dam, console ----
  (foreach su sups
    (cond
      ((= (nth 8 su) "0") (QSD:Line (nth 1 su) 0.0 (nth 1 su) (- h) "QS_BaoBeTong"))
      ((= (nth 8 su) "D")
       (QSD:PL (list (list (nth 1 su) 0.0) (list (nth 2 su) 0.0) (list (nth 2 su) (- (nth 10 su))) (list (nth 1 su) (- (nth 10 su))))
               "QS_BaoBeTong" T 0.0))
      (T
       ;; cot phia duoi
       (if (not (member (nth 9 su) '(2 3)))
         (progn (QSD:Line (nth 1 su) (- h) (nth 1 su) ybot "QS_BaoBeTong")
                (QSD:Line (nth 2 su) (- h) (nth 2 su) ybot "QS_BaoBeTong")
                (QSD:ZigH (nth 1 su) (nth 2 su) ybot 1.0)))
       ;; cot phia tren (bo rong / lech rieng)
       (if (not (member (nth 9 su) '(1 3)))
         (progn (setq c (+ (QSD:SupC su) (nth 7 su)) wt (nth 6 su))
                (QSD:Line (- c (/ wt 2.0)) 0.0 (- c (/ wt 2.0)) colU "QS_BaoBeTong")
                (QSD:Line (+ c (/ wt 2.0)) 0.0 (+ c (/ wt 2.0)) colU "QS_BaoBeTong")
                (QSD:ZigH (- c (/ wt 2.0)) (+ c (/ wt 2.0)) colU 1.0)))
       (if (= (car su) 0) (QSD:Line (nth 1 su) 0.0 (nth 1 su) (- h) "QS_BaoBeTong"))
       (if (= (car su) (1- (length sups))) (QSD:Line (nth 2 su) 0.0 (nth 2 su) (- h) "QS_BaoBeTong"))
       (if (member (nth 9 su) '(1 3)) (QSD:Line (nth 1 su) 0.0 (nth 2 su) 0.0 "QS_BaoBeTong"))
       (if (member (nth 9 su) '(2 3)) (QSD:Line (nth 1 su) (- h) (nth 2 su) (- h) "QS_BaoBeTong")))))
  ;; ---- net khuat: day san (san lat: mat tren san), cot / dam giao duoi san, dam giao tai cot ----
  (setq sb (QSD:Get "SB" beam))
  (if (> hs 0)
    (progn
      (setq y (if inv (- (- h hs)) (- hs)))
      (foreach su sups
        (if (and (> (nth 3 su) 0) (= (nth 8 su) "C") (not inv))
          (QSD:PL (list (list (nth 1 su) (- hs)) (list (nth 1 su) (- h)) (list (nth 2 su) (- h)) (list (nth 2 su) (- hs)))
                  "QS_NetKhuat" nil 0.0)))
      (foreach sp spans
        (setq xl (nth 1 sp))
        (foreach s1 sb
          (if (= (car s1) (car sp))
            (progn (QSD:Line xl y (- (nth 1 s1) (/ (nth 2 s1) 2.0)) y "QS_NetKhuat")
                   (setq xl (+ (nth 1 s1) (/ (nth 2 s1) 2.0))))))
        (QSD:Line xl y (nth 2 sp) y "QS_NetKhuat"))))
  (foreach s1 sb
    (setq x (nth 1 s1))
    (QSD:PL (list (list (- x (/ (nth 2 s1) 2.0)) (- hs)) (list (- x (/ (nth 2 s1) 2.0)) (- (nth 3 s1)))
                  (list (+ x (/ (nth 2 s1) 2.0)) (- (nth 3 s1))) (list (+ x (/ (nth 2 s1) 2.0)) (- hs)))
            "QS_NetKhuat" nil 0.0))
  (foreach su sups
    (if (setq c (nth 12 su))
      (progn (setq x (+ (QSD:SupC su) (nth 2 c)))
             (QSD:PL (list (list (- x (/ (car c) 2.0)) (- hs)) (list (- x (/ (car c) 2.0)) (- (cadr c)))
                           (list (+ x (/ (car c) 2.0)) (- (cadr c))) (list (+ x (/ (car c) 2.0)) (- hs)))
                     "QS_NetKhuat" nil 0.0))))
  ;; ---- be tong lot (N8) ----
  (if (setq lot (QSD:Get "LOT" beam))
    (foreach sp spans
      (QSD:PL (list (list (nth 1 sp) (- h)) (list (nth 1 sp) (- (+ h (car lot)))) (list (nth 2 sp) (- (+ h (car lot)))) (list (nth 2 sp) (- h)))
              "QS_BaoBeTong" nil 0.0)))
  ;; ---- truc ----
  (foreach su sups
    (QSD:Line (nth 4 su) colU (nth 4 su) yAx "QS_Truc")
    (QSD:Insert "Dce_KhTenTruc" (nth 4 su) yAx (* 1.2 tl) "QS_Truc" (list (cons "TRUC" (nth 5 su)))))
  ;; ---- cao do ----
  ;; thep cho dau trai -> day cao do / dim h sang trai
  (setq xsh 0.0)
  (foreach c (QSD:Get "CHO" beam) (if (= (car c) "L") (setq xsh (max xsh (+ (nth 5 c) 600.0)))))
  (QSD:Insert "Dce_CaoTrinh" (- -100.0 xsh) 0.0 tl "QS_Block" (list (cons "CT" (QSD:CoteTxt (QSD:Get "COTE" beam)))))
  ;; ---- thep chu ----
  (setq hdls nil)
  (foreach b bars
    (setq y (QSD:BarY beam b))
    (setq ent (QSD:PL (QSD:BarPts (nth 4 b) (nth 5 b) y (nth 6 b) (nth 7 b) (if (= (nth 0 b) "B") 1.0 -1.0))
                      "QS_ThepChu" nil 0.0))
    (setq hdl (if ent (QSD:Handle ent) nil))
    (setq hdls (cons (cons (nth 10 b) hdl) hdls))
    (if ent
      (progn
        (QSD:SetXd ent "DcePro"
          (list (cons 1000 (strcat "(0)_" name "(1)_" (nth 10 b) "(2)_" (nth 0 b) ";" hdl ";"
                                   "(3)_" (itoa (nth 3 b)) "(4)_" (itoa nck) "(5)_" (itoa (nth 2 b))))))
        (QSD:SetXd ent *QSD-APP*
          (list (cons 1000 id) (cons 1000 "BAR") (cons 1000 (nth 0 b)) (cons 1070 (nth 1 b)) (cons 1000 (nth 8 b)))))))
  ;; ---- thep cho 2 dau dam: dam zone ke ben (net khuat), mach ngung, dim L cho / coupler ----
  (foreach side '("L" "R")
    (setq lst (vl-remove-if-not '(lambda (c) (= (car c) side)) (QSD:Get "CHO" beam)))
    (if lst
      (progn
        (setq x0 (if (= side "L") 0.0 ltot) sg (if (= side "L") -1.0 1.0)
              lm (apply 'max (mapcar '(lambda (c) (nth 5 c)) lst)))
        (setq xe (+ x0 (* sg (+ lm 600.0))))
        (QSD:Line x0 0.0 xe 0.0 "QS_NetKhuat")
        (QSD:Line x0 (- h) xe (- h) "QS_NetKhuat")
        (QSD:ZigV xe 0.0 (- h))
        (QSD:Line x0 (* 3.0 tl) x0 (- (+ h (* 3.0 tl))) "QS_Symbol")
        (QSD:Text (+ x0 (* sg 1.0 tl)) (/ h -2.0) "M\\U+1EA0CH NG\\U+1EEANG" (* 1.8 tl) "QS_Symbol" "M" (/ pi 2))
        (setq cp (vl-remove-if-not '(lambda (c) (= (nth 1 c) "COUPLER")) lst))
        ;; coupler: ky hieu tai dau thanh (tai mep, hoac ra ngoai mep L1 / L2 so le)
        (if cp
          (foreach b bars
            (if (if (= side "L") (<= (nth 4 b) 1.0) (>= (nth 5 b) (- ltot 1.0)))
              (QSD:CplBox (if (= side "L") (nth 4 b) (nth 5 b)) (QSD:BarY beam b)))))
        ;; dim doan cho / doan coupler ra ngoai mep
        (setq k 0 xs nil)
        (foreach c lst (if (and (> (nth 5 c) 0.5) (not (member (nth 5 c) xs))) (setq xs (append xs (list (nth 5 c))))))
        (foreach L (QSD:Sort xs '<)
          (QSD:DimH (if (= side "L") (- L) x0) (if (= side "L") x0 (+ ltot L)) 0.0 (+ (* 4.0 tl) (* k 5.0 tl)) tl nil)
          (setq k (1+ k)))
        (QSD:Text (+ x0 (* sg (max (* 0.5 lm) (* 2.0 tl)))) (+ (* 4.0 tl) (* k 5.0 tl) (* 1.0 tl))
                  (QSD:ChoLab beam side (if cp "COUPLER" "THANG")) (* 2.0 tl) "QS_Symbol" (if (= side "L") "R" "L") 0.0)
        ;; ten dam zone sau ghi trong vung net khuat
        (setq tn (cdr (assoc side (QSD:Get "CHOTEN" beam))))
        (if (and tn (/= tn ""))
          (QSD:Text (/ (+ x0 xe) 2.0) (- (+ h (* 3.0 tl))) (strcat "D\\U+1EA6M " tn) (* 2.0 tl) "QS_Symbol" "C" 0.0)))))
  ;; ---- tag thep: moi nhip 3 vi tri (trai / giua / phai), tren + duoi ----
  (foreach sp spans
    (foreach loc (list (list (+ (nth 1 sp) 300.0) 1.0) (list (/ (+ (nth 1 sp) (nth 2 sp)) 2.0) -1.0) (list (- (nth 2 sp) 300.0) -1.0))
      (setq x (car loc) dir (cadr loc))
      (setq lst (vl-remove-if-not '(lambda (b) (and (= (nth 0 b) "T") (<= (nth 4 b) x) (>= (nth 5 b) x))) bars))
      (setq lst (QSD:Sort lst '(lambda (a b) (< (QSD:BarY beam a) (QSD:BarY beam b)))) k 1)
      (foreach b lst
        (QSD:TagBar b (cdr (assoc (nth 10 b) hdls)) x (QSD:BarY beam b) (* k 5 tl) dir tl name nck)
        (setq k (1+ k)))
      (setq lst (vl-remove-if-not '(lambda (b) (and (or (= (nth 0 b) "B") (and (= (nth 0 b) "G") (< dir 0) (> x (+ (nth 1 sp) 400.0)) (< x (- (nth 2 sp) 400.0))))
                                                    (<= (nth 4 b) x) (>= (nth 5 b) x))) bars))
      (setq lst (QSD:Sort lst '(lambda (a b) (> (QSD:BarY beam a) (QSD:BarY beam b)))) k 0)
      (foreach b lst
        (if (= (nth 0 b) "G")
          (if (= (nth 1 b) 1)
            (progn
              (setq n 0) (foreach b2 bars (if (and (= (nth 0 b2) "G") (= (nth 9 b2) (nth 9 b))) (setq n (max n (nth 1 b2)))))
              (QSD:PL (list (list (+ x 400.0) (QSD:BarY beam b)) (list (+ x 400.0) (+ (- h) a1))) "QS_Dim" nil 0.0)
              (setq *QSD-GIATAG* (list n))
              (QSD:TagBar b (cdr (assoc (nth 10 b) hdls)) (+ x 400.0) (+ (- h) a1)
                          (- (+ h (* 7 tl) (* k 5 tl))) 1.0 tl name nck)
              (setq k (1+ k))))
          (progn
            (QSD:TagBar b (cdr (assoc (nth 10 b) hdls)) x (QSD:BarY beam b) (- (+ h (* 7 tl) (* k 5 tl))) dir tl name nck)
            (setq k (1+ k)))))))
  ;; ---- dai: net dai tai bien vung + tag dai phia tren (T.LINK ghi kem) ----
  (foreach z (QSD:Get "ZONES" beam)
    (setq zc (/ (+ (nth 3 z) (nth 4 z)) 2.0))
    (setq sp (nth (car z) spans))
    (cond
      ((and (< (nth 3 z) (+ (nth 1 sp) 1.0)) (> (nth 4 z) (- (nth 2 sp) 1.0)))
       (setq xs (list (list (+ (nth 1 sp) dv) 1.0) (list (- (nth 2 sp) dv) -1.0))))
      ((< (nth 3 z) (+ (nth 1 sp) 1.0)) (setq xs (list (list (+ (nth 1 sp) dv) 1.0) (list (- (nth 4 z) 30.0) -1.0))))
      ((> (nth 4 z) (- (nth 2 sp) 1.0)) (setq xs (list (list (+ (nth 3 z) 30.0) 1.0) (list (- (nth 2 sp) dv) -1.0))))
      (T (setq xs nil)))
    (foreach xx xs
      (QSD:Line (car xx) (- a1) (car xx) (- (- h a1)) "QS_ThepDai")
      (if (= (QSD:Cfg "SLDAIMCD") "TWO")
        (QSD:Line (+ (car xx) (* (cadr xx) (nth 2 z))) (- a1) (+ (car xx) (* (cadr xx) (nth 2 z))) (- (- h a1)) "QS_ThepDai")))
    ;; so luong dai: tru dai tai vi tri dam giao (neu khong tick "Khong tru bo")
    (setq n (nth 7 z))
    (if (not (QSD:CfgB "KHONGTRUDAI"))
      (foreach s1 sb
        (if (and (= (car s1) (car z)) (> (nth 1 s1) (nth 3 z)) (< (nth 1 s1) (nth 4 z)))
          (setq n (max 1 (- n (fix (/ (nth 2 s1) (nth 2 z)))))))))
    (setq ent (QSD:Insert "Dce_KhtThepDai" zc yDimT tl "QS_Block"
                (list (cons "SH" (QSD:SM sm (QSD:SKey "S" (nth 1 z) (QSD:WidthAt beam zc))))
                      (cons "DKVAKC" (strcat (QSD:DaiTxt n (nth 1 z) (nth 2 z)) (if (nth 7 sp) " (T.LINK)" ""))))))
    ;; xdata giong DCE: (1)_SH;(2)_N<nhip>/D<vung>/KC<buoc>
    (setq k 1)
    (foreach z2 (QSD:Get "ZONES" beam) (if (and (= (car z2) (car z)) (< (nth 3 z2) (- (nth 3 z) 1.0))) (setq k (1+ k))))
    (if ent (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" name "(1)_" (QSD:SM sm (QSD:SKey "S" (nth 1 z) (QSD:WidthAt beam zc)))
                                                            ";(2)_N" (itoa (1+ (car z))) "/D" (itoa k) "/KC" (QSD:NumStr (nth 2 z))
                                                            "(3)_D(4)_" (itoa nck) "(5)_D"))))))
  ;; ---- dai trong cot (dong 12 cot goi) ----
  (setq sd (if (QSD:Get "ZONES" beam) (nth 1 (car (QSD:Get "ZONES" beam))) 8.0))
  (foreach cs (QSD:Get "COLSTIR" beam)
    (setq su (nth (car cs) sups))
    (foreach xx (list (+ (nth 1 su) 50.0) (- (nth 2 su) 50.0)) (QSD:Line xx (- a1) xx (- (- h a1)) "QS_ThepDai"))
    (QSD:Insert "Dce_KhtThepDai" (QSD:SupC su) yDimT tl "QS_Block"
                (list (cons "SH" (QSD:SM sm (QSD:SKey "S" sd (QSD:Get "B" beam))))
                      (cons "DKVAKC" (strcat (QSD:DaiTxt (1+ (QSD:CntDiv (- (nth 3 su) 100.0) (cadr cs))) sd (cadr cs))
                                             (if (caddr cs) " (+)" ""))))))
  ;; ---- dai gia cuong tai dam giao (ben L / R) ----
  (foreach s1 sb
    (if (setq gc (nth 4 s1))
      (progn
        (setq x (nth 1 s1) k 1 xs nil)
        (repeat (if (= (nth 3 gc) "") (QSD:Ceil (/ (car gc) 2.0)) (car gc))
          (if (/= (nth 3 gc) "R") (setq xs (cons (- x (/ (nth 2 s1) 2.0) (* k (nth 2 gc))) xs)))
          (if (or (= (nth 3 gc) "R") (and (= (nth 3 gc) "") (<= (* 2 k) (car gc))))
            (setq xs (cons (+ x (/ (nth 2 s1) 2.0) (* k (nth 2 gc))) xs)))
          (setq k (1+ k)))
        (setq y (- (* 0.357 h)))
        (foreach xx xs (QSD:Line xx (- a1) xx (- (- h a1)) "QS_ThepDai"))
        (QSD:Line (apply 'min xs) y (apply 'max xs) y "QS_Dim")
        (setq k (1+ (length (vl-remove-if-not '(lambda (b) (and (= (nth 0 b) "T") (<= (nth 4 b) x) (>= (nth 5 b) x))) bars))))
        (QSD:TagPts (list (list x y) (list x (* k 5 tl)) (list (- x (* 9 tl)) (* k 5 tl)))
                    "Dce_KhtMcThepChu" tl (QSD:SM sm (QSD:SKey "S" (cadr gc) (QSD:WidthAt beam (nth 1 s1))))
                    (strcat (itoa (car gc)) "%%c" (itoa (cadr gc)) "a" (QSD:NumStr (nth 2 gc))) nil))))
  ;; ---- thep vai bo tai dam giao (dong 30) ----
  (foreach hg (QSD:Get "HANGERS" beam)
    ;; hg = (j x b2 n d)
    (setq x (nth 1 hg) hd (nth 4 hg) bh (+ (/ (nth 2 hg) 2.0) 50.0)
          yt1 (- a1) yb1 (+ (- h) a1) ang (if (>= h (QSD:CfgN "HVB")) (* (QSD:CfgN "GOCVB") (/ pi 180.0)) (/ pi 4.0))
          dx (/ (- yt1 yb1) (/ (sin ang) (cos ang))))
    (setq pts (list (list (- x bh dx (* (QSD:CfgN "DAIVB") hd)) yt1) (list (- x bh dx) yt1) (list (- x bh) yb1)
                    (list (+ x bh) yb1) (list (+ x bh dx) yt1) (list (+ x bh dx (* (QSD:CfgN "DAIVB") hd)) yt1)))
    (setq ent (QSD:PL pts "QS_ThepChu" nil 0.0))
    (if ent (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" name "(1)_" (QSD:SM sm (strcat "V" (itoa hd))) "(2)_V;"
                                                            (QSD:Handle ent) ";(3)_" (itoa hd) "(4)_" (itoa nck) "(5)_" (itoa (nth 3 hg)))))))
    (QSD:TagPts (list (list (+ x bh) yb1) (list (+ x bh) (* -0.62 h)) (list (+ x bh (* 9 tl)) (* -0.62 h)))
                "Dce_KhtMcThepTangCuong" tl (QSD:SM sm (strcat "V" (itoa hd))) (QSD:BarTxt (nth 3 hg) hd) nil))
  ;; ---- dim hang tren: mep goi + bien vung dai ----
  (setq xs (list 0.0 ltot))
  (foreach su sups (setq xs (append xs (list (nth 1 su) (nth 2 su)))))
  (foreach z (QSD:Get "ZONES" beam) (setq xs (append xs (list (nth 3 z) (nth 4 z)))))
  (setq xs (QSD:UniqSorted xs) i 0)
  (while (< (1+ i) (length xs))
    (QSD:DimH (nth i xs) (nth (1+ i) xs) colU yDimT tl nil)
    (setq i (1+ i)))
  ;; ---- dim hang duoi: mep goi, truc, dau thanh thep duoi tang cuong ----
  (setq xs (list 0.0 ltot))
  (foreach su sups (setq xs (append xs (list (nth 1 su) (nth 2 su))))
    (if (and (QSD:CfgB "DIMMEPCOT") (> (nth 4 su) (+ (nth 1 su) 1.0)) (< (nth 4 su) (- (nth 2 su) 1.0))) (setq xs (append xs (list (nth 4 su))))))
  (foreach b bars (if (and (= (nth 0 b) "B") (/= (nth 8 b) "CHAY")) (setq xs (append xs (list (nth 4 b) (nth 5 b))))))
  (setq xs (QSD:UniqSorted xs) i 0)
  (while (< (1+ i) (length xs))
    (QSD:DimH (nth i xs) (nth (1+ i) xs) ybot yDimB tl nil)
    (setq i (1+ i)))
  ;; ---- dim thong thuy (J8 = Ltt) ----
  (if yLtt (foreach sp spans (QSD:DimH (nth 1 sp) (nth 2 sp) ybot yLtt tl nil)))
  ;; ---- dim truc - truc ----
  (setq i 0)
  (while (< (1+ i) (length sups))
    (QSD:DimH (nth 4 (nth i sups)) (nth 4 (nth (1+ i) sups)) ybot yAx tl nil)
    (setq i (1+ i)))
  ;; ---- ten nhip (khi khong an) ----
  (if (not (QSD:CfgB "ANTENNHIP"))
    (foreach sp spans
      (QSD:Text (/ (+ (nth 1 sp) (nth 2 sp)) 2.0) (+ (- h) (* -1.5 tl)) (strcat "NH\\U+1ECAP " (itoa (1+ (car sp))))
                (* 2.0 tl) "QS_Text" "C" 0.0)))
  ;; ---- dim chieu cao dam ----
  (QSD:Dim (- xsh) 0.0 (- xsh) (- h) (- (* -7 tl) xsh) (- h) (/ pi 2) nil tl)
  ;; ---- ky hieu mat cat ----
  (foreach sc (QSD:Get "SECS" beam)
    (QSD:Insert "DCE_MatCatA" (car sc) yArr tl "QS_Block" (list (cons "1" (itoa (cadr sc)))))
    (QSD:Insert "DCE_MatCatA" (car sc) (- yAx (* 7 tl)) tl "QS_Block" (list (cons "1" (itoa (cadr sc))))))
  ;; ---- ten dam (mang so lieu) ----
  (setq ent (QSD:Insert "Dce_KhTenDam" (/ ltot 2.0) (- yAx (* 15 tl)) (* 2 tl) "QS_Block"
                        (list (cons "TENDAM" (strcat "%%uD\\U+1EA6M " name " (SL=" (itoa nck) ")"))
                              (cons "TL" (strcat "TL: 1/" (QSD:Cfg "TLDOC"))))))
  (QSD:StoreData ent id beam)
  (- yAx (* 20 tl)))

(defun QSD:UniqSorted (xs / r)
  (setq r nil)
  (foreach x (QSD:Sort xs '<) (if (or (null r) (> (- x (car r)) 1.0)) (setq r (cons x r))))
  (reverse r))

;; luu so lieu tho vao xdata cua ten dam
(defun QSD:StoreData (ent id beam / s chunks)
  (setq s (QSD:RawSerialize (QSD:Get "RAW" beam)) chunks nil)
  (while (> (strlen s) 120) (setq chunks (cons (substr s 1 120) chunks) s (substr s 121)))
  (setq chunks (reverse (cons s chunks)))
  (QSD:SetXd ent *QSD-APP*
    (append (list (cons 1000 id) (cons 1000 "DATA")
                  (cons 1011 (list *QSD-BX* *QSD-BY* 0.0))   ; 1011: di chuyen theo doi tuong
                  (cons 1040 (QSD:Get "H" beam)) (cons 1040 (QSD:Get "L" beam)))
            (mapcar '(lambda (c) (cons 1000 c)) chunks))))

;;;-----------------------------------------------------------------------------
;;; 10. MAT CAT NGANG (ty le 1:1, ghi chu theo ty le TLNGANG - giong DCE)
;;;-----------------------------------------------------------------------------
(defun QSD:BarsAt (beam x)
  (vl-remove-if-not '(lambda (b) (and (<= (nth 4 b) (+ x 1e-6)) (>= (nth 5 b) (- x 1e-6)))) (QSD:Get "BARS" beam)))
(defun QSD:ZoneAt (beam x / r)
  (foreach z (QSD:Get "ZONES" beam) (if (and (>= x (nth 3 z)) (<= x (nth 4 z))) (setq r z)))
  r)

(defun QSD:SecSig (beam x / l z)
  (setq l (mapcar '(lambda (b) (strcat (nth 0 b) (itoa (nth 1 b)) (nth 8 b) "-" (itoa (nth 2 b)) "t" (itoa (nth 3 b))))
                  (QSD:BarsAt beam x)))
  (setq z (QSD:ZoneAt beam x))
  (strcat (QSD:NumStr (QSD:WidthAt beam x)) "|" (QSD:Join (QSD:Sort l '<) ",") "|" (if z (strcat (QSD:NumStr (nth 1 z)) "a" (QSD:NumStr (nth 2 z))) "")))

;; moi nhip 3 MC (goi trai / giua / phai), gop MC trung nhau
(defun QSD:MakeSecs (beam / sigs sp ln sig p num res)
  (setq sigs nil res nil num 0)
  (foreach sp (QSD:Get "SPANS" beam)
    (setq ln (nth 3 sp))
    (foreach x (list (+ (nth 1 sp) (max 150.0 (* 0.06 ln))) (/ (+ (nth 1 sp) (nth 2 sp)) 2.0)
                     (- (nth 2 sp) (max 150.0 (* 0.06 ln))))
      (setq sig (QSD:SecSig beam x))
      (if (setq p (assoc sig sigs))
        (setq res (cons (list x (cdr p) nil) res))
        (progn (setq num (1+ num) sigs (cons (cons sig num) sigs))
               (setq res (cons (list x num T) res))))))
  (reverse res))

;; toa do cac thanh trong 1 lop: grp = list (n d chay? bar) -> list (x d bar)
(defun QSD:LayerXs (grp xe / n cont adds idx res i k m)
  (setq cont nil adds nil)
  (foreach g grp (repeat (car g) (if (caddr g) (setq cont (cons (list (cadr g) (cadddr g)) cont))
                                              (setq adds (cons (list (cadr g) (cadddr g)) adds)))))
  (setq cont (reverse cont) adds (reverse adds))
  (setq n (+ (length cont) (length adds)) res nil)
  (cond
    ((= n 0) nil)
    ((= n 1) (list (cons 0.0 (car (append cont adds)))))
    (T
     (setq idx nil m (length cont) i 0)
     (repeat m
       (setq idx (cons (if (> m 1) (fix (+ 0.5 (* i (/ (float (1- n)) (1- m))))) 0) idx) i (1+ i)))
     (setq i 0)
     (repeat n
       (setq res (cons (cons (+ (- xe) (* i (/ (* 2.0 xe) (1- n))))
                             (if (or (member i idx) (null adds))
                               (progn (setq k (car cont) cont (cdr cont)) k)
                               (progn (setq k (car adds) adds (cdr adds)) k)))
                       res)
             i (1+ i)))
     (reverse res))))

;;; ---- hinh hoc thep dai / thep C: DINH GOC (toa do tuong doi) -> bo tron khi ve ----
;;;  Dinh goc = kich thuoc danh nghia (dim tren shop), bo tron ban kinh RDAI tai moi goc.
(defun QSD:V- (a b) (list (- (car a) (car b)) (- (cadr a) (cadr b))))
(defun QSD:VLen (v) (sqrt (+ (* (car v) (car v)) (* (cadr v) (cadr v)))))
(defun QSD:VUnit (v / l) (setq l (QSD:VLen v)) (if (> l 1e-9) (list (/ (car v) l) (/ (cadr v) l)) (list 1.0 0.0)))
(defun QSD:Dir (a) (list (cos a) (sin a)))
(defun QSD:PAdd (p v k) (list (+ (car p) (* k (car v))) (+ (cadr p) (* k (cadr v)))))
(defun QSD:Deg (a) (* pi (/ a 180.0)))
;; goc re co dau (rad) tu huong u sang huong v (> 0 re trai)
(defun QSD:Turn (u v) (atan (- (* (car u) (cadr v)) (* (cadr u) (car v))) (+ (* (car u) (car v)) (* (cadr u) (cadr v)))))
(defun QSD:RStir ( / r) (setq r (QSD:CfgN "RDAI")) r)

;; hinh (dinh goc, goc duoi-trai tim/ngoai = 0,0):
;;  "KIN"/"KINT" dai kin ngoai/trong w x h : DAIKIEU = DCE -> 1 doan chong thang (LCHONG) + 1 moc tai goc tren-phai
;;                                           DAIKIEU = 2MOC -> 2 moc tai goc tren-phai
;;  "UN"/"UT"   dai U bao / U trong (ho tren), moc 2 dau huong vao trong
;;  "C"         thep / dai C nam ngang dai w, dir 1 = moc len, -1 = moc xuong ; d >= BEMOCC -> thanh thang
;;  o = do lech nhanh chong (ve thay 2 nhanh; 0 = trung nhau, dung tinh chieu dai)
(defun QSD:ShpPts (kind w h d dir o / ang lh lc s0 pts hk)
  (cond
    ((wcmatch kind "KIN*")
     (setq ang (QSD:CfgN (if (= kind "KINT") "GOCTRONG" "GOCQ"))
           lh (QSD:HookLen (if (= kind "KINT") "LMOCTRONG" "LMOCNGOAI") d)
           s0 (if (> ang 91.0) (+ (QSD:RStir) (* 1.5 d)) 0.0)
           hk (QSD:Dir (- (* -0.5 pi) (QSD:Deg (- ang 90.0)))))
     (if (= (QSD:Cfg "DAIKIEU") "2MOC")
       (list (QSD:PAdd (list w (+ h o)) (QSD:Dir (+ pi (QSD:Deg (- ang 90.0)))) lh)
             (list w (+ h o)) (list w 0.0) (list 0.0 0.0) (list 0.0 h) (list w h) (QSD:PAdd (list w h) hk lh))
       (progn
         (setq lc (min (max (* (QSD:KD (QSD:Cfg "LCHONG") d) d) (* 2.0 (QSD:RStir))) (* 0.8 w)))
         (setq pts (list (list (- w lc) (+ h o)) (list w (+ h o)) (list w 0.0) (list 0.0 0.0) (list 0.0 h) (list w h)))
         (if (> s0 0) (setq pts (append pts (list (list w (- h s0))))))
         (append pts (list (QSD:PAdd (QSD:Last pts) hk lh))))))
    ;; "L1" dai 1 nhanh (dai moc): moc tren GOC1N / LMOC1N vong qua thanh tren, nhanh dung h, chan duoi 90 do LCHAN1N
    ((= kind "L1")
     (list (QSD:PAdd (list 0.0 h) (QSD:Dir (- (* 0.5 pi) (QSD:Deg (QSD:CfgN "GOC1N")))) (QSD:HookLen "LMOC1N" d))
           (list 0.0 h) (list 0.0 0.0) (list (QSD:HookLen "LCHAN1N" d) 0.0)))
    ((wcmatch kind "U*")
     (setq ang (QSD:CfgN "GOCUBAO") lh (QSD:HookLen (if (= kind "UT") "MOCUTRONG" "MOCUBAO") d))
     (list (QSD:PAdd (list 0.0 h) (QSD:Dir (- (QSD:Deg (- ang 90.0)))) lh)
           (list 0.0 h) (list 0.0 0.0) (list w 0.0) (list w h)
           (QSD:PAdd (list w h) (QSD:Dir (+ pi (QSD:Deg (- ang 90.0)))) lh)))
    ((>= d (QSD:CfgN "BEMOCC")) (list (list 0.0 0.0) (list w 0.0)))
    (T
     (list (QSD:PAdd (list 0.0 0.0) (QSD:Dir (* dir (- (* 0.5 pi) (QSD:Deg (- (QSD:CfgN "GOCCL") 90.0))))) (QSD:HookLen "LMOCCL" d))
           (list 0.0 0.0) (list w 0.0)
           (QSD:PAdd (list w 0.0) (QSD:Dir (- pi (* dir (- (* 0.5 pi) (QSD:Deg (- (QSD:CfgN "GOCCR") 90.0)))))) (QSD:HookLen "LMOCCR" d))))))

;; bo tron cac goc: -> list (x y bulge) ; ban kinh tu giam khi doan ngan
(defun QSD:Fillet (pts r / res i n p0 p1 p2 u v th tg)
  (setq n (length pts) res (list (list (car (car pts)) (cadr (car pts)) 0.0)) i 1)
  (while (< i (1- n))
    (setq p0 (nth (1- i) pts) p1 (nth i pts) p2 (nth (1+ i) pts)
          u (QSD:VUnit (QSD:V- p1 p0)) v (QSD:VUnit (QSD:V- p2 p1)) th (QSD:Turn u v))
    (if (or (< (abs th) 1e-6) (<= r 0))
      (setq res (cons (list (car p1) (cadr p1) 0.0) res))
      (progn
        (setq tg (min (* r (/ (sin (/ (abs th) 2.0)) (cos (/ (abs th) 2.0))))
                      (* 0.45 (QSD:VLen (QSD:V- p1 p0))) (* 0.45 (QSD:VLen (QSD:V- p2 p1)))))
        (setq res (cons (append (QSD:PAdd p1 u (- tg)) (list (/ (sin (/ th 4.0)) (cos (/ th 4.0))))) res))
        (setq res (cons (append (QSD:PAdd p1 v tg) (list 0.0)) res))))
    (setq i (1+ i)))
  (reverse (cons (list (car (QSD:Last pts)) (cadr (QSD:Last pts)) 0.0) res)))

;; chieu dai duong tim sau bo tron
(defun QSD:FilletLen (pts r / s i n p0 p1 p2 u v th tg)
  (setq n (length pts) s 0.0 i 0)
  (while (< i (1- n)) (setq s (+ s (QSD:VLen (QSD:V- (nth (1+ i) pts) (nth i pts)))) i (1+ i)))
  (setq i 1)
  (while (< i (1- n))
    (setq p0 (nth (1- i) pts) p1 (nth i pts) p2 (nth (1+ i) pts)
          u (QSD:VUnit (QSD:V- p1 p0)) v (QSD:VUnit (QSD:V- p2 p1)) th (QSD:Turn u v))
    (if (and (> (abs th) 1e-6) (> r 0))
      (progn
        (setq tg (min (* r (/ (sin (/ (abs th) 2.0)) (cos (/ (abs th) 2.0))))
                      (* 0.45 (QSD:VLen (QSD:V- p1 p0))) (* 0.45 (QSD:VLen (QSD:V- p2 p1)))))
        (setq s (+ s (* (/ tg (/ (sin (/ (abs th) 2.0)) (cos (/ (abs th) 2.0)))) (abs th)) (* -2.0 tg)))))
    (setq i (1+ i)))
  s)

;; ban kinh bo tron theo kich thuoc hinh
(defun QSD:ShpR (w h / r m)
  (setq r (QSD:RStir) m (cond ((and (> w 0) (> h 0)) (min w h)) ((> w 0) w) (T h)))
  (if (> (* 2 r) m) (* 0.25 m) r))
;; khoa so hieu dai trong: 1 nhanh -> theo phi ; dai kin -> theo phi + be rong + so thanh lop 1
(defun QSD:InKey (d b nl)
  (if (= (QSD:Cfg "DAITRONGKIEU") "1NHANH") (QSD:SKey "IN1N" d "")
    (QSD:SKey "IN" d (strcat (QSD:NumStr b) "|" (itoa nl)))))
;; tong cac doan thang (dinh goc)
(defun QSD:PtsLen (pts / s) (setq s 0.0)
  (while (cdr pts) (setq s (+ s (QSD:VLen (QSD:V- (cadr pts) (car pts)))) pts (cdr pts)))
  s)
;; chieu dai cat: theo tim (tru phan uon) ; dai C / dai 1 nhanh co the chon "cong doan" = cong kich thuoc
;; ngoai cac doan thang, bo qua uon (giong DCE: C 60+270+120 = 450, 1 nhanh 72+870+144 = 1085)
(defun QSD:ShpLen (kind w h d dir)
  (if (and (member kind '("C" "L1")) (= (QSD:Cfg "LCKIEU") "CONGDOAN")
           (not (and (= kind "C") (>= d (QSD:CfgN "BEMOCC")))))
    (QSD:PtsLen (QSD:ShpPts kind (if (> w 0) (+ w d) 0.0) (if (> h 0) (+ h d) 0.0) d dir 0.0))
    (QSD:FilletLen (QSD:ShpPts kind w h d dir 0.0) (QSD:ShpR w h))))
;; ve hinh, dat goc (0,0) cua hinh tai (xo, yo) ; tra ve ename
(defun QSD:ShpDraw (pts w h xo yo lay)
  (QSD:PL (mapcar '(lambda (p) (list (+ xo (car p)) (+ yo (cadr p)) (caddr p))) (QSD:Fillet pts (QSD:ShpR w h))) lay nil 0.0))
(defun QSD:LechO (d) (if (QSD:CfgB "DAILECH") d 0.0))

;; dai kin ngoai / trong ; xa<xb, ya>yb (tim dai, toa do tuong doi) ; kind "N" ngoai, "T" trong
(defun QSD:StirPL (xa xb ya yb d kind)
  (QSD:ShpDraw (QSD:ShpPts (if (= kind "T") "KINT" "KIN") (- xb xa) (- ya yb) d 1.0 (QSD:LechO d))
               (- xb xa) (- ya yb) xa yb "QS_ThepDai"))
;; dai U (T.LINK) ; kind "N" U bao, "T" U trong
(defun QSD:StirU (xa xb ya yb d kind)
  (QSD:ShpDraw (QSD:ShpPts (if (= kind "T") "UT" "UN") (- xb xa) (- ya yb) d 1.0 0.0) (- xb xa) (- ya yb) xa yb "QS_ThepDai"))
;; thep / dai C tai cao do y tu xa den xb
(defun QSD:CBar (xa xb y dir d)
  (QSD:ShpDraw (QSD:ShpPts "C" (- xb xa) 0.0 d dir 0.0) (- xb xa) 0.0 xa y "QS_ThepDai"))

(defun QSD:DrawSection (beam x num cx cy / xs tn b h hs inv sides dl z ds bars yl xe grp p pts tagL tagR ytr
                          lay y ygs rows gs sm sp inner nb cdo ctie lot lays yg1 dC mode
                          nL1 ytop ybt cvT cvB cvL cvR yST ySB xSL xSR bcx dLay dL1 xe1 yT1 tlk xin dG yA yB dct xr ydim ncT ncB
                          yB1 k xt yt2)
  (setq tn (QSD:TN) b (QSD:WidthAt beam x) h (QSD:Get "H" beam) hs (QSD:Get "HS" beam)
        inv (QSD:Get "SLABINV" beam) sides (QSD:Get "SLABSIDE" beam)
        dl (QSD:CfgN "DLMC") sm (QSD:StirMarks beam))
  (setq z (QSD:ZoneAt beam x) ds (if z (nth 1 z) 8.0))
  (setq sp nil) (foreach s1 (QSD:Get "SPANS" beam) (if (and (>= x (nth 1 s1)) (<= x (nth 2 s1))) (setq sp s1)))
  (setq tlk (and sp (nth 7 sp)))
  (setq bars (QSD:BarsAt beam x))
  (setq tagL (- cx (/ b 2.0) (* 7.5 tn)) tagR (+ cx (/ b 2.0) (* 12 tn)))
  ;; lop bao ve dai -> tim dai, tam bo thep
  (setq cvT (QSD:CfgN "BTBVT") cvB (QSD:CfgN "BTBVB") cvL (QSD:CfgN "BTBVL") cvR (QSD:CfgN "BTBVR"))
  (setq yST (- cy cvT (/ ds 2.0)) ySB (+ (- cy h) cvB (/ ds 2.0))
        xSL (+ (- cx (/ b 2.0)) cvL (/ ds 2.0)) xSR (- (+ cx (/ b 2.0)) cvR (/ ds 2.0))
        bcx (+ cx (/ (- cvL cvR) 2.0)))
  ;; ---- be tong + canh san (tai san trai/phai, san lat) + zigzag ----
  (if (and (> hs 0) (/= sides 0))
    (progn
      (setq ytop (if inv (- cy h (- hs)) cy) ybt (if inv (- cy h) (- cy hs)))
      (if inv
        (progn
          (QSD:PL (append (if (member sides '(2 3)) (list (list (+ cx (/ b 2.0) 75.0) ytop)) nil)
                          (list (list (+ cx (/ b 2.0)) ytop) (list (+ cx (/ b 2.0)) cy) (list (- cx (/ b 2.0)) cy) (list (- cx (/ b 2.0)) ytop))
                          (if (member sides '(1 3)) (list (list (- cx (/ b 2.0) 75.0) ytop)) nil))
                  "QS_BaoBeTong" nil 0.0)
          (QSD:Line (if (member sides '(1 3)) (- cx (/ b 2.0) 75.0) (- cx (/ b 2.0))) ybt
                    (if (member sides '(2 3)) (+ cx (/ b 2.0) 75.0) (+ cx (/ b 2.0))) ybt "QS_BaoBeTong"))
        (progn
          (QSD:PL (append (if (member sides '(1 3)) (list (list (- cx (/ b 2.0) 75.0) ybt)) nil)
                          (list (list (- cx (/ b 2.0)) ybt) (list (- cx (/ b 2.0)) (- cy h)) (list (+ cx (/ b 2.0)) (- cy h)) (list (+ cx (/ b 2.0)) ybt))
                          (if (member sides '(2 3)) (list (list (+ cx (/ b 2.0) 75.0) ybt)) nil))
                  "QS_BaoBeTong" nil 0.0)
          (QSD:Line (if (member sides '(1 3)) (- cx (/ b 2.0) 75.0) (- cx (/ b 2.0))) cy
                    (if (member sides '(2 3)) (+ cx (/ b 2.0) 75.0) (+ cx (/ b 2.0))) cy "QS_BaoBeTong")
          (if (not (member sides '(1 3))) (QSD:Line (- cx (/ b 2.0)) cy (- cx (/ b 2.0)) ybt "QS_BaoBeTong"))
          (if (not (member sides '(2 3))) (QSD:Line (+ cx (/ b 2.0)) cy (+ cx (/ b 2.0)) ybt "QS_BaoBeTong"))))
      (if (member sides '(1 3)) (QSD:ZigV (- cx (/ b 2.0) 75.0) (max ytop ybt) (min ytop ybt)))
      (if (member sides '(2 3)) (QSD:ZigV (+ cx (/ b 2.0) 75.0) (max ytop ybt) (min ytop ybt))))
    (QSD:PL (list (list (- cx (/ b 2.0)) cy) (list (+ cx (/ b 2.0)) cy) (list (+ cx (/ b 2.0)) (- cy h)) (list (- cx (/ b 2.0)) (- cy h)))
            "QS_BaoBeTong" T 0.0))
  ;; ---- be tong lot ----
  (if (setq lot (QSD:Get "LOT" beam))
    (QSD:PL (list (list (- cx (/ b 2.0) (cadr lot)) (- cy h)) (list (- cx (/ b 2.0) (cadr lot)) (- cy h (car lot)))
                  (list (+ cx (/ b 2.0) (cadr lot)) (- cy h (car lot))) (list (+ cx (/ b 2.0) (cadr lot)) (- cy h)))
            "QS_BaoBeTong" T 0.0))
  ;; ---- dai bao: dai kin (goc Q) hoac T.LINK = U bao + dai C mu ----
  (if tlk
    (progn (QSD:StirU xSL xSR yST ySB ds "N") (QSD:CBar xSL xSR yST -1.0 ds))
    (QSD:StirPL xSL xSR yST ySB ds "N"))
  ;; ---- thep tren / duoi theo lop ----
  (setq ytr (- cy (* 4 tn)) ygs nil lays nil nL1 0 dL1 20.0 xe1 nil yT1 nil yB1 nil ncT 0 ncB 0)
  (foreach tp '("T" "B")
    (setq lay 1)
    (repeat 5
      (setq grp nil)
      (foreach bb bars
        (if (and (= (nth 0 bb) tp) (= (nth 1 bb) lay))
          (setq grp (append grp (list (list (nth 2 bb) (nth 3 bb) (= (nth 8 bb) "CHAY") bb))))))
      (if grp
        (progn
          (setq dLay (apply 'max (mapcar 'cadr grp)))
          (setq yl (if (= tp "T") (- cy cvT ds (/ dLay 2.0) (* (1- lay) dl)) (+ (- cy h) cvB ds (/ dLay 2.0) (* (1- lay) dl))))
          (setq xe (- (/ b 2.0) (/ (+ cvL cvR) 2.0) ds (/ dLay 2.0)))
          (setq lays (cons (list tp lay yl (apply '+ (mapcar 'car grp)) dLay xe) lays))
          (if (and (= tp "T") (= lay 1)) (setq nL1 (apply '+ (mapcar 'car grp)) dL1 dLay xe1 xe yT1 yl))
          (if (and (= tp "B") (= lay 1)) (setq yB1 yl))
          (setq pts (QSD:LayerXs grp xe))
          (foreach p pts
            (QSD:Insert "Dce_McThepChu" (+ bcx (car p)) yl (float (car (cdr p))) "QS_ThepChu" nil)
            (if (/= (nth 8 (cadr (cdr p))) "CHAY") (QSD:Circle (+ bcx (car p)) yl 18.0 "QS_Dim")))
          ;; tag: thep chay suot -> ben trai ; tang cuong -> ben phai
          (foreach g grp
            (setq xs (mapcar 'car (vl-remove-if-not '(lambda (p) (equal (cadr (cdr p)) (cadddr g))) pts)))
            (if (caddr g)
              (progn
                (setq y (if (= tp "T") (+ cy (* 3 tn) (* 5 tn ncT)) (- cy h (* 3 tn) (* 5 tn ncB))))
                (if (= tp "T") (setq ncT (1+ ncT)) (setq ncB (1+ ncB)))
                (foreach xx xs (QSD:PL (list (list (+ bcx xx) yl) (list (+ bcx xx) y) (list tagL y)) "QS_Dim" nil 0.0))
                (QSD:Insert "Dce_KhtMcThepChu" tagL y tn "QS_Block"
                            (list (cons "SH" (nth 10 (cadddr g))) (cons "DKVAKC" (QSD:BarTxt (car g) (cadr g))))))
              (progn
                (setq y (if (= tp "T") (setq ytr (- ytr (* 5 tn))) (- cy h (* -5 tn) (* -5 tn (length ygs)))))
                (if (= tp "B") (setq ygs (cons y ygs)))
                (foreach xx xs (QSD:PL (list (list (+ bcx xx) yl) (list (+ bcx xx) (+ yl (if (= tp "T") -25.0 25.0)))
                                             (list (- tagR (* 2.5 tn)) (+ yl (if (= tp "T") -25.0 25.0)))) "QS_Dim" nil 0.0))
                (QSD:PL (list (list (- tagR (* 2.5 tn)) (+ yl (if (= tp "T") -25.0 25.0))) (list (- tagR (* 2.5 tn)) y) (list tagR y))
                        "QS_Dim" nil 0.0)
                (QSD:Insert "Dce_KhtMcThepTangCuongLoai2" tagR y tn "QS_Block"
                            (list (cons "SH" (nth 10 (cadddr g))) (cons "DKVAKC" (QSD:BarTxt (car g) (cadr g))))))))))
      (setq lay (1+ lay))))
  ;; ---- dai trong (dong 27 nhip, hoac tu dong khi lop 1 co >= 4 thanh): om thanh thu 2 va thu n-1 ----
  (setq inner (if (and sp (nth 6 sp)) (nth 6 sp) (if (and z (>= nL1 4)) (list ds (nth 2 z) (nth 2 z)) nil)))
  (if (and inner (>= nL1 3) xe1)
    (if (and (= (QSD:Cfg "DAITRONGKIEU") "1NHANH") yT1 yB1)
      ;; kieu DCE: 1 dai 1 nhanh sat trai moi thanh giua lop 1 tren (thanh 2 .. n-1), moc tren vong thanh tren,
      ;; chan duoi tai lop 1 duoi ; 1 tag chung ben phai
      (progn
        (setq nb (max 3 nL1) k 1 yt2 (+ (- cy h) (* 0.45 h)))
        (repeat (- nb 2)
          (setq xt (- (+ bcx (- xe1) (* k (/ (* 2.0 xe1) (1- nb)))) (/ dL1 2.0) (/ (car inner) 2.0)))
          (QSD:ShpDraw (QSD:ShpPts "L1" 0.0 (- yT1 yB1) (car inner) 1.0 0.0) 0.0 (- yT1 yB1) xt yB1 "QS_ThepDai")
          (QSD:PL (list (list xt yt2) (list tagR yt2)) "QS_Dim" nil 0.0)
          (setq k (1+ k)))
        (QSD:Insert "Dce_KhtMcThepTangCuong" tagR yt2 tn "QS_Block"
                    (list (cons "SH" (QSD:SM sm (QSD:InKey (car inner) b nL1)))
                          (cons "DKVAKC" (QSD:DaiTxt nil (car inner) (cadr inner))))))
    (progn
      (setq nb (max 3 nL1))
      (setq p (- xe1 (/ (* 2.0 xe1) (1- nb))))                      ; tam thanh thu 2
      (setq xin (+ p (/ dL1 2.0) (/ (car inner) 2.0)))
      (if tlk
        (QSD:StirU (- bcx xin) (+ bcx xin) (- yST ds) (+ ySB ds) (car inner) "T")
        (QSD:StirPL (- bcx xin) (+ bcx xin) (- yST ds) (+ ySB ds) (car inner) "T"))
      (QSD:TagPts (list (list (- bcx xin) (- cy (* 0.75 h))) (list tagL (- cy (* 0.75 h))))
                  "Dce_KhtMcThepChu" tn (QSD:SM sm (QSD:InKey (car inner) b nL1))
                  (QSD:DaiTxt nil (car inner) (cadr inner)) nil))))
  ;; ---- thep C do lop tang cuong (N2/N3): nam giua lop 1 va lop 2 ----
  (setq cdo (QSD:Get "CDO" beam))
  (if (and cdo (/= (nth 2 cdo) "KHONG"))
    (foreach tp '("T" "B")
      (setq p (vl-remove-if-not '(lambda (l) (= (car l) tp)) lays))
      (if (or (>= (length p) 2) (and (= (nth 2 cdo) "MM") p (>= (nth 3 (car p)) 2)))
        (progn
          (setq dC (if (car cdo) (car cdo) ds))
          (setq yA (nth 2 (QSD:Last p)) xe (nth 5 (QSD:Last p)))    ; lop 1 (danh sach dao nguoc)
          (setq y (if (>= (length p) 2) (/ (+ yA (nth 2 (nth (- (length p) 2) p))) 2.0)
                                        (if (= tp "T") (- yA (/ dl 2.0)) (+ yA (/ dl 2.0)))))
          (QSD:CBar (- bcx xe) (+ bcx xe) y (if (= tp "T") -1.0 1.0) dC)
          (if (QSD:CfgB "TAGCDO")
            (progn
              (setq yl (if (= tp "T") (+ cy (* 3 tn) (* 5 tn (max 1 ncT))) (- cy h (* 3 tn) (* 5 tn (max 1 ncB)))))
              (QSD:TagPts (list (list (+ bcx (* 0.4 xe)) y) (list (+ bcx (* 0.4 xe)) yl) (list tagL yl))
                          "Dce_KhtMcThepChu" tn (QSD:SM sm (QSD:SKey "CDO" 0 (QSD:BarWAt beam bars tp 2 b)))
                          (strcat "%%c" (QSD:NumStr dC) "a" (QSD:NumStr (cadr cdo))) nil)))))))
  ;; ---- thep gia + dai C noi 2 thep gia ----
  (setq gs (vl-remove-if-not '(lambda (bb) (= (nth 0 bb) "G")) bars) ctie (QSD:Get "CTIE" beam) yg1 nil)
  (if gs
    (progn
      (setq rows 0) (foreach bb gs (setq rows (max rows (nth 1 bb))))
      (setq yA (- cy cvT ds 12.0) yB (+ (- cy h) cvB ds 12.0))
      (foreach bb gs
        (setq dG (nth 3 bb))
        (setq y (- yA (* (- yA yB) (/ (float (nth 1 bb)) (1+ rows)))))
        (setq xe (- (/ b 2.0) (/ (+ cvL cvR) 2.0) ds (/ dG 2.0)))
        (foreach p (QSD:LayerXs (list (list (nth 2 bb) (nth 3 bb) T bb)) xe)
          (QSD:Insert "Dce_McThepChu" (+ bcx (car p)) y (float (nth 3 bb)) "QS_ThepChu" nil)
          (QSD:Circle (+ bcx (car p)) y 18.0 "QS_Dim"))
        (setq mode (if ctie (strcase (QSD:Trim (car ctie))) ""))
        (setq dct (if (and ctie (cadr ctie)) (cadr ctie) ds))
        (if (and (/= mode "") (/= mode "NONE")
                 (or (wcmatch mode "TO*,TOAN*") (not (wcmatch mode "SO LE*")) (= (rem (nth 1 bb) 2) 1)))
          (QSD:CBar (- bcx xe (/ dG 2.0) (/ dct 2.0)) (+ bcx xe (/ dG 2.0) (/ dct 2.0)) (- y (QSD:CfgN "KHEHOC"))
                    (if (cadddr ctie) -1.0 1.0) dct))
        (if (= (nth 1 bb) 1)
          (progn
            (setq yg1 y)
            (QSD:PL (list (list (+ bcx xe) y) (list tagL y)) "QS_Dim" nil 0.0)
            (QSD:Insert "Dce_KhtMcThepChu" tagL y tn "QS_Block"
                        (list (cons "SH" (nth 10 bb)) (cons "DKVAKC" (strcat (itoa rows) "x" (QSD:BarTxt (nth 2 bb) (nth 3 bb)))))))))
      (if (and yg1 ctie (/= (strcase (QSD:Trim (car ctie))) "") (/= (strcase (QSD:Trim (car ctie))) "NONE"))
        (QSD:TagPts (list (list (+ bcx (* 0.3 xe)) (- yg1 (QSD:CfgN "KHEHOC"))) (list (+ bcx (* 0.3 xe)) (+ yg1 (* 5 tn))) (list tagL (+ yg1 (* 5 tn))))
                    "Dce_KhtMcThepChu" tn (QSD:SM sm (QSD:SKey "CTIE" 0 (QSD:BarWAt beam bars "G" 1 b)))
                    (strcat "%%c" (QSD:NumStr dct) "a"
                            (QSD:NumStr (if (caddr ctie) (caddr ctie) (if z (nth 2 z) 200.0)))) nil))))
  ;; ---- tag dai bao ----
  (if z
    (QSD:TagPts (list (list xSL (- cy (* 0.6 h))) (list tagL (- cy (* 0.6 h))))
                "Dce_KhtMcThepChu" tn (QSD:SM sm (QSD:SKey "S" (nth 1 z) b))
                (strcat (QSD:DaiTxt nil (nth 1 z) (nth 2 z)) (if tlk " (T.LINK)" "")) nil))
  ;; ---- cao do, dim, ten MC ----
  (if (QSD:CfgB "GHICAODO")
    (QSD:Insert "Dce_CaoTrinh" (+ cx (/ b 2.0) (* 22.5 tn)) cy tn "QS_Block" (list (cons "CT" (QSD:CoteTxt (QSD:Get "COTE" beam))))))
  (setq xr (+ cx (/ b 2.0) (* 4 tn)))
  (if (QSD:CfgB "DIMMCNPHAI")
    (QSD:Dim xr cy xr (- cy h) (+ xr (* 7 tn)) (- cy h) (/ pi 2) nil tn)
    (QSD:Dim tagL cy tagL (- cy h) (- tagL (* 7 tn)) (- cy h) (/ pi 2) nil tn))
  (setq ydim (if (QSD:CfgB "DIMMCNPHAI") (+ xr (* 14 tn)) (+ xr (* 3 tn))))
  (if (and (QSD:CfgB "DIMHSAN") (> hs 0) (not inv))
    (QSD:Dim (+ cx (/ b 2.0)) cy (+ cx (/ b 2.0)) (- cy hs) ydim (- cy hs) (/ pi 2) nil tn))
  (if (QSD:CfgB "DIMBTBV")
    (progn
      (QSD:Dim (+ cx (/ b 2.0)) cy (+ cx (/ b 2.0)) (- cy cvT) (+ cx (/ b 2.0) (* 1.5 tn)) (- cy cvT) (/ pi 2) nil tn)
      (QSD:Dim (- cx (/ b 2.0)) (- cy h) (+ (- cx (/ b 2.0)) cvL) (- cy h) (+ (- cx (/ b 2.0)) cvL) (- cy h (* 1.5 tn)) 0.0 nil tn)))
  (QSD:Dim (- cx (/ b 2.0)) (- cy h (* 3 tn)) (+ cx (/ b 2.0)) (- cy h (* 3 tn)) (+ cx (/ b 2.0)) (- cy h (* 10 tn)) 0.0 nil tn)
  (QSD:Insert "Dce_KhMatCat" cx (- cy h (* 19 tn)) (* 2 tn) "QS_Block"
              (list (cons "TENMATCAT" (strcat "%%UMC " (itoa num) "-" (itoa num)))
                    (cons "TL" (if (QSD:CfgB "GHITLMCN") (strcat "TL: 1/" (QSD:Cfg "TLNGANG")) ""))))
  (+ b 1275.0))

;; hang mat cat ngang ben phai mat cat doc (giong DCE)
(defun QSD:DrawAllSections (beam / x)
  (setq x (+ (QSD:Get "L" beam) 5000.0))
  (foreach sc (QSD:Get "SECS" beam)
    (if (caddr sc)
      (setq x (+ x (QSD:DrawSection beam (car sc) (cadr sc) x 408.0)))))
  (princ))

;;;-----------------------------------------------------------------------------
;;; 10. TIM SO LIEU DAM TRONG BAN VE
;;;-----------------------------------------------------------------------------
;; truong (n)_ trong chuoi xdata DcePro
(defun QSD:DceField (s n / tag p sub e)
  (if (= (type s) 'STR)
    (progn
      (setq tag (strcat "(" (itoa n) ")_"))
      (if (setq p (vl-string-search tag s))
        (progn (setq sub (substr s (+ p (strlen tag) 1)))
               (if (setq e (vl-string-search "(" sub)) (substr sub 1 e) sub))
        ""))
    ""))

(defun QSD:DceStr (ent) (car (QSD:XdStrings ent "DcePro")))

;; tim block DCE mang so lieu tu 1 doi tuong bat ky cua dam DCE
(defun QSD:FindDceBlock (ent / nm ss i e f r n)
  (cond
    ((null ent) nil)
    ((and (= (cdr (assoc 0 (entget ent))) "INSERT") (QSD:XdStrings ent "LuuThongSoChung_SYS")) ent)
    (T
     (setq nm (QSD:DceField (QSD:DceStr ent) 0))
     (setq ss (ssget "_X" '((0 . "INSERT") (-3 ("LuuThongSoChung_SYS")))))
     (setq n (if ss (sslength ss) 0) i 0 r nil)
     (while (and (null r) (< i n))
       (setq e (ssname ss i))
       (setq f (QSD:DceFields (QSD:XdConcat e "LuuThongSoChung_SYS")))
       (if (and f (/= nm "") (= (QSD:Trim (car f)) (QSD:Trim nm))) (setq r e))
       (setq i (1+ i)))
     (if (and (null r) (= n 1) (= nm "")) (setq r (ssname ss 0)))
     r)))

;; xdata QS_DAM cua 1 doi tuong -> list cac cap (code . value)
(defun QSD:QsXd (ent / xd)
  (setq xd (cdr (assoc -3 (entget ent (list *QSD-APP*)))))
  (if xd (cdr (assoc *QSD-APP* xd)) nil))

;; tim doi tuong DATA (ten dam) theo id
(defun QSD:FindQsDataById (id / ss i n e x r)
  (setq ss (ssget "_X" (list '(0 . "INSERT,TEXT") (list -3 (list *QSD-APP*)))) n (if ss (sslength ss) 0) i 0 r nil)
  (while (and (null r) (< i n))
    (setq e (ssname ss i) x (QSD:QsXd e))
    (if (and (= (cdr (nth 0 x)) id) (= (cdr (nth 1 x)) "DATA")) (setq r e))
    (setq i (1+ i)))
  r)

;; doc DATA -> (id origin raw)
(defun QSD:ReadQsData (ent / x id org s)
  (setq x (QSD:QsXd ent))
  (if (and x (= (cdr (nth 1 x)) "DATA"))
    (progn
      (setq id (cdr (nth 0 x)) org (cdr (assoc 1011 x)) s "")
      (foreach p (QSD:Drop x 2) (if (= (car p) 1000) (setq s (strcat s (cdr p)))))
      (list id org (QSD:RawParse s)))
    nil))

(defun QSD:FindQsData (ent / x d)
  (setq x (if ent (QSD:QsXd ent) nil))
  (cond ((null x) nil)
        ((= (cdr (nth 1 x)) "DATA") (QSD:ReadQsData ent))
        ((setq d (QSD:FindQsDataById (cdr (nth 0 x)))) (QSD:ReadQsData d))
        (T nil)))

(defun QSD:PickEnt (msg / r)
  (setq r (vl-catch-all-apply 'entsel (list msg)))
  (if (or (vl-catch-all-error-p r) (null r)) nil (car r)))

(defun QSD:PrintBeam (beam / sp)
  (QSD:Msg (strcat "   Dam: " (QSD:Get "NAME" beam) "  b x h = " (QSD:NumStr (QSD:Get "B" beam)) " x "
                   (QSD:NumStr (QSD:Get "H" beam)) "  | " (itoa (length (QSD:Get "SPANS" beam))) " nhip"
                   "  | L = " (QSD:NumStr (QSD:Get "L" beam)) " mm  | " (itoa (length (QSD:Get "BARS" beam)))
                   " nhom thep chu"))
  (foreach w (QSD:Get "WARN" beam) (QSD:Msg (strcat "   ! " w)))
  (princ))

(defun QSD:HasFatal (beam / r) (foreach w (QSD:Get "WARN" beam) (if (wcmatch w "LOI*") (setq r T))) r)

;;;-----------------------------------------------------------------------------
;;; 11. LENH QS_VEDAM
;;;-----------------------------------------------------------------------------
(defun c:QS_VEDAM ( / *error* doc src raw ent dat beam p id yEnd oldEcho oldOs)
  (defun *error* (msg)
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if oldEcho (setvar "CMDECHO" oldEcho))
    (if oldOs (setvar "OSMODE" oldOs))
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*,*BREAK*")))
      (QSD:Err msg))
    (princ))
  (QSD:CfgLoad)
  (initget "Excel Dce Qsdam")
  (setq src (getkword "\nNguon so lieu dam [Excel (sheet QS_DAM / DCE_Pro_Beam dang mo)/Dce (block DCE trong ban ve)/Qsdam (dam QS da ve)] <Excel>: "))
  (if (null src) (setq src "Excel"))
  (cond
    ((= src "Excel") (setq raw (QSD:RawFromExcel)))
    ((= src "Dce")
     (setq ent (QSD:PickEnt "\nChon 1 doi tuong cua dam DCE (ten dam, thanh thep, ky hieu MC...): "))
     (if (setq ent (QSD:FindDceBlock ent))
       (setq raw (QSD:RawFromDce ent))
       (QSD:Err "Khong tim thay block DCE mang so lieu (xdata LuuThongSoChung_SYS).")))
    ((= src "Qsdam")
     (setq ent (QSD:PickEnt "\nChon ten dam / thanh thep cua dam QS_DAM: "))
     (if (setq dat (QSD:FindQsData ent)) (setq raw (caddr dat))
       (QSD:Err "Doi tuong khong mang so lieu QS_DAM."))))
  (if raw
    (progn
      (setq beam (QSD:BuildBeam raw))
      (QSD:PrintBeam beam)
      (if (QSD:HasFatal beam)
        (QSD:Err "So lieu thieu - khong ve.")
        (progn
          (setq p (getpoint "\nDiem chen (mep TREN - TRAI dam, mep ngoai goi 1): "))
          (if p
            (progn
              (setq p (trans p 1 0))
              (setq doc (QSD:Doc) oldEcho (getvar "CMDECHO") oldOs (getvar "OSMODE"))
              (setvar "CMDECHO" 0) (setvar "OSMODE" 0)
              (vla-StartUndoMark doc)
              (QSD:Setup)
              (setq *QSD-BX* (car p) *QSD-BY* (cadr p))
              (setq beam (QSD:Put "SECS" (QSD:MakeSecs beam) beam))
              (setq id (QSD:NewId))
              (setq yEnd (QSD:DrawElev beam id))
              (if (QSD:CfgB "MCNGANG") (QSD:DrawAllSections beam))
              (vla-EndUndoMark doc)
              (setvar "CMDECHO" oldEcho) (setvar "OSMODE" oldOs)
              (QSD:Msg (strcat ">> Da ve dam " (QSD:Get "NAME" beam) ". Dung QS_SHOPDAM de cat thep."))))))))
  (princ))

;;;-----------------------------------------------------------------------------
;;; 12. KHOANG (interval) - tinh toan thuan
;;;-----------------------------------------------------------------------------
;; bo khoang MO (a,b) khoi danh sach khoang dong [c,d]
(defun QSD:IvSub (ivs a b / r lo hi)
  (setq r nil)
  (foreach iv ivs
    (setq lo (car iv) hi (cadr iv))
    (if (or (<= hi a) (>= lo b)) (setq r (cons iv r))
      (progn
        (if (<= lo a) (setq r (cons (list lo a) r)))
        (if (>= hi b) (setq r (cons (list b hi) r))))))
  (QSD:Sort (reverse r) '(lambda (u v) (< (car u) (car v)))))

(defun QSD:IvClip (ivs lo hi / r)
  (foreach iv ivs
    (if (<= (max lo (car iv)) (min hi (cadr iv)))
      (setq r (cons (list (max lo (car iv)) (min hi (cadr iv))) r))))
  (QSD:Sort (reverse r) '(lambda (u v) (< (car u) (car v)))))

(defun QSD:IvIn (ivs v / r) (foreach iv ivs (if (and (>= v (- (car iv) 1e-6)) (<= v (+ (cadr iv) 1e-6))) (setq r T))) r)

;; phan bu cua ivs trong [lo,hi]
(defun QSD:IvComp (ivs lo hi / r x)
  (setq r nil x lo)
  (foreach iv (QSD:IvClip ivs lo hi)
    (if (> (car iv) x) (setq r (cons (list x (car iv)) r)))
    (setq x (max x (cadr iv))))
  (if (< x hi) (setq r (cons (list x hi) r)))
  (reverse r))

;;;-----------------------------------------------------------------------------
;;; 13. VUNG DUOC PHEP NOI (toa do x tuong doi dam)
;;;     mode NHIP: [trai + kL , phai - kL] moi nhip
;;;     mode GOI : [goi - kL(nhip trai) , goi + kL(nhip phai)] moi goi
;;;     mode TATCA: ca dam.   TIMCOT = 1: do tu tim truc, L = khoang cach truc
;;;-----------------------------------------------------------------------------
(defun QSD:SpanRefs (beam j / sups sp)
  (setq sups (QSD:Get "SUPS" beam) sp (nth j (QSD:Get "SPANS" beam)))
  (if (QSD:CfgB "TIMCOT")
    (list (nth 4 (nth j sups)) (nth 4 (nth (1+ j) sups)))
    (list (nth 1 sp) (nth 2 sp))))

(defun QSD:Zones (beam tp / mode k ivs sups spans ns ltot r a b i)
  (setq mode (QSD:Cfg (cond ((= tp "T") "TOPMODE") ((= tp "B") "BOTMODE") (T "GIAMODE")))
        k (QSD:CfgN (cond ((= tp "T") "TOPK") ((= tp "B") "BOTK") (T "GIAK")))
        sups (QSD:Get "SUPS" beam) spans (QSD:Get "SPANS" beam) ns (length spans) ltot (QSD:Get "L" beam))
  (setq ivs nil)
  (cond
    ((= mode "NHIP")
     (setq i 0)
     (repeat ns
       (setq r (QSD:SpanRefs beam i) a (+ (car r) (* k (- (cadr r) (car r)))) b (- (cadr r) (* k (- (cadr r) (car r)))))
       (if (< a b) (setq ivs (cons (list a b) ivs)))
       (setq i (1+ i))))
    ((= mode "GOI")
     (setq i 0)
     (repeat (1+ ns)
       (setq a (if (> i 0) (progn (setq r (QSD:SpanRefs beam (1- i))) (- (cadr r) (* k (- (cadr r) (car r))))) 0.0))
       (setq b (if (< i ns) (progn (setq r (QSD:SpanRefs beam i)) (+ (car r) (* k (- (cadr r) (car r))))) ltot))
       (if (< a b) (setq ivs (cons (list a b) ivs)))
       (setq i (1+ i))))
    (T (setq ivs (list (list 0.0 ltot)))))
  (setq ivs (QSD:IvClip (reverse ivs) 0.0 ltot))
  (if (QSD:CfgB "KHONGCOT")
    (foreach su sups (if (> (nth 3 su) 0) (setq ivs (QSD:IvSub ivs (nth 1 su) (nth 2 su))))))
  ivs)

;;;-----------------------------------------------------------------------------
;;; 14. THUAT TOAN CAT 1 THANH (toa do t = chieu dai trai tu dau thanh)
;;;   Lb  : chieu dai trai thanh     zt : vung noi cho phep (theo t)
;;;   Lp  : chieu dai noi chong      fb : cac khoang cam cua e (de so le)
;;;   Tra ve (dsE flag) : dsE = vi tri cuoi doan cat thu k (t) ; doan k+1 bat dau tai e-Lp
;;;   flag: nil | "SOLE" (khong so le duoc) | "NGOAIVUNG" (khong tim duoc vung noi)
;;;-----------------------------------------------------------------------------
(defun QSD:PickE (s ivs lib r / e best iv lo hi)
  (setq best nil)
  ;; 1. uu tien chieu dai trong thu vien (lon nhat truoc)
  (foreach L lib (if (and (null best) (QSD:IvIn ivs (+ s L))) (setq best (+ s L))))
  ;; 2. vi tri xa nhat, lam tron xuong theo buoc r
  (if (null best)
    (foreach iv (reverse ivs)
      (if (null best)
        (progn
          (setq lo (car iv) hi (cadr iv))
          (setq e (+ s (QSD:RoundDn (- hi s) r)))
          (if (>= e (- lo 1e-6)) (setq best e))))))
  best)

(defun QSD:CutPlan (Lb zt Lp Lp2 fb / Ls r lmin lib s es laps flag lo hi ivs e guard lu)
  ;; Lp = chieu dai noi TRONG vung cho phep, Lp2 = NGOAI vung (khi buoc phai noi ngoai vung)
  (setq Ls (QSD:CfgN "LSTOCK") r (QSD:CfgN "RNDCAT") lmin (QSD:CfgN "LMIN"))
  ;; uu tien: ca cay (Ls) -> thu vien L (lon -> nho)
  (setq lib (cons Ls (if (and (QSD:CfgB "UUTIENTV")
                               (not (and (QSD:CfgB "CATCHAN")
                                         (QSD:CfgB (if (= *QSD-CUTTP* "T") "CATCHANT" "CATCHANB")))))
              (QSD:Sort (vl-remove-if-not '(lambda (x) (and x (> x 0) (< x Ls)))
                          (mapcar 'QSD:Num (QSD:Split (QSD:Cfg "THUVIEN") ","))) '>)
              nil)))
  (setq s 0.0 es nil laps nil flag nil guard 0)
  (while (and (> (- Lb s) (+ Ls 1e-6)) (< guard 50))
    (setq guard (1+ guard) lu Lp)
    (setq lo (+ s Lp lmin) hi (min (+ s Ls) (- (+ Lb Lp) lmin)))
    ;; vung cho phep cua e: lap [e-Lp, e] nam tron trong 1 vung
    (setq ivs nil)
    (foreach z zt (if (<= (+ (car z) Lp) (cadr z)) (setq ivs (cons (list (+ (car z) Lp) (cadr z)) ivs))))
    (setq ivs (QSD:IvClip (reverse ivs) lo hi))
    (setq e nil)
    (if fb
      (progn
        (setq e (QSD:PickE s (QSD:IvClip (QSD:IvSubAll ivs fb) lo hi) lib r))
        (if (null e) (setq flag (if flag flag "SOLE")))))
    (if (null e) (setq e (QSD:PickE s ivs lib r)))
    (if (null e)
      (setq flag "NGOAIVUNG" lu Lp2
            e (+ s (QSD:RoundDn (min Ls (max (- (min (+ s Ls) (- (+ Lb Lp2) lmin)) s) (+ Lp2 r))) r))))
    (if (<= (- e lu) s) (setq e (+ s lu r) flag "NGOAIVUNG"))
    (setq es (cons e es) laps (cons lu laps) s (- e lu)))
  (list (reverse es) flag (reverse laps)))

(defun QSD:IvSubAll (ivs fb) (foreach f fb (setq ivs (QSD:IvSub ivs (car f) (cadr f)))) ivs)

;; danh sach doan (t0 t1) ; laps = chieu dai noi tung moi noi
(defun QSD:Pieces (Lb es laps / s r)
  (setq s 0.0 r nil)
  (foreach e es (setq r (cons (list s e) r) s (- e (car laps)) laps (cdr laps)))
  (reverse (cons (list s Lb) r)))

;;;-----------------------------------------------------------------------------
;;; 15. NHAN DANG THANH THEP O MAT CAT DOC
;;;   rec = (ent mark tp d n nck x1 x2 legL legR y complex name)
;;;-----------------------------------------------------------------------------
(defun QSD:EntPts (ent / ed r)
  (setq ed (entget ent))
  (cond
    ((= (cdr (assoc 0 ed)) "LINE") (list (cdr (assoc 10 ed)) (cdr (assoc 11 ed))))
    ((= (cdr (assoc 0 ed)) "LWPOLYLINE")
     (foreach p ed (if (= (car p) 10) (setq r (cons (cdr p) r))))
     (reverse r))
    (T nil)))

(defun QSD:RecogBar (ent x0 y0 / s tp d n nck pts best bl y x1 x2 thr lft rgt legL legR cx p q cpx)
  (setq s (QSD:DceStr ent))
  (setq tp (strcase (substr (QSD:DceField s 2) 1 1)))
  (if (and (member tp '("T" "B" "G")) (wcmatch (QSD:DceField s 2) "?;*"))
    (progn
      (setq d (fix (+ 0.01 (QSD:NumD (QSD:DceField s 3) 0))) n (fix (QSD:NumD (QSD:DceField s 5) 1))
            nck (fix (QSD:NumD (QSD:DceField s 4) 1)))
      (setq pts (mapcar '(lambda (p) (list (- (car p) x0) (- (cadr p) y0))) (QSD:EntPts ent)))
      (if (and (> d 0) (> (length pts) 1))
        (progn
          ;; doan ngang dai nhat
          (setq best nil bl 0.0 p (car pts))
          (foreach q (cdr pts)
            (if (and (< (abs (- (cadr q) (cadr p))) 1.0) (> (abs (- (car q) (car p))) bl))
              (setq bl (abs (- (car q) (car p))) best (list p q)))
            (setq p q))
          (if best
            (progn
              (setq y (cadr (car best)) thr (* 0.9 (QSD:HookMin d)))
              (setq x1 (apply 'min (mapcar 'car pts)) x2 (apply 'max (mapcar 'car pts)))
              (setq legL 0.0 legR 0.0 cpx nil)
              (foreach p pts
                (setq cx (- (cadr p) y))
                (cond
                  ((<= (car p) (+ x1 60.0)) (if (> (abs cx) (abs legL)) (setq legL cx)))
                  ((>= (car p) (- x2 60.0)) (if (> (abs cx) (abs legR)) (setq legR cx)))
                  ((> (abs cx) 60.0) (setq cpx T))))
              (if (< (abs legL) thr) (setq legL 0.0))
              (if (< (abs legR) thr) (setq legR 0.0))
              (list ent (QSD:DceField s 1) tp d (max 1 n) (max 1 nck) x1 x2 legL legR y cpx (QSD:DceField s 0)))
            nil))
        nil))
    nil))

;; do tim goc dam DCE: mep ngoai goi 1 (min x) va mat tren dam (max y net ngang)
;; do tim goc dam DCE: mep ngoai goi 1 (min x) va mat tren dam (max y net ngang
;; nam trong pham vi chieu dai dam - bo qua net be tong cua mat cat ngang)
(defun QSD:FindOrigin (ss ltot / i e ed segs pts xmin ymax lay p q)
  (setq i 0 xmin nil ymax nil segs nil)
  (repeat (sslength ss)
    (setq e (ssname ss i) ed (entget e) lay (strcase (cdr (assoc 8 ed))))
    (if (and (wcmatch lay "*BAOBETONG*") (setq pts (QSD:EntPts e)))
      (setq segs (cons pts segs)))
    (setq i (1+ i)))
  ;; x min: diem trai nhat cua cum net dai nhat theo phuong ngang
  (foreach pts segs (foreach p pts (if (or (null xmin) (< (car p) xmin)) (setq xmin (car p)))))
  (if xmin
    (foreach pts segs
      (setq p (car pts))
      (foreach q (cdr pts)
        (if (and (< (abs (- (cadr q) (cadr p))) 0.5) (> (abs (- (car q) (car p))) 100.0)
                 (>= (min (car p) (car q)) (- xmin 1.0)) (<= (max (car p) (car q)) (+ xmin ltot 1.0)))
          (if (or (null ymax) (> (cadr q) ymax)) (setq ymax (cadr q))))
        (setq p q))))
  (if (and xmin ymax) (list xmin ymax) nil))

(defun QSD:SSBox (ss / i ed mn mx p)
  ;; khong dung vla-GetBoundingBox (loi safearray khi goi gian tiep) - lay cac diem 10/11
  (setq i 0 mn nil mx nil)
  (repeat (sslength ss)
    (setq ed (entget (ssname ss i)))
    (foreach g ed
      (if (and (member (car g) '(10 11)) (listp (cdr g)) (numberp (cadr g)))
        (setq p (cdr g)
              mn (if mn (list (min (car mn) (car p)) (min (cadr mn) (cadr p))) (list (car p) (cadr p)))
              mx (if mx (list (max (car mx) (car p)) (max (cadr mx) (cadr p))) (list (car p) (cadr p))))))
    (setq i (1+ i)))
  (if mn (list mn mx) nil))

;;;-----------------------------------------------------------------------------
;;; 16. CAT 1 NHOM THANH (so le 2 nhom A / B)
;;;   tra ve list nhom: (qty pieces es flag) ; pieces theo t
;;;-----------------------------------------------------------------------------
;; chieu dai noi: bang mm (uu tien) hoac he so x d ; inside = T trong vung / nil ngoai vung
;; cot bang: T / B / G / Random (Random dung cho thanh khong thuoc 3 loai tren)
(defun QSD:LapLen (tp d inside / c col tbl p best k)
  (setq c (QSD:CfgN "COUPLER"))
  (setq col (cond ((= tp "T") 1) ((= tp "B") 2) ((= tp "G") 3) (T 4)))
  (cond
    ((and (> c 0) (>= d c)) 0.0)
    ((and (QSD:CfgB "UUTIENLAPMM") (setq tbl (QSD:ParseLapMM (QSD:Cfg (if inside "LAPMM1" "LAPMM2")))))
     (if (setq p (assoc (fix (+ d 0.01)) tbl)) (float (nth col p))
       (progn (setq best (car tbl))
              (foreach it tbl (if (< (abs (- (car it) d)) (abs (- (car best) d))) (setq best it)))
              (QSD:RoundUp (* d (/ (float (nth col best)) (car best))) 10.0))))
    (T (setq k (QSD:ParseFracs (QSD:Cfg (if inside "LAPKD1" "LAPKD2"))))
       (* d (if (nth (1- col) k) (nth (1- col) k) 40.0)))))

;; vi tri moi noi BAT BUOC (tam doan noi, toa do x) cua loai thep tp:
;;  co "cat thep" o nhip (dong 27 nhip: T B TL TR BL BR ; F5 "/T/B") -> dat giua phan vung noi
;;  cho phep nam trong nhip (L = trai, R = phai ; "B" = ben trai)
(defun QSD:ForcedX (beam tp / r zs ivs sp c side iv)
  (setq r nil zs (QSD:Zones beam tp))
  (foreach sp (QSD:Get "SPANS" beam)
    (foreach c (nth 5 sp)
      (if (= (substr c 1 1) tp)
        (progn
          (setq side (if (> (strlen c) 1) (substr c 2 1) (if (= tp "B") "L" "")))
          (setq ivs (QSD:IvClip zs (nth 1 sp) (nth 2 sp)))
          (setq iv (cond ((null ivs) nil) ((= side "R") (QSD:Last ivs)) (T (car ivs))))
          (if (null iv) (setq iv (list (nth 1 sp) (nth 2 sp))))
          (setq r (cons (/ (+ (car iv) (cadr iv)) 2.0) r))))))
  (QSD:Sort r '<))

;; cat 1 thanh co moi noi bat buoc: tach thanh cac doan tai moi noi bat buoc, moi doan cat binh thuong
(defun QSD:CutSeg (Lb zt Lp Lp2 fb forced / segs s e r es laps flag sub off zt2 fb2)
  (if (null forced)
    (QSD:CutPlan Lb zt Lp Lp2 fb)
    (progn
      (setq s 0.0 es nil laps nil flag nil)
      (foreach tc (append forced (list nil))
        (setq e (if tc (+ tc (/ Lp 2.0)) Lb))
        (setq zt2 (mapcar '(lambda (z) (list (- (car z) s) (- (cadr z) s))) zt)
              fb2 (mapcar '(lambda (z) (list (- (car z) s) (- (cadr z) s))) fb))
        (setq sub (QSD:CutPlan (- e s) zt2 Lp Lp2 fb2))
        (setq es (append es (mapcar '(lambda (x) (+ x s)) (car sub))) laps (append laps (caddr sub)))
        (if (cadr sub) (setq flag (cadr sub)))
        (if tc (setq es (append es (list e)) laps (append laps (list Lp)) s (- e Lp))))
      (list es flag laps))))

(defun QSD:CutRec (beam rec / tp d n x1 x2 lL lR Lb zx zt Lp Lp2 gap nA nB pa pb fb res fx)
  (setq tp (nth 2 rec) d (nth 3 rec) n (nth 4 rec) x1 (nth 6 rec) x2 (nth 7 rec)
        lL (abs (nth 8 rec)) lR (abs (nth 9 rec)) *QSD-CUTTP* tp)
  (setq Lb (+ lL (- x2 x1) lR))
  (setq Lp (QSD:LapLen tp d T) Lp2 (QSD:LapLen tp d nil) gap (* (QSD:CfgN "GAPD") d))
  ;; moi noi bat buoc nam trong thanh (cach 2 dau >= Lmin)
  (setq fx nil)
  (foreach x (QSD:ForcedX beam tp)
    (if (and (> x (+ x1 (QSD:CfgN "LMIN") (/ Lp 2.0))) (< x (- x2 (QSD:CfgN "LMIN") (/ Lp 2.0))))
      (setq fx (append fx (list (+ lL (- x x1)))))))
  (if (or (and (<= Lb (QSD:CfgN "LSTOCK")) (null fx)) (nth 11 rec))
    (list (list n (list (list 0.0 Lb)) nil (if (and (nth 11 rec) (> Lb (QSD:CfgN "LSTOCK"))) "PHUCTAP" nil)))
    (progn
      (setq zx (QSD:Zones beam tp))
      (setq zt (mapcar '(lambda (z) (list (+ lL (- (car z) x1)) (+ lL (- (cadr z) x1))))
                       (QSD:IvClip zx x1 x2)))
      (if (and (QSD:CfgB "SOLE") (> n 1))
        (setq nA (QSD:Ceil (/ n 2.0)) nB (- n nA))
        (setq nA n nB 0))
      (setq pa (QSD:CutSeg Lb zt Lp Lp2 nil fx))
      (setq res (list (list nA (QSD:Pieces Lb (car pa) (caddr pa)) (car pa) (cadr pa))))
      (if (> nB 0)
        (progn
          (setq fb (mapcar '(lambda (e l) (list (- e l gap) (+ e gap Lp))) (car pa) (caddr pa)))
          (setq pb (QSD:CutSeg Lb zt Lp Lp2 fb fx))
          (setq res (append res (list (list nB (QSD:Pieces Lb (car pb) (caddr pb)) (car pb) (cadr pb)))))))
      res)))

;; noi cac doan thanh cung so hieu / loai / phi / cao do, khe ho <= KCJOIN (thanh bi ve tach doan)
(defun QSD:JoinRecs (recs / kc out done a b m)
  (setq kc (QSD:CfgN "KCJOIN") out nil)
  (setq recs (QSD:Sort recs '(lambda (a b) (< (nth 6 a) (nth 6 b)))))
  (while recs
    (setq a (car recs) recs (cdr recs) done nil)
    (while (not done)
      (setq m nil)
      (foreach b recs
        (if (and (null m) (= (nth 1 a) (nth 1 b)) (= (nth 2 a) (nth 2 b)) (= (nth 3 a) (nth 3 b)) (= (nth 4 a) (nth 4 b))
                 (< (abs (- (nth 10 a) (nth 10 b))) 1.0) (>= (nth 6 b) (- (nth 7 a) 1.0)) (<= (- (nth 6 b) (nth 7 a)) kc)
                 (= (nth 9 a) 0.0) (= (nth 8 b) 0.0))
          (setq m b)))
      (if m
        (setq a (list (nth 0 a) (nth 1 a) (nth 2 a) (nth 3 a) (nth 4 a) (nth 5 a) (nth 6 a) (nth 7 m)
                      (nth 8 a) (nth 9 m) (nth 10 a) (or (nth 11 a) (nth 11 m)) (nth 12 a))
              recs (vl-remove m recs))
        (setq done T)))
    (setq out (cons a out)))
  (reverse out))

;; hinh dang 1 doan (t0 t1) cua thanh rec -> (a b c) = chan trai, doan ngang, chan phai (co dau)
(defun QSD:PieceShape (rec t0 t1 / lL lR hl a c b)
  (setq lL (abs (nth 8 rec)) lR (abs (nth 9 rec)) hl (- (nth 7 rec) (nth 6 rec)))
  (setq a (if (< t0 lL) (- lL t0) 0.0))
  (setq c (if (> t1 (+ lL hl)) (- t1 lL hl) 0.0))
  (setq b (- (min t1 (+ lL hl)) (max t0 lL)))
  (list (if (< (nth 8 rec) 0) (- a) a) (max 0.0 b) (if (< (nth 9 rec) 0) (- c) c)
        (+ (nth 6 rec) (max 0.0 (- t0 lL)))))          ; x bat dau doan ngang

;;;-----------------------------------------------------------------------------
;;; 17. VE SHOP
;;;-----------------------------------------------------------------------------
(defun QSD:RndCT (x) (QSD:Round x (if (QSD:CfgB "RNDTKTCT") (QSD:CfgN "RNDTKT") 1.0)))
(defun QSD:RndTot (x) (QSD:Round x (QSD:CfgN "RNDTKT")))
(defun QSD:ShapeTxt (sh / l)
  (setq l nil)
  (if (/= (car sh) 0.0) (setq l (cons (QSD:NumStr (QSD:RndCT (abs (car sh)))) l)))
  (setq l (cons (QSD:NumStr (QSD:RndCT (cadr sh))) l))
  (if (/= (caddr sh) 0.0) (setq l (cons (QSD:NumStr (QSD:RndCT (abs (caddr sh)))) l)))
  (QSD:Join (reverse l) "+"))

;; ve 1 doan tai cao do y (tuyet doi, x tuong doi)
;; ve 1 doan tai cao do y (x tuong doi), dang DCE (vat goc + gach dau thanh)
(defun QSD:DrawPiece (sh y din / xa xb)
  (setq xa (nth 3 sh) xb (+ (nth 3 sh) (cadr sh)))
  (QSD:PL (QSD:BarPts xa xb y (car sh) (caddr sh) din) "QS_ThepShop" nil 0.0))

;; chieu cao chan lon nhat (theo dau) trong cac hang
(defun QSD:RowsLeg (rows sg / m)
  (setq m 0.0)
  (foreach rowl rows
    (foreach it rowl
      (foreach l (list (nth 8 (car it)) (nth 9 (car it)))
        (if (> (* sg l) m) (setq m (* sg l))))))
  m)

;; ve 1 dai shop giong DCE: khung + o ten ben trai, vung DUOC PHEP NOI (net khuat + hatch),
;; tung doan: dim chieu dai, dim chan, tag "n%%cd (L=...)", dim doan noi + ellipse.
;; dir = 1: dai tren (dat tu yBase len), -1: dai duoi (tu yBase xuong)
;; kieu thep cho tai dau side ("L"/"R") cua loai thep tp: "THANG" / "COUPLER" / nil
(defun QSD:ChoKind (beam side tp / r)
  (foreach c (QSD:Get "CHO" beam)
    (if (and (= (car c) side) (= (nth 2 c) tp) (member (nth 1 c) '("THANG" "COUPLER"))) (setq r (nth 1 c))))
  r)
;; ky hieu coupler (hop 80 x 50) tai dau thanh
(defun QSD:CplBox (x y)
  (QSD:PL (list (list (- x 40.0) (+ y 25.0)) (list (+ x 40.0) (+ y 25.0)) (list (+ x 40.0) (- y 25.0)) (list (- x 40.0) (- y 25.0)))
          "QS_Symbol" T 0.0))

(defun QSD:DrawBand (beam rows yBase dir label tp id / tl ltot n dn up pitch y0 yb yt ys y k rowl it rec gi pcs pk sh
                        ey eyn ent lp e1 flag din xm txt pc2 sh2 ylo xlo xhi tps side x0 sg kd)
  (setq tl (QSD:TL) ltot (QSD:Get "L" beam) n (length rows)
        dn (QSD:RowsLeg rows -1.0) up (QSD:RowsLeg rows 1.0))
  (setq pitch (max (* 20.0 tl) (+ (max dn up) 95.0)))
  (if (= dir 1)
    (setq yb yBase y0 (+ yBase dn (* 12 tl) (* pitch (1- n))) yt (+ y0 up (* 25 tl)))
    (setq yt yBase y0 (- yBase up (* 25 tl)) yb (- y0 (* pitch (1- n)) dn (* 15 tl))))
  (setq din (if (= tp "T") -1.0 1.0))
  ;; khung + o nhan (mo rong khi co thep cho 2 dau)
  (setq xlo -370.0 xhi ltot)
  (foreach rowl rows (foreach it rowl (setq xlo (min xlo (nth 6 (car it))) xhi (max xhi (nth 7 (car it))))))
  (setq xlo (- (min 0.0 xlo) 1270.0) xhi (+ (max ltot xhi) 120.0))
  (QSD:PL (list (list xlo yt) (list xhi yt) (list xhi yb) (list xlo yb)) "QS_Dim" T 0.0)
  (QSD:PL (list (list xlo yt) (list (+ xlo 900.0) yt) (list (+ xlo 900.0) yb) (list xlo yb)) "QS_Dim" T 0.0)
  (QSD:MText (+ xlo 450.0) (/ (+ yt yb) 2.0) label (* 2.5 tl) "QS_Text")
  (setq *QSD-BANDS* (append *QSD-BANDS* (list (list tp xlo yb xhi yt))))
  ;; vung duoc phep noi
  (foreach iv (QSD:Zones beam tp)
    (QSD:PL (list (list (car iv) yt) (list (cadr iv) yt) (list (cadr iv) yb) (list (car iv) yb)) "QS_NetKhuat" T 0.0)
    (QSD:HatchRect (car iv) (cadr iv) yb yt "QS_Hatch"))
  ;; thep cho 2 dau dam: duong MACH NGUNG + ghi chu (cho thang / coupler)
  (if (QSD:CfgB "CHOSHOP")
    (progn
      (setq tps nil)
      (foreach rowl rows (foreach it rowl (if (not (member (nth 2 (car it)) tps)) (setq tps (cons (nth 2 (car it)) tps)))))
      (foreach side '("L" "R")
        (setq kd nil)
        (foreach t1 tps (if (QSD:ChoKind beam side t1) (setq kd (QSD:ChoKind beam side t1))))
        (if kd
          (progn
            (setq x0 (if (= side "L") 0.0 ltot) sg (if (= side "L") -1.0 1.0))
            (QSD:Line x0 yt x0 yb "QS_Symbol")
            (QSD:Text (+ x0 (* sg 1.2 tl)) (/ (+ yt yb) 2.0)
                      (strcat "M\\U+1EA0CH NG\\U+1EEANG - " (QSD:ChoLab beam side kd))
                      (* 1.8 tl) "QS_Symbol" "M" (/ pi 2)))))))
  ;; tung hang
  (setq k 0)
  (foreach rowl rows
    (setq y (- y0 (* pitch k)))
    (foreach it rowl
      (setq rec (car it) gi (cadr it) pcs (nth 1 gi) pk 0)
      (foreach pc pcs
        (setq sh (QSD:PieceShape rec (car pc) (cadr pc)))
        (setq ey (+ y (* 70.0 (rem pk 2))))
        (setq ent (QSD:DrawPiece sh ey din))
        (if ent
          (progn
            (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" (QSD:Get "NAME" beam) "(1)_" (nth 4 pc) "(2)_" (QSD:Handle ent) ";"
                                                             "(3)_" (itoa (nth 3 rec)) "(4)_" (itoa (QSD:Get "NCK" beam)) "(5)_" (itoa (car gi))))))
            (QSD:SetXd ent *QSD-APP* (list (cons 1000 id) (cons 1000 "SHOP") (cons 1000 (nth 4 pc))))))
        ;; coupler tai dau thanh trung mep dam (thep cho kieu COUPLER)
        (if (QSD:CfgB "CHOSHOP")
          (progn
            (if (and (= (car sh) 0.0) (<= (nth 3 sh) 1.0) (= (QSD:ChoKind beam "L" (nth 2 rec)) "COUPLER"))
              (QSD:CplBox (nth 3 sh) ey))
            (if (and (= (caddr sh) 0.0) (>= (+ (nth 3 sh) (cadr sh)) (- ltot 1.0)) (= (QSD:ChoKind beam "R" (nth 2 rec)) "COUPLER"))
              (QSD:CplBox (+ (nth 3 sh) (cadr sh)) ey))))
        ;; dim chieu dai + chan
        (if (QSD:CfgB "DIMDV") (QSD:DimH (nth 3 sh) (+ (nth 3 sh) (cadr sh)) ey (+ ey (* 2 tl)) tl nil))
        (if (and (QSD:CfgB "DIMDV") (/= (car sh) 0.0))
          (QSD:Dim (nth 3 sh) ey (nth 3 sh) (+ ey (car sh)) (+ (nth 3 sh) (* 2 tl)) (+ ey (car sh)) (/ pi 2) nil tl))
        (if (and (QSD:CfgB "DIMDV") (/= (caddr sh) 0.0))
          (QSD:Dim (+ (nth 3 sh) (cadr sh)) ey (+ (nth 3 sh) (cadr sh)) (+ ey (caddr sh))
                   (- (+ (nth 3 sh) (cadr sh)) (* 2 tl)) (+ ey (caddr sh)) (/ pi 2) nil tl))
        ;; tag
        (setq xm (+ (nth 3 sh) (/ (cadr sh) 2.0)))
        (setq ent (QSD:Insert "Dce_KhtThepDai2" xm ey tl "QS_Block"
                    (list (cons "SH" (nth 4 pc))
                          (cons "DKVAKC" (strcat (QSD:BarTxtN (car gi) (nth 3 rec)) " (L="
                                                 (QSD:NumStr (QSD:RndTot (- (cadr pc) (car pc)))) ")")))))
        (if ent (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" (QSD:Get "NAME" beam) "(1)_" (nth 4 pc) "(2)_(3)_"
                                                                (itoa (nth 3 rec)) "(4)_" (itoa (QSD:Get "NCK" beam)) "(5)_" (itoa (car gi)))))))
        ;; moi noi voi doan sau
        (if (< pk (1- (length pcs)))
          (progn
            (setq e1 (+ (nth 3 sh) (cadr sh)) eyn (+ y (* 70.0 (rem (1+ pk) 2))) ylo (min ey eyn)
                  lp (- (cadr pc) (car (nth (1+ pk) pcs))))
            (if (> lp 0)
              (progn
                (QSD:DimH (- e1 lp) e1 ylo (- ylo (* 6.5 tl)) tl nil)
                (QSD:Ellipse (- e1 (/ lp 2.0)) (/ (+ ey eyn) 2.0) (* 2.8 tl) 0.6 "QS_Symbol"))
              (QSD:PL (list (list (- e1 (* 2 tl)) (- ylo 50.0)) (list (+ e1 (* 2 tl)) (- ylo 50.0))
                            (list (+ e1 (* 2 tl)) (+ ylo 120.0)) (list (- e1 (* 2 tl)) (+ ylo 120.0)))
                      "QS_Symbol" T 0.0))))
        (setq pk (1+ pk)))
      (if (setq flag (nth 3 gi))
        (QSD:Text (- (nth 6 rec) (* 3 tl)) y (cond ((= flag "SOLE") "KHONG SO LE DUOC")
                                                  ((= flag "PHUCTAP") "HINH PHUC TAP - CHUA CAT")
                                                  (T "NOI NGOAI VUNG CHO PHEP"))
                  (* 2.0 tl) "QS_Symbol" "R" 0.0)))
    (setq k (1+ k)))
  (if (= dir 1) yt yb))

;; xep nhieu thanh khong chong nhau vao chung 1 hang shop (thanh da cat chiem ca hang)
(defun QSD:PackRows (items / rows ext placed m)
  (setq rows nil m (* 3.0 (QSD:TH)))
  (foreach it items
    (setq ext (list (- (nth 6 (car it)) m) (+ (nth 7 (car it)) m)) placed nil)
    (if (= (length (nth 1 (cadr it))) 1)
      (setq rows (mapcar '(lambda (r)
                             (if (and (not placed) (car r)
                                      (not (vl-remove-if-not '(lambda (e) (and (< (car ext) (cadr e)) (> (cadr ext) (car e)))) (cadr r))))
                               (progn (setq placed T) (list T (cons ext (cadr r)) (append (caddr r) (list it))))
                               r))
                         rows)))
    (if (not placed)
      (setq rows (append rows (list (list (= (length (nth 1 (cadr it))) 1) (list ext) (list it)))))))
  (mapcar 'caddr rows))

;; gan so hieu doan: moi so hieu goc, moi hinh dang khac nhau -> mark.1, mark.2 ...
;; groups: list (rec grp) ; tra ve (rows items) : pieces duoc them (t0 t1 ... mark)
(defun QSD:AssignMarks (lst / out shapes key p sh mk items k newpcs cnt)
  (setq out nil items nil)
  (foreach row lst
    (setq shapes (QSD:Get (nth 1 (car row)) items))
    (setq newpcs nil)
    (foreach pc (nth 1 (cadr row))
      (setq sh (QSD:PieceShape (car row) (car pc) (cadr pc)))
      (setq key (strcat (itoa (nth 3 (car row))) "|" (QSD:NumStr (QSD:Round (car sh) 1.0)) "|"
                        (QSD:NumStr (QSD:Round (cadr sh) 1.0)) "|" (QSD:NumStr (QSD:Round (caddr sh) 1.0))))
      (if (setq p (assoc key shapes))
        (setq mk (cadr p) shapes (subst (list key mk (+ (caddr p) (car (cadr row))) (nth 3 p) (nth 4 p)) p shapes))
        (progn
          (setq cnt (1+ (length shapes)))
          (setq mk (if (and (= (length (nth 1 (cadr row))) 1) (null (assoc (nth 1 (car row)) items)) (null shapes))
                     (nth 1 (car row)) (strcat (nth 1 (car row)) "." (itoa cnt))))
          (setq shapes (append shapes (list (list key mk (car (cadr row)) sh (car row)))))))
      (setq newpcs (cons (append (QSD:Take pc 2) (list nil nil mk)) newpcs)))
    (setq items (QSD:Put (nth 1 (car row)) shapes items))
    (setq out (cons (list (car row) (list (car (cadr row)) (reverse newpcs) (nth 2 (cadr row)) (nth 3 (cadr row)))) out)))
  (list (reverse out) items))

;; xep cac doan vao cay thep (First Fit Decreasing) -> so cay
(defun QSD:PackCount (lens Ls / bins placed)
  (setq bins nil)
  (foreach L (QSD:Sort lens '>)
    (setq placed nil)
    (setq bins (mapcar '(lambda (b) (if (and (not placed) (<= L (+ b 1e-6))) (progn (setq placed T) (- b L)) b)) bins))
    (if (not placed) (setq bins (append bins (list (- Ls L))))))
  (length bins))

;; ---- thong ke thep dai / thep C (chieu dai cat theo duong tim, moc theo cai dat) ----
;; tra ve list (mark d hinhdang L sl/ck nck hinh) ; hinh = (kind w h d dir) theo duong tim (xem QSD:ShpPts)
(defun QSD:DaiSched (beam / sm nck h cvT cvB cvL cvR r add cs w hh b x bars nL1 dL1 xe1 p xin inner sp tlk zc n
                        ctie dct gs rows s cdo dC lays lay tp cnt gc ds)
  (setq sm (QSD:StirMarks beam) nck (QSD:Get "NCK" beam) h (QSD:Get "H" beam)
        cvT (QSD:CfgN "BTBVT") cvB (QSD:CfgN "BTBVB") cvL (QSD:CfgN "BTBVL") cvR (QSD:CfgN "BTBVR") r nil)
  ;; spec = (kind w h d dir) -> chieu dai tinh tu hinh
  (defun QSD:_sadd (mk d txt spec q / key e L)
    (setq L (QSD:RndTot (apply 'QSD:ShpLen spec)) key (strcat mk "|" (itoa (fix d)) "|" (QSD:NumStr L)))
    (if (setq e (assoc key r))
      (setq r (subst (list key mk d txt L (+ (nth 5 e) q) spec) e r))
      (setq r (append r (list (list key mk d txt L q spec))))))
  (defun QSD:_txt (pre w hh ang len) (strcat pre (QSD:NumStr (QSD:RndCT w)) "x" (QSD:NumStr (QSD:RndCT hh))
                                             " Q" (QSD:NumStr ang) " m" (QSD:NumStr (QSD:RndCT len))))
;; dai trong / dai 1 nhanh tai vi tri x (nhip sp), ds = phi dai ngoai tai do ;
  ;; q0 = so dai ngoai ; sz = buoc dai ngoai (nil = moi dai ngoai 1 bo dai trong, dung cho dai gia cuong dam phu)
  (defun QSD:_inadd (x ds sp q0 sz / b hh tlk bars nL1 dL1 inner xe1 p xin cnt)
    (setq b (QSD:WidthAt beam x) hh (- h cvT cvB ds) tlk (nth 7 sp))
    (setq bars (QSD:BarsAt beam x) nL1 0 dL1 0)
    (foreach bb bars (if (and (= (car bb) "T") (= (nth 1 bb) 1)) (setq nL1 (+ nL1 (nth 2 bb)) dL1 (max dL1 (nth 3 bb)))))
    (setq inner (if (nth 6 sp) (nth 6 sp) (if (>= nL1 4) (list ds (if sz sz 100.0) (if sz sz 100.0)) nil)))
    (if (and inner (>= nL1 3))
      (progn
        (setq xe1 (- (/ b 2.0) (/ (+ cvL cvR) 2.0) ds (/ dL1 2.0)) p (- xe1 (/ (* 2.0 xe1) (1- (max 3 nL1)))))
        (setq xin (* 2.0 (+ p (/ dL1 2.0) (/ (car inner) 2.0))))
        (setq cnt (if sz (max 1 (fix (+ 0.5 (* q0 (/ (float sz) (max 1.0 (nth 1 inner))))))) q0))
        (cond
          ;; dai 1 nhanh (DCE): moi thanh giua lop 1 tren 1 dai ; chieu cao = chieu cao dai ngoai (tim)
          ((= (QSD:Cfg "DAITRONGKIEU") "1NHANH")
           (QSD:_sadd (QSD:SM sm (QSD:InKey (car inner) b nL1)) (car inner)
                      (strcat "1 nhanh h" (QSD:NumStr (QSD:RndCT hh)) " Q" (QSD:Cfg "GOC1N")
                              " m" (QSD:NumStr (QSD:RndCT (QSD:HookLen "LMOC1N" (car inner))))
                              " c" (QSD:NumStr (QSD:RndCT (QSD:HookLen "LCHAN1N" (car inner)))))
                      (list "L1" 0.0 hh (car inner) 1.0) (* cnt (- (max 3 nL1) 2))))
          (tlk
           (QSD:_sadd (QSD:SM sm (QSD:InKey (car inner) b nL1)) (car inner)
                      (strcat "U " (QSD:NumStr (QSD:RndCT xin)) "x" (QSD:NumStr (QSD:RndCT (- hh (* 2 ds)))))
                      (list "UT" xin (- hh (* 2 ds)) (car inner) 1.0) cnt))
          (T
           (QSD:_sadd (QSD:SM sm (QSD:InKey (car inner) b nL1)) (car inner)
                      (QSD:_txt "" xin (- hh (* 2 ds)) (QSD:CfgN "GOCTRONG") (QSD:HookLen "LMOCTRONG" (car inner)))
                      (list "KINT" xin (- hh (* 2 ds)) (car inner) 1.0) cnt))))))
  (foreach z (QSD:Get "ZONES" beam)
    ;; z = (j d s x0 x1 xa xb n)
    (setq sp (nth (car z) (QSD:Get "SPANS" beam)) tlk (nth 7 sp) zc (/ (+ (nth 3 z) (nth 4 z)) 2.0)
          b (QSD:WidthAt beam zc) ds (nth 1 z) n (nth 7 z))
    (if (not (QSD:CfgB "KHONGTRUDAI"))
      (foreach s1 (QSD:Get "SB" beam)
        (if (and (= (car s1) (car z)) (> (nth 1 s1) (nth 3 z)) (< (nth 1 s1) (nth 4 z)))
          (setq n (max 1 (- n (fix (/ (nth 2 s1) (nth 2 z)))))))))
    (setq w (- b cvL cvR ds) hh (- h cvT cvB ds))
    ;; dai ngoai
    (if tlk
      (progn
        (QSD:_sadd (QSD:SM sm (QSD:SKey "S" ds b)) ds
                   (strcat "U " (QSD:NumStr (QSD:RndCT w)) "x" (QSD:NumStr (QSD:RndCT hh)))
                   (list "UN" w hh ds 1.0) n)
        (QSD:_sadd (QSD:SM sm (QSD:SKey "S" ds b)) ds (strcat "C " (QSD:NumStr (QSD:RndCT w)))
                   (list "C" w 0.0 ds -1.0) n))
      (QSD:_sadd (QSD:SM sm (QSD:SKey "S" ds b)) ds
                 (QSD:_txt "" w hh (QSD:CfgN "GOCQ") (QSD:HookLen "LMOCNGOAI" ds))
                 (list "KIN" w hh ds 1.0) n))
    ;; dai trong
    (QSD:_inadd zc ds sp n (nth 2 z)))
  ;; dai gia cuong tai dam giao (cung hinh dai ngoai nhip do)
  (foreach s1 (QSD:Get "SB" beam)
    (if (setq gc (nth 4 s1))
      (progn
        (setq b (QSD:WidthAt beam (nth 1 s1)) ds (cadr gc) w (- b cvL cvR ds) hh (- h cvT cvB ds))
        (QSD:_sadd (QSD:SM sm (QSD:SKey "S" (cadr gc) b)) ds
                   (QSD:_txt "" w hh (QSD:CfgN "GOCQ") (QSD:HookLen "LMOCNGOAI" ds))
                   (list "KIN" w hh ds 1.0) (car gc))
        ;; moi dai gia cuong dam phu cung co bo dai trong / dai 1 nhanh nhu dai thuong tai do
        (if (QSD:CfgB "DAITRONGGC")
          (QSD:_inadd (nth 1 s1) (cond ((QSD:ZoneAt beam (nth 1 s1)) (nth 1 (QSD:ZoneAt beam (nth 1 s1)))) (T ds))
                      (nth (car s1) (QSD:Get "SPANS" beam)) (car gc) nil)))))
  ;; dai C noi thep gia
  (setq ctie (QSD:Get "CTIE" beam))
  (if (and ctie (/= (QSD:Trim (car ctie)) "") (/= (strcase (QSD:Trim (car ctie))) "NONE"))
    (foreach bb (vl-remove-if-not '(lambda (x) (= (car x) "G")) (QSD:Get "BARS" beam))
      (setq ds (if (QSD:Get "ZONES" beam) (nth 1 (car (QSD:Get "ZONES" beam))) 8.0)
            dct (if (cadr ctie) (cadr ctie) ds) s (if (caddr ctie) (caddr ctie) 400.0))
      (if (or (not (wcmatch (strcase (car ctie)) "SO LE*")) (= (rem (nth 1 bb) 2) 1))
        (progn
          (setq b (QSD:WidthAt beam (/ (+ (nth 4 bb) (nth 5 bb)) 2.0)) w (+ (- b cvL cvR (* 2 ds)) dct))
          (QSD:_sadd (QSD:SM sm (QSD:SKey "CTIE" 0 b)) dct (strcat "C " (QSD:NumStr (QSD:RndCT w)))
                     (list "C" w 0.0 dct 1.0) (1+ (QSD:CntDiv (- (nth 5 bb) (nth 4 bb)) s)))))))
  ;; thep C do lop tang cuong: moi thanh lop 2 (T/B)
  (setq cdo (QSD:Get "CDO" beam))
  (if (and cdo (/= (nth 2 cdo) "KHONG") (> (cadr cdo) 0))
    (foreach bb (QSD:Get "BARS" beam)
      (if (and (member (car bb) '("T" "B")) (= (nth 1 bb) 2))
        (progn
          (setq ds (if (QSD:Get "ZONES" beam) (nth 1 (car (QSD:Get "ZONES" beam))) 8.0) dC (if (car cdo) (car cdo) ds))
          (setq b (QSD:WidthAt beam (/ (+ (nth 4 bb) (nth 5 bb)) 2.0)) w (- b cvL cvR (* 2 ds) 25.0))
          (QSD:_sadd (QSD:SM sm (QSD:SKey "CDO" 0 b)) dC (strcat "C " (QSD:NumStr (QSD:RndCT w)))
                     (list "C" w 0.0 dC 1.0) (1+ (QSD:CntDiv (- (nth 5 bb) (nth 4 bb)) (cadr cdo))))))))
  (mapcar '(lambda (e) (list (nth 1 e) (fix (nth 2 e)) (nth 3 e) (nth 4 e) (nth 5 e) nck (nth 6 e))) r))

;;;-----------------------------------------------------------------------------
;;; 17b. SHOP THEP DAI (giong ban ve DCE dam.dwg): moi so hieu dai / thep C ve 1 hinh ty le 1:1
;;;      theo kich thuoc NGOAI, dim tung doan (an duong dim / duong giong, lam tron 5),
;;;      tag Dce_KhtThepDai2 (SH, DKVAKC = "SL%%cd (L=...)", VITRI) + xdata DcePro / QS_DAM.
;;;-----------------------------------------------------------------------------
;; dim thang hang theo doan p1-p2, chi hien chu (giong DCE: DIMSE1/2, DIMSD1/2 = 1, DIMRND = 5)
(defun QSD:DimAl (p1 p2 loc sc / o nm)
  (setq o (vl-catch-all-apply 'vla-AddDimAligned
            (list (QSD:MSpace) (vlax-3d-point (QSD:P (car p1) (cadr p1))) (vlax-3d-point (QSD:P (car p2) (cadr p2)))
                  (vlax-3d-point (QSD:P (car loc) (cadr loc))))))
  (if (not (vl-catch-all-error-p o))
    (progn
      (vl-catch-all-apply 'vla-put-Layer (list o "QS_Dim"))
      (setq nm (QSD:DimStyleName sc))
      (if (tblsearch "DIMSTYLE" nm) (vl-catch-all-apply 'vla-put-StyleName (list o nm)) (QSD:DimOverride o sc))
      (foreach f '(vla-put-ExtLine1Suppress vla-put-ExtLine2Suppress vla-put-DimLine1Suppress vla-put-DimLine2Suppress)
        (vl-catch-all-apply f (list o :vlax-true)))
      (vl-catch-all-apply 'vla-put-RoundDistance (list o 5.0))
      (vlax-vla-object->ename o))
    nil))

;; dim cac doan cua hinh (dinh goc da dich), bo doan trung (song song, cung chieu dai +- o)
(defun QSD:DimShape (pts o tn / cx cy done i p1 p2 v nv m len dup)
  (setq cx (/ (+ (apply 'min (mapcar 'car pts)) (apply 'max (mapcar 'car pts))) 2.0)
        cy (/ (+ (apply 'min (mapcar 'cadr pts)) (apply 'max (mapcar 'cadr pts))) 2.0)
        done nil i (1- (length pts)))
  (while (> i 0)                                   ; duyet tu cuoi ve dau (uu tien nhanh trong / moc)
    (setq p1 (nth (1- i) pts) p2 (nth i pts) len (QSD:VLen (QSD:V- p2 p1)))
    (if (> len 1.0)
      (progn
        (setq v (QSD:VUnit (QSD:V- p2 p1)) dup nil)
        (foreach dd done
          (if (and (< (abs (- (* (car v) (cadr (car dd))) (* (cadr v) (car (car dd))))) 0.01)
                   (<= (abs (- len (cadr dd))) (+ o 1.0)))
            (setq dup T)))
        (if (not dup)
          (progn
            (setq nv (list (- (cadr v)) (car v)) m (QSD:PAdd p1 v (/ len 2.0)))
            (if (< (+ (* (car nv) (- (car m) cx)) (* (cadr nv) (- (cadr m) cy))) 0) (setq nv (list (- (car nv)) (- (cadr nv)))))
            (QSD:DimAl p1 p2 (QSD:PAdd m nv (* 2.0 tn)) tn)
            (setq done (cons (list v len) done))))))
    (setq i (1- i))))

;; ve shop dai: x0, ytop = goc tren-trai vung ve (toa do tuong doi) ; tra ve (xmax ymin)
(defun QSD:DrawDaiShop (beam x0 ytop id / tn name nck rows x y rowh k n sp d o pts w h mnx mxx mny mxy dx dy ent hdl sh q xm)
  (setq tn (QSD:TN) name (QSD:Get "NAME" beam) nck (QSD:Get "NCK" beam))
  (setq rows (QSD:Sort (QSD:DaiSched beam) '(lambda (a b) (< (QSD:NumD (car a) 0) (QSD:NumD (car b) 0)))))
  (setq x x0 y ytop k 0 rowh 0.0 n (fix (QSD:CfgN "DAIMOIHANG")) xm x0)
  (foreach r rows
    ;; r = (mark d hinhdang L sl/ck nck (kind w h d dir))
    (setq sp (nth 6 r) d (float (nth 1 r)) sh (car r) q (nth 4 r))
    (setq o (if (wcmatch (car sp) "KIN*") (QSD:LechO d) 0.0))
    ;; kich thuoc NGOAI = duong tim + d (thep C: chieu dai ngang giu nguyen + d)
    (setq w (if (> (nth 1 sp) 0) (+ (nth 1 sp) d) 0.0) h (if (> (nth 2 sp) 0) (+ (nth 2 sp) d) 0.0))
    (setq pts (QSD:ShpPts (car sp) w h d (nth 4 sp) o))
    (setq mnx (apply 'min (mapcar 'car pts)) mxx (apply 'max (mapcar 'car pts))
          mny (apply 'min (mapcar 'cadr pts)) mxy (apply 'max (mapcar 'cadr pts)))
    (if (and (> n 0) (> k 0) (= (rem k n) 0))
      (setq x x0 y (- y rowh (* 10.0 tn)) rowh 0.0))
    (setq dx (- x mnx) dy (- y mxy))
    (setq pts (mapcar '(lambda (p) (list (+ (car p) dx) (+ (cadr p) dy))) pts))
    (setq ent (QSD:PL (QSD:Fillet pts (QSD:ShpR w h)) "QS_ThepDai" nil 0.0))
    (if ent
      (progn
        (setq hdl (QSD:Handle ent))
        (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" name "(1)_" sh "(2)_" hdl ";(3)_" (itoa (fix d))
                                                         "(4)_" (itoa nck) "(5)_" (itoa q)))))
        (QSD:SetXd ent *QSD-APP* (list (cons 1000 id) (cons 1000 "SHOPDAI") (cons 1000 sh)))))
    (if (QSD:CfgB "DAIDIM") (QSD:DimShape pts o tn))
    (setq ent (QSD:Insert "Dce_KhtThepDai2" (+ x (* 2.0 tn)) (- (+ mny dy) (* 2.0 tn)) tn "QS_Block"
                          (list (cons "SH" sh)
                                (cons "DKVAKC" (strcat (itoa q) "%%c" (itoa (fix d)) " (L=" (QSD:NumStr (nth 3 r)) ")"))
                                (cons "VITRI" ""))))
    (if ent (QSD:SetXd ent "DcePro" (list (cons 1000 (strcat "(0)_" name "(1)_" sh "(2)_(3)_" (itoa (fix d))
                                                            "(4)_" (itoa nck) "(5)_" (itoa q))))))
    (setq x (+ x (- mxx mnx) (QSD:CfgN "DAIKC")) xm (max xm (+ x (- (QSD:CfgN "DAIKC"))))
          rowh (max rowh (- mxy mny)) k (1+ k)))
  (list xm (- y rowh (* 10.0 tn))))

;; bang thong ke + CSV
;; extra = cac dong them (vd coupler): (mark d "COUPLER" 0 sl nck) - khong tinh KL / so cay
(defun QSD:DrawTable (beam items y0 extra / th nck rows cw gc ds dct x y r hdr ds tot wt f fn Ls lens cnt vals row i sep line)
  (setq th (QSD:TH) nck (QSD:Get "NCK" beam) Ls (QSD:CfgN "LSTOCK"))
  (setq rows nil)
  (foreach it items
    (foreach s (cdr it)
      ;; s = (key mark qty shape rec)
      (setq rows (cons (list (nth 1 s) (nth 3 (nth 4 s)) (QSD:ShapeTxt (nth 3 s))
                             (+ (abs (car (nth 3 s))) (cadr (nth 3 s)) (abs (caddr (nth 3 s))))
                             (nth 2 s) (nth 5 (nth 4 s)))
                       rows))))
  (setq rows (append (reverse rows) (QSD:DaiSched beam) extra))
  (setq rows (QSD:Sort rows '(lambda (a b) (< (QSD:NumD (car a) 99999) (QSD:NumD (car b) 99999)))))
  ;; row = (mark d shape L qty/CK nck)
  (setq hdr '("SH" "%%c" "HINH DANG (mm)" "L (mm)" "SL/CK" "SO CK" "TONG SL" "TONG L (m)" "KL (kg)"))
  (setq cw (mapcar '(lambda (w) (* w th)) '(5 3 14 6 5 5 6 7 7)))
  (if (QSD:CfgB "BANG")
    (progn
      (QSD:Text 0.0 (+ y0 (* 0.5 th)) (strcat "BANG THONG KE DOAN CAT THEP - " (QSD:Get "NAME" beam)) (* 1.2 th) "QS_Text" "L" 0.0)
      (setq y (- y0 (* 1.0 th)))
      (defun QSD:_row (vals y / x i)
        (setq x 0.0 i 0)
        (foreach w cw
          (QSD:Text (+ x (/ w 2.0)) (- y (* 1.25 th)) (nth i vals) (* 0.7 th) "QS_Text" "C" 0.0)
          (QSD:Line x y x (- y (* 2.0 th)) "QS_Dim")
          (setq x (+ x w) i (1+ i)))
        (QSD:Line x y x (- y (* 2.0 th)) "QS_Dim")
        (QSD:Line 0.0 y x y "QS_Dim")
        (QSD:Line 0.0 (- y (* 2.0 th)) x (- y (* 2.0 th)) "QS_Dim"))
      (QSD:_row hdr y)
      (setq y (- y (* 2.0 th)))))
  (setq tot nil lens nil)
  (foreach r rows
    (setq cnt (* (nth 4 r) (nth 5 r)))
    (setq wt (* cnt (/ (nth 3 r) 1000.0) 0.0061654 (nth 1 r) (nth 1 r)))
    (if (= (nth 2 r) "COUPLER")
      (setq vals (list (car r) (itoa (nth 1 r)) "COUPLER" "-" (itoa (nth 4 r)) (itoa (nth 5 r)) (itoa cnt) "-" "-"))
      (setq vals (list (car r) (itoa (nth 1 r)) (nth 2 r) (QSD:NumStr (QSD:RndTot (nth 3 r))) (itoa (nth 4 r))
                       (itoa (nth 5 r)) (itoa cnt) (rtos (* cnt (/ (nth 3 r) 1000.0)) 2 2) (rtos wt 2 1))))
    (if (QSD:CfgB "BANG") (progn (QSD:_row vals y) (setq y (- y (* 2.0 th)))))
    (if (/= (nth 2 r) "COUPLER")
      (progn
        (setq tot (QSD:Put (nth 1 r) (+ wt (QSD:NumD (QSD:Get (nth 1 r) tot) 0.0)) tot))
        (repeat cnt (setq lens (QSD:Put (nth 1 r) (cons (nth 3 r) (QSD:Get (nth 1 r) lens)) lens)))))
    (setq row (cons vals row)))
  ;; tong theo phi
  (setq line nil)
  (foreach p (QSD:Sort tot '(lambda (a b) (< (car a) (car b))))
    (setq i (QSD:PackCount (QSD:Get (car p) lens) Ls))
    (setq line (cons (strcat "%%c" (itoa (car p)) ": " (rtos (cdr p) 2 1) " kg, can " (itoa i) " cay "
                             (rtos (/ Ls 1000.0) 2 1) "m (hao hut "
                             (rtos (* 100.0 (- 1.0 (/ (apply '+ (QSD:Get (car p) lens)) (* i Ls)))) 2 1) "%)")
                     line)))
  (foreach s (reverse line)
    (QSD:Msg (strcat "   " (QSD:Replace s "%%c" "D")))
    (if (QSD:CfgB "BANG") (progn (QSD:Text 0.0 (- y (* 1.2 th)) s (* 0.8 th) "QS_Text" "L" 0.0) (setq y (- y (* 1.6 th))))))
  ;; CSV
  (if (QSD:CfgB "CSV")
    (progn
      (setq fn (strcat (getvar "DWGPREFIX") "QS_SHOPDAM_" (QSD:SafeName (QSD:Get "NAME" beam)) ".csv"))
      (setq f (open fn "w"))
      (if (null f)
        (progn (setq fn (strcat (if (getenv "TEMP") (strcat (getenv "TEMP") "\\") "") "QS_SHOPDAM_" (QSD:SafeName (QSD:Get "NAME" beam)) ".csv"))
               (setq f (open fn "w"))))
      (if f
        (progn
          (write-line (strcat "Dam," (QSD:Replace (QSD:Get "NAME" beam) "," ";")) f)
          (write-line "SH,D,Hinh dang (mm),L (mm),SL/CK,So CK,Tong SL,Tong L (m),KL (kg)" f)
          (foreach v (reverse row) (write-line (QSD:Join (mapcar '(lambda (x) (QSD:Replace (QSD:Replace x "%%c" "") "," ";")) v) ",") f))
          (close f)
          (QSD:Msg (strcat "   Da xuat CSV: " fn)))
        (QSD:Err "Khong ghi duoc file CSV."))))
  y)

;;;-----------------------------------------------------------------------------
;;; 18. LENH QS_SHOPDAM
;;;-----------------------------------------------------------------------------
(defun c:QS_SHOPDAM ( / *error* doc ss i n e x dat raw beam org id recs rec name blk res tops bots
                        bx p yTop yBot oldEcho oldOs rowsT rowsB am nm skipped ncut
                        rowsG cpl hoi tren mode yEnd xR bd ds sx labT labG labB)
  (defun *error* (msg)
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if oldEcho (setvar "CMDECHO" oldEcho))
    (if oldOs (setvar "OSMODE" oldOs))
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*,*BREAK*"))) (QSD:Err msg))
    (princ))
  (QSD:CfgLoad)
  (princ "\nQuet chon MAT CAT DOC dam can shop (gom net be tong + thanh thep): ")
  (setq ss (ssget))
  (if ss
    (progn
      ;; ---- 1. tim so lieu dam ----
      (setq i 0 n (sslength ss) dat nil blk nil)
      (while (and (< i n) (null dat))
        (setq e (ssname ss i))
        (if (setq x (QSD:QsXd e)) (setq dat (QSD:FindQsData e)))
        (setq i (1+ i)))
      (if dat
        (setq raw (caddr dat) org (cadr dat) id (car dat))
        (progn
          (setq i 0)
          (while (and (< i n) (null blk))
            (setq e (ssname ss i))
            (if (or (QSD:XdStrings e "LuuThongSoChung_SYS") (/= (QSD:DceField (QSD:DceStr e) 0) ""))
              (setq blk (QSD:FindDceBlock e)))
            (setq i (1+ i)))
          (if blk (setq raw (QSD:RawFromDce blk) id (QSD:NewId)))))
      (if (null raw)
        (QSD:Err "Khong nhan dang duoc dam: vung chon khong co doi tuong QS_DAM / DCE mang so lieu.")
        (progn
          (setq beam (QSD:BuildBeam raw) name (QSD:Get "NAME" beam))
          (QSD:PrintBeam beam)
          ;; ---- 2. goc toa do ----
          (if (null org)
            (progn
              (setq org (QSD:FindOrigin ss (QSD:Get "L" beam)))
              (if org
                (QSD:Msg (strcat "   Goc dam (tu net be tong): X=" (rtos (car org) 2 1) " Y=" (rtos (cadr org) 2 1)))
                (progn
                  (setq p (getpoint "\nKhong tim thay net be tong - chon diem mep TREN-TRAI dam (mep ngoai goi 1): "))
                  (if p (setq org (trans p 1 0)))))))
          (if (and org (not (QSD:HasFatal beam)))
            (progn
              ;; ---- 3. nhan dang thanh thep ----
              (setq recs nil i 0 skipped 0)
              (repeat n
                (setq e (ssname ss i))
                (if (and (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "LINE"))
                         (not (wcmatch (strcase (cdr (assoc 8 (entget e)))) "QS_THEPSHOP"))
                         (setq rec (QSD:RecogBar e (car org) (cadr org))))
                  (if (or (= (nth 12 rec) "") (= (QSD:Trim (nth 12 rec)) (QSD:Trim name)))
                    (setq recs (cons rec recs))
                    (setq skipped (1+ skipped))))
                (setq i (1+ i)))
              (if (> skipped 0) (QSD:Msg (strcat "   Bo qua " (itoa skipped) " thanh cua dam khac.")))
              (setq i (length recs) recs (QSD:JoinRecs recs))
              (if (< (length recs) i) (QSD:Msg (strcat "   Da noi " (itoa (- i (length recs))) " doan thanh thang hang (KC Join).")))
              (QSD:Msg (strcat "   Nhan dang " (itoa (length recs)) " thanh (T/B/G) o mat cat doc."))
              (if recs
                (progn
                  ;; ---- 4. cat ----
                  (setq res nil ncut 0)
                  (foreach rec recs
                    (foreach g (QSD:CutRec beam rec)
                      (if (> (length (nth 1 g)) 1) (setq ncut (1+ ncut)))
                      (setq res (cons (list rec g) res))))
                  (setq res (QSD:Sort res '(lambda (a b) (if (= (nth 2 (car a)) (nth 2 (car b)))
                                                         (if (= (nth 2 (car a)) "T") (> (nth 10 (car a)) (nth 10 (car b)))
                                                             (< (nth 10 (car a)) (nth 10 (car b))))
                                                         (< (vl-position (nth 2 (car a)) '("T" "B" "G"))
                                                            (vl-position (nth 2 (car b)) '("T" "B" "G")))))))
                  (setq am (QSD:AssignMarks res))
                  (setq res (car am))
                  (setq rowsT (vl-remove-if-not '(lambda (r) (= (nth 2 (car r)) "T")) res)
                        rowsG (vl-remove-if-not '(lambda (r) (= (nth 2 (car r)) "G")) res)
                        rowsB (vl-remove-if-not '(lambda (r) (= (nth 2 (car r)) "B")) res))
                  (cond ((= (QSD:Cfg "SHOPGIA") "DUOI") (setq rowsB (append rowsB rowsG) rowsG nil))
                        ((= (QSD:Cfg "SHOPGIA") "TREN") (setq rowsT (append rowsT rowsG) rowsG nil)))
                  ;; ---- coupler thep cho: dem theo phi (dau thanh trung mep dam, khong be ke) ----
                  (setq cpl nil)
                  (foreach rec recs
                    (foreach side '("L" "R")
                      (if (and (= (QSD:ChoKind beam side (nth 2 rec)) "COUPLER")
                               (if (= side "L") (and (<= (nth 6 rec) 1.0) (= (nth 8 rec) 0.0))
                                 (and (>= (nth 7 rec) (- (QSD:Get "L" beam) 1.0)) (= (nth 9 rec) 0.0))))
                        (setq cpl (QSD:Put (nth 3 rec) (+ (nth 4 rec) (QSD:NumD (QSD:Get (nth 3 rec) cpl) 0)) cpl)))))
                  (setq cpl (mapcar '(lambda (c) (list "CPL" (car c) "COUPLER" 0.0 (cdr c) (QSD:Get "NCK" beam))) cpl))
                  ;; ---- 5. vi tri ve (bo cuc theo QS_DAMSET trang 5; mac dinh giong DCE dam.dwg):
                  ;;      shop TREN phia tren MC doc ; duoi MC doc: dai GIA (rieng) sat tren dai DUOI ;
                  ;;      shop dai ben phai khung shop TREN ; bang thong ke duoi cung ----
                  (setq bx (QSD:SSBox ss) hoi (QSD:CfgB "HOIDIEM") tren (= (QSD:Cfg "SHOPTRENVT") "TREN")
                        mode (QSD:Cfg "SHOPDAI"))
                  (setq *QSD-BX* (car org) *QSD-BY* 0.0 *QSD-BANDS* nil)
                  (setq p (if (and hoi tren rowsT) (getpoint "\nCao do dat SHOP THEP TREN (chi lay Y) <Tu dong - phia tren MC doc>: ")))
                  (setq yTop (if p (cadr (trans p 1 0)) (+ (if bx (cadr (cadr bx)) (cadr org)) (QSD:CfgN "DOLECHSHOP"))))
                  (setq p (if hoi (getpoint "\nCao do dat SHOP THEP DUOI (chi lay Y) <Tu dong - phia duoi MC doc>: ")))
                  (setq yBot (if p (cadr (trans p 1 0)) (- (if bx (cadr (car bx)) (- (cadr org) 3000.0)) (QSD:CfgN "KCSHOPDUOI"))))
                  (setq doc (QSD:Doc) oldEcho (getvar "CMDECHO") oldOs (getvar "OSMODE"))
                  (setvar "CMDECHO" 0) (setvar "OSMODE" 0)
                  (vla-StartUndoMark doc)
                  (QSD:Setup)
                  (setq rowsT (QSD:PackRows rowsT) rowsG (QSD:PackRows rowsG) rowsB (QSD:PackRows rowsB))
                  (setq labT "TH\\U+00C9P\\PL\\U+1EDAP TR\\U+00CAN" labG "TH\\U+00C9P\\PGI\\U+00C1"
                        labB "TH\\U+00C9P\\PL\\U+1EDAP D\\U+01AF\\U+1EDAI")
                  (if (and tren rowsT) (QSD:DrawBand beam rowsT yTop 1 labT "T" id))
                  (foreach bd (list (if (not tren) (list rowsT labT "T")) (list rowsG labG "G") (list rowsB labB "B"))
                    (if (and bd (car bd)) (setq yBot (QSD:DrawBand beam (car bd) yBot -1 (cadr bd) (caddr bd) id))))
                  ;; ---- shop thep dai ----
                  (setq yEnd yBot xR nil)
                  (if (and (/= mode "KHONG") *QSD-BANDS*)
                    (progn
                      (setq bd (if (= mode "PHAITREN") (cond ((assoc "T" *QSD-BANDS*)) (T (car *QSD-BANDS*))) (QSD:Last *QSD-BANDS*)))
                      (if (= mode "DUOI")
                        (setq ds (QSD:DrawDaiShop beam (nth 1 bd) (- yBot (QSD:CfgN "DAILUI") (* 3.0 (QSD:TH))) id)
                              yEnd (cadr ds))
                        (setq ds (QSD:DrawDaiShop beam (+ (nth 3 bd) (QSD:CfgN "DAIKCKHUNG")) (- (nth 4 bd) (QSD:CfgN "DAILUI")) id)
                              xR (car ds)))))
                  ;; ---- bang thong ke ----
                  (if (and (= (QSD:Cfg "BANGVT") "PHAI") *QSD-BANDS*)
                    (progn
                      (setq bd (QSD:Last *QSD-BANDS*) sx *QSD-BX*)
                      (setq *QSD-BX* (+ *QSD-BX* (max (nth 3 bd) (if (and xR (= mode "PHAIDUOI")) xR 0.0)) 1500.0))
                      (QSD:DrawTable beam (cadr am) (nth 4 bd) cpl)
                      (setq *QSD-BX* sx))
                    (QSD:DrawTable beam (cadr am) (- yEnd (* 3.0 (QSD:TH))) cpl))
                  (vla-EndUndoMark doc)
                  (setvar "CMDECHO" oldEcho) (setvar "OSMODE" oldOs)
                  (QSD:Msg (strcat ">> Xong: " (itoa ncut) " nhom thanh duoc cat. Kiem tra vung gach cheo = vung KHONG duoc noi."))))))))))
  (princ))
;;;-----------------------------------------------------------------------------
;;; 19. CAI DAT: QS_DAMSET  (DCL tu sinh, 4 trang giong bang cai dat DCE)
;;;     loi DCL -> sua tren dong lenh (QS_DAMSETCMD)
;;;     QS_DAMNOI : bang chieu dai noi theo phi (trong / ngoai vung, T/B/G/Random)
;;;-----------------------------------------------------------------------------
(defun QSD:KeyRange (k1 k2 / r on)
  (setq r nil on nil)
  (foreach d *QSD-DEF*
    (if (= (car d) k1) (setq on T))
    (if on (setq r (cons (car d) r)))
    (if (= (car d) k2) (setq on nil)))
  (reverse r))

(setq *QSD-PAGES*
  (list (list "1. HIEN THI / MAT CAT DOC" (QSD:KeyRange "TLDOC" "TATSODO"))
        (list "2. DAI / MOC / MAT CAT NGANG" (QSD:KeyRange "LMOCNGOAI" "ROUNDUPSL"))
        (list "3. NEO / BE KE / THEP CHO" (QSD:KeyRange "HOOKD" "KNHIP"))
        (list "4. CAT THEP SHOP" (vl-remove "THUVIEN" (QSD:KeyRange "LSTOCK" "CSV")))
        (list "5. BO CUC SHOP" (QSD:KeyRange "SHOPTRENVT" "CHOSHOP"))))

;; nhan hien thi cho gia tri chon (kieu L)
(setq *QSD-LLAB*
 '(("NGOAI" . "Ngoai") ("TRONG" . "Trong") ("ONE" . "One Link") ("TWO" . "Two Link")
   ("SIEURUTGON" . "Sieu rut gon") ("RUTGON" . "Rut gon") ("DAYDU" . "Day du")
   ("90" . "90 do") ("135" . "135 do") ("180" . "180 do") ("45" . "45 do") ("60" . "60 do")
   ("KHONG" . "Khong") ("2DAU" . "2 dau") ("TOANBO" . "Toan bo")
   ("KEOHETCOT" . "Keo het cot") ("THEOL" . "Theo L") ("MEPDUOI" . "Mep duoi") ("TIMDAM" . "Tim dam")
   ("THANG" . "Cho thang (keo ra ngoai)") ("COUPLER" . "Coupler (tai mep / ra ngoai CPLL)")
   ("TBG" . "Tren + Duoi + Gia") ("TB" . "Tren + Duoi") ("T" . "Tren") ("B" . "Duoi")
   ("TATCA" . "Tat ca thanh toi dau dam") ("CHAY" . "Chi thep chay suot")
   ("DCE" . "Kieu DCE (chong + 1 moc)") ("2MOC" . "2 moc tai goc")
   ("CONGDOAN" . "Cong doan thang (bo qua uon)") ("TIM" . "Theo tim (tru uon)")
   ("1NHANH" . "1 nhanh / thanh giua (DCE)") ("KIN" . "Dai kin om thanh 2, n-1")
   ("TREN" . "Tren") ("DUOI" . "Duoi") ("RIENG" . "Dai rieng (nhu DCE)")
   ("PHAITREN" . "Ben phai shop TREN") ("PHAIDUOI" . "Ben phai shop DUOI") ("PHAI" . "Ben phai shop")))
(defun QSD:LLab (v / p) (if (setq p (assoc v *QSD-LLAB*)) (cdr p) v))
(defun QSD:Opts (k / d) (setq d (assoc k *QSD-DEF*)) (if (= (nth 3 d) "M") (mapcar 'car *QSD-MODES*) (nth 4 d)))

(defun QSD:DclEsc (s) (QSD:Replace (QSD:Replace (QSD:Replace s "\\" "\\\\") "\"" "'") "%%c" "D"))

(defun QSD:DclField (k / d kind lab)
  (setq d (assoc k *QSD-DEF*) kind (nth 3 d) lab (QSD:DclEsc (nth 2 d)))
  (cond
    ((= kind "B") (strcat "      : toggle { key = \"" k "\"; label = \"" lab "\"; }"))
    ((member kind '("M" "L"))
     (strcat "      : row { fixed_height = true; : text { label = \"" lab "\"; width = 44; } : popup_list { key = \"" k "\"; width = 26; } }"))
    ((and (= kind "S") (wcmatch k "NEO?"))
     (strcat "      : text { label = \"" lab "\"; } : edit_box { key = \"" k "\"; edit_width = 70; edit_limit = 400; }"))
    (T (strcat "      : row { fixed_height = true; : text { label = \"" lab "\"; width = 44; } : edit_box { key = \"" k "\"; edit_width = 14; edit_limit = 200; } }"))))

;; 1 trang: cot trai = o nhap / chon, cot phai = tick
(defun QSD:DclPage (i pg / ks f b)
  (setq ks (cadr pg))
  (setq f (vl-remove-if '(lambda (k) (= (nth 3 (assoc k *QSD-DEF*)) "B")) ks)
        b (vl-remove-if-not '(lambda (k) (= (nth 3 (assoc k *QSD-DEF*)) "B")) ks))
  (append
    (list (strcat "qsdamp" (itoa i) " : dialog { label = \"QS_DAM - Cai dat  |  " (car pg) "\";")
          "  : row {"
          "    : button { key = \"P1\"; label = \"1. Hien thi\"; }"
          "    : button { key = \"P2\"; label = \"2. Dai / Moc\"; }"
          "    : button { key = \"P3\"; label = \"3. Neo / Cho\"; }"
          "    : button { key = \"P4\"; label = \"4. Shop\"; }"
          "    : button { key = \"P5\"; label = \"5. Bo cuc\"; }"
          "    : button { key = \"NOI\"; label = \"Bang L noi...\"; }"
          "  }"
          "  : row {"
          (strcat "    : boxed_column { label = \"" (car pg) "\";"))
    (mapcar 'QSD:DclField f)
    (if (= i 4)
      (list "      : row {"
            "        : list_box { key = \"LIB\"; label = \"Thu vien L (mm)\"; width = 16; height = 8; }"
            "        : column { : edit_box { key = \"LIBNEW\"; edit_width = 8; }"
            "                   : button { key = \"LIBADD\"; label = \"Them\"; }"
            "                   : button { key = \"LIBDEL\"; label = \"Xoa\"; } }"
            "      }")
      nil)
    (list "    }"
          "    : boxed_column { label = \"Tuy chon\";")
    (mapcar 'QSD:DclField b)
    (list "      : spacer { height = 1; }"
          "    }"
          "  }"
          "  : text { key = \"ERR\"; label = \"\"; width = 110; }"
          "  : row { : button { key = \"DEF\"; label = \"Mac dinh (trang nay)\"; width = 22; }"
          "          : spacer { width = 30; } ok_cancel; }"
          "  : text { label = \"Gia tri noi / neo / moc mac dinh CHUA XAC NHAN - ky su kiem tra theo thuyet minh du an.\"; }"
          "}")))

(defun QSD:DclNoi ( / r i)
  (setq r (list "qsdamnoi : dialog { label = \"QS_DAM - Chieu dai noi thep (mm) theo phi\";"
                "  : toggle { key = \"UUTIENLAPMM\"; label = \"Uu tien noi theo bang du lieu mm nay (bo tick = dung he so x d ben duoi)\"; }"
                "  : row { : text { label = \"DKT\"; width = 7; }"
                "          : text { label = \"TRONG VUNG:   Tren     Duoi      Gia    Random\"; width = 46; }"
                "          : text { label = \"NGOAI VUNG:   Tren     Duoi      Gia    Random\"; width = 46; } }")
        i 1)
  (repeat 15
    (setq r (append r (list (strcat "  : row { fixed_height = true; : edit_box { key = \"D" (itoa i) "\"; edit_width = 4; }"
                                    " : edit_box { key = \"A" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"B" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"C" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"E" (itoa i) "\"; edit_width = 6; }"
                                    " : spacer { width = 3; }"
                                    " : edit_box { key = \"F" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"G" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"H" (itoa i) "\"; edit_width = 6; }"
                                    " : edit_box { key = \"I" (itoa i) "\"; edit_width = 6; } }")))
          i (1+ i)))
  (append r
    (list "  : row { : text { label = \"He so x d khi khong dung bang (T/B/G/Random):  trong vung\"; }"
          "          : edit_box { key = \"LAPKD1\"; edit_width = 14; }"
          "          : text { label = \"ngoai vung\"; } : edit_box { key = \"LAPKD2\"; edit_width = 14; } }"
          "  : text { key = \"ERR\"; label = \"\"; width = 100; }"
          "  : row { : button { key = \"DEF\"; label = \"Mac dinh\"; width = 14; } : spacer { width = 30; } ok_cancel; }"
          "}")))

(defun QSD:WriteDcl ( / fn f i)
  (setq fn (vl-filename-mktemp "qsdam" nil ".dcl"))
  (if (and fn (setq f (open fn "w")))
    (progn
      (setq i 1)
      (foreach pg *QSD-PAGES* (foreach s (QSD:DclPage i pg) (write-line s f)) (setq i (1+ i)))
      (foreach s (QSD:DclNoi) (write-line s f))
      (close f)
      fn)
    nil))

;; ---- do / doc 1 trang ----
(defun QSD:DlgFill (ks cfg / kind v o)
  (foreach k ks
    (setq kind (nth 3 (assoc k *QSD-DEF*)) v (QSD:Get k cfg))
    (cond
      ((member kind '("M" "L"))
       (setq o (QSD:Opts k))
       (start_list k) (foreach m o (add_list (if (= kind "M") (cdr (assoc m *QSD-MODES*)) (QSD:LLab m)))) (end_list)
       (set_tile k (itoa (cond ((vl-position v o)) (T 0)))))
      (T (set_tile k v))))
  (if (member "LSTOCK" ks)
    (progn
      (setq *QSD-LIB* (vl-remove-if '(lambda (x) (= x "")) (mapcar 'QSD:Trim (QSD:Split (QSD:Get "THUVIEN" cfg) ","))))
      (QSD:DlgLib)))
  (set_tile "ERR" ""))

(defun QSD:DlgLib ()
  (start_list "LIB") (foreach x *QSD-LIB* (add_list x)) (end_list))

(defun QSD:DlgLibAdd ( / v)
  (setq v (QSD:Num (get_tile "LIBNEW")))
  (if (and v (> v 0) (<= v (QSD:NumD (get_tile "LSTOCK") 11700.0)))
    (progn
      (setq *QSD-LIB* (mapcar 'QSD:NumStr (QSD:Sort (mapcar 'QSD:Num (cons (QSD:NumStr v) *QSD-LIB*)) '>)))
      (QSD:DlgLib) (set_tile "LIBNEW" "") (set_tile "ERR" ""))
    (set_tile "ERR" "Thu vien L: nhap so > 0 va <= L cay thep.")))

(defun QSD:DlgLibDel ( / i)
  (setq i (get_tile "LIB"))
  (if (and i (/= i ""))
    (progn (setq i (atoi i))
           (setq *QSD-LIB* (append (QSD:Take *QSD-LIB* i) (QSD:Drop *QSD-LIB* (1+ i))))
           (QSD:DlgLib))))

;; doc + kiem tra trang -> cfg moi hoac nil (hien loi)
(defun QSD:DlgRead (ks cfg / kind v err)
  (setq err nil)
  (foreach k ks
    (setq kind (nth 3 (assoc k *QSD-DEF*)) v (get_tile k))
    (if (member kind '("M" "L")) (setq v (nth (atoi v) (QSD:Opts k))))
    (setq v (QSD:Trim v))
    (if (and (null err) (setq err (QSD:CfgCheck k v))) nil (setq cfg (QSD:Put k v cfg))))
  (if (member "LSTOCK" ks) (setq cfg (QSD:Put "THUVIEN" (QSD:Join *QSD-LIB* ",") cfg)))
  (if err (progn (set_tile "ERR" (strcat "LOI: " err)) nil) cfg))

(defun QSD:DlgGo (code / c)
  (if (setq c (QSD:DlgRead *QSD-DLGKEYS* *QSD-DLGCFG*)) (progn (setq *QSD-DLGCFG* c) (done_dialog code))))

;; ---- hop thoai bang noi ----
(defun QSD:NoiRows (cfg / t1 t2 ds r p q)
  (setq t1 (QSD:ParseLapMM (QSD:Get "LAPMM1" cfg)) t2 (QSD:ParseLapMM (QSD:Get "LAPMM2" cfg)) ds nil)
  (foreach it (append t1 t2) (if (not (member (car it) ds)) (setq ds (cons (car it) ds))))
  (setq r nil)
  (foreach d (QSD:Sort ds '<)
    (setq p (assoc d t1) q (assoc d t2))
    (setq r (cons (list d (if p (cdr p) (list 0 0 0 0)) (if q (cdr q) (if p (cdr p) (list 0 0 0 0)))) r)))
  (reverse r))

(defun QSD:NoiFill (cfg / rows i r)
  (setq rows (QSD:NoiRows cfg) i 1)
  (repeat 15
    (setq r (nth (1- i) rows))
    (set_tile (strcat "D" (itoa i)) (if r (itoa (car r)) ""))
    (mapcar '(lambda (k v) (set_tile (strcat k (itoa i)) (if (and r v (> v 0)) (QSD:NumStr v) "")))
            '("A" "B" "C" "E") (if r (cadr r) '(nil nil nil nil)))
    (mapcar '(lambda (k v) (set_tile (strcat k (itoa i)) (if (and r v (> v 0)) (QSD:NumStr v) "")))
            '("F" "G" "H" "I") (if r (caddr r) '(nil nil nil nil)))
    (setq i (1+ i)))
  (set_tile "UUTIENLAPMM" (QSD:Get "UUTIENLAPMM" cfg))
  (set_tile "LAPKD1" (QSD:Get "LAPKD1" cfg)) (set_tile "LAPKD2" (QSD:Get "LAPKD2" cfg))
  (set_tile "ERR" ""))

(defun QSD:NoiRead (cfg / i d a b s1 s2 err v)
  (setq i 1 s1 nil s2 nil err nil)
  (repeat 15
    (setq d (QSD:Num (get_tile (strcat "D" (itoa i)))))
    (if d
      (progn
        (setq a (mapcar '(lambda (k) (QSD:Num (get_tile (strcat k (itoa i))))) '("A" "B" "C" "E"))
              b (mapcar '(lambda (k) (QSD:Num (get_tile (strcat k (itoa i))))) '("F" "G" "H" "I")))
        (if (or (member nil (QSD:Take a 3)) (member nil (QSD:Take b 3)))
          (if (null err) (setq err (strcat "Dong phi " (QSD:NumStr d) ": nhap du Tren / Duoi / Gia (trong va ngoai vung)."))))
        (if (null (nth 3 a)) (setq a (append (QSD:Take a 3) (list (car a)))))
        (if (null (nth 3 b)) (setq b (append (QSD:Take b 3) (list (car b)))))
        (if (not (or (member nil a) (member nil b)))
          (setq s1 (cons (strcat (QSD:NumStr d) "-" (QSD:Join (mapcar 'QSD:NumStr a) "/")) s1)
                s2 (cons (strcat (QSD:NumStr d) "-" (QSD:Join (mapcar 'QSD:NumStr b) "/")) s2)))))
    (setq i (1+ i)))
  (if (null s1) (setq err "Bang noi trong."))
  (foreach k '("LAPKD1" "LAPKD2")
    (setq v (QSD:Trim (get_tile k)))
    (if (and (null err) (QSD:CfgCheck k v)) (setq err (QSD:CfgCheck k v)) (setq cfg (QSD:Put k v cfg))))
  (if err
    (progn (set_tile "ERR" (strcat "LOI: " err)) nil)
    (QSD:Put "UUTIENLAPMM" (get_tile "UUTIENLAPMM")
      (QSD:Put "LAPMM1" (QSD:Join (reverse s1) ";") (QSD:Put "LAPMM2" (QSD:Join (reverse s2) ";") cfg)))))

(defun QSD:NoiAccept ( / c) (if (setq c (QSD:NoiRead *QSD-DLGCFG*)) (progn (setq *QSD-DLGCFG* c) (done_dialog 1))))

(defun QSD:NoiDialog (id / r)
  (if (new_dialog "qsdamnoi" id)
    (progn
      (QSD:NoiFill *QSD-DLGCFG*)
      (action_tile "DEF" "(QSD:NoiFill (QSD:CfgDefaults))")
      (action_tile "accept" "(QSD:NoiAccept)")
      (action_tile "cancel" "(done_dialog 0)")
      (setq r (start_dialog))
      T)
    nil))

;; ---- vong lap cac trang ----
(defun QSD:SetDialog (page / fn id r run pg)
  (setq fn (QSD:WriteDcl) r nil *QSD-DLGCFG* *QSD-CFG*)
  (if fn
    (progn
      (setq id (load_dialog fn))
      (if (and id (> id 0) (new_dialog (strcat "qsdamp" (itoa page)) id))
        (progn
          (setq run T)
          (while run
            (setq pg (nth (1- page) *QSD-PAGES*) *QSD-DLGKEYS* (cadr pg))
            (QSD:DlgFill *QSD-DLGKEYS* *QSD-DLGCFG*)
            (action_tile "P1" "(QSD:DlgGo 11)") (action_tile "P2" "(QSD:DlgGo 12)")
            (action_tile "P3" "(QSD:DlgGo 13)") (action_tile "P4" "(QSD:DlgGo 14)")
            (action_tile "P5" "(QSD:DlgGo 15)")
            (action_tile "NOI" "(QSD:DlgGo 20)")
            (action_tile "LIBADD" "(QSD:DlgLibAdd)")
            (action_tile "LIBDEL" "(QSD:DlgLibDel)")
            (action_tile "DEF" "(QSD:DlgFill *QSD-DLGKEYS* (QSD:CfgDefaults))")
            (action_tile "accept" "(QSD:DlgGo 1)")
            (action_tile "cancel" "(done_dialog 0)")
            (setq r (start_dialog))
            (cond
              ((= r 1) (QSD:CfgSave *QSD-DLGCFG*) (QSD:Msg ">> Da luu cai dat.") (setq run nil))
              ((= r 0) (QSD:Msg "Huy - khong thay doi.") (setq run nil))
              ((= r 20) (QSD:NoiDialog id))
              ((and (> r 10) (< r 16)) (setq page (- r 10))))
            (if run (if (not (new_dialog (strcat "qsdamp" (itoa page)) id)) (setq run nil))))
          (unload_dialog id)
          (vl-file-delete fn)
          T)
        (progn (if (and id (> id 0)) (unload_dialog id)) (vl-file-delete fn) nil)))
    nil))

;; ---- sua tren dong lenh (du phong khi DCL loi) ----
(defun QSD:SetCmdline ( / cfg i k v n d kind e pg ks go)
  (setq cfg *QSD-CFG* go T)
  (while go
    (initget "1 2 3 4 5 Noi Luu")
    (setq pg (getkword "\nQS_DAM cai dat - chon trang [1 Hien thi/2 Dai-Moc/3 Neo-Cho/4 Shop/5 Bo cuc shop/Noi (bang L noi)/Luu] <Luu>: "))
    (cond
      ((or (null pg) (= pg "Luu")) (setq go nil))
      (T
       (setq ks (if (= pg "Noi") '("UUTIENLAPMM" "LAPMM1" "LAPMM2" "LAPKD1" "LAPKD2")
                  (append (cadr (nth (1- (atoi pg)) *QSD-PAGES*)) (if (= pg "4") '("THUVIEN") nil))))
       (while
         (progn
           (setq i 1)
           (foreach k ks
             (setq d (assoc k *QSD-DEF*))
             (QSD:Msg (strcat (if (< i 10) " " "") (itoa i) ". " (nth 2 d) " = " (QSD:Get k cfg)
                              (if (nth 4 d) (strcat "   [" (QSD:Join (nth 4 d) "/") "]") "")))
             (setq i (1+ i)))
           (initget 6)
           (setq n (getint (strcat "\nSo muc can sua (1-" (itoa (length ks)) ", Enter = ve chon trang): ")))
           (if (and n (<= n (length ks)))
             (progn
               (setq k (nth (1- n) ks) d (assoc k *QSD-DEF*) kind (nth 3 d))
               (cond
                 ((= kind "M") (initget "NHIP GOI TATCA")
                  (setq v (getkword (strcat "\n" (nth 2 d) " [NHIP/GOI/TATCA] <" (QSD:Get k cfg) ">: "))))
                 ((= kind "B") (initget "0 1")
                  (setq v (getkword (strcat "\n" (nth 2 d) " [0/1] <" (QSD:Get k cfg) ">: "))))
                 ((= kind "L") (setq v (strcase (getstring (strcat "\n" (nth 2 d) " [" (QSD:Join (nth 4 d) "/") "] <" (QSD:Get k cfg) ">: ")))))
                 (T (setq v (getstring T (strcat "\n" (nth 2 d) " <" (QSD:Get k cfg) ">: ")))))
               (if (and v (/= v ""))
                 (if (setq e (QSD:CfgCheck k v)) (QSD:Err e) (setq cfg (QSD:Put k v cfg))))
               T)
             nil))))))
  (QSD:CfgSave cfg)
  (QSD:Msg ">> Da luu cai dat."))

(defun c:QS_DAMSET ( / m)
  (QSD:CfgLoad)
  (if (not (QSD:SetDialog 1))
    (progn (QSD:Msg "(Hop thoai DCL khong mo duoc -> sua tren dong lenh)") (QSD:SetCmdline)))
  (princ))

(defun c:QS_DAMNOI ( / fn id)
  (QSD:CfgLoad)
  (setq *QSD-DLGCFG* *QSD-CFG* fn (QSD:WriteDcl))
  (if (and fn (setq id (load_dialog fn)) (> id 0) (QSD:NoiDialog id))
    (progn
      (if (not (equal *QSD-DLGCFG* *QSD-CFG*)) (progn (QSD:CfgSave *QSD-DLGCFG*) (QSD:Msg ">> Da luu bang chieu dai noi.")))
      (unload_dialog id) (vl-file-delete fn))
    (progn (if (and id (> id 0)) (unload_dialog id)) (if fn (vl-file-delete fn))
           (QSD:Msg "(DCL loi -> sua bang noi tren dong lenh: chon trang Noi)") (QSD:SetCmdline)))
  (princ))

(defun c:QS_DAMSETCMD () (QSD:CfgLoad) (QSD:SetCmdline) (princ))

(defun c:QS_DAMHELP ()
  (textscr)
  (foreach s
    (list
      "================ QS_DAM v3.1 ================"
      "QS_VEDAM   : ve dam tu Excel (sheet QS_DAM_V2 / QS_DAM_V1 / DCE_Pro_Beam) / block DCE / dam QS da ve."
      "             Excel: de sheet dam can ve dang mo (o A1 = QS_DAM_V2) roi chay lenh."
      "             Chon diem = mep TREN-TRAI dam (mep ngoai goi 1). Ve MC doc, truc, dim, MC ngang,"
      "             thep cho 2 dau dam (cho thang / coupler) + mach ngung."
      "QS_SHOPDAM : quet chon MC doc -> nhan dang thanh T/B/G -> noi doan thang hang (KC Join)"
      "             -> vung noi, moi noi bat buoc (cat thep o nhip), cat theo L cay + thu vien L,"
      "                so le, noi chong theo bang mm / he so x d (trong / ngoai vung)"
      "             -> shop tren / duoi, bang thong ke doan cat + THONG KE DAI (moc theo cai dat), CSV."
      "QS_DAMSET  : cai dat 5 trang (Hien thi / Dai-Moc / Neo-Cho / Shop / Bo cuc shop) + nut Bang L noi."
      "Bo cuc shop (trang 5): mac dinh giong DCE - shop TREN tren MC doc; duoi MC doc: dai THEP GIA sat tren"
      "  dai THEP DUOI; shop THEP DAI ben phai khung shop TREN (cach 810, lui 350, moi hinh cach 1000)."
      "Dai trong: 1 nhanh moi thanh giua lop 1 tren (kieu DCE) hoac dai kin om thanh 2 / n-1 (trang 2)."
      "  Tai dai gia cuong dam phu cong them dai trong. L dai C / 1 nhanh: cong doan (bo qua uon) hoac theo tim."
      "Thep cho 2 dau: Excel S3:T7 hoac QS_DAMSET trang 3 - Cho thang (keo ra L cho) / Coupler (dung tai mep)."
      "  Coupler: L cho = 0 (tai mep) | 100 | 100/300 (so le: 1/2 thanh ra 100, 1/2 thanh ra 300)."
      "  Ten dam cho noi (Excel S8/T8): ghi 'COUPLER / THEP CHO NOI DAM ...' tren MC doc va shop."
      "QS_DAMNOI  : bang chieu dai noi theo phi. QS_DAMSETCMD: cai dat tren dong lenh."
      "Moc dai: L moc (x d) nhap '12' | '12/6' (d <= d nguong: 12d, lon hon: 6d) | '8-12/10-10/12-8'."
      "Goc moc: dai kin / dai trong / dai C trai-phai / dai U: 90 - 135 - 180 do."
      "Muc chi LUU (chua anh huong hinh ve): Keo thep >50%, Chenh mep, Nhan thep, Vi tri ghi MC,"
      "  An MCD, Thong ke be tong, Danh ten MCN, Danh Goi-Nhip, Muc do ve MCN, Ghi truc MCN, So do,"
      "  cac tuy chon be ke thep tren/duoi (trang 3, tru Be ke toi thieu), Neo du, Form."
      "Luu y: giat cap, doi tiet dien, mong bang chua ho tro - se canh bao."
      "Gia tri noi / neo / moc mac dinh CHUA XAC NHAN - kiem tra theo thuyet minh du an.")
    (princ (strcat "\n" s)))
  (princ))

(princ (strcat "\nQS_DAM v" *QSD-VER* " da nap:  QS_VEDAM | QS_SHOPDAM | QS_DAMSET | QS_DAMNOI | QS_DAMHELP"))
(princ)
