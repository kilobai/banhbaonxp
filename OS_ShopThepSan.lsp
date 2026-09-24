;;  OS_ShopThepSan.lsp  -  SHOP THEP SAN  -  Phien ban 1.0.0 (chinh thuc)  (DCL tu sinh)
;;  Tac gia : Nguyen Xuan Phat
;;  Email   : banhbaonxp@gmail.com
;;  SDT     : 0898010995
;;  (Truoc day: OS_ShopThepSan v1.0.0)
;;  Lenh: SHOPTHEP / ST (bang dieu khien)  OS_VETHEP  OS_CAPNHATTHEP  OS_CANGIUASH  OS_DIMTHEP
;;        OS_THEPSAN  OS_CATTHEP  OS_VUNGCAT  OS_CAPNHATRAI
;;        OS_RAILIVE  OS_NOILAIRAI  OS_VUNGSAN
;;        OS_GOPBT3  OS_KIEMTRABT3  OS_BUNGBT3  OS_CAPNHATBT3  OS_PHUONGANCATBT3  OS_VEXEMCATBT3  OS_CATBT3
;;
;;  v1.0.0 - Cat so le: nhom thanh <= 1 cay (khong cat) khong tach chan / le, giu buoc rai goc.
;;  v1.0.0 - Nhom BIEN THIEN co thanh <= 1 cay va thanh > 1 cay: OS_THEPSAN tach 2 nhom; OS_CATTHEP
;;           cho cac thanh khong can cat thanh nhom rieng (khong gop voi doan dau thanh dai).
;;  v1.0.0 - Cat V3: nhom thep DEU (cung chieu dai) -> ca nhom dung chung 1 phuong an cat khi tranh
;;           trung moi noi (khong con tu ra L=min~max "bien thien" khi thep goc deu).
;;  v1.0.0 - Cat V3 co tick "Xoa thep goc": xoa ca dim cu (QS_Dim) cua cac thanh chua cat.
;;  v1.0.0 - Cat V3 tung khung rieng: doc moi noi cua thep V3 da cat truoc tren ban ve -> nhom cat
;;           sau khong trung moi noi voi nhom ke ben da cat. Bao Defpoints nhom sau cat: 4 dinh,
;;           mep thang (het "<").
;;  v1.0.0 - Cat so le V3: vung cat qua hep -> lap phoi tham lam tranh moi noi ke ben, cuoi cung
;;           cho moi noi ra ngoai vung (khong de trung moi noi). Duong bao Defpoints lay bao loi
;;           tung mep -> het vet lom "<".
;;  v1.0.0 - Duong bao Defpoints nhom V3 sau cat: mep trai/phai theo huong chung,
;;           sap theo tram -> het gap khuc (giu nguyen cat so le v20.29).
;;  v1.0.0 - TAI CAU TRUC THEP SAN: chi con QS_BT_V3.
;;   - OS_THEPSAN luon gop V3 (DEU + BIEN THIEN, quy hoach dong), luon ve 1 thanh
;;     dai dien + tag + duong rai; so hieu theo hinh dang thanh.
;;   - Hs / Cote / huong rai rieng CHI lay tu VUNG SAN (OS_VUNGSAN). Bo doc TEXT
;;     Hs/Cote, bo layer ranh gioi va layer dau huong rai.
;;   - Bo tuy chon: chi ve 1 thanh, chen tag, ve rai, tag tong, gop BT, V3, toi uu,
;;     duong bao BT, layer bao, L trung binh / cong dung, xu ly chenh cote (tu bat).
;;   - Bo lenh BT kieu cu: QS_BUNGBT, QS_BTLIVE, QS_CAPNHATBT (dung ban *BT3).
;;   - Xoa 67 ham khong con duoc goi.
;;
;;  v1.0.0 - GIAO DIEN: viet lai nhan 8 hop thoai (OS_VETHEP, OS_CAPNHATTHEP,
;;   OS_DIMTHEP, OS_THEPSAN, OS_CATTHEP, OS_GIACUONGLOMO, OS_VUNGSAN, cai dat du an):
;;   danh so muc theo thu tu doc, ghi ro don vi, bo viet tat, bo so phien ban cu;
;;   sua chinh ta / cau chu thong bao (so le, dau phay, cau tieng Anh -> tieng Viet).
;;   Giu nguyen toan bo key va logic.
;;
;;  v1.0.0 - GOP THEP:
;;   - Gom theo O SAN: moi thanh cung goi 2 dau (cung dam / bien) vao 1 nhom,
;;     khong xet khoang cach, chieu dai; tach khi giua 2 thanh co DAM / mep san /
;;     ranh vung san. Lo mo khong tach nhom.
;;   - SO LE XEN KE: doan dai / ngan xen ke -> 2 nhom chan / le, buoc 2a.
;;   - Lenh moi OS_GOPBT3: gop lai cac nhom V3 / thanh le da ve thanh 1 nhom.
;;
;;  v1.0.0 - OS_THEPSAN nhan polyline VUNG SAN (OS_VUNGSAN) lam duong bao san khi
;;   tap chon khong co duong tren layer mep ngoai. Layer mep ngoai khong con bat buoc.
;;
;;  v1.0.0 - OS_CATTHEP cat duoc nhom QS_BT_V3 (dung thong so hop thoai; tick "Xoa thep
;;   goc" = cat tai cho va xoa nguon, bo tick = hoi diem dat, giu nguon).
;;
;;  v1.0.0 - Cat V3 trong OS_CATTHEP: theo VUNG CAT (tay / tu dong theo dam), CAT SO LE
;;   (2 nhom C / CS buoc 2a), lech Y doan noi, dim tung doan (doan bien thien ghi
;;   Lmin~Lmax), dim doan noi; layer QS_ThepCatV3 mau do.
;;  v1.0.0 - So hieu doan cat V3 ghi tuan tu SH.1, SH.2, SH.3 ...
;;  v1.0.0 - Lenh SHOPTHEP: bang dieu khien tong cac lenh chinh.
;;  v1.0.0 - Them lenh tat ST = SHOPTHEP.
;;  v1.0.0 - OS_CATTHEP muc 4 (cat thep bien thien 1 dau) ap dung cho nhom QS_BT_V3:
;;   L1 / L2 so le, khong dung L1/L2, hien tung thanh sau khi cat. Ket qua van la
;;   nhom V3 chuan (qua kiem tra QS-V3Audit), nhom BT2 cu khong dung vao V3.
;;  v1.0.0 - Muc 4: chon cat tu TRAI qua / tu PHAI qua (thanh dung: duoi / tren).
;;  v1.0.0 - Muc 4: DAO DAU - thanh L1 cat tu dau da chon, thanh L2 cat tu dau nguoc lai.
;;  v1.0.0 - Dim noi ghi tren hang thanh dai dien; thanh dai dien 2 nhom so le cach nhau
;;   "Khoang cach 2 thanh mau"; text style QS_TEXT he so chieu rong 0.7.
;;  v1.0.0 - Cat V3: thanh cat theo MUC 4 (cat 1 dau L1/L2) cung khong duoc trung moi noi voi
;;   thanh ke ben: thu dao chieu cat, doi L1/L2, roi dich; bao so thanh co nhom khac ke ben.
;;  v20.28 - OS_CATTHEP thanh THUONG (khong phai V3): quet nhieu thanh cat chung -> nhom co duong rai
;;   chong nhau (thep xen ke / so le) khong trung moi noi, cach nhau >= "So le moi noi 2 thanh".
;;  v20.27 - Cat V3 so le co VUNG CAT (noi tai goi): thanh so le trung moi noi -> cam +/- "So le moi
;;   noi" quanh moi noi thanh ke ben, lap lai phoi -> moi noi chuyen sang goi ke tiep. Xet ca cap so le
;;   trong CUNG nhom va thanh ke ben nhom khac, so theo toa do that (thanh nguoc chieu dung).
;;  v20.26 - Cat V3: bang moi noi chung ca lan cat - thanh ke ben thuoc NHOM KHAC (2 nhom so le
;;   quet chung) khong trung moi noi, cach nhau >= "So le moi noi 2 thanh"; phoi hop cung giu dieu kien nay.
;;  v20.25 - Cat V3 dung "PHOI HOP: dich moi noi giam hao hut" + "Dung sai phoi hop": moi thanh dich
;;   moi noi trong dung sai, xep doan vao dau thua chung ca lan quet -> it cay, it dau vun.
;;  v20.24 - Cat V3: thanh dai dien chon THEO SO THU TU THANH cho ca nhom -> moi doan noi cua
;;   1 cap thep nam dung tren 1 thanh (chi lech Y), khong con nhay sang thanh ben canh.
;;  v20.23 - Cat so le V3: moi noi thanh le lech DUNG "So le moi noi 2 thanh" so voi thanh chan
;;   (truoc day chi dung khi doan du qua ngan); Lech Y + Khoang cach 2 thanh mau giu nhu v20.22.
;;  v20.22 - Cat so le V3: moi nhom chon vi tri thanh dai dien 1 lan (huong lech co dinh),
;;   cac doan noi cua cung 1 thanh nam cung hang, chi lech Y - het nhay loan giua cac hang.
;;  v20.21 - OS_CATTHEP (nhom V3): thanh dai dien sau cat GIU VI TRI thanh dai dien chua cat;
;;   khong so le chi lech Y doan noi; so le: nhom kia lech "Khoang cach 2 thanh mau".
;;  v20.20 - OS_THEPSAN: quet chon CHI lay doi tuong tren layer thep san (mep ngoai, dam,
;;   QS_VungSan, QS_LoMo) -> quet ca mat bang lon khong bi treo; nhan lo mo kin tren QS_LoMo.
;;  v20.20 - Tuong thich AutoCAD + ZWCAD: sap xep so khong con mat phan tu trung (QS-Sap),
;;   bo command-s, reactor chi tao khi CAD ho tro.
;;  v20.19 - Lam lai tu v20.16: OS_MBTK trim theo polyline gioi han (giu polyline tren QS_GioiHan),
;;   bo ham nthcdr (loi ZWCAD "listp: 0"), hop thoai gon hon va KHONG con treo: moi nut bam / nap du lieu
;;   deu bat loi va bao len dong ghi chu; chia polyline lom chi chay luc ve.
;;  v20.17 - OS_MBTK: TRIM theo polyline gioi han - net dam / mep san / truc / cot cat dung tai bien,
;;   cung + polyline cat thanh doan, vung san va lo mo cat theo bien (ca polyline lom);
;;   giu lai polyline gioi han tren layer QS_GioiHan.
;;  v20.16 - OS_MBTK: lo mo tu khep vong + ve chu X; net dam dut quang duoc noi (cung duong,
;;   khe <= tuy chon); tuy chon POLYLINE GIOI HAN - chi giu doi tuong / vung san ben trong.
;;  v20.15 - Lenh moi OS_MBTK: ve lai mat bang ket cau tu ban thiet ke (Revit / CAD): chep layer
;;   thiet ke sang layer QS, doc GHI CHU hatch (Cote SSL - xx, SLAB xx THK) -> vung san OS_VUNGSAN.
;;  v20.14 - Hop thoai OS_THEPSAN / OS_CATTHEP / OS_VETHEP xep luoi 4 cot deu (nhan 28, o nhap 8).
;;  v20.13 - Hop thoai OS_CATTHEP dung lai theo luoi 3 cot deu, nhan / o nhap thang hang.

(vl-load-com)
;; v1.0.0: dialog da doi -> luon sinh lai file DCL tam khi nap file.
(setq *QS-DCL-TMP* nil)

;; Project settings are plain validated strings, stored in this drawing only.
(setq *QS-PJ-Schema*
 '(("scale" "Ty le ban ve 1:" "50" pos)
   ("round" "Buoc lam tron (mm)" "5" pos)
   ("anchor" "He so neo thep san n (x d)" "40" pos)
   ("cover" "Lop bao ve thep san (mm)" "40" nonneg)
   ("edge" "Cach mep san (mm)" "50" nonneg)
   ("hook" "Be ke toi thieu (mm)" "0" nonneg)
   ("outer" "Layer mep ngoai san" "QS_BaoBeTong" text)
   ("beam" "Layer dam" "QS_NetKhuat" text)
   ("boundary" "Layer ranh vung" "QS_RanhGioi" text)
   ("zone" "Layer zone" "kata_CJ" text)
   ("direction" "Layer huong rai" "QS_HuongRai" text)
   ("stock" "Chieu dai 1 cay thep (mm)" "11700" pos)))

(defun QS-PJRead (/ record pairs data p key)
  (setq record (dictsearch (namedobjdict) "QS_PROJECT_V1"))
  (foreach p record
    (cond ((= (car p) 1) (setq key (cdr p)))
          ((and key (= (car p) 300))
           (setq pairs (cons (cons key (cdr p)) pairs) key nil))))
  (foreach p *QS-PJ-Schema*
    (setq data (cons (cons (car p) (if (assoc (car p) pairs)
      (cdr (assoc (car p) pairs)) (nth 2 p))) data)))
  (reverse data))

(defun QS-PJValid (data / ok row value number)
  (setq ok T)
  (foreach row *QS-PJ-Schema*
    (setq value (cdr (assoc (car row) data)))
    (if (or (not (= (type value) 'STR)) (= value "") (> (strlen value) 200))
      (setq ok nil)
      (if (/= (nth 3 row) 'text)
        (progn (setq number (distof value 2))
          (if (or (null number) (< number 0)
                  (and (= (nth 3 row) 'pos) (<= number 0))) (setq ok nil))))))
  ok)

(defun QS-PJWrite (data / old entity codes p)
  (if (QS-PJValid data)
    (progn
      (setq codes (list '(0 . "XRECORD") '(100 . "AcDbXrecord") '(280 . 1)))
      (foreach p data (setq codes (append codes (list (cons 1 (car p)) (cons 300 (cdr p))))))
      (setq old (dictsearch (namedobjdict) "QS_PROJECT_V1"))
      (if old
        (entmod (append
          (vl-remove-if '(lambda (item) (member (car item) '(1 300)))
            (entget (cdr (assoc -1 old))))
          (cdddr codes)))
        (progn (setq entity (entmakex codes))
          (if entity (dictadd (namedobjdict) "QS_PROJECT_V1" entity)))))))

(defun QS-PJMap (name)
  (cond
    ((= name "qs_thepsan") '(("styl" "scale") ("srnd" "round")
      ("sneo" "anchor") ("sbv" "cover") ("slui" "edge") ("sbeke" "hook")
      ("lngoai" "outer") ("ldam" "beam") ("szone" "zone")))
    ((= name "qs_vethepdce") '(("tyle1" "scale") ("buoclamtron" "round")))
    ((= name "qs_capnhatthep") '(("buoclamtron2" "round")))
    ((= name "qs_dimthep") '(("drnd" "round")))
    ((= name "qs_catthep") '(("ctyle" "scale") ("crnd" "round") ("ccay" "stock") ("cldam" "beam")))))

(defun QS-PJApplyTiles (name / data pair)
  (setq data (QS-PJRead))
  (foreach pair (QS-PJMap name) (set_tile (car pair) (cdr (assoc (cadr pair) data))))
  (if (= name "qs_dimthep")
    (set_tile "dcao" (rtos (* 2.5 (atof (cdr (assoc "scale" data)))) 2 3)))
  (if (= name "qs_thepsan")
    (set_tile "scaochu" (strcat "Cao chu that = "
      (rtos (* 2.5 (atof (cdr (assoc "scale" data)))) 2 1) " mm"))))

(defun QS-PJCollect (/ row out)
  (foreach row *QS-PJ-Schema*
    (setq out (cons (cons (car row) (vl-string-trim " " (get_tile (car row)))) out)))
  (reverse out))

(defun QS-PJAccept (/ data)
  (setq data (QS-PJCollect))
  (if (not (QS-PJValid data)) (set_tile "error" "Thong so khong hop le - kiem tra cac o so va ten layer.")
    (if (QS-PJWrite data) (done_dialog 1)
      (set_tile "error" "Khong luu duoc cau hinh vao DWG."))))

(defun QS-PJExport (/ data path file row)
  (setq data (QS-PJCollect))
  (if (and (QS-PJValid data) (setq path (getfiled "Xuat cau hinh QS" "QS_project.qsp" "qsp" 1)))
    (if (setq file (open path "w"))
      (progn (write-line "QS_PROJECT_V1" file)
        (foreach row data (write-line (strcat (car row) "=" (cdr row)) file))
        (close file) (set_tile "error" "Da xuat cau hinh.")))))

(defun QS-PJImport (/ path file line pos data row valid)
  (if (setq path (getfiled "Nhap cau hinh QS" "" "qsp" 0))
    (if (setq file (open path "r"))
      (progn
        (setq valid (= (read-line file) "QS_PROJECT_V1"))
        (while (setq line (read-line file))
          (if (setq pos (vl-string-search "=" line))
            (setq data (cons (cons (substr line 1 pos) (substr line (+ pos 2))) data))))
        (close file)
        (if (and valid (QS-PJValid data))
          (progn (foreach row data (if (assoc (car row) *QS-PJ-Schema*) (set_tile (car row) (cdr row))))
            (set_tile "error" "Da nhap. Bam \"Luu vao DWG\" de ap dung."))
          (set_tile "error" "File cau hinh sai dinh dang hoac thieu thong so."))))))

(defun QS-PJDialog (/ path file id row result)
  (setq path (vl-filename-mktemp "qs_project" nil ".dcl") file (open path "w"))
  (if file
    (progn
      (write-line "qs_project : dialog { label = \"Shop thep san  |  Cai dat du an (luu trong ban ve)\"; : row { : column {" file)
      (foreach row *QS-PJ-Schema*
        (if (= (car row) "outer") (write-line "} : column {" file))
        (write-line (strcat ": edit_box { key=\"" (car row) "\"; label=\"" (cadr row)
          "\"; edit_width=22; edit_limit=200; }") file))
      (write-line "} } : text { key=\"error\"; width=75; } : text { label=\"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment=centered; } : row { : button { key=\"imp\"; label=\"Nhap cau hinh...\"; } : button { key=\"exp\"; label=\"Xuat cau hinh...\"; } } : row { : button { key=\"accept\"; label=\"Luu vao DWG\"; is_default=true; } : button { key=\"cancel\"; label=\"Huy\"; is_cancel=true; } } }" file)
      (close file) (setq id (load_dialog path))
      (if (and (>= id 0) (new_dialog "qs_project" id))
        (progn
          (foreach row (QS-PJRead) (set_tile (car row) (cdr row)))
          (action_tile "accept" "(QS-PJAccept)")
          (action_tile "cancel" "(done_dialog 0)")
          (action_tile "imp" "(QS-PJImport)")
          (action_tile "exp" "(QS-PJExport)")
          (setq result (start_dialog))))
      (if (>= id 0) (unload_dialog id)) (vl-file-delete path)))
  result)

(defun QS-PJMode (name enabled / pair key)
  (if (= enabled "1") (QS-PJApplyTiles name))
  (foreach pair (QS-PJMap name)
    (mode_tile (car pair) (if (= enabled "1") 1 0)))
  (if (= name "qs_dimthep") (mode_tile "dcao" (if (= enabled "1") 1 0)))
  ;; Layer pick callbacks must not bypass project-owned fields.
  (foreach key (cond ((= name "qs_thepsan") '("pk1" "pk2" "pk5")))
    (mode_tile key (if (= enabled "1") 1 0)))
  (set_tile "qs_source" (if (= enabled "1") "Dang dung: cai dat du an (luu trong ban ve)" "Dang dung: thong so rieng cua lenh nay")))

(defun QS-PJOpenFrom (name)
  (if (= (QS-PJDialog) 1)
    (progn (set_tile "qs_useproject" "1") (QS-PJMode name "1"))))

(defun QS-PJInit (name)
  ;; Existing drawings without project settings retain their original session values.
  (set_tile "qs_useproject" (if (dictsearch (namedobjdict) "QS_PROJECT_V1") "1" "0"))
  (QS-PJMode name (get_tile "qs_useproject"))
  (action_tile "qs_useproject" (strcat "(QS-PJMode \"" name "\" $value)"))
  (action_tile "qs_project" (strcat "(QS-PJOpenFrom \"" name "\")")))

(defun c:OS_CAIDAT () (QS-PJDialog) (princ))

(setq *QS-DCL-TMP* nil *QS-DCLID* nil *QS-ACAD* nil *QS-MUITEN* "F"
      *QS-NHIPC* nil *QS-MEMOC* nil *QS-SSDIM* nil
      *QS-KHONGDATCHU* nil)

(defun QS-Acad ()
  (if (null *QS-ACAD*) (setq *QS-ACAD* (vlax-get-acad-object)))
  *QS-ACAD*
)

(defun QS-Doc () (vla-get-ActiveDocument (QS-Acad)))

;; Layer dung cho OS_THEPSAN: mep ngoai, dam, vung san, lo mo (chuoi loc ssget, co escape)
(defun QS-WcEsc (s / r i c)
  (setq r "" i 1)
  (while (<= i (strlen s))
    (setq c (substr s i 1))
    (setq r (strcat r (if (member c '("#" "@" "." "*" "?" "~" "[" "]" "-" "`" ",")) (strcat "`" c) c))
          i (1+ i)))
  r)
(defun QS-LayLoMo () (if (and *QS4-LLO* (/= *QS4-LLO* "")) *QS4-LLO* "QS_LoMo"))
(defun QS-LayThepSan ( / ds r)
  (foreach l (list *QS4-LNG* *QS4-LDAM* (if *QSVS-LAY* *QSVS-LAY* "QS_VungSan") (QS-LayLoMo))
    (if (and l (/= l "") (not (member (strcase l) (mapcar 'strcase ds)))) (setq ds (append ds (list l)))))
  (setq r "")
  (foreach l ds (setq r (if (= r "") (QS-WcEsc l) (strcat r "," (QS-WcEsc l)))))
  r)

;; Sap xep GIU phan tu trung (vl-sort cua AutoCAD tu xoa so nguyen trung, ZWCAD thi khong)
;; Reactor an toan: CAD khong ho tro -> tra nil, khong loi
(defun QS-TaoReactor (objs ten ds / r)
  (setq r (if vlr-object-reactor (vl-catch-all-apply 'vlr-object-reactor (list objs ten ds))))
  (if (or (null r) (vl-catch-all-error-p r))
    (progn (if (not *QS-REAC-BAO*)
             (princ "\n[Chu y] CAD nay khong ho tro reactor - tu cap nhat khi keo rai khong chay, dung OS_CAPNHATRAI."))
           (setq *QS-REAC-BAO* T) nil)
    r))

(defun QS-Sap (lst qsSapF)
  (mapcar 'car (vl-sort (mapcar 'list lst)
                        '(lambda (a b) (apply qsSapF (list (car a) (car b)))))))

(defun QS-Space (doc)
  (if (and (= 0 (getvar "TILEMODE")) (= 1 (getvar "CVPORT")))
    (vla-get-PaperSpace doc)
    (vla-get-ModelSpace doc)
  )
)

(defun QS-Num (s / v)
  (setq s (if s (vl-string-trim " \t" s) ""))
  (if (= s "")
    nil
    (if (setq v (distof s 2)) v nil)
  )
)

(defun QS-ChuoiChieuDai (mn mx rnd / a b)
  (setq a (QS-LamTron mn rnd) b (QS-LamTron mx rnd))
  (if (= a b) (itoa a) (strcat (itoa a) "~" (itoa b)))
)

(defun QS-LamTron (val step)
  (setq val (abs (float val)))
  (if (or (null step) (not (numberp step)) (< step 1))
    (fix (+ 0.5 val))
    (* (fix (+ 0.5 (/ val (float step)))) (fix step))
  )
)

(defun QS-LayerBiKhoa (ent / rec)
  (and (setq rec (tblsearch "LAYER" (cdr (assoc 8 (entget ent)))))
       (= 4 (logand 4 (cdr (assoc 70 rec))))
  )
)

(defun QS-DamBaoLayer (ten mau / rec dxf)
  (if (not (tblsearch "LAYER" ten))
    (entmakex
      (list '(0 . "LAYER")
            '(100 . "AcDbSymbolTableRecord")
            '(100 . "AcDbLayerTableRecord")
            (cons 2 ten) '(70 . 0) (cons 62 mau) '(6 . "Continuous")
      )
    )
  )

  (if (setq rec (tblsearch "LAYER" ten))
    (progn
      (setq dxf (entget (tblobjname "LAYER" ten)))
      (if (/= 0 (logand 5 (cdr (assoc 70 dxf))))
        (progn
          (setq dxf (subst (cons 70 (logand (cdr (assoc 70 dxf)) (~ 5)))
                           (assoc 70 dxf) dxf))
          (princ (strcat "\n[Chu y] Da mo khoa / ra bang layer \"" ten "\".")))
      )
      (if (< (cdr (assoc 62 dxf)) 0)
        (progn
          (setq dxf (subst (cons 62 (abs (cdr (assoc 62 dxf)))) (assoc 62 dxf) dxf))
          (princ (strcat "\n[Chu y] Da bat layer \"" ten "\".")))
      )
      (entmod dxf)
    )
  )
  (if (tblsearch "LAYER" ten) T nil)
)

(defun QS-DCL-EB (k lbl w act / q s)
  (setq q (chr 34))
  (setq s (strcat "      : edit_box { key = " q k q "; label = " q lbl q
                  "; edit_width = " (itoa w) "; fixed_width = true; alignment = right;"))
  (if (/= act "") (setq s (strcat s " action = " q act q ";")))
  (strcat s " }")
)

(defun QS-DCL-TX (lbl / q)
  (setq q (chr 34))
  (strcat "      : text { label = " q lbl q "; }")
)

(defun QS-DCL-TK (k lbl w / q)
  (setq q (chr 34))
  (strcat "      : text { key = " q k q "; label = " q lbl q
          "; width = " (itoa w) "; }")
)

(defun QS-DCL-RB (k lbl act / q)
  (setq q (chr 34))
  (strcat "      : radio_button { key = " q k q "; label = " q lbl q
          "; action = " q act q "; }")
)

(defun QS-DCL-BOX (lbl / q)
  (setq q (chr 34))
  (strcat "    : boxed_column { label = " q lbl q "; alignment = top; fixed_height = true;")
)

(defun QS-DCL-TG (k lbl / q)
  (setq q (chr 34))
  (strcat "      : toggle { key = " q k q "; label = " q lbl q "; }")
)

(defun QS-DCL-EBR (k lbl lw ew) (QS-DCL-EBA k lbl lw ew ""))

(defun QS-DCL-EBA (k lbl lw ew act / q s)
  (setq q (chr 34) s "      : row { children_alignment = centered;")
  (if (> lw 0)
    (setq s (strcat s " : text { label = " q lbl q "; width = " (itoa lw) "; fixed_width = true; }")))
  (setq s (strcat s " : edit_box { key = " q k q "; edit_width = " (itoa ew) "; fixed_width = true;"))
  (if (/= act "") (setq s (strcat s " action = " q act q ";")))
  (strcat s " } }"))

(defun QS-DCL-COL (w)
  (strcat "    : column { width = " (itoa w) "; fixed_width = true; alignment = top; fixed_height = true;"))

(defun QS-DCL-BT (k lbl / q)
  (setq q (chr 34))
  (strcat "        : button { key = " q k q "; label = " q lbl q "; fixed_width = true; alignment = centered; }")
)

(defun QS-TaoFileDCL ( / fn f q tmp)
  (setq q (chr 34))
  (setq tmp (getvar "TEMPPREFIX"))
  (setq fn (vl-filename-mktemp "qsdbim" tmp ".dcl"))
  (if (not fn)
    (setq fn (strcat (if (and tmp (/= tmp "")) tmp "C:\\") "qsdbim_tam.dcl"))
  )
  (setq f (open fn "w"))
  (if (not f)
    (progn (princ (strcat "\n[Loi] Khong ghi duoc file tam: " fn)) nil)
    (progn
      (foreach L
        (list

          "qs_vethepdce : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_VETHEP - Ve thanh thep     (v1.0.0)" q ";")
          (strcat "  initial_focus = " q "duongkinh" q ";")
          (QS-DCL-TX "Nhap thong so, bam OK roi pick cac diem tren ban ve.   (*) = bat buoc")
          "  spacer;"
          "  : row { alignment = top;"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  1. Thong so thep  ")
          (QS-DCL-EBA "sonhanh" "So nhanh (so thanh)" 28 8 "(QS-PreviewTag)")
          (QS-DCL-EBA "duongkinh" "Duong kinh d (mm) *" 28 8 "(QS-PreviewTag)")
          (QS-DCL-EBA "khoangcach" "Khoang cach a (mm)" 28 8 "(QS-PreviewTag)")
          (QS-DCL-TX "De trong khoang cach neu la thep chu.")
          "    }"
          (QS-DCL-BOX "  2. Thong tin tag / cau kien  ")
          (QS-DCL-EBR "sh" "So hieu (SH)" 16 14)
          (QS-DCL-EBR "vitri" "Vi tri" 16 14)
          (QS-DCL-EBR "solop" "So lop" 16 14)
          (QS-DCL-EBR "macauKien" "Ma cau kien" 16 14)
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  3. Neo va zone  ")
          (QS-DCL-TG "vtneo" "Tinh neo theo mep dam o 2 dau")
          (QS-DCL-TG "vtkeup" "Be ke huong LEN (bo tick = XUONG)")
          (QS-DCL-TG "vtzone" "Ve LINE zone 2 dau (uu tien hon dam)")
          (QS-DCL-EBR "vtl1" "Zone L1 (mm)" 28 8)
          (QS-DCL-TG "vtsole" "So le 2 nhom, buoc 2a (L1 / L2)")
          (QS-DCL-EBR "vtl2" "Zone L2 (mm)" 28 8)
          (QS-DCL-TX "Zone: am = thut vao, duong = cho ra.")
          (QS-DCL-TX "Neo, bao ve, be ke: theo OS_THEPSAN.")
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  4. The hien tren ban ve  ")
          (QS-DCL-EBR "tyle1" "Ty le ban ve 1 : *" 28 8)
          (QS-DCL-EBR "buoclamtron" "Buoc lam tron (mm)" 28 8)
          (QS-DCL-TX "Cao chu = 2.5 x ty le. Buoc 1 = khong tron.")
          (QS-DCL-TG "dimdoan" "Ghi kich thuoc TUNG DOAN")
          (QS-DCL-TG "dimrai" "Ve DUONG RAI (so thanh theo a)")
          (QS-DCL-TG "bt_vung" "Bien thien: ve bao Defpoints + Group")
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  5. Ve dong loat  ")
          (QS-DCL-TX "Doc bo mau (tag + thanh + rai + dim)")
          (QS-DCL-TX "roi ve cho hang loat block tag:")
          (QS-DCL-BT "btmau" "Doc bo mau QS <")
          "      spacer;"
          (QS-DCL-TX "Doc thep thiet ke tu block Revit / CAD:")
          (QS-DCL-BT "bttk" "Doc thep thiet ke <")
          "    }"
          "    }"
          "  }"
          "  spacer;"
          (QS-DCL-BOX "  Xem truoc noi dung tag (DKVAKC)  ")
          (QS-DCL-TK "preview" "(nhap thong so de xem truoc)" 90)
          "    }"
          (QS-DCL-TK "ghichu" " " 90)
          "  : boxed_row { label = \"Cai dat du an\"; : toggle { key = \"qs_useproject\"; label = \"Dung thong so chung cua du an\"; } : button { key = \"qs_project\"; label = \"Sua cai dat du an...\"; fixed_width = true; } : text { key = \"qs_source\"; width = 45; } }"
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_capnhatthep : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_CAPNHATTHEP - Cap nhat thep     (v1.0.0)" q ";")
          "  spacer;"
          (QS-DCL-TX "Chon che do cap nhat. O thong so de trong = giu nguyen gia tri cua tung thanh.")
          "  spacer;"
          "  : row {"
          (strcat "    : boxed_radio_column { key = " q "chedo" q
                  "; label = " q "  1. Che do cap nhat  " q ";")
          (QS-DCL-RB "cd_daionly" "Chi chieu dai (theo hinh dang thanh)" "(QS-ToggleTS)")
          (QS-DCL-RB "cd_tsonly"  "Chi thong so thep" "(QS-ToggleTS)")
          (QS-DCL-RB "cd_cahai"   "Ca chieu dai va thong so" "(QS-ToggleTS)")
          "    }"
          (QS-DCL-BOX "  2. Thong so moi  ")
          (QS-DCL-EB "newsonhanh"    "So nhanh" 8 "")
          (QS-DCL-EB "newduongkinh"  "Duong kinh (mm)" 8 "")
          (QS-DCL-EB "newkhoangcach" "Khoang cach a (mm)" 8 "")
          (QS-DCL-TX "Nhap 0 vao khoang cach de XOA khoang cach.")
          "    }"
          "  }"
          "  spacer;"
          (QS-DCL-BOX "  3. Chieu dai  ")
          (QS-DCL-EB "buoclamtron2" "Buoc lam tron (mm, 1 = khong lam tron)" 8 "")
          "    }"
          "  spacer;"
          (QS-DCL-BOX "  4. Duong rai thep  ")
          (QS-DCL-TG "cnrai"  "Cap nhat SO THANH theo duong rai (ca ban ve)")
          (QS-DCL-TG "cnlive" "BAT tu cap nhat khi keo duong rai")
          (QS-DCL-TX "Bo tick o tren = TAT che do tu cap nhat.")
          "    }"
          "  spacer;"
          (QS-DCL-TK "ghichu2" " " 62)
          "  spacer;"
          "  : boxed_row { label = \"Cai dat du an\"; : toggle { key = \"qs_useproject\"; label = \"Dung thong so chung cua du an\"; } : button { key = \"qs_project\"; label = \"Sua cai dat du an...\"; fixed_width = true; } : text { key = \"qs_source\"; width = 45; } }"
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_dimthep : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_DIMTHEP - Ghi kich thuoc tung doan thep     (v1.0.0)" q ";")
          (strcat "  initial_focus = " q "dcao" q ";")
          "  spacer;"
          (QS-DCL-TX "Ghi chieu dai TUNG DOAN thanh thep bang dim da an duong giong, duong kich thuoc")
          (QS-DCL-TX "va mui ten - chi con lai con so, giong ban ve tay.   (*) = bat buoc")
          "  spacer;"
          "  : row {"
          (QS-DCL-BOX "  1. Co chu va lam tron  ")
          (QS-DCL-EB "dcao" "Cao chu that (mm) *" 10 "")
          (QS-DCL-EB "drnd" "Buoc lam tron (mm)" 10 "")
          (QS-DCL-TX "Buoc = 0 hoac 1: khong lam tron.")
          "    }"
          (QS-DCL-BOX "  2. Vi tri chu  ")
          (QS-DCL-EB "dofs" "Cach duong thep (mm)" 10 "")
          (QS-DCL-EB "dmin" "Bo qua doan ngan hon (mm)" 10 "")
          (QS-DCL-TX "Cach duong = 0: tu lay 0.8 x cao chu.")
          "    }"
          "  }"
          "  spacer;"
          (strcat "    : boxed_radio_column { key = " q "dphia" q
                  "; label = " q "  3. Phia dat chu  " q ";")
          (QS-DCL-RB "ph_auto" "Tu dong: phia tren doan ngang, ben phai doan dung" "")
          (QS-DCL-RB "ph_dao"  "Dao sang phia ben kia" "")
          "    }"
          "  spacer;"
          (QS-DCL-TK "dghichu" " " 62)
          "  spacer;"
          "  : boxed_row { label = \"Cai dat du an\"; : toggle { key = \"qs_useproject\"; label = \"Dung thong so chung cua du an\"; } : button { key = \"qs_project\"; label = \"Sua cai dat du an...\"; fixed_width = true; } : text { key = \"qs_source\"; width = 45; } }"
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_thepsan : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_THEPSAN - Thep san QS_BT_V3     (v1.0.0)" q ";")
          (strcat "  initial_focus = " q "sd" q ";")
          (QS-DCL-TX "Quet mep san (hoac VUNG SAN) + mat trong dam + lo mo -> tu rai thep, tinh neo / be ke, gop 1 thanh dai dien.")
          (QS-DCL-TX "Chieu day, cao do va huong rai rieng lay tu VUNG SAN (lenh OS_VUNGSAN).   (*) = bat buoc")
          "  spacer;"
          "  : row { alignment = top;"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  1. Thong so thep  ")
          (QS-DCL-EBR "sd" "Duong kinh d (mm) *" 28 8)
          (QS-DCL-EBR "sa" "Khoang cach a (mm) *" 28 8)
          (QS-DCL-EBR "ssh" "So hieu bat dau" 28 8)
          (QS-DCL-EBR "slui" "Cach mep san (mm, 0 = 50)" 28 8)
          (QS-DCL-EBR "sohep" "Bo qua o san hep hon (mm)" 28 8)
          "    }"
          (QS-DCL-BOX "  2. Neo - be ke - bao ve  ")
          (QS-DCL-EBR "sneo" "He so neo n (Lneo = n x d)" 28 8)
          (QS-DCL-EBR "sbeke" "Be ke min (mm, 0 = tu tinh)" 28 8)
          (QS-DCL-EBR "sbv" "Lop bao ve (mm)" 28 8)
          (QS-DCL-TG "sdao" "Dao phia be ke")
          (QS-DCL-TG "sgom" "Gop thep xuyen qua dam")
          (QS-DCL-TG "skedeu" "Dong bo be ke: MAX moi dau cung huong")
          "    }"
          (QS-DCL-BOX "  3. Layer duong bao  ")
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "lngoai" "Mep ngoai san" 14 16)
          (QS-DCL-BT "pk1" " Pick < ")
          "      }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "ldam" "Mat trong dam" 14 16)
          (QS-DCL-BT "pk2" " Pick < ")
          "      }"
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (strcat "    : boxed_radio_column { key = " q "sphuong" q "; label = " q "  4. Phuong rai thep  " q ";")
          (QS-DCL-RB "pw_ngang" "Nam ngang" "")
          (QS-DCL-RB "pw_dung" "Thang dung" "")
          (QS-DCL-RB "pw_pick" "Pick 2 diem tren ban ve" "")
          "    }"
          (strcat "    : boxed_radio_column { key = " q "smuiten" q "; label = " q "  5. Dau mui ten cua dim  " q ";")
          (QS-DCL-RB "mt_dac" "Tam giac dac (closed filled)" "")
          (QS-DCL-RB "mt_cheo" "Gach cheo (oblique)" "")
          (QS-DCL-RB "mt_cham" "Cham tron (dot)" "")
          "    }"
          (QS-DCL-BOX "  6. Ty le va ghi chu  ")
          (QS-DCL-EBR "styl" "Ty le ban ve 1 :" 28 8)
          (QS-DCL-EBR "srnd" "Buoc lam tron (mm)" 28 8)
          (QS-DCL-EBR "srl" "Duong rai lech tim (mm)" 28 8)
          (QS-DCL-EBR "smck" "Ten cau kien" 16 22)
          (QS-DCL-TK "scaochu" "Cao chu that = 2.5 x ty le" 40)
          "    }"
          (QS-DCL-BOX "  7. Kich thuoc  ")
          (QS-DCL-TG "sdim" "Ghi dim tung doan cho thanh dai dien")
          (QS-DCL-TG "sdneo" "Dim rieng DOAN NEO (keo ra ngoai)")
          (QS-DCL-EBR "skneo" "Dim neo cach thanh (mm)" 28 8)
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  8. Lop thep - vung san - zone  ")
          (strcat "      : radio_row { key = " q "slop" q ";")
          (QS-DCL-RB "lp_duoi" "DUOI (day san)" "")
          (QS-DCL-RB "lp_tren" "TREN (mat san)" "")
          "      }"
          (QS-DCL-EBR "shsmd" "Hs ngoai vung san (mm)" 28 8)
          (QS-DCL-EBR "sctmd" "Cote ngoai vung san (m)" 28 8)
          (QS-DCL-TX "Dung cho cho KHONG co vung OS_VUNGSAN.")
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "szone" "Layer zone" 14 16)
          (QS-DCL-BT "pk5" " Pick < ")
          "      }"
          (QS-DCL-EBR "szcho1" "Cho noi zone - thanh le (mm)" 28 8)
          (QS-DCL-EBR "szcho2" "Cho noi zone - thanh chan" 28 8)
          (QS-DCL-EBR "szlech" "Lech dim 2 dai so le (mm)" 28 8)
          (QS-DCL-TX "Zone kin: trong = dang ve, ngoai = ke ben.")
          "    }"
          (QS-DCL-BOX "  9. Gop thep QS_BT_V3 (1 thanh dai dien)  ")
          (QS-DCL-TX "Gom moi thanh cung 1 o san (cung dam 2 dau)")
          (QS-DCL-TX "bat ke khoang cach / L. Tach tai DAM.")
          (QS-DCL-EBR "sbtn" "So le: toi thieu (thanh)" 28 8)
          (QS-DCL-EBR "sbtds" "So le: chenh L >= (mm)" 28 8)
          (QS-DCL-TX "Dai / ngan xen ke -> tach 2 nhom, buoc 2a.")
          (QS-DCL-EBR "sbtmaxn" "Max thanh / nhom (0 = khong)" 28 8)
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  10. San chenh cote: nguong va xu ly  ")
          (QS-DCL-EBR "snguong" "Nguong chenh cote (mm)" 28 8)
          (QS-DCL-EBR "snhan" "Do doc nhan thep 1 /" 28 8)
          (QS-DCL-EBR "scmep" "Diem nhan cach mep dam (mm)" 28 8)
          (QS-DCL-EBR "sltach" "Lech 2 thanh khi tach (mm)" 28 8)
          (QS-DCL-TG "snlt" "Chenh  <  nguong: NHAN thep")
          (QS-DCL-TG "sneq" "Chenh  =  nguong: NHAN thep")
          (QS-DCL-TG "sngt" "Chenh  >  nguong: NHAN thep")
          (QS-DCL-TX "Bo tick: <= nguong keo thang, > tach thanh.")
          (QS-DCL-TG "skeodai" "Khi TACH: keo thanh DAI qua NGAN")
          (QS-DCL-TG "sbdim" "Dim bo qua doan nhan")
          (QS-DCL-TG "sbxien" "Khong cong chieu dai doan xien nhan")
          "    }"
          "    }"
          "  }"
          "  spacer;"
          (QS-DCL-TK "sghichu" " " 90)
          "  : boxed_row { label = \"Cai dat du an\"; : toggle { key = \"qs_useproject\"; label = \"Dung thong so chung cua du an\"; } : button { key = \"qs_project\"; label = \"Sua cai dat du an...\"; fixed_width = true; } : text { key = \"qs_source\"; width = 45; } }"
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_catthep : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_CATTHEP - Cat / noi thep theo chieu dai cay     (v1.0.0)" q ";")
          (strcat "  initial_focus = " q "ccay" q ";")
          (QS-DCL-TX "Thanh dai hon 1 cay duoc cat thanh nhieu doan noi chong, danh so hieu phu SH.1, SH.2 ...  Nhom QS_BT_V3 cat bang bo cat V3.")
          "  spacer;"
          "  : row { alignment = top;"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  1. Cay thep va moi noi  ")
          (QS-DCL-EBR "ccay" "Chieu dai 1 cay thep (mm)" 28 8)
          (QS-DCL-EBR "cnoi" "Chieu dai noi (50d hoac mm)" 28 8)
          (QS-DCL-EBR "cnoing" "Noi ngoai vung cat (50d/mm)" 28 8)
          (QS-DCL-EBR "cmin" "Doan cat ngan nhat (mm)" 28 8)
          (QS-DCL-EBR "crnd" "Buoc lam tron (mm)" 28 8)
          "    }"
          (QS-DCL-BOX "  2. So le va the hien  ")
          (QS-DCL-EBR "csole" "So le moi noi 2 thanh (mm)" 28 8)
          (QS-DCL-EBR "clech" "Lech Y doan noi (mm)" 28 8)
          (QS-DCL-EBR "ckc" "Khoang cach 2 thanh mau (mm)" 28 8)
          (QS-DCL-EBR "ctyle" "Ty le ban ve 1 :" 28 8)
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  3. Thu vien chieu dai  ")
          (QS-DCL-TX "Chieu dai (mm), cach nhau dau phay:")
          (QS-DCL-EBR "ctv" "" 0 38)
          (QS-DCL-TX "Vd: 11700,10400,9750,9360,7020,5200")
          (QS-DCL-TX "De trong: cat dung chieu dai 1 cay.")
          "    }"
          (QS-DCL-BOX "  4. Cat thep bien thien 1 dau  ")
          (QS-DCL-TG "cbt_enable" "Cat bien thien 1 dau (tung thanh)")
          (QS-DCL-TG "cbt_nofirst" "Khong dung chieu dai thanh dau L1 / L2")
          (QS-DCL-TG "cbt_sole" "So le thanh dau L1 / L2")
          (QS-DCL-EBR "cbt_l1" "Thanh dau L1 (mm)" 28 8)
          (QS-DCL-EBR "cbt_l2" "Thanh dau L2 (mm)" 28 8)
          (strcat "      : radio_row { key = " q "cbt_huong" q ";")
          (QS-DCL-RB "bh_trai" "Cat tu TRAI qua" "")
          (QS-DCL-RB "bh_phai" "Cat tu PHAI qua" "")
          "      }"
          (QS-DCL-TG "cbt_daodau" "Dao dau: L2 cat tu dau nguoc lai")
          (QS-DCL-TG "cbt_single" "Hien tung thanh sau khi cat")
          (QS-DCL-TG "cbt_group" "Gop lai thep bien thien sau khi cat")
          (QS-DCL-TX "Dung: trai = duoi. Co vung cat thi bo qua.")
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  5. Dim sau khi cat  ")
          (QS-DCL-TG "cdim" "Ghi dim tung doan")
          (QS-DCL-TG "cdnoi" "Dim doan NOI (keo ra ngoai)")
          (QS-DCL-TG "cdneoc" "Ghi lai dim doan NEO sau khi cat")
          (QS-DCL-EBR "ckneo" "Dim neo cach thanh (mm)" 28 8)
          (QS-DCL-EBR "cknoi" "Dim noi cach thanh (mm)" 28 8)
          (QS-DCL-EBR "cdmin" "Bo qua doan ngan hon (mm)" 28 8)
          (QS-DCL-TX "0 = dim ca doan be ke 2 dau (kieu cu).")
          "    }"
          (QS-DCL-BOX "  6. Tuy chon duong rai  ")
          (QS-DCL-TG "csolea" "CAT SO LE: 2 thanh so le, rai 2a")
          (QS-DCL-TG "cvrai" "Ve lai duong rai + lien ket thep, tag")
          (strcat "      : radio_row { key = " q "ckrai" q ";")
          (QS-DCL-RB "kr_canh" "Rai canh nhau" "")
          (QS-DCL-RB "kr_trung" "Rai trung nhau" "")
          "      }"
          (QS-DCL-EBR "ckcrai" "Khoang cach 2 duong rai (mm)" 28 8)
          (QS-DCL-EBR "clthep" "Layer thanh thep" 16 22)
          "    }"
          "    }"
          (QS-DCL-COL 46)
          (QS-DCL-BOX "  7. Vung cat va phoi hop  ")
          (QS-DCL-TG "cxoa" "Xoa thep, tag, dim goc (V3: tai cho)")
          (QS-DCL-TG "ctag" "Ghi tag cho tung doan cat")
          (QS-DCL-TG "cdao" "Dao phia lech Y")
          (QS-DCL-TG "cvung" "Moi noi chi trong VUNG CAT (pick sau)")
          (QS-DCL-TG "cvtd" "TU DONG lay vung cat theo net dam")
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "cldam" "Layer net dam" 14 16)
          (QS-DCL-BT "pkld" " Pick < ")
          "      }"
          (QS-DCL-EBR "cchia" "Chia nhip L / n, n =" 28 8)
          (QS-DCL-EBR "cming" "Nhip toi thieu (mm)" 28 8)
          (strcat "      : radio_row { key = " q "clopv" q ";")
          (QS-DCL-RB "lv_duoi" "DUOI: noi tai goi" "")
          (QS-DCL-RB "lv_tren" "TREN: giua nhip" "")
          "      }"
          (QS-DCL-BT "pkvc" " Ve duong vung cat (OS_VUNGCAT) < ")
          (QS-DCL-EBR "cvuot" "Cho phep vuot vung (mm)" 28 8)
          (QS-DCL-TG "cphoi" "PHOI HOP: dich moi noi giam hao hut")
          (QS-DCL-EBR "cdsai" "Dung sai phoi hop (mm)" 28 8)
          "    }"
          "    }"
          "  }"
          "  spacer;"
          (QS-DCL-TK "cghichu" " " 90)
          "  : boxed_row { label = \"Cai dat du an\"; : toggle { key = \"qs_useproject\"; label = \"Dung thong so chung cua du an\"; } : button { key = \"qs_project\"; label = \"Sua cai dat du an...\"; fixed_width = true; } : text { key = \"qs_source\"; width = 45; } }"
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_mbtk : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_MBTK - Ve lai mat bang ket cau tu ban thiet ke     (v1.0.0)" q ";")
          "  : row { alignment = top;"
          (QS-DCL-COL 44)
          (QS-DCL-BOX "  1. Layer thiet ke -> layer QS  ")
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mbo" "Mep san" 10 18)
          (QS-DCL-BT "pk_mbo" " Pick < ")
          "      }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mdam" "Dam" 10 18)
          (QS-DCL-BT "pk_mdam" " Pick < ")
          "      }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mlo" "Lo mo" 10 18)
          (QS-DCL-BT "pk_mlo" " Pick < ")
          "      }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mcot" "Cot / vach" 10 18)
          (QS-DCL-BT "pk_mcot" " Pick < ")
          "      }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mtruc" "Truc" 10 18)
          (QS-DCL-BT "pk_mtruc" " Pick < ")
          "      }"
          "    }"
          (QS-DCL-BOX "  2. Tuy chon ve  ")
          (QS-DCL-TG "mnhan" "Ghi nhan Hs / Cote trong vung")
          (QS-DCL-TG "mnen" "Lo trong hatch san -> LO MO (X)")
          (QS-DCL-TG "mxoa" "Xoa ket qua cu cung vi tri dat")
          (QS-DCL-EBR "mgap" "Noi net dam dut <= (mm)" 26 8)
          (QS-DCL-EBR "mlomax" "Lo mo lon nhat (m2)" 26 8)
          "    }"
          "    }"
          (QS-DCL-COL 44)
          (QS-DCL-BOX "  3. Ghi chu va hatch vung san  ")
          (QS-DCL-BT "bt_gc" " Chon bang ghi chu (quet) < ")
          (QS-DCL-TK "mgcinfo" " " 40)
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mhat" "Hatch vung" 10 18)
          (QS-DCL-BT "pk_mhat" " Pick < ")
          "      }"
          (QS-DCL-BT "bt_auto" " Tu nhan layer hatch ")
          (QS-DCL-EBR "mssl" "Cote SSL (m)" 26 8)
          (QS-DCL-EBR "mhs0" "Hs san thuong (mm)" 26 8)
          (QS-DCL-EBR "mdt" "Bo qua vung nho (m2)" 26 8)
          "    }"
          (QS-DCL-BOX "  4. Trim theo polyline gioi han  ")
          (QS-DCL-TG "mclip" "Trim, giu lai polyline (QS_GioiHan)")
          (QS-DCL-BT "pk_clip" " Chon polyline gioi han < ")
          (QS-DCL-TK "mclipinfo" " " 40)
          "    }"
          "    }"
          (QS-DCL-COL 80)
          (QS-DCL-BOX "  5. Doi chieu hatch -> Hs / Cote (OK / ~ kiem tra / ? phai gan)  ")
          "      : list_box { key = \"mlist\"; height = 12; width = 76; multiple_select = true; tabs = \"4 24 29 39 44\"; }"
          (QS-DCL-TK "mtong" " " 74)
          "      : popup_list { key = \"mpop\"; width = 76; }"
          "      : row { children_alignment = centered;"
          (QS-DCL-EBR "mhs" "Hs" 3 7)
          (QS-DCL-EBR "mct" "Cote" 5 7)
          (QS-DCL-BT "bt_tay" " Gan tay ")
          (QS-DCL-BT "bt_bo" " Bo qua ")
          (QS-DCL-BT "bt_zoom" " Zoom < ")
          (QS-DCL-BT "bt_khop" " Tu khop ")
          "      }"
          "    }"
          "    }"
          "  }"
          (QS-DCL-TK "mghichu" " " 110)
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
          "qs_lomo : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_GIACUONGLOMO - Thep gia cuong lo mo san     (v1.0.0)" q ";")
          (QS-DCL-TX "Nhan polyline KIN (lo 4 goc) va polyline HO (2 - 3 canh, lo o mep san).")
          (QS-DCL-TX "Day / Lech cua TAG, DIM tinh theo so lan cao chu (so am = lech nguoc lai).")
          "  : row {"
          (QS-DCL-BOX "  1. Thanh ngang  ")
          (QS-DCL-EB "lsn" "So thanh" 5 "")
          (QS-DCL-EB "ldn" "Duong kinh (mm)" 5 "")
          (QS-DCL-EB "lan" "Neo La (mm)" 5 "")
          "      : row {"
          "      : column {"
          (QS-DCL-EB "ltgn" "Day TAG" 4 "")
          (QS-DCL-EB "ldmn" "Day DIM" 4 "")
          "      }"
          "      : column {"
          (QS-DCL-EB "lxtn" "Lech TAG" 4 "")
          (QS-DCL-EB "lxdn" "Lech DIM" 4 "")
          "      }"
          "      }"
          "    }"
          (QS-DCL-BOX "  2. Thanh doc  ")
          (QS-DCL-EB "lsd" "So thanh" 5 "")
          (QS-DCL-EB "ldd" "Duong kinh (mm)" 5 "")
          (QS-DCL-EB "lad" "Neo La (mm)" 5 "")
          "      : row {"
          "      : column {"
          (QS-DCL-EB "ltgd" "Day TAG" 4 "")
          (QS-DCL-EB "ldmd" "Day DIM" 4 "")
          "      }"
          "      : column {"
          (QS-DCL-EB "lxtd" "Lech TAG" 4 "")
          (QS-DCL-EB "lxdd" "Lech DIM" 4 "")
          "      }"
          "      }"
          "    }"
          (QS-DCL-BOX "  3. Thanh xien (o goc lo)  ")
          (QS-DCL-EB "lsx" "So thanh" 5 "")
          (QS-DCL-EB "ldx" "Duong kinh (mm)" 5 "")
          (QS-DCL-EB "lax" "Neo La (mm)" 5 "")
          (QS-DCL-EB "lcx" "Chi ve khi canh lo >= (mm)" 5 "")
          "      : row {"
          "      : column {"
          (QS-DCL-EB "ltgx" "Day TAG" 4 "")
          (QS-DCL-EB "ldmx" "Day DIM" 4 "")
          "      }"
          "      : column {"
          (QS-DCL-EB "lxtx" "Lech TAG" 4 "")
          (QS-DCL-EB "lxdx" "Lech DIM" 4 "")
          "      }"
          "      }"
          "    }"
          "  }"
          "  : row {"
          (QS-DCL-BOX "  4. Lo mo  ")
          "      : row {"
          (QS-DCL-EB "llay" "Layer lo mo" 13 "")
          (QS-DCL-BT "pkl" " Pick < ")
          "      }"
          (QS-DCL-EB "lkc"  "Khoang cach 2 thanh (mm)" 6 "")
          (QS-DCL-EB "lcm"  "Cach mep lo (mm)" 6 "")
          (QS-DCL-EB "lnho"  "Lo NHO hon (mm)" 6 "")
          (QS-DCL-EB "lsnho" "-> dung so thanh" 6 "")
          (QS-DCL-TG "lxnho" "-> van ve thanh xien")
          "    }"
          (QS-DCL-BOX "  5. Dam  ")
          "      : row {"
          (QS-DCL-EB "lldam" "Layer dam" 13 "")
          (QS-DCL-BT "pkd" " Pick < ")
          "      }"
          (QS-DCL-EB "lnd" "Neo vao dam (x d)" 5 "")
          (QS-DCL-EB "lbv" "Lop bao ve (mm)" 5 "")
          (QS-DCL-EB "lke" "Be ke toi thieu (mm)" 5 "")
          (QS-DCL-EB "ltd" "Tim dam trong pham vi (mm)" 5 "")
          (QS-DCL-TX "Quet chon net dam cung luc voi lo mo.")
          "    }"
          (QS-DCL-BOX "  6. The hien  ")
          "      : row {"
          "      : column {"
          (QS-DCL-EB "ltyle" "Ty le 1 :" 5 "")
          (QS-DCL-EB "lmck"  "Ma cau kien" 5 "")
          (QS-DCL-EB "lsh"   "SH bat dau" 5 "")
          "      }"
          "      : column {"
          (QS-DCL-EB "lrnd"  "Lam tron (mm)" 5 "")
          (QS-DCL-EB "lachu" "KC thep chu (mm)" 5 "")
          "      }"
          "      }"
          (QS-DCL-TG "lauto" "TU DONG tinh so thanh theo khoang cach thep chu")
          "      : row {"
          (QS-DCL-TG "ltag" "Ghi TAG")
          (QS-DCL-TG "ldim" "Ghi DIM")
          "      }"
          "    }"
          "  }"
          (QS-DCL-TK "lghichu" " " 62)
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  ok_cancel;"
          "}"
          ""
        )
        (write-line L f)
      )
      (close f)
      fn
    )
  )
)

(defun QS-Doc6 ( / )
  (setq *QS6-SN* (vl-string-trim " " (get_tile "lsn"))
        *QS6-DN* (vl-string-trim " " (get_tile "ldn"))
        *QS6-AN* (vl-string-trim " " (get_tile "lan"))
        *QS6-SD* (vl-string-trim " " (get_tile "lsd"))
        *QS6-DD* (vl-string-trim " " (get_tile "ldd"))
        *QS6-AD* (vl-string-trim " " (get_tile "lad"))
        *QS6-SX* (vl-string-trim " " (get_tile "lsx"))
        *QS6-DX* (vl-string-trim " " (get_tile "ldx"))
        *QS6-AX* (vl-string-trim " " (get_tile "lax"))
        *QS6-CX* (vl-string-trim " " (get_tile "lcx"))
        *QS6-LAY* (vl-string-trim " " (get_tile "llay"))
        *QS6-KC* (vl-string-trim " " (get_tile "lkc"))
        *QS6-CM* (vl-string-trim " " (get_tile "lcm"))
        *QS6-NHO* (vl-string-trim " " (get_tile "lnho"))
        *QS6-SNHO* (vl-string-trim " " (get_tile "lsnho"))
        *QS6-XNHO* (get_tile "lxnho")
        *QS6-LDAM* (vl-string-trim " " (get_tile "lldam"))
        *QS6-ND* (vl-string-trim " " (get_tile "lnd"))
        *QS6-BV* (vl-string-trim " " (get_tile "lbv"))
        *QS6-KE* (vl-string-trim " " (get_tile "lke"))
        *QS6-TD* (vl-string-trim " " (get_tile "ltd"))
        *QS6-AUTO* (get_tile "lauto")
        *QS6-ACHU* (vl-string-trim " " (get_tile "lachu"))
        *QS6-TYL* (vl-string-trim " " (get_tile "ltyle"))
        *QS6-MCK* (vl-string-trim " " (get_tile "lmck"))
        *QS6-SH* (vl-string-trim " " (get_tile "lsh"))
        *QS6-RND* (vl-string-trim " " (get_tile "lrnd"))
        *QS6-TGN* (vl-string-trim " " (get_tile "ltgn"))
        *QS6-DMN* (vl-string-trim " " (get_tile "ldmn"))
        *QS6-XTN* (vl-string-trim " " (get_tile "lxtn"))
        *QS6-XDN* (vl-string-trim " " (get_tile "lxdn"))
        *QS6-TGD* (vl-string-trim " " (get_tile "ltgd"))
        *QS6-DMD* (vl-string-trim " " (get_tile "ldmd"))
        *QS6-XTD* (vl-string-trim " " (get_tile "lxtd"))
        *QS6-XDD* (vl-string-trim " " (get_tile "lxdd"))
        *QS6-TGX* (vl-string-trim " " (get_tile "ltgx"))
        *QS6-DMX* (vl-string-trim " " (get_tile "ldmx"))
        *QS6-XTX* (vl-string-trim " " (get_tile "lxtx"))
        *QS6-XDX* (vl-string-trim " " (get_tile "lxdx"))
        *QS6-TAG* (get_tile "ltag")
        *QS6-DIM* (get_tile "ldim"))
  (princ)
)
(defun QS-ModeLM ( / a)
  (setq a (= (get_tile "lauto") "1"))
  (mode_tile "lsn" (if a 1 0))
  (mode_tile "lsd" (if a 1 0))
  (mode_tile "lachu" (if a 0 1))
  (princ)
)
(defun QS-Accept6 ( / ) (QS-Doc6) (setq *QS6-OK* T) (done_dialog 1))

(defun QS-NapDCL ( / id)
  (if (not (and *QS-DCL-TMP* (findfile *QS-DCL-TMP*)))
    (setq *QS-DCL-TMP* (QS-TaoFileDCL))
  )
  (if (not *QS-DCL-TMP*)
    nil
    (progn
      (setq id (load_dialog *QS-DCL-TMP*))
      (if (or (null id) (< id 0))
        (progn
          (princ "\n[Loi] Khong nap duoc giao dien DCL tu file tam:")
          (princ (strcat "\n      " *QS-DCL-TMP*))
          (setq *QS-DCL-TMP* nil)
          nil
        )
        (progn (setq *QS-DCLID* id) id)
      )
    )
  )
)

(defun QS-DongDCL ( / tmpQS)
  (if (and *QS-DCLID* (numberp *QS-DCLID*) (>= *QS-DCLID* 0))
    (progn (unload_dialog *QS-DCLID*) (setq *QS-DCLID* nil))
  )
  (princ)
)

(defun QS-PreviewTag ( / sn dk kc s)
  (setq sn (get_tile "sonhanh")
        dk (get_tile "duongkinh")
        kc (get_tile "khoangcach"))
  (if (= sn "") (setq sn "1"))
  (setq s (strcat sn "%%c" (if (= dk "") "??" dk)))
  (if (/= kc "") (setq s (strcat s "a" kc)))
  (set_tile "preview" (strcat s "   (L = tu dong theo hinh hoc)"))
  (princ)
)

(defun QS-ApDungCheDo (cd / )
  (if (= cd "cd_daionly")
    (progn (mode_tile "newsonhanh" 1) (mode_tile "newduongkinh" 1) (mode_tile "newkhoangcach" 1))
    (progn (mode_tile "newsonhanh" 0) (mode_tile "newduongkinh" 0) (mode_tile "newkhoangcach" 0))
  )
  (if (= cd "cd_tsonly")
    (mode_tile "buoclamtron2" 1)
    (mode_tile "buoclamtron2" 0)
  )
  (princ)
)

(defun QS-ToggleTS ( / tmpQS)
  (QS-ApDungCheDo (get_tile "chedo"))
  (princ)
)

(defun QS-DocTK ( / )
  (setq *QS1-TKTL*  (vl-string-trim " " (get_tile "tyle1"))
        *QS1-TKMCK* (vl-string-trim " " (get_tile "macauKien"))
        *QS1-TKSH*  (vl-string-trim " " (get_tile "sh"))
        *QS1-TKSL*  (vl-string-trim " " (get_tile "solop"))
        *QS1-TK*    T)
  (princ)
)

(defun QS-Accept1 ( / sn dk kc cc bt sl)
  (setq sn (vl-string-trim " " (get_tile "sonhanh"))
        dk (vl-string-trim " " (get_tile "duongkinh"))
        kc (vl-string-trim " " (get_tile "khoangcach"))
        cc (vl-string-trim " " (get_tile "tyle1"))
        bt (vl-string-trim " " (get_tile "buoclamtron")))
  (cond
    ((or (= dk "") (not (QS-Num dk)) (<= (QS-Num dk) 0))
     (set_tile "ghichu" "[Loi] Duong kinh bat buoc va phai la so > 0.")
     (mode_tile "duongkinh" 2))
    ((and (/= sn "") (or (not (QS-Num sn)) (<= (QS-Num sn) 0)))
     (set_tile "ghichu" "[Loi] So nhanh phai la so > 0 (hoac de trong = 1).")
     (mode_tile "sonhanh" 2))
    ((and (/= kc "") (or (not (QS-Num kc)) (<= (QS-Num kc) 0)))
     (set_tile "ghichu" "[Loi] Khoang cach phai la so > 0 (hoac de trong).")
     (mode_tile "khoangcach" 2))
    ((and (= (get_tile "vtzone") "1") (null (QS-Num (get_tile "vtl1"))))
     (set_tile "ghichu" "[Loi] L1 zone phai la so (duoc phep am, 0, duong).")
     (mode_tile "vtl1" 2))
    ((and (= (get_tile "vtsole") "1")
          (or (null (QS-Num kc)) (<= (QS-Num kc) 0) (null (QS-Num (get_tile "vtl1")))))
     (set_tile "ghichu" "[Loi] So le can khoang cach a > 0 va L1 hop le."))
    ((and (= (get_tile "vtsole") "1") (null (QS-Num (get_tile "vtl2"))))
     (set_tile "ghichu" "[Loi] L2 so le phai la so (duoc phep am, 0, duong).")
     (mode_tile "vtl2" 2))
    ((or (= cc "") (not (QS-Num cc)) (<= (QS-Num cc) 0))
     (set_tile "ghichu" "[Loi] Ty le ban ve phai la so > 0 (vd 100, 50, 25).")
     (mode_tile "tyle1" 2))
    ((and (/= bt "") (or (not (QS-Num bt)) (< (QS-Num bt) 1)))
     (set_tile "ghichu" "[Loi] Buoc lam tron phai la so >= 1.")
     (mode_tile "buoclamtron" 2))
    (T
     (setq sl (vl-string-trim " " (get_tile "solop")))
     (if (= sl "") (setq sl "1"))
     (setq *QS1-SN*  (if (= sn "") "1" sn)
           *QS1-DK*  dk
           *QS1-KC*  kc
           *QS1-TL*  cc
           *QS1-CC*  (rtos (* 2.5 (QS-Num cc)) 2 4)
           *QS1-BT*  (if (= bt "") "1" bt)
           *QS1-SH*  (vl-string-trim " " (get_tile "sh"))
           *QS1-VT*  (vl-string-trim " " (get_tile "vitri"))
           *QS1-MCK* (vl-string-trim " " (get_tile "macauKien"))
           *QS1-SL*  sl
           *QS1-DIM* (get_tile "dimdoan")
           *QS1-DRAI* (get_tile "dimrai")
           *QS1-BTVUNG* (get_tile "bt_vung")
           *QS1-NEOON* (get_tile "vtneo")
           *QS1-KEUP* (get_tile "vtkeup")
           *QS1-ZONEON* (get_tile "vtzone")
           *QS1-ZONEL1* (get_tile "vtl1")
           *QS1-SOLE* (get_tile "vtsole")
           *QS1-ZONEL2* (get_tile "vtl2"))
     (done_dialog 1))
  )
  (princ)
)

(defun QS-Accept2 ( / cd bt sn dk kc)
  (setq cd (get_tile "chedo")
        bt (vl-string-trim " " (get_tile "buoclamtron2"))
        sn (vl-string-trim " " (get_tile "newsonhanh"))
        dk (vl-string-trim " " (get_tile "newduongkinh"))
        kc (vl-string-trim " " (get_tile "newkhoangcach")))
  (cond
    ((and (/= cd "cd_tsonly") (/= bt "") (or (not (QS-Num bt)) (< (QS-Num bt) 1)))
     (set_tile "ghichu2" "[Loi] Buoc lam tron phai la so >= 1.")
     (mode_tile "buoclamtron2" 2))
    ((and (/= cd "cd_daionly") (/= sn "") (or (not (QS-Num sn)) (<= (QS-Num sn) 0)))
     (set_tile "ghichu2" "[Loi] So nhanh phai la so > 0 (hoac de trong = giu nguyen).")
     (mode_tile "newsonhanh" 2))
    ((and (/= cd "cd_daionly") (/= dk "") (or (not (QS-Num dk)) (<= (QS-Num dk) 0)))
     (set_tile "ghichu2" "[Loi] Duong kinh phai la so > 0 (hoac de trong = giu nguyen).")
     (mode_tile "newduongkinh" 2))
    ((and (/= cd "cd_daionly") (/= kc "") (not (QS-Num kc)))
     (set_tile "ghichu2" "[Loi] Khoang cach phai la so (0 = xoa khoang cach).")
     (mode_tile "newkhoangcach" 2))
    (T
     (setq *QS2-CD* cd
           *QS2-SN* sn
           *QS2-DK* dk
           *QS2-KC* kc
           *QS2-BT* (if (= bt "") "1" bt)
           *QS2-RAI* (get_tile "cnrai")
           *QS2-LIVE* (get_tile "cnlive"))
     (done_dialog 1))
  )
  (princ)
)

(defun QS-Accept3 ( / cao rnd ofs dmin)
  (setq cao  (vl-string-trim " " (get_tile "dcao"))
        rnd  (vl-string-trim " " (get_tile "drnd"))
        ofs  (vl-string-trim " " (get_tile "dofs"))
        dmin (vl-string-trim " " (get_tile "dmin")))
  (cond
    ((or (= cao "") (not (QS-Num cao)) (<= (QS-Num cao) 0))
     (set_tile "dghichu" "[Loi] Cao chu that phai la so > 0 (vd 125).")
     (mode_tile "dcao" 2))
    ((and (/= rnd "") (or (not (QS-Num rnd)) (< (QS-Num rnd) 0)))
     (set_tile "dghichu" "[Loi] Buoc lam tron phai la so >= 0.")
     (mode_tile "drnd" 2))
    ((and (/= ofs "") (or (not (QS-Num ofs)) (< (QS-Num ofs) 0)))
     (set_tile "dghichu" "[Loi] Khoang cach phai la so >= 0 (0 = tu dong).")
     (mode_tile "dofs" 2))
    ((and (/= dmin "") (or (not (QS-Num dmin)) (< (QS-Num dmin) 0)))
     (set_tile "dghichu" "[Loi] Nguong doan ngan phai la so >= 0.")
     (mode_tile "dmin" 2))
    (T
     (setq *QS3-CAO*  cao
           *QS3-RND*  (if (= rnd "")  "1" rnd)
           *QS3-OFS*  (if (= ofs "")  "0" ofs)
           *QS3-MIN*  (if (= dmin "") "0" dmin)
           *QS3-PHIA* (get_tile "dphia"))
     (done_dialog 1))
  )
  (princ)
)

(defun QS-Doc4 ( / tmpQS)
  (setq *QS4-D*    (vl-string-trim " " (get_tile "sd"))
        *QS4-A*    (vl-string-trim " " (get_tile "sa"))
        *QS4-SH*   (vl-string-trim " " (get_tile "ssh"))
        *QS4-LUI*  (vl-string-trim " " (get_tile "slui"))
        *QS4-OHEP* (vl-string-trim " " (get_tile "sohep"))
        *QS4-NEO*  (vl-string-trim " " (get_tile "sneo"))
        *QS4-BEKE* (vl-string-trim " " (get_tile "sbeke"))
        *QS4-BV*   (vl-string-trim " " (get_tile "sbv"))
        *QS4-LNG*  (vl-string-trim " " (get_tile "lngoai"))
        *QS4-LDAM* (vl-string-trim " " (get_tile "ldam"))
        *QS4-PHUONG* (get_tile "sphuong")
        *QS4-MT*   (get_tile "smuiten")
        *QS4-TYL*  (vl-string-trim " " (get_tile "styl"))
        *QS4-RL*   (vl-string-trim " " (get_tile "srl"))
        *QS4-MCK*  (vl-string-trim " " (get_tile "smck"))
        *QS4-RND*  (vl-string-trim " " (get_tile "srnd"))
        *QS4-DIM*  (get_tile "sdim")
        *QS4-DAO*  (get_tile "sdao")
        *QS4-GOM*  (get_tile "sgom")
        *QS4-KEDEU* (get_tile "skedeu")
        *QS4-NG*   (vl-string-trim " " (get_tile "snguong"))
        *QS4-NHAN* (vl-string-trim " " (get_tile "snhan"))
        *QS4-CMEP* (vl-string-trim " " (get_tile "scmep"))
        *QS4-LTACH* (vl-string-trim " " (get_tile "sltach"))
        *QS4-HSMD* (vl-string-trim " " (get_tile "shsmd"))
        *QS4-CTMD* (vl-string-trim " " (get_tile "sctmd"))
        *QS4-LOP*  (get_tile "slop")
        *QS4-LZONE* (vl-string-trim " " (get_tile "szone"))
        *QS4-ZCHO1* (vl-string-trim " " (get_tile "szcho1"))
        *QS4-ZCHO2* (vl-string-trim " " (get_tile "szcho2"))
        *QS4-ZLECH* (vl-string-trim " " (get_tile "szlech"))
        *QS4-NLT*  (get_tile "snlt")
        *QS4-NEQ*  (get_tile "sneq")
        *QS4-NGT*  (get_tile "sngt")
        *QS4-BDIM* (get_tile "sbdim")
        *QS4-KEODAI* (get_tile "skeodai")
        *QS4-DNEO* (get_tile "sdneo")
        *QS4-KNEO* (vl-string-trim " " (get_tile "skneo"))
        *QS4-BXIEN* (get_tile "sbxien")
        *QS4-BTN*   (vl-string-trim " " (get_tile "sbtn"))
        *QS4-BTDS*  (vl-string-trim " " (get_tile "sbtds"))
        *QS4-BTMAXN* (vl-string-trim " " (get_tile "sbtmaxn")))
  (princ)
)

(defun QS-Loi4 (msg key) (set_tile "sghichu" (strcat "[Loi] " msg)) (mode_tile key 2) nil)

(defun QS-Accept4 ( / tmpQS)
  (QS-Doc4)
  (cond
    ((or (not (QS-Num *QS4-D*)) (<= (QS-Num *QS4-D*) 0))
     (QS-Loi4 "Duong kinh d phai la so > 0." "sd"))
    ((or (not (QS-Num *QS4-A*)) (<= (QS-Num *QS4-A*) 0))
     (QS-Loi4 "Khoang cach a phai la so > 0." "sa"))
    ((or (not (QS-Num *QS4-NEO*)) (< (QS-Num *QS4-NEO*) 0))
     (QS-Loi4 "He so neo n phai la so >= 0 (vd 40 cho 40d)." "sneo"))
    ((and (/= *QS4-BEKE* "") (or (not (QS-Num *QS4-BEKE*)) (< (QS-Num *QS4-BEKE*) 0)))
     (QS-Loi4 "Be ke toi thieu phai la so >= 0." "sbeke"))
    ((or (not (QS-Num *QS4-BV*)) (< (QS-Num *QS4-BV*) 0))
     (QS-Loi4 "Lop bao ve phai la so >= 0." "sbv"))
    ((or (not (QS-Num *QS4-TYL*)) (<= (QS-Num *QS4-TYL*) 0))
     (QS-Loi4 "Ty le ban ve phai la so > 0 (vd 100 cho 1:100)." "styl"))
    ((and (/= *QS4-RL* "") (not (QS-Num *QS4-RL*)))
     (QS-Loi4 "Duong rai lech tim thanh phai la so (0 = ngay tim thanh)." "srl"))
    ((or (not (QS-Num *QS4-NG*)) (< (QS-Num *QS4-NG*) 0))
     (QS-Loi4 "Nguong chenh cao do phai la so >= 0 (vd 50)." "snguong"))
    ((or (not (QS-Num *QS4-NHAN*)) (< (QS-Num *QS4-NHAN*) 1))
     (QS-Loi4 "Do doc nhan thep phai la so >= 1 (vd 6 cho 1/6)." "snhan"))
    ((and (/= *QS4-HSMD* "") (not (QS-Num *QS4-HSMD*)))
     (QS-Loi4 "Hs ngoai vung san phai la so (mm)." "shsmd"))
    ((and (/= *QS4-CTMD* "") (not (QS-Num *QS4-CTMD*)))
     (QS-Loi4 "Cote ngoai vung san phai la so (m, vd -0.050)." "sctmd"))
    ((or (not (QS-Num *QS4-BTN*)) (< (QS-Num *QS4-BTN*) 3))
     (QS-Loi4 "So le xen ke: so thanh toi thieu phai >= 3." "sbtn"))
    ((or (not (QS-Num *QS4-BTDS*)) (< (QS-Num *QS4-BTDS*) 0))
     (QS-Loi4 "So le: chenh chieu dai phai la so >= 0 (mm)." "sbtds"))
    ((and (/= *QS4-BTMAXN* "") (not (QS-Num *QS4-BTMAXN*)))
     (QS-Loi4 "Toi da so thanh / nhom phai la so (0 = khong gioi han)." "sbtmaxn"))
    (T (setq *QS4-OK* T) (done_dialog 1))
  )
  (princ)
)

(defun QS-DamBaoStyleQS ( / tmpQS)
  (if (not (tblsearch "STYLE" "QS_TEXT"))
    (entmakex
      (list '(0 . "STYLE")
            '(100 . "AcDbSymbolTableRecord")
            '(100 . "AcDbTextStyleTableRecord")
            '(2 . "QS_TEXT") '(70 . 0) '(40 . 0.0) '(41 . 0.7)
            '(50 . 0.0) '(71 . 0) '(42 . 2.5)
            (cons 3 "arial.ttf") (cons 4 "")
      )
    )
  )
  ;; v20.15: he so chieu rong QS_TEXT = 0.7 (ap ca cho style da co trong ban ve)
  (if (tblsearch "STYLE" "QS_TEXT")
    (progn
      (setq tmpQS (vl-catch-all-apply 'vla-Item (list (vla-get-TextStyles (QS-Doc)) "QS_TEXT")))
      (if (and (not (vl-catch-all-error-p tmpQS))
               (not (equal (vla-get-Width tmpQS) 0.7 1e-6)))
        (vl-catch-all-apply 'vla-put-Width (list tmpQS 0.7)))
      T)
    nil)
)

(defun QS-DimChuan (ty ma / )
  (QS-DamBaoStyleQS)
  (QS-DatMuiTen ma)
  (QS-SetVarAn "DIMSCALE"  ty)
  (QS-SetVarAn "DIMTXT"    2.5)
  (QS-SetVarAn "DIMTXSTY"  (if (tblsearch "STYLE" "QS_TEXT") "QS_TEXT" "Standard"))
  (QS-SetVarAn "DIMCLRT"   3)
  (QS-SetVarAn "DIMCLRD"   8)
  (QS-SetVarAn "DIMCLRE"   8)
  (QS-SetVarAn "DIMGAP"    1.0)
  (QS-SetVarAn "DIMEXO"    2.0)
  (QS-SetVarAn "DIMEXE"    1.0)
  (QS-SetVarAn "DIMDLE"    0.0)
  (QS-SetVarAn "DIMDLI"    3.75)
  (QS-SetVarAn "DIMCEN"    2.5)
  (QS-SetVarAn "DIMASZ"    1.8)
  (QS-SetVarAn "DIMFXLON"  0)
  (QS-SetVarAn "DIMJUST"   0)
  (QS-SetVarAn "DIMTIH"    0)
  (QS-SetVarAn "DIMTOH"    0)
  (QS-SetVarAn "DIMSOXD"   0)
  (QS-SetVarAn "DIMATFIT"  3)
  (QS-SetVarAn "DIMDEC"    0)
  (QS-SetVarAn "DIMLUNIT"  2)
  (QS-SetVarAn "DIMLFAC"   1.0)
  (QS-SetVarAn "DIMZIN"    8)
  (QS-SetVarAn "DIMDSEP"   44)
  (QS-SetVarAn "DIMTFILL"  0)
  (QS-SetVarAn "DIMPOST"   "")
  (princ)
)

(defun QS-DamBaoStyle ( / tmpQS)
  (if (not (tblsearch "STYLE" "Dce_Text"))
    (entmakex
      (list '(0 . "STYLE")
            '(100 . "AcDbSymbolTableRecord")
            '(100 . "AcDbTextStyleTableRecord")
            '(2 . "Dce_Text") '(70 . 0) '(40 . 0.0) '(41 . 1.0)
            '(50 . 0.0) '(71 . 0) '(42 . 2.5)
            (cons 3 "arial.ttf") (cons 4 "")
      )
    )
  )
  (if (tblsearch "STYLE" "Dce_Text") T nil)
)

(defun QS-TaoATTDEF2 (lop mau pt ptAlign hj vj dfl prompt tag)
  (entmake
    (list '(0 . "ATTDEF")
          '(100 . "AcDbEntity")
          (cons 8 lop) (cons 62 mau)
          '(100 . "AcDbText")
          (cons 10 pt) (cons 40 2.5) (cons 1 dfl)
          '(50 . 0.0) '(41 . 0.7) '(51 . 0.0)
          '(7 . "Dce_Text") '(71 . 0)
          (cons 72 hj) (cons 11 ptAlign) '(210 0.0 0.0 1.0)
          '(100 . "AcDbAttributeDefinition")
          '(280 . 0) (cons 3 prompt) (cons 2 tag)
          '(70 . 0) '(73 . 0) (cons 74 vj)
          '(280 . 0)
    )
  )
)

(defun QS-TaoBlockTag ( / ok)
  (if (tblsearch "BLOCK" "Dce_KhtThepDai2")
    T
    (progn
      (QS-DamBaoStyle)
      (QS-DamBaoLayer "QS_ViTriThep" 7)

      (setq ok
        (entmake (list '(0 . "BLOCK") '(2 . "Dce_KhtThepDai2")
                       '(70 . 2) '(10 0.0 0.0 0.0))))
      (if (not ok)
        (progn (princ "\n[Loi] Khong khoi tao duoc dinh nghia block.") nil)
        (progn

          (entmake (list '(0 . "CIRCLE") '(100 . "AcDbEntity") '(8 . "0")
                         '(100 . "AcDbCircle")
                         (cons 10 (list -7.59738 -3.5 0.0))
                         (cons 40 2.5) '(210 0.0 0.0 1.0)))

          (QS-TaoATTDEF2 "0" 3 (list -4.56069 -4.5 0.0) (list 0.0 0.0 0.0) 0 0
                         "555a333" "Nhap Duong kinh va Khoang cach" "DKVAKC")

          (QS-TaoATTDEF2 "0" 11 (list -7.59738 -3.5 0.0) (list -7.59738 -3.5 0.0) 1 2
                         "NN" "Nhap so hieu cay thep" "SH")

          (QS-TaoATTDEF2 "QS_ViTriThep" 11 (list 12.8293 -4.5 0.0) (list 12.8293 -4.5 0.0) 1 1
                         "" "Nhap vi tri thep" "VITRI")
          (entmake (list '(0 . "ENDBLK")))

          (if (tblsearch "BLOCK" "Dce_KhtThepDai2")
            (progn
              (princ "\n[OK] Chua co block tag - da TU DONG tao block Dce_KhtThepDai2.")
              T)
            (progn (princ "\n[Loi] Khong tao duoc block Dce_KhtThepDai2.") nil)
          )
        )
      )
    )
  )
)

(defun QS-TamTronBlock (blkName / bl e ed c)
  (if (setq bl (tblobjname "BLOCK" blkName))
    (progn
      (setq e (entnext bl))
      (while (and e (null c))
        (setq ed (entget e))
        (if (= (cdr (assoc 0 ed)) "CIRCLE") (setq c (cdr (assoc 10 ed))))
        (setq e (entnext e))
      )
    )
  )
  (if c c (list -7.59738 -3.5 0.0))
)

(defun QS-DatMC (e pt / ed)
  (setq ed (entget e))

  (if (and (= 1 (cdr (assoc 72 ed)))
           (assoc 74 ed) (= 2 (cdr (assoc 74 ed)))
           (assoc 11 ed) (< (distance (cdr (assoc 11 ed)) pt) 1.0e-6))
    nil
    (progn
  (setq ed (if (assoc 72 ed) (subst (cons 72 1) (assoc 72 ed) ed) (append ed (list (cons 72 1)))))
  (setq ed (if (assoc 74 ed) (subst (cons 74 2) (assoc 74 ed) ed) (append ed (list (cons 74 2)))))
  (setq ed (if (assoc 11 ed) (subst (cons 11 pt) (assoc 11 ed) ed) (append ed (list (cons 11 pt)))))

  (setq ed (if (assoc 10 ed) (subst (cons 10 pt) (assoc 10 ed) ed) ed))
      (if (entmod ed) (progn (entupd e) T) nil)
    )
  )
)

(defun QS-CanGiuaSH-Block (blkName / bl e ed tam ok)
  (setq tam (QS-TamTronBlock blkName))
  (if (setq bl (tblobjname "BLOCK" blkName))
    (progn
      (setq e (entnext bl))
      (while e
        (setq ed (entget e))
        (if (and (= (cdr (assoc 0 ed)) "ATTDEF")
                 (= (strcase (cdr (assoc 2 ed))) "SH"))
          (if (QS-DatMC e tam) (setq ok T))
        )
        (setq e (entnext e))
      )
    )
  )
  ok
)

(defun QS-BlockToWorld (ins bpt / ed p sx sy rot ca sa)
  (setq ed  (entget ins)
        p   (cdr (assoc 10 ed))
        sx  (if (assoc 41 ed) (cdr (assoc 41 ed)) 1.0)
        sy  (if (assoc 42 ed) (cdr (assoc 42 ed)) 1.0)
        rot (if (assoc 50 ed) (cdr (assoc 50 ed)) 0.0)
        ca  (cos rot)
        sa  (sin rot))
  (list (+ (car p)  (- (* sx (car bpt) ca) (* sy (cadr bpt) sa)))
        (+ (cadr p) (+ (* sx (car bpt) sa) (* sy (cadr bpt) ca)))
        (caddr p))
)

(defun QS-CanGiuaSH-Insert (ins tam / e ed wp ok)
  (setq wp (QS-BlockToWorld ins tam))
  (setq e (entnext ins))
  (while (and e (/= (cdr (assoc 0 (setq ed (entget e)))) "SEQEND"))
    (if (and (= (cdr (assoc 0 ed)) "ATTRIB")
             (= (strcase (cdr (assoc 2 ed))) "SH"))
      (if (QS-DatMC e wp) (setq ok T))
    )
    (setq e (entnext e))
  )
  (if ok (entupd ins))
  ok
)

(defun c:OS_CANGIUASH ( / *error* doc blkName tam ss i n ent dem)

  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (setq blkName "Dce_KhtThepDai2")
  (setq doc (QS-Doc) *QS-VT-TEMP* nil)
  (vla-StartUndoMark doc)

  (if (not (tblsearch "BLOCK" blkName))
    (princ (strcat "\n[Loi] Ban ve chua co block \"" blkName "\"."))
    (progn
      (setq tam (QS-TamTronBlock blkName))
      (if (QS-CanGiuaSH-Block blkName)
        (princ "\n[OK] Da sua dinh nghia block - cac tag VE MOI se co so hieu nam giua vong tron.")
        (princ "\n[Chu y] Khong tim thay ATTDEF \"SH\" trong dinh nghia block."))

      (setq dem 0)
      (setq ss (ssget "_X" (list (cons 0 "INSERT") (cons 2 blkName))))
      (if (not ss)
        (princ "\nKhong co tag nao da chen trong ban ve.")
        (progn
          (setq n (sslength ss) i 0)
          (while (< i n)
            (setq ent (ssname ss i))
            (if (QS-LayerBiKhoa ent)
              (princ (strcat "\n  [Bo qua] Tag tren layer bi khoa: "
                             (cdr (assoc 5 (entget ent)))))
              (if (QS-CanGiuaSH-Insert ent tam) (setq dem (1+ dem)))
            )
            (setq i (1+ i))
          )
          (princ (strcat "\n[HOAN TAT] Da can giua so hieu cho " (itoa dem)
                         "/" (itoa n) " tag co san trong ban ve."))
          (princ "\nGo REGEN neu man hinh chua cap nhat ngay.")
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-SetVarAn (v gt)
  (vl-catch-all-apply 'setvar (list v gt))
)

(defun QS-LuuDimStyle (ten / )
  (if (tblsearch "DIMSTYLE" ten)
    (command "_.-DIMSTYLE" "_S" ten "_Y")
    (command "_.-DIMSTYLE" "_S" ten))
  (princ)
)

(defun QS-SetBlkVar (v lst / ok)
  (setq ok nil)
  (foreach nm lst
    (if (and (not ok)
             (not (vl-catch-all-error-p (vl-catch-all-apply 'setvar (list v nm)))))
      (setq ok T))
  )
  ok
)

(defun QS-DatMuiTen (ma / lst)

  (setq lst (cond ((= ma "O") (list "_ArchTick" "_ARCHTICK" "ArchTick"))
                  ((= ma "D") (list "_Dot" "_DOT" "Dot"))
                  (T          (list "." ""))))

  (QS-SetBlkVar "DIMBLK"    lst)
  (QS-SetBlkVar "DIMBLK1"   lst)
  (QS-SetBlkVar "DIMBLK2"   lst)
  (QS-SetBlkVar "DIMLDRBLK" lst)
  (QS-SetVarAn  "DIMSAH" 0)
  (setq *QS-MUITEN* ma)
  (princ)
)

(defun QS-ChuanBiDimStyle (h rnd ma / ten ty)
  (if (not ma) (setq ma "F"))
  (setq ty (/ h 2.5))
  (if (<= ty 0.0) (setq ty 1.0))
  (setq ten (strcat "QS_Thep_" (itoa (fix (+ 0.5 ty)))))
  (if T
    (progn
      (QS-DimChuan ty ma)
      (QS-SetVarAn "DIMSE1"    1)
      (QS-SetVarAn "DIMSE2"    1)
      (QS-SetVarAn "DIMSD1"    1)
      (QS-SetVarAn "DIMSD2"    1)
      (QS-SetVarAn "DIMTAD"    0)
      (QS-SetVarAn "DIMTIX"    1)
      (QS-SetVarAn "DIMTMOVE"  2)
      (QS-SetVarAn "DIMTOFL"   0)
      (QS-SetVarAn "DIMASZ"    0.0)
      (QS-SetVarAn "DIMRND"    (float rnd))
      (QS-LuuDimStyle ten)
    )
  )
  ten
)

(defun QS-GanLinkRai (ent hdl / )
  (if (and ent hdl (/= hdl "") (entget ent))
    (progn
      (regapp "QS_Rai")
      (vl-catch-all-apply 'entmod
        (list (append (entget ent)
                      (list (list -3 (list "QS_Rai" (cons 1000 hdl)))))))
    )
  )
  (princ)
)

(defun QS-XoaVongTronRai (p1 p2 ssCir tol / ss i n e c dd dem)
  (setq ss (if ssCir ssCir (ssget "_X" '((0 . "CIRCLE") (8 . "QS_Symbol,DCE_Symbol")))))
  (setq dem 0 i 0 n (if ss (sslength ss) 0))
  (while (< i n)
    (setq e (ssname ss i))
    (if (entget e)
      (progn
        (setq c (cdr (assoc 10 (entget e))))
        (if c
          (progn
            (setq c (list (car c) (cadr c)))
            (setq dd (distance c (QS-ChanVuongGoc p1 p2 c)))
            (if (< dd tol) (progn (entdel e) (setq dem (1+ dem))))
          )
        )
      )
    )
    (setq i (1+ i))
  )
  dem
)

(defun QS-DatKieuDim (ent ten / obj)
  (if (and ent ten (/= ten "") (tblsearch "DIMSTYLE" ten) (entget ent))
    (progn
      (setq obj (vl-catch-all-apply 'vlax-ename->vla-object (list ent)))
      (if (not (vl-catch-all-error-p obj))
        (vl-catch-all-apply 'vla-put-StyleName (list obj ten)))
    )
  )
  (princ)
)

(defun QS-IDMoi ( / tmpQS)
  (if (not *QS-IDRAI*)
    (setq *QS-IDRAI*
      (+ 10000 (fix (* 100000.0 (- (getvar "CDATE") (fix (getvar "CDATE"))))))))
  (setq *QS-IDRAI* (1+ *QS-IDRAI*))
  (itoa *QS-IDRAI*)
)

(defun QS-GanXDataChuoi (ent s / )
  (if (and ent (entget ent))
    (progn
      (regapp "DcePro")
      (vl-catch-all-apply 'entmod
        (list (append (entget ent)
                      (list (list -3 (list "DcePro" (cons 1000 s)))))))
    )
  )
  (princ)
)

(defun QS-GanXDThep (eBar mck sh dia soLop idRai aKC / )
  (if (and eBar (entget eBar))
    (QS-GanXDataChuoi eBar
      (strcat "(0)_" mck "(1)_" sh
              "(2)_" idRai "/KC" (rtos aKC 2 0) ";"
              "(3)_" dia "(4)_" soLop
              "(5)_" (cdr (assoc 5 (entget eBar))))))
  (princ)
)
(defun QS-GanXDTag (eTag mck sh dia soLop hBar soTong / )
  (if (and eTag (entget eTag))
    (QS-GanXDataChuoi eTag
      (strcat "(0)_" mck "(1)_" sh "(2)_" (if hBar hBar "")
              "(3)_" dia "(4)_" soLop "(5)_" (itoa soTong))))
  (princ)
)
(defun QS-GanXDThepKC0 (eBar mck sh dia soLop / )
  (if (and eBar (entget eBar))
    (QS-GanXDataChuoi eBar
      (strcat "(0)_" mck "(1)_" sh "(2)_"
              "(3)_" dia "(4)_" soLop
              "(5)_" (cdr (assoc 5 (entget eBar))))))
  (princ)
)
(defun QS-RongTheo (pts w / mn mx p tp)
  (foreach p pts
    (setq tp (+ (* (car p) (car w)) (* (cadr p) (cadr w))))
    (if (or (null mn) (< tp mn)) (setq mn tp))
    (if (or (null mx) (> tp mx)) (setq mx tp))
  )
  (if mn (- mx mn) 0.0)
)
(defun QS-GanXDRai (eRai mck shRai dia soLop idRai soTong ht4 / )
  (if (null ht4) (setq ht4 ""))
  (if (and eRai (entget eRai))
    (QS-GanXDataChuoi eRai
      (strcat "(0)_" mck "(1)_" shRai "(2)_" idRai
              "(3)_" dia "(4)_" soLop ht4 "(5)_" (itoa soTong))))
  (princ)
)

(defun QS-GanBoLienKet (eBar eTag eRai mck sh shRai dia soLop aKC soTong ht4
                        / idRai hBar hTag)
  (setq idRai (QS-IDMoi))
  (if (null ht4) (setq ht4 ""))
  (setq hBar (if eBar (cdr (assoc 5 (entget eBar)))))
  (if eBar
    (QS-GanXDataChuoi eBar
      (strcat "(0)_" mck "(1)_" sh
              "(2)_" idRai "/KC" (rtos aKC 2 0) ";"
              "(3)_" dia "(4)_" soLop "(5)_" hBar)))
  (if eTag
    (QS-GanXDataChuoi eTag
      (strcat "(0)_" mck "(1)_" sh "(2)_" (if hBar hBar "")
              "(3)_" dia "(4)_" soLop "(5)_" (itoa soTong))))
  (if eRai
    (progn
      (QS-GanXDataChuoi eRai
        (strcat "(0)_" mck "(1)_" shRai "(2)_" idRai
                "(3)_" dia "(4)_" soLop ht4 "(5)_" (itoa soTong)))

      (if eTag
        (progn
          (setq hTag (cdr (assoc 5 (entget eTag))))
          (QS-GanLinkRai eRai hTag)
          (QS-GanLinkRai eTag (cdr (assoc 5 (entget eRai))))
          (if eBar (QS-GanLinkRai eBar (cdr (assoc 5 (entget eRai)))))
        )
      )
    )
  )
  idRai
)

(defun QS-IDNhomRai (ent / f p)
  (setq f (QS-TachFieldXData (QS-DocXDataTho ent) 2))
  (if (and f (/= f ""))
    (progn
      (setq p (vl-string-search "/" f))
      (if p (substr f 1 p) f)
    )
  )
)

(defun QS-KCTrenThep (ent / f p)
  (setq f (QS-TachFieldXData (QS-DocXDataTho ent) 2))
  (if (and f (setq p (vl-string-search "/KC" f)))
    (atof (QS-SoDau (substr f (+ p 4))))
    0.0
  )
)

(defun QS-ThepTheoIDRai (idRai ssBar / ss i n e)
  (setq ss (if ssBar ssBar
             (ssget "_X" '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "LINE")
                           (-4 . "OR>") (8 . "QS_ThepChu,DCE_ThepChu")))))
  (setq i 0 n (if ss (sslength ss) 0) e nil)
  (while (and (null e) (< i n))
    (if (equal (QS-IDNhomRai (ssname ss i)) idRai)
      (setq e (ssname ss i)))
    (setq i (1+ i))
  )
  e
)

(defun QS-LapChiMuc ( / ss i n e id h pr)
  (setq *QS-IXBAR* nil *QS-IXTAG* nil *QS-IXTSS* nil)
  (setq ss (ssget "_X" '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "LINE")
                         (-4 . "OR>") (8 . "QS_ThepChu,DCE_ThepChu"))))
  (setq i 0 n (if ss (sslength ss) 0))
  (while (< i n)
    (setq e (ssname ss i))
    (setq id (QS-IDNhomRai e))
    (if (and id (/= id ""))
      (progn
        (setq pr (assoc id *QS-IXBAR*))
        (if pr
          (setq *QS-IXBAR* (subst (cons id (cons e (cdr pr))) pr *QS-IXBAR*))
          (setq *QS-IXBAR* (cons (list id e) *QS-IXBAR*)))
      )
    )
    (setq i (1+ i))
  )
  (setq ss (ssget "_X" '((0 . "INSERT") (8 . "QS_Block,DCE_Block"))))
  (setq *QS-IXTSS* ss)
  (setq i 0 n (if ss (sslength ss) 0))
  (while (< i n)
    (setq e (ssname ss i))
    (setq h (QS-TachFieldXData (QS-DocXDataTho e) 2))
    (if (and h (/= h ""))
      (setq *QS-IXTAG* (cons (cons (strcase h) e) *QS-IXTAG*)))
    (setq i (1+ i))
  )
  (setq *QS-IX* T)
  (princ)
)

(defun QS-XoaChiMuc ( / )
  (setq *QS-IX* nil *QS-IXBAR* nil *QS-IXTAG* nil *QS-IXTSS* nil)
  (princ)
)

(defun QS-TagTheoHandleThep (hBar ssTag / ss i n e f)
  (if (and *QS-IX* (null ssTag))
    (cdr (assoc (strcase hBar) *QS-IXTAG*))
    (progn
  (setq ss (if ssTag ssTag
             (if *QS-IXTSS* *QS-IXTSS*
               (ssget "_X" '((0 . "INSERT") (8 . "QS_Block,DCE_Block"))))))
  (setq i 0 n (if ss (sslength ss) 0) e nil)
  (while (and (null e) (< i n))
    (setq f (QS-TachFieldXData (QS-DocXDataTho (ssname ss i)) 2))
    (if (and f (= (strcase f) (strcase hBar))) (setq e (ssname ss i)))
    (setq i (1+ i))
  )
  e
    )
  )
)

(defun QS-ChuanBiDimNeo (h rnd ma / ten ty)

  (setq ma "O")
  (setq ty (/ h 2.5))
  (if (<= ty 0.0) (setq ty 1.0))
  (setq ten (strcat "QS_Neo_" (itoa (fix (+ 0.5 ty)))))

  (if T
    (progn

      (QS-DimChuan ty ma)
      (QS-SetVarAn "DIMASZ"    1.5)
      (QS-SetVarAn "DIMFXLON"  1)
      (QS-SetVarAn "DIMFXL"    4.0)
      (QS-SetVarAn "DIMEXO"    2.0)
      (QS-SetVarAn "DIMEXE"    1.0)
      (QS-SetVarAn "DIMCEN"    2.5)
      (QS-SetVarAn "DIMJOGANG" 45.0)
      (QS-SetVarAn "DIMSE1"    0)
      (QS-SetVarAn "DIMSE2"    0)
      (QS-SetVarAn "DIMSD1"    0)
      (QS-SetVarAn "DIMSD2"    0)
      (QS-SetVarAn "DIMTAD"    1)
      (QS-SetVarAn "DIMTIX"    1)
      (QS-SetVarAn "DIMTMOVE"  2)
      (QS-SetVarAn "DIMTOFL"   1)
      (QS-SetVarAn "DIMTDEC"   0)
      (QS-SetVarAn "DIMTZIN"   8)
      (QS-SetVarAn "DIMRND"    (float rnd))
      (QS-LuuDimStyle ten)
    )
  )
  ten
)

(defun QS-CutNoiStyle (h rnd ma / ten ty styles style)

  (setq ma "O")
  (setq ty (/ h 2.5))
  (if (<= ty 0.0) (setq ty 1.0))
  (setq ten (strcat "QS_Neo_" (itoa (fix (+ 0.5 ty)))))

  (if T
    (progn

      (QS-DimChuan ty ma)
      (QS-SetVarAn "DIMASZ"    1.5)
      (QS-SetVarAn "DIMFXLON"  1)
      (QS-SetVarAn "DIMFXL"    4.0)
      (QS-SetVarAn "DIMEXO"    2.0)
      (QS-SetVarAn "DIMEXE"    1.0)
      (QS-SetVarAn "DIMCEN"    2.5)
      (QS-SetVarAn "DIMJOGANG" 45.0)
      (QS-SetVarAn "DIMSE1"    0)
      (QS-SetVarAn "DIMSE2"    0)
      (QS-SetVarAn "DIMSD1"    0)
      (QS-SetVarAn "DIMSD2"    0)
      (QS-SetVarAn "DIMTAD"    1)
      (QS-SetVarAn "DIMTIX"    1)
      (QS-SetVarAn "DIMTMOVE"  2)
      (QS-SetVarAn "DIMTOFL"   1)
      (QS-SetVarAn "DIMTDEC"   0)
      (QS-SetVarAn "DIMTZIN"   8)
      (QS-SetVarAn "DIMRND"    (float rnd))
      (setq styles (vla-get-DimStyles (QS-Doc)))
      (setq style (if (tblsearch "DIMSTYLE" ten) (vla-Item styles ten) (vla-Add styles ten)))
      (vla-CopyFrom style (QS-Doc))
    )
  )
  ten
)

(defun QS-VeDimNoi (spc p1 p2 h ofs nd / mid tp dimObj)
  (setq mid (list (/ (+ (car p1) (car p2)) 2.0)
                  (/ (+ (cadr p1) (cadr p2)) 2.0)))
  (setq tp (list (+ (car mid) (* ofs (car nd)))
                 (+ (cadr mid) (* ofs (cadr nd))) 0.0))
  (setq dimObj
    (vl-catch-all-apply 'vla-AddDimAligned
      (list spc (vlax-3d-point (list (car p1) (cadr p1) 0.0))
                (vlax-3d-point (list (car p2) (cadr p2) 0.0))
                (vlax-3d-point tp))))
  (if (vl-catch-all-error-p dimObj)
    nil
    (progn
      (vl-catch-all-apply 'vla-put-Layer      (list dimObj "QS_Dim"))
      (vl-catch-all-apply 'vla-put-TextHeight (list dimObj 2.5))
      T
    )
  )
)

(defun QS-GhiDimNoiCap (dsCap h rnd ofs ma / doc spc olddim oldecho z dem)
  (if (null dsCap)
    0
    (progn
      (setq doc (QS-Doc) spc (QS-Space doc))
      (QS-DamBaoLayer "QS_Dim" 254)
      (if (<= ofs 0.0) (setq ofs (* 2.5 h)))
      (setq oldecho (getvar "CMDECHO"))
      (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
      (setq olddim (getvar "DIMSTYLE"))
      (QS-ChuanBiDimNeo h rnd ma)
      (setq dem 0)
      (foreach z dsCap
        (if (> (distance (list (car (car z)) (cadr (car z)))
                         (list (car (cadr z)) (cadr (cadr z)))) 1.0)
          (if (QS-VeDimNoi spc (car z) (cadr z) h ofs (caddr z))
            (setq dem (1+ dem))))
      )
      (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
        (command "_.-DIMSTYLE" "_R" olddim))
      (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
      dem
    )
  )
)

(defun QS-GhiDimCap (dsCap h rnd ofs ma
                     / doc spc olddim oldecho z dem midZ lastMid gGap)
  (if (null dsCap)
    0
    (progn
      (setq doc (QS-Doc) spc (QS-Space doc))
      (QS-DamBaoLayer "QS_Dim" 254)
      (if (<= ofs 0.0) (setq ofs (* 2.5 h)))
      (setq oldecho (getvar "CMDECHO"))
      (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
      (setq olddim (getvar "DIMSTYLE"))
      (QS-ChuanBiDimNeo h rnd ma)
      ;; dev47: nhieu dai/nhom rieng le nam sat nhau -> doan neo o dau CO
      ;; DINH cua tung nhom nam qua gan nhau, dim chong chu len nhau
      ;; khong doc duoc (DU chieu dai co hoi khac nhau vai mm do hinh hoc
      ;; that). Uu tien DE DOC: bo qua 1 doan neu no nam qua gan doan da
      ;; GIU LAI gan nhat (< gGap), bat ke gia tri co trung hay khong -
      ;; chi giu doan dau tien cua tung cum sat nhau.
      (setq gGap (* 4.0 h))
      (setq dem 0 *QS-KHONGDATCHU* T lastMid nil)
      (foreach z dsCap
        (if (> (distance (list (car (car z)) (cadr (car z)))
                         (list (car (cadr z)) (cadr (cadr z)))) 1.0)
          (progn
            (setq midZ (list (/ (+ (car (car z)) (car (cadr z))) 2.0)
                              (/ (+ (cadr (car z)) (cadr (cadr z))) 2.0)))
            (if (not (and lastMid (< (distance midZ lastMid) gGap)))
              (progn
                (if (QS-VeDimDoan spc (car z) (cadr z) h ofs nil nil T T)
                  (setq dem (1+ dem)))
                (setq lastMid midZ)
              )
            )
          )
        )
      )
      (setq *QS-KHONGDATCHU* nil)
      (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
        (command "_.-DIMSTYLE" "_R" olddim))
      (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
      dem
    )
  )
)

(defun QS-TimMepDam (spc p d dmax curves / ln t0 ts best x r res)
  (if (or (null curves) (<= dmax 0.0))
    nil
    (progn
      (setq ln (vl-catch-all-apply 'vla-AddLine
                 (list spc
                   (vlax-3d-point (list (car p) (cadr p) 0.0))
                   (vlax-3d-point (list (+ (car p) (* dmax (car d)))
                                        (+ (cadr p) (* dmax (cadr d))) 0.0)))))
      (if (vl-catch-all-error-p ln)
        nil
        (progn
          (setq t0 (+ (* (car p) (car d)) (* (cadr p) (cadr d))))
          (setq ts (QS-GiaoT ln curves d))
          (vl-catch-all-apply 'vla-Delete (list ln))
          (setq best nil)
          (foreach x ts
            (setq r (- x t0))
            (if (< r 0.0) (setq r 0.0))
            (if (<= r dmax) (setq best (cons r best))))
          (setq best (vl-sort best (function <)))
          (setq res nil)
          (foreach x best
            (if (or (null res) (> (- x (car res)) 1.0))
              (setq res (cons x res))))
          (reverse res)
        )
      )
    )
  )
)

(defun QS-NeoKe (ds neoD bv kemin / r1 r2 B la h)
  (if (null ds)
    nil
    (progn
      (setq r1 (car ds) r2 (cadr ds))
      (if (null r2)
        (list (+ r1 neoD) 0.0)
        (progn
          (setq B (- (- r2 bv) r1))
          (if (< B 0.0) (setq B 0.0))
          (if (<= neoD B)
            (setq la neoD h 0.0)
            (setq la B h (- neoD B)))
          (if (and (> h 1.0e-6) (< h kemin)) (setq h kemin))
          (list (+ r1 la) h)
        )
      )
    )
  )
)

(defun QS-VeThanhKe (p1 p2 h1 h2 nn lay / pts eLst p)
  (setq pts (list (list (car p1) (cadr p1)) (list (car p2) (cadr p2))))
  (if (> h1 1.0e-6)
    (setq pts (cons (list (+ (car p1) (* h1 (car nn)))
                          (+ (cadr p1) (* h1 (cadr nn)))) pts)))
  (if (> h2 1.0e-6)
    (setq pts (append pts (list (list (+ (car p2) (* h2 (car nn)))
                                      (+ (cadr p2) (* h2 (cadr nn))))))))
  (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                   (cons 8 lay) '(100 . "AcDbPolyline")
                   (cons 90 (length pts)) '(70 . 0)))
  (foreach p pts
    (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))
  (if (entmake eLst) (entlast) nil)
)

(defun QS-GhiDimLM (dsCap h rnd ma / doc spc olddim oldecho z dem
                                     p1 p2 m of mid tp dimObj lc uu tt)
  (if (null dsCap)
    0
    (progn
      (setq doc (QS-Doc) spc (QS-Space doc))
      (QS-DamBaoLayer "QS_Dim" 254)
      (setq oldecho (getvar "CMDECHO"))
      (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
      (setq olddim (getvar "DIMSTYLE"))
      (QS-ChuanBiDimNeo h rnd ma)
      (setq dem 0)
      (foreach z dsCap
        (setq p1 (nth 0 z) p2 (nth 1 z) m (nth 2 z) of (nth 3 z)
              lc (if (nth 4 z) (nth 4 z) 0.0))
        (if (> (distance p1 p2) 1.0)
          (progn
            (setq mid (list (/ (+ (car p1) (car p2)) 2.0)
                            (/ (+ (cadr p1) (cadr p2)) 2.0)))
            (setq uu (QS-DVi p1 p2))
            (if (null uu) (setq uu (list 1.0 0.0)))
            (setq tp (list (+ (car mid) (* of (car m)))
                           (+ (cadr mid) (* of (cadr m))) 0.0))
            (setq tt (list (+ (car tp) (* lc (car uu)))
                           (+ (cadr tp) (* lc (cadr uu))) 0.0))
            (setq dimObj
              (vl-catch-all-apply 'vla-AddDimAligned
                (list spc (vlax-3d-point (list (car p1) (cadr p1) 0.0))
                          (vlax-3d-point (list (car p2) (cadr p2) 0.0))
                          (vlax-3d-point tp))))
            (if (not (vl-catch-all-error-p dimObj))
              (progn
                (vl-catch-all-apply 'vla-put-Layer      (list dimObj "QS_Dim"))
                (vl-catch-all-apply 'vla-put-TextHeight (list dimObj 2.5))
                (if (> (abs lc) 1.0e-6)
                  (vl-catch-all-apply 'vla-put-TextPosition
                    (list dimObj (vlax-3d-point tt))))
                (setq dem (1+ dem))))
          )
        )
      )
      (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
        (command "_.-DIMSTYLE" "_R" olddim))
      (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
      dem
    )
  )
)

(defun QS-LayDoanThep (ent bomin / np i p1 p2 lst dchord darc)
  (setq np (fix (+ 0.0001 (vlax-curve-getEndParam ent))))
  (setq i 0 lst nil)
  (while (< i np)
    (setq p1 (vlax-curve-getPointAtParam ent i)
          p2 (vlax-curve-getPointAtParam ent (1+ i)))
    (if (and p1 p2)
      (progn
        (setq dchord (distance p1 p2))
        (setq darc (- (vlax-curve-getDistAtParam ent (1+ i))
                      (vlax-curve-getDistAtParam ent i)))
        (if (and (> dchord 1.0e-6) (> dchord bomin)
                 (< (- darc dchord) (max 1.0e-6 (* 0.001 dchord))))
          (setq lst (cons (list p1 p2) lst)))
      )
    )
    (setq i (1+ i))
  )
  (reverse lst)
)

(defun QS-VeDimDoan (spc p1 p2 h ofs dao cen eptren lathan / ang nx ny mid tp dimObj dxm dym dot)
  (setq ang (angle p1 p2))
  (setq nx (- (sin ang)) ny (cos ang))
  (setq mid (list (/ (+ (car p1) (car p2)) 2.0)
                  (/ (+ (cadr p1) (cadr p2)) 2.0)
                  0.0))

  (setq dot nil)
  (if cen
    (progn
      (setq dxm (- (car mid) (car cen)) dym (- (cadr mid) (cadr cen)))
      (setq dot (+ (* nx dxm) (* ny dym)))
      (if (< (abs dot) (* 0.01 h)) (setq dot nil))
    )
  )
  (cond

    ((and eptren lathan)
     (if (> (abs ny) 0.1)
       (if (< ny 0.0) (setq nx (- nx) ny (- ny)))
       (if (> nx 0.0) (setq nx (- nx) ny (- ny)))))
    (dot (if (< dot 0.0) (setq nx (- nx) ny (- ny))))

    ((or (< ny -1.0e-8) (and (< (abs ny) 1.0e-8) (< nx 0.0)))
     (setq nx (- nx) ny (- ny)))
  )
  (if dao (setq nx (- nx) ny (- ny)))
  (setq tp (list (+ (car mid) (* ofs nx)) (+ (cadr mid) (* ofs ny)) 0.0))
  (setq dimObj
    (vl-catch-all-apply 'vla-AddDimAligned
      (list spc (vlax-3d-point (list (car p1) (cadr p1) 0.0))
                (vlax-3d-point (list (car p2) (cadr p2) 0.0))
                (vlax-3d-point tp))))
  (if (vl-catch-all-error-p dimObj)
    nil
    (progn
      (vl-catch-all-apply 'vla-put-Layer        (list dimObj "QS_Dim"))
      (vl-catch-all-apply 'vla-put-TextHeight   (list dimObj 2.5))
      (if *QS-DIMTHEOHUONG*
        (vla-put-TextRotation dimObj
          (QS-GocDoc (list (- (car p2) (car p1)) (- (cadr p2) (cadr p1))))))
      (if (not *QS-KHONGDATCHU*)
        (vl-catch-all-apply 'vla-put-TextPosition (list dimObj (vlax-3d-point tp))))
      dimObj
    )
  )
)

(defun QS-GhiDimThep (lstEnt h rnd ofs bomin dao ma eptren
                      / doc spc olddim oldecho dem bo e segs s cen sx sy nn
                        imax dmax i dd angMax)
  (setq doc (QS-Doc) spc (QS-Space doc))
  (QS-DamBaoLayer "QS_Dim" 254)
  (if (<= ofs 0.0) (setq ofs (* 0.8 h)))
  (setq oldecho (getvar "CMDECHO"))
  (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
  (setq olddim (getvar "DIMSTYLE"))
  (QS-ChuanBiDimStyle h rnd ma)
  (setq dem 0 bo 0)
  (foreach e lstEnt
    (setq segs (QS-LayDoanThep e bomin))
    (setq bo (+ bo (- (fix (+ 0.0001 (vlax-curve-getEndParam e))) (length segs))))

    (setq sx 0.0 sy 0.0 nn 0)
    (foreach s segs
      (setq sx (+ sx (car (car s)) (car (cadr s)))
            sy (+ sy (cadr (car s)) (cadr (cadr s)))
            nn (+ nn 2))
    )
    (setq cen (if (> nn 0) (list (/ sx nn) (/ sy nn)) nil))

    (setq imax 0 dmax -1.0 i 0)
    (foreach s segs
      (setq dd (distance (car s) (cadr s)))
      (if (> dd dmax) (setq dmax dd imax i))
      (setq i (1+ i))
    )

    (setq angMax (if segs (angle (car (nth imax segs)) (cadr (nth imax segs))) 0.0))
    (foreach s segs
      (if (QS-VeDimDoan spc (car s) (cadr s) h ofs dao cen eptren
            (> (abs (cos (- (angle (car s) (cadr s)) angMax))) 0.9))
        (setq dem (1+ dem)))
    )
  )

  (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
    (command "_.-DIMSTYLE" "_R" olddim))
  (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
  (list dem bo)
)

(defun c:OS_DIMTHEP ( / *error* doc dclId ss n i ent lst kq
                        cao rnd ofs bomin dao)

  (defun *error* (msg)
    (QS-DongDCL)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (princ "\n=== OS_DIMTHEP - GHI KICH THUOC TUNG DOAN THANH THEP ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)

  (setq *QS3-CAO* nil)
  (setq dclId (QS-NapDCL))
  (if dclId
    (progn
      (if (not (new_dialog "qs_dimthep" dclId))
        (princ "\n[Loi] Khong khoi tao duoc dialog qs_dimthep.")
        (progn
          (set_tile "dcao" (if *QSL-DCAO* *QSL-DCAO* (if *QSL-CC* *QSL-CC* "125")))
          (set_tile "drnd" (if *QSL-DRND* *QSL-DRND* "5"))
          (set_tile "dofs" (if *QSL-DOFS* *QSL-DOFS* "0"))
          (set_tile "dmin" (if *QSL-DMIN* *QSL-DMIN* "0"))
          (if (not *QSL-DPHIA*) (setq *QSL-DPHIA* "ph_auto"))
          (set_tile "dphia" *QSL-DPHIA*)
          (set_tile "dghichu" "Sau khi bam OK: quet chon cac duong thep can ghi kich thuoc.")
          (action_tile "accept" "(QS-Accept3)")
          (action_tile "cancel" "(done_dialog 0)")
          (progn (QS-PJInit "qs_dimthep") (start_dialog))
        )
      )
      (QS-DongDCL)
    )
  )

  (if (not *QS3-CAO*)
    (princ "\nDa huy lenh.")
    (progn
      (setq cao   (QS-Num *QS3-CAO*)
            rnd   (QS-Num *QS3-RND*)
            ofs   (QS-Num *QS3-OFS*)
            bomin (QS-Num *QS3-MIN*)
            dao   (= *QS3-PHIA* "ph_dao"))
      (setq *QSL-DCAO* *QS3-CAO* *QSL-DRND* *QS3-RND* *QSL-DOFS* *QS3-OFS*
            *QSL-DMIN* *QS3-MIN* *QSL-DPHIA* *QS3-PHIA*)

      (princ "\n\nQuet chon cac duong thep (LINE/POLYLINE) can ghi kich thuoc tung doan: ")
      (setq ss (ssget '((-4 . "<OR") (0 . "LINE") (0 . "LWPOLYLINE")
                        (0 . "POLYLINE") (-4 . "OR>"))))
      (if (not ss)
        (princ "\nKhong chon duoc duong thep nao. Huy lenh.")
        (progn
          (setq n (sslength ss) i 0 lst nil)
          (while (< i n)
            (setq ent (ssname ss i))
            (setq lst (cons ent lst))
            (setq i (1+ i))
          )
          (setq lst (reverse lst))
          (setq kq (QS-GhiDimThep lst cao rnd ofs bomin dao "F" T))
          (princ (strcat "\n\n[HOAN TAT] Da ghi " (itoa (car kq))
                         " dim tren " (itoa (length lst)) " thanh thep."))
          (if (> (cadr kq) 0)
            (princ (strcat "\n[Chu y] Bo qua " (itoa (cadr kq))
                           " doan (ngan hon nguong hoac la doan cong/bo tron).")))
          (princ (strcat "\n   Dimstyle dang dung : QS_Thep_" (itoa (fix cao))
                         "_" (itoa (fix rnd)) "_F   -   Layer : DCE_Dim"))
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-Pt (u v s tt)
  (list (+ (* s (car v))  (* tt (car u)))
        (+ (* s (cadr v)) (* tt (cadr u)))
        0.0)
)

(defun QS-LocTrung (ts / res)
  (foreach x ts
    (if (or (null res) (> (abs (- x (car res))) 1.0e-7))
      (setq res (cons x res))))
  (reverse res)
)

(defun QS-TsToKhoang (ts / res)
  (while (and ts (cdr ts))
    (if (> (- (cadr ts) (car ts)) 1.0e-6)
      (setq res (cons (list (car ts) (cadr ts)) res)))
    (setq ts (cddr ts))
  )
  (reverse res)
)

(defun QS-HopKhoang (lst / sx res cur k)
  (setq sx (vl-sort lst (function (lambda (x y) (< (car x) (car y))))))
  (setq res nil cur nil)
  (foreach k sx
    (if (and cur (<= (car k) (+ (cadr cur) 1.0)))
      (setq cur (list (car cur) (max (cadr cur) (cadr k))))
      (progn (if cur (setq res (cons cur res))) (setq cur k))))
  (if cur (setq res (cons cur res)))
  (reverse res)
)

(defun QS-SlabIntervals (lnObj curves w)
  (if *QS-SLABUNION*
    (QS-GiaoTHop lnObj curves w)
    (QS-TsToKhoang (QS-GiaoT lnObj curves w))))

(defun QS-GiaoTHop (lnObj curves w / res c)
  (setq res nil)
  (foreach c curves
    (setq res (append res (QS-TsToKhoang (QS-GiaoT lnObj (list c) w)))))
  (QS-HopKhoang res)
)

(defun QS-BeamGapCovered (intervals lo hi / found iv)
  (foreach iv intervals
    (if (and (<= (car iv) (+ lo 0.5)) (>= (cadr iv) (- hi 0.5)))
      (setq found T)))
  found)

(defun QS-BeamEdges (intervals / out iv)
  ;; Ignore internal edges of overlapping beam footprints.
  (foreach iv intervals (setq out (append out (list (car iv) (cadr iv)))))
  out)

(defun QS-BeamWidth (intervals edge side / result iv near gap best width)
  (setq result 0.0)
  (foreach iv intervals
    (progn
      (setq near (if (< side 0) (cadr iv) (car iv))
            gap (* side (- near edge))
            width (if (< side 0) (- edge (car iv)) (- (cadr iv) edge)))
      ;; Only accept a beam on the anchorage side, with at most 10 mm clearance.
      ;; Include clearance in extension so cover is measured from the real far face.
      (if (and (> width 0.5) (<= gap (+ 10.0 1.0e-6))
               (or (>= gap 0.0)
                   (and (<= (car iv) edge) (>= (cadr iv) edge)))
               (or (null best) (< (max 0.0 gap) best)))
        (setq result width best (max 0.0 gap)))))
  result)

(defun QS-SlabLinkClear (a b / f s lo hi rooms valid iv)
  ;; Check interpolated clear spans, never anchorage extensions, against beam union.
  (if (not *QS-SLAB-STRICT*) T
    (progn
      (setq valid T)
      (foreach f '(0.25 0.5 0.75)
        (if valid
          (progn
            (setq s (+ (nth 1 a) (* f (- (nth 1 b) (nth 1 a))))
                  lo (+ (nth 8 a) (* f (- (nth 8 b) (nth 8 a))))
                  hi (+ (nth 9 a) (* f (- (nth 9 b) (nth 9 a)))))
            (vla-put-StartPoint lnObj (vlax-3d-point (QS-Pt u v s tmin)))
            (vla-put-EndPoint lnObj (vlax-3d-point (QS-Pt u v s tmax)))
            (setq rooms (QS-TruKhoang (QS-SlabIntervals lnObj dsNgoai u)
                                      (QS-GiaoTHop lnObj dsDamSan u)))
            (if dsLo (setq rooms (QS-TruKhoang rooms (QS-GiaoTHop lnObj dsLo u))))
            (if vgClip (setq rooms (QS-GiaoKhoang rooms (QS-GiaoTHop lnObj vgClip u))))
            (if vgTru (setq rooms (QS-TruKhoang rooms (QS-GiaoTHop lnObj vgTru u))))
            (setq valid nil)
            (foreach iv rooms
              (if (and (<= (car iv) (+ lo 0.5)) (>= (cadr iv) (- hi 0.5)))
                (setq valid T))))))
      valid)))

(defun QS-TruKhoang (A B / res cur tmp lo hi)
  (foreach a A
    (setq cur (list a))
    (foreach b B
      (setq tmp nil)
      (foreach c cur
        (setq lo (car c) hi (cadr c))
        (cond
          ((or (<= (cadr b) lo) (>= (car b) hi)) (setq tmp (cons c tmp)))
          (T
           (if (> (- (car b) lo) 1.0e-6)  (setq tmp (cons (list lo (car b)) tmp)))
           (if (> (- hi (cadr b)) 1.0e-6) (setq tmp (cons (list (cadr b) hi) tmp))))
        )
      )
      (setq cur (reverse tmp))
    )
    (setq res (append res cur))
  )
  (vl-sort res (function (lambda (x y) (< (car x) (car y)))))
)

(defun QS-GiaoKhoang (A B / res lo hi)
  (foreach a A
    (foreach b B
      (setq lo (max (car a) (car b)) hi (min (cadr a) (cadr b)))
      (if (> (- hi lo) 1.0e-6) (setq res (cons (list lo hi) res)))
    )
  )
  (vl-sort res (function (lambda (x y) (< (car x) (car y)))))
)

(defun QS-TKe (ts t0 eps / r)
  (foreach x ts (if (and (null r) (> x (+ t0 eps))) (setq r x)))
  r
)

(defun QS-TTruoc (ts t0 eps / r)
  (foreach x ts (if (< x (- t0 eps)) (setq r x)))
  r
)

(defun QS-KhoangChua (lst tt / r)
  (foreach k lst
    (if (and (null r) (>= tt (car k)) (<= tt (cadr k))) (setq r k)))
  r
)

(defun QS-Chen (x lst / res done y)
  (setq res nil done nil)
  (foreach y lst
    (if (and (not done) (<= x y)) (progn (setq res (cons x res)) (setq done T)))
    (setq res (cons y res))
  )
  (if (not done) (setq res (cons x res)))
  (reverse res)
)

(defun QS-SapKhongLoai (lst / res x)
  (setq res nil)
  (foreach x lst (setq res (QS-Chen x res)))
  res
)

(defun QS-GiaoT (lnObj curves u / ts tc r n i px py)
  (setq ts nil)
  (foreach c curves
    (setq tc nil r (vl-catch-all-apply 'vlax-invoke (list lnObj 'IntersectWith c 0)))
    (if (and (not (vl-catch-all-error-p r)) r (listp r))
      (progn
        (setq n (length r) i 0)
        (while (<= (+ i 3) n)
          (setq px (nth i r) py (nth (1+ i) r))
          (setq tc (cons (+ (* px (car u)) (* py (cadr u))) tc))
          (setq i (+ i 3))
        )
      )
    )
    (setq ts (append ts (QS-LocTrung (QS-Sap tc '<))))
  )
  (QS-SapKhongLoai ts)
)

(defun QS-TinhNeo (B lneo hmin c / la h thieu)

  (if (> B (+ lneo c)) (setq B (+ lneo c)))
  (if (<= B 1.0e-6)
    (list (- c) hmin)
    (progn
      (setq thieu (- lneo (- B c)))
      (if (< thieu 0.0) (setq thieu 0.0))
      (if (>= thieu hmin)
        (setq la (- B c) h thieu)
        (setq h hmin la (- lneo h c))
      )
      (if (< la 0.0) (setq la 0.0))
      (if (> la (- B c)) (setq la (- B c)))
      (if (< la 0.0) (setq la 0.0))
      (if (< h 0.0) (setq h 0.0))
      (list la h)
    )
  )
)

(defun QS-SgnN (nx ny v)
  (if (> (+ (* nx (car v)) (* ny (cadr v))) 0.0) 1.0 -1.0)
)

(defun QS-STaiT (s dsGay nx ny v tt / sc g)
  (setq sc s)
  (foreach g (vl-sort dsGay (function (lambda (a b) (< (car a) (car b)))))
    (if (>= tt (cadr g)) (setq sc (+ sc (* (QS-SgnN nx ny v) (caddr g)))))
  )
  sc
)

(defun QS-VeThanhThep (u v s t1 t2 h1 h2 nx ny dsGay / p1 p2 pts eLst g sc sgnN)
  (setq sgnN (QS-SgnN nx ny v) sc s)
  (setq pts (list (QS-Pt u v sc t1)))
  (foreach g (vl-sort dsGay (function (lambda (a b) (< (car a) (car b)))))
    (if (and (> (car g) (+ t1 1.0e-6)) (< (cadr g) (- t2 1.0e-6)))
      (progn
        (setq pts (append pts (list (QS-Pt u v sc (car g)))))
        (setq sc (+ sc (* sgnN (caddr g))))
        (setq pts (append pts (list (QS-Pt u v sc (cadr g)))))
      )
    )
  )
  (setq pts (append pts (list (QS-Pt u v sc t2))))
  (setq p1 (car pts) p2 (last pts))
  (if (> h1 1.0e-6)
    (setq pts (cons (list (+ (car p1) (* h1 nx)) (+ (cadr p1) (* h1 ny)) 0.0) pts)))
  (if (> h2 1.0e-6)
    (setq pts (append pts
                (list (list (+ (car p2) (* h2 nx)) (+ (cadr p2) (* h2 ny)) 0.0)))))
  (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                   '(8 . "QS_ThepChu") '(100 . "AcDbPolyline")
                   (cons 90 (length pts)) '(70 . 0)))
  (foreach p pts
    (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))
  (if (entmake eLst) (entlast) nil)
)

(defun QS-ChuanBiRaiStyle (h ma / ten ty)
  (if (not ma) (setq ma "F"))
  (setq ty (/ h 2.5))
  (if (<= ty 0.0) (setq ty 1.0))
  (setq ten (strcat "QS_Rai_" (itoa (fix (+ 0.5 ty)))))
  (if T
    (progn
      (QS-DimChuan ty ma)
      (QS-SetVarAn "DIMTXT"   0.0)
      (QS-SetVarAn "DIMASZ"   2.5)
      (QS-SetVarAn "DIMSE1"   0)
      (QS-SetVarAn "DIMSE2"   0)
      (QS-SetVarAn "DIMSD1"   0)
      (QS-SetVarAn "DIMSD2"   0)
      (QS-SetVarAn "DIMEXO"   0.0)
      (QS-SetVarAn "DIMEXE"   1.0)
      (QS-SetVarAn "DIMTAD"   1)
      (QS-SetVarAn "DIMTIX"   1)
      (QS-SetVarAn "DIMTMOVE" 2)
      (QS-SetVarAn "DIMTOFL"  1)
      (QS-SetVarAn "DIMRND"   0.0)
      (QS-LuuDimStyle ten)
    )
  )
  ten
)

(defun QS-CutRaiStyle (h ma / ten ty styles obj)
  (if (not ma) (setq ma "F"))
  (setq ty (/ h 2.5))
  (if (<= ty 0.0) (setq ty 1.0))
  (setq ten (strcat "QS_Rai_" (itoa (fix (+ 0.5 ty)))))
  (if T
    (progn
      (QS-DimChuan ty ma)
      (QS-SetVarAn "DIMTXT"   0.0)
      (QS-SetVarAn "DIMASZ"   2.5)
      (QS-SetVarAn "DIMSE1"   0)
      (QS-SetVarAn "DIMSE2"   0)
      (QS-SetVarAn "DIMSD1"   0)
      (QS-SetVarAn "DIMSD2"   0)
      (QS-SetVarAn "DIMEXO"   0.0)
      (QS-SetVarAn "DIMEXE"   1.0)
      (QS-SetVarAn "DIMTAD"   1)
      (QS-SetVarAn "DIMTIX"   1)
      (QS-SetVarAn "DIMTMOVE" 2)
      (QS-SetVarAn "DIMTOFL"  1)
      (QS-SetVarAn "DIMRND"   0.0)
      (setq styles (vla-get-DimStyles (QS-Doc)))
      (setq obj (if (tblsearch "DIMSTYLE" ten) (vla-Item styles ten) (vla-Add styles ten)))
      (vla-CopyFrom obj (QS-Doc))
    )
  )
  ten
)

(defun QS-VeDuongRai (spc p1 p2 ptBar h / dimObj cirObj)
  (if (< (distance p1 p2) 1.0e-6)
    nil
    (progn
      (setq dimObj
        (vl-catch-all-apply 'vla-AddDimAligned
          (list spc (vlax-3d-point (list (car p1) (cadr p1) 0.0))
                    (vlax-3d-point (list (car p2) (cadr p2) 0.0))
                    (vlax-3d-point (list (car p1) (cadr p1) 0.0)))))
      (if (not (vl-catch-all-error-p dimObj))
        (progn
          (vl-catch-all-apply 'vla-put-Layer (list dimObj "QS_Symbol"))

          (vl-catch-all-apply 'vla-put-TextOverride (list dimObj " "))
        )
      )
      (if ptBar
        (progn
          (setq cirObj
            (vl-catch-all-apply 'vla-AddCircle
              (list spc (vlax-3d-point (list (car ptBar) (cadr ptBar) 0.0)) (* 0.25 h))))
          (if (not (vl-catch-all-error-p cirObj))
            (vl-catch-all-apply 'vla-put-Layer (list cirObj "QS_Symbol")))
        )
      )

      (if (vl-catch-all-error-p dimObj)
        nil
        (vl-catch-all-apply 'vlax-vla-object->ename (list dimObj)))
    )
  )
)

(defun QS-GocRai45 (g)
  (while (< g 0.0) (setq g (+ g (* 2.0 pi))))
  (while (>= g (- (/ pi 2.0) 1.0e-9)) (setq g (- g (/ pi 2.0))))
  (if (< g 0.0) (setq g 0.0))
  (if (> g (/ pi 4.0)) (setq g (- g (/ pi 2.0))))
  g
)

(defun QS-GocDoc (u / g)
  (setq g (angle '(0.0 0.0) u))
  (while (< g 0.0) (setq g (+ g (* 2.0 pi))))
  (while (>= g (* 2.0 pi)) (setq g (- g (* 2.0 pi))))
  (if (and (> g (+ (/ pi 2.0) 1.0e-9)) (<= g (+ (* 1.5 pi) 1.0e-9)))
    (setq g (- g pi)))
  (if (< g 0.0) (setq g (+ g (* 2.0 pi))))
  g
)

(defun QS-ChenTagThep (spc pt tyle dkvakc sh vitri gocxoay / insObj a)
  (if (not gocxoay) (setq gocxoay 0.0))
  (setq insObj
    (vla-InsertBlock spc (vlax-3d-point (list (car pt) (cadr pt) 0.0))
                     "Dce_KhtThepDai2" tyle tyle tyle gocxoay))
  (vl-catch-all-apply 'vla-put-Layer (list insObj "QS_Block"))
  (foreach a (vlax-invoke insObj 'GetAttributes)
    (cond
      ((= (strcase (vla-get-TagString a)) "DKVAKC") (vla-put-TextString a dkvakc))
      ((= (strcase (vla-get-TagString a)) "SH")     (vla-put-TextString a sh))
      ((= (strcase (vla-get-TagString a)) "VITRI")  (vla-put-TextString a vitri))
    )
  )
  (vla-Update insObj)
  insObj
)

(defun QS-PhamViChieu (curves w / mn mx e np i p tp)
  (foreach e curves
    (setq np (fix (+ 0.0001 (vlax-curve-getEndParam e))) i 0)
    (while (<= i np)
      (setq p (vlax-curve-getPointAtParam e i))
      (if p
        (progn
          (setq tp (+ (* (car p) (car w)) (* (cadr p) (cadr w))))
          (if (or (null mn) (< tp mn)) (setq mn tp))
          (if (or (null mx) (> tp mx)) (setq mx tp))
        )
      )
      (setq i (1+ i))
    )
  )
  (if mn (list mn mx) nil)
)

(defun QS-CaoSoSanh (hs cote matsan)
  (if matsan (* 1000.0 cote) (- (* 1000.0 cote) hs))
)

(defun QS-ChiaKhoang (kh tsR / res iv lo hi cuts t0 prev prevk)
  (foreach iv kh
    (setq lo (car iv) hi (cadr iv) cuts nil)
    (foreach t0 tsR
      (if (and (> t0 (+ lo 1.0e-6)) (< t0 (- hi 1.0e-6))) (setq cuts (cons t0 cuts))))
    (setq cuts (QS-Sap (reverse cuts) '<))
    (if (null cuts)
      (setq res (cons (list lo hi "DAM" "DAM") res))
      (progn
        (setq prev lo prevk "DAM")
        (foreach t0 cuts
          (setq res (cons (list prev t0 prevk "RANH") res))
          (setq prev t0 prevk "RANH"))
        (setq res (cons (list prev hi prevk "DAM") res))
      )
    )
  )
  (vl-sort res (function (lambda (x y) (< (car x) (car y)))))
)

(defun QS-TagRanhBien (kh ts / res iv a b k1 k2 t0)
  (foreach iv kh
    (setq a (car iv) b (cadr iv) k1 (caddr iv) k2 (cadddr iv))
    (foreach t0 ts
      (if (< (abs (- t0 a)) 1.0) (setq k1 "RANH"))
      (if (< (abs (- t0 b)) 1.0) (setq k2 "RANH")))
    (setq res (cons (list a b k1 k2) res)))
  (reverse res)
)

(defun QS-DauChum (chum lech / n i res)
  (setq n (length chum) i 0 res nil)
  (while (< i n)
    (setq res (cons (if (or (<= n 1) (<= lech 0.0))
                      0.0
                      (if (= (rem i 2) 0) (- (/ lech 2.0)) (/ lech 2.0)))
                    res))
    (setq i (1+ i))
  )
  (reverse res)
)
(defun QS-LechTach (ivs lech / res chum tbPrev iv)
  (setq res nil chum nil tbPrev nil)
  (foreach iv ivs
    (if (and tbPrev (< (nth 2 iv) (+ tbPrev 1.0)))
      (setq chum (cons iv chum))
      (progn
        (setq res (append res (QS-DauChum (reverse chum) lech)))
        (setq chum (list iv))))
    (setq tbPrev (nth 3 iv))
  )
  (append res (QS-DauChum (reverse chum) lech))
)

(defun QS-GomKhoang (dsIv khN sanAm nguong matsan nhanN nhanLT nhanEQ nhanGT chogom
                     bodim boxien lneo keoDai cachMep
                     / res cur iv delta addl ok comat giua laRanh Lnhan g1 g2 gays
                       Lchieu Lthat Ladd tbm bdam thap caoA caoB doCote Lcur Liv
                       veThang)
  (setq res nil cur nil)
  (foreach iv dsIv
    (if (null cur)
      (setq cur (append iv (list 0.0 nil)))
      (progn
        (setq giua (/ (+ (nth 1 cur) (nth 0 iv)) 2.0))
        (setq comat (if (QS-KhoangChua khN giua) T nil))
        (setq laRanh (and (= (nth 9 cur) "RANH") (= (nth 8 iv) "RANH")))

        (setq bdam (- (nth 0 iv) (nth 1 cur)))
        (setq delta 0.0 thap nil)
        (if sanAm
          (progn
            (setq caoA (QS-CaoSoSanh (nth 6 cur) (nth 7 cur) matsan))
            (setq caoB (QS-CaoSoSanh (nth 6 iv)  (nth 7 iv)  matsan))
            (setq delta (abs (- caoA caoB)))
            (setq thap (< caoB caoA))))
        (setq doCote (and sanAm (> delta 1.0e-6)) veThang nil)
        (cond
          ;; Only bridge a verified beam gap when merging is enabled.
          ((and *QS-SLAB-STRICT* (> bdam 0.5)
                (not (and chogom (<= bdam (+ (* 2.0 lneo) 1.0e-6))
                          (QS-BeamGapCovered khD (nth 1 cur) (nth 0 iv)))))
           (setq ok nil))
          ((not comat) (setq ok nil))

          ((and sanAm (> delta 1.0e-6))
           (cond
             ((< delta (- nguong 1.0e-6)) (setq ok T veThang (not nhanLT)))
             ((<= delta (+ nguong 1.0e-6)) (setq ok T veThang (not nhanEQ)))
             (T (setq ok nhanGT veThang nil))))

          ((< bdam 1.0) (setq ok chogom))

          ((and chogom (<= bdam (+ (* 2.0 lneo) 1.0e-6))) (setq ok T))
          (T (setq ok nil))
        )
        (cond
          (ok
            (setq *QS-SOGOP* (1+ (if *QS-SOGOP* *QS-SOGOP* 0)))
            (setq addl (nth 10 cur) gays (nth 11 cur) tbm (nth 3 iv))
            (if (and sanAm (> delta 1.0e-6) (not veThang))
              (progn
                (setq *QS-SONHAN* (1+ (if *QS-SONHAN* *QS-SONHAN* 0)))

                (setq Lchieu (* delta nhanN))
                (setq Lthat  (* delta (sqrt (+ (* nhanN nhanN) 1.0))))

                (setq Ladd (if boxien 0.0 (- Lthat Lchieu)))
                (setq addl (+ addl Ladd))
                (if (not bodim)
                  (progn

                    (if thap
                      (setq g2 (+ (nth 0 iv)  cachMep) g1 (- g2 Lchieu))
                      (setq g1 (- (nth 1 cur) cachMep) g2 (+ g1 Lchieu)))
                    (if (> g2 (- tbm 1.0))
                      (setq g2 (- tbm 1.0) g1 (- g2 Lchieu)))
                    (if (< g1 (+ (nth 2 cur) 1.0))
                      (setq g1 (+ (nth 2 cur) 1.0) g2 (+ g1 Lchieu)))

                    (if (> (- g2 g1) 1.0)
                      (setq gays (append gays
                                   (list (list g1 g2 (if thap delta (- delta)))))))
                  )
                )
              )
            )
            (setq cur (list (nth 0 cur) (nth 1 iv) (nth 2 cur) tbm
                            (nth 4 cur) (nth 5 iv) (nth 6 iv) (nth 7 iv)
                            (nth 8 cur) (nth 9 iv) addl gays))
          )

          ((and keoDai doCote comat (not *QS-SLAB-STRICT*))
           (setq *QS-SOGOP* (1+ (if *QS-SOGOP* *QS-SOGOP* 0)))
           (setq Lcur (- (nth 1 cur) (nth 0 cur))
                 Liv  (- (nth 1 iv)  (nth 0 iv)))
           (setq cur (list (nth 0 cur) (nth 1 iv) (nth 2 cur) (nth 3 iv)
                           (nth 4 cur) (nth 5 iv)
                           (if (>= Lcur Liv) (nth 6 cur) (nth 6 iv))
                           (if (>= Lcur Liv) (nth 7 cur) (nth 7 iv))
                           (nth 8 cur) (nth 9 iv)
                           (nth 10 cur) (nth 11 cur)))
          )
          (T (setq res (cons cur res)) (setq cur (append iv (list 0.0 nil))))
        )
      )
    )
  )
  (if cur (setq res (cons cur res)))
  (reverse res)
)

(defun QS-TachZoneIv (dsIv tsZ cho lneo
                     / res iv z zj co t1 t2 ta tb h1 h2)
  (if (or (null tsZ) (null dsIv))
    dsIv
    (progn
      (setq res nil)
      (foreach iv dsIv
        (setq t1 (nth 0 iv) t2 (nth 1 iv) ta (nth 2 iv) tb (nth 3 iv)
              h1 (nth 4 iv) h2 (nth 5 iv) co nil)

        (foreach z tsZ
          (if (and (>= z (- t2 50.0)) (<= z (+ t2 lneo 100.0)))
            (setq tb (+ z cho) t2 (+ z cho) h2 0.0))
          (if (and (<= z (+ t1 50.0)) (>= z (- t1 lneo 100.0)))
            (setq ta (- z cho) t1 (- z cho) h1 0.0))
        )

        (foreach z tsZ
          (setq zj (+ z cho))
          (if (and (null co) (> z (+ t1 50.0)) (< z (- t2 50.0))
                   (> zj (+ ta 100.0)) (< zj (- tb 100.0)))
            (setq co (list z zj)))
        )
        (if co
          (progn
            (setq res (cons (list t1 (cadr co) ta (cadr co) h1 0.0
                                  (nth 6 iv) (nth 7 iv) (nth 8 iv) "ZONE"
                                  (nth 10 iv) (nth 11 iv)) res))
            (setq z (if (> cho 0.0) (car co) (cadr co)))
            (setq res (cons (list z t2 z tb 0.0 h2
                                  (nth 6 iv) (nth 7 iv) "ZONE" (nth 9 iv)
                                  (nth 10 iv) (nth 11 iv)) res))
          )
          (setq res (cons (list t1 t2 ta tb h1 h2 (nth 6 iv) (nth 7 iv)
                                (nth 8 iv) (nth 9 iv) (nth 10 iv) (nth 11 iv))
                          res))
        )
      )
      (reverse res)
    )
  )
)

(defun QS-TrungTen (lay ds / r x)
  (setq r nil)
  (if (and lay (/= lay ""))
    (foreach x ds
      (if (and x (/= x "") (= (strcase lay) (strcase x))) (setq r T))))
  r
)

(defun QS-CoKin (objs / r)
  (setq r nil)
  (foreach e objs
    (if (not (vl-catch-all-error-p
               (vl-catch-all-apply 'vlax-curve-isClosed (list e))))
      (if (vlax-curve-isClosed e) (setq r T))))
  r
)

(defun QS-TagZoneKh (kh tsZ / res iv k1 k2 z)
  (if (null tsZ)
    kh
    (progn
      (setq res nil)
      (foreach iv kh
        (setq k1 (caddr iv) k2 (cadddr iv))
        (foreach z tsZ
          (if (< (abs (- z (car  iv))) 1.0) (setq k1 "ZONE"))
          (if (< (abs (- z (cadr iv))) 1.0) (setq k2 "ZONE")))
        (setq res (cons (list (car iv) (cadr iv) k1 k2) res)))
      (reverse res)
    )
  )
)

(defun QS-CoZone (iv)
  (or (= (nth 8 iv) "ZONE") (= (nth 9 iv) "ZONE"))
)

(defun QS-CanGiuaTagU (obj pt u / a p1 p2 c dt res h w g ip r)
  (setq res nil)
  (vl-catch-all-apply 'vla-Update (list obj))
  (foreach a (vlax-invoke obj 'GetAttributes)
    (if (and (null res) (= (strcase (vla-get-TagString a)) "DKVAKC"))
      (progn
        (setq c nil)
        (if (not (vl-catch-all-error-p
                   (vl-catch-all-apply 'vla-GetBoundingBox (list a 'p1 'p2))))
          (progn
            (setq p1 (vlax-safearray->list p1) p2 (vlax-safearray->list p2))
            (if (> (distance (list (car p1) (cadr p1))
                             (list (car p2) (cadr p2))) 1.0)
              (setq c (list (/ (+ (car p1) (car p2)) 2.0)
                            (/ (+ (cadr p1) (cadr p2)) 2.0))))))
        (if (null c)
          (progn
            (setq h (vl-catch-all-apply 'vla-get-Height (list a)))
            (if (vl-catch-all-error-p h) (setq h 0.0))
            (setq g (vl-catch-all-apply 'vla-get-Rotation (list a)))
            (if (vl-catch-all-error-p g) (setq g 0.0))
            (setq ip (vl-catch-all-apply 'vla-get-InsertionPoint (list a)))
            (if (not (vl-catch-all-error-p ip))
              (progn
                (setq ip (vlax-safearray->list (vlax-variant-value ip)))
                (setq w (* 0.72 h (float (strlen (vla-get-TextString a)))))
                (setq c (list (+ (car ip)  (* (/ w 2.0) (cos g)))
                              (+ (cadr ip) (* (/ w 2.0) (sin g)))))))))
        (if c
          (progn
            (setq dt (- (+ (* (car pt) (car u)) (* (cadr pt) (cadr u)))
                        (+ (* (car c)  (car u)) (* (cadr c)  (cadr u)))))
            (if (> (abs dt) 1.0e-6)
              (vl-catch-all-apply 'vla-Move
                (list obj (vlax-3d-point (list 0.0 0.0 0.0))
                          (vlax-3d-point (list (* dt (car u)) (* dt (cadr u)) 0.0)))))
            (setq res T)
          )
        )
      )
    )
  )
  res
)

(defun QS-ChonDaiDien (grp dsTagPt dv dt / n cand i idx best rr s tt p ok)
  (setq n (length grp) cand (list (/ n 2)) i 1)
  (while (<= i n)
    (setq cand (append cand (list (+ (/ n 2) i) (- (/ n 2) i))))
    (setq i (1+ i)))
  (setq best nil)
  (foreach idx cand
    (if (and (null best) (>= idx 0) (< idx n))
      (progn
        (setq rr (nth idx grp)
              s  (nth 1 rr)
              tt (/ (+ (nth 2 rr) (nth 3 rr)) 2.0)
              ok T)
        (foreach p dsTagPt
          (if (and (< (abs (- s (car p))) dv)
                   (< (abs (- tt (cadr p))) dt))
            (setq ok nil)))
        (if ok (setq best rr))
      )
    )
  )
  (if best best (nth (/ n 2) grp))
)

(defun QS-DemHo (objs / d e)
  (setq d 0)
  (foreach e objs
    (if (not (vl-catch-all-error-p
               (vl-catch-all-apply 'vlax-curve-isClosed (list e))))
      (if (not (vlax-curve-isClosed e)) (setq d (1+ d)))))
  d
)

(defun QS-NhanKieuDam (spc dsNgoai dsDam u v smin smax tmin tmax
                       / ln i n s L1 L2 khN khD a b)
  (setq ln (vla-AddLine spc (vlax-3d-point (QS-Pt u v smin tmin))
                            (vlax-3d-point (QS-Pt u v smin tmax))))
  (setq L1 0.0 L2 0.0 n 20 i 1)
  (while (<= i n)
    (setq s (+ smin (* (- smax smin) (/ (float i) (float (1+ n))))))
    (vla-put-StartPoint ln (vlax-3d-point (QS-Pt u v s tmin)))
    (vla-put-EndPoint   ln (vlax-3d-point (QS-Pt u v s tmax)))
    (setq khN (QS-SlabIntervals ln dsNgoai u))
    (setq khD (QS-GiaoTHop ln dsDam u))
    (foreach a (QS-GiaoKhoang khN khD) (setq L1 (+ L1 (- (cadr a) (car a)))))
    (foreach b (QS-TruKhoang  khN khD) (setq L2 (+ L2 (- (cadr b) (car b)))))
    (setq i (1+ i))
  )
  (vl-catch-all-apply 'vla-Delete (list ln))
  (if (>= L1 L2) "BAO" "RECT")
)

(defun QS-MocChia (curves w / lst e np i p res)
  (foreach e curves
    (setq np (fix (+ 0.0001 (vlax-curve-getEndParam e))) i 0)
    (while (<= i np)
      (setq p (vlax-curve-getPointAtParam e i))
      (if p (setq lst (cons (+ (* (car p) (car w)) (* (cadr p) (cadr w))) lst)))
      (setq i (1+ i))
    )
  )
  (setq lst (QS-Sap lst '<))
  (foreach x lst
    (if (or (null res) (> (- x (car res)) 1.0)) (setq res (cons x res))))
  (reverse res)
)

(defun QS-VungThanDam (dsHo w / vs e r res)
  (setq vs nil)
  (foreach e dsHo
    (setq r (QS-PhamViChieu (list e) w))
    (if (and r (< (- (cadr r) (car r)) 1.0))
      (setq vs (cons (/ (+ (car r) (cadr r)) 2.0) vs)))
  )
  (setq vs (QS-Sap vs '<) res nil)
  (while (and vs (cdr vs))
    (setq res (cons (list (car vs) (cadr vs)) res))
    (setq vs (cddr vs))
  )
  (reverse res)
)

(defun QS-TrongThanDam (s1 s2 vung / r k)
  (setq r nil)
  (foreach k vung
    (if (and (null r) (>= s1 (- (car k) 1.0)) (<= s2 (+ (cadr k) 1.0)))
      (setq r T)))
  r
)

(defun QS-KeyKh (kh / s k)
  (setq s "")
  (foreach k kh
    (setq s (strcat s (itoa (QS-R0 (car k))) "," (itoa (QS-R0 (cadr k))) ";")))
  s
)

(defun QS-LaSanDoc (ln p u v dsNgoai dsDam dsDamHo dsLo kieuDam coDam smin smax
                    / tu sv khN khD khL khHo kh)
  (setq tu (+ (* (car p) (car u)) (* (cadr p) (cadr u))))
  (setq sv (+ (* (car p) (car v)) (* (cadr p) (cadr v))))
  (vla-put-StartPoint ln (vlax-3d-point (QS-Pt v u tu smin)))
  (vla-put-EndPoint   ln (vlax-3d-point (QS-Pt v u tu smax)))
  (setq khN (QS-SlabIntervals ln dsNgoai v))
  (setq khD (QS-GiaoTHop ln dsDam v))
  (setq khL (if dsLo (QS-TsToKhoang (QS-GiaoT ln dsLo v)) nil))
  (setq khHo (if dsDamHo (QS-TsToKhoang (QS-GiaoT ln dsDamHo v)) nil))
  (setq kh (cond ((not coDam) khN)
                 ((= kieuDam "RECT") (QS-TruKhoang khN khD))
                 (T khD)))
  (setq kh (QS-TruKhoang (QS-TruKhoang kh khL) khHo))
  (QS-KhoangChua kh sv)
)

(defun QS-TrongMotDam (ln curves w t1 t2 / res c k)
  (setq res nil)
  (foreach c curves
    (if (null res)
      (foreach k (QS-TsToKhoang (QS-GiaoT ln (list c) w))
        (if (and (<= (car k) (+ t1 1.0)) (>= (cadr k) (- t2 1.0)))
          (setq res T)))))
  res
)

(defun QS-OHopLe (ln u v s t1 t2 dsNgoai dsDam dsDamHo dsLo kieuDam coDam
                  smin smax ohep / ok f kv)
  (setq ok T)
  (foreach f (list 0.25 0.5 0.75)
    (if ok
      (progn
        (setq kv (QS-LaSanDoc ln (QS-Pt u v s (+ t1 (* f (- t2 t1))))
                              u v dsNgoai dsDam dsDamHo dsLo kieuDam coDam
                              smin smax))
        (if (or (null kv)
                (and *QS-SLAB-STRICT* kv
                     (or (< (- s (car kv)) (- lui 0.5))
                         (< (- (cadr kv) s) (- lui 0.5))))
                (and (> ohep 0.0) (< (- (cadr kv) (car kv)) ohep)))
          (setq ok nil))
      )
    )
  )
  ok
)

(defun QS-LocDai (spc mocs dsNgoai dsDam dsDamHo dsLo kieuDam coDam u v tmin tmax
                  / res ln rest s1 s2 s khN khD khL khSan gop k vung khHo)
  (setq vung (QS-VungThanDam dsDamHo v))
  (setq ln (vla-AddLine spc (vlax-3d-point (QS-Pt u v (car mocs) tmin))
                            (vlax-3d-point (QS-Pt u v (car mocs) tmax))))
  (setq rest mocs res nil)
  (while (cdr rest)
    (setq s1 (car rest) s2 (cadr rest))
    (if (> (- s2 s1) 1.0e-6)
      (progn
        (setq s (+ (/ (+ s1 s2) 2.0) 0.0137))
        (vla-put-StartPoint ln (vlax-3d-point (QS-Pt u v s tmin)))
        (vla-put-EndPoint   ln (vlax-3d-point (QS-Pt u v s tmax)))
        (setq khN (QS-SlabIntervals ln dsNgoai u))
        (setq khD (QS-GiaoTHop ln dsDam u))
        (setq khL (if dsLo (QS-TsToKhoang (QS-GiaoT ln dsLo u)) nil))

        (setq khSan (cond ((not coDam) khN)
                          ((= kieuDam "RECT") (QS-TruKhoang khN khD))
                          (T khD)))

        (setq khHo (if dsDamHo (QS-TsToKhoang (QS-GiaoT ln dsDamHo u)) nil))
        (setq khSan (QS-TruKhoang (QS-TruKhoang khSan khL) khHo))

        (if (QS-TrongThanDam s1 s2 vung) (setq khSan nil))
        (setq khSan (vl-remove-if
                      (function (lambda (x) (< (- (cadr x) (car x)) 50.0))) khSan))
        (if khSan (setq res (cons (list s1 s2 (QS-KeyKh khSan)) res)))
      )
    )
    (setq rest (cdr rest))
  )
  (vl-catch-all-apply 'vla-Delete (list ln))

  (setq res (reverse res) gop nil)
  (foreach k res
    (if (and gop
             (< (abs (- (cadr (car gop)) (car k))) 1.0e-6)
             (or *QS-SLAB-STRICT* (= (caddr (car gop)) (caddr k))))
      (setq gop (cons (list (car (car gop)) (cadr k) (caddr k)) (cdr gop)))
      (setq gop (cons k gop)))
  )
  (vl-remove-if (function (lambda (x) (< (- (cadr x) (car x)) 50.0))) (reverse gop))
)

(defun QS-ChenVT (x lst)
  (cond
    ((null lst) (list x))
    ((<= (car x) (car (car lst))) (cons x lst))
    (T (cons (car lst) (QS-ChenVT x (cdr lst))))
  )
)
(defun QS-SapVT (lst / res x)
  (setq res nil)
  (foreach x lst (setq res (QS-ChenVT x res)))
  res
)

(defun QS-ViTriQuet (dais lui aa / res s s1 s2 rest cuoi prevS2 prevLast prevKey
                                   lien noi a1 b1)
  (setq rest dais prevS2 nil prevLast nil)
  (while rest
    (setq s1 (car (car rest)) s2 (cadr (car rest)))
    (setq lien (and prevS2 prevLast (< (abs (- s1 prevS2)) 1.0)
                    (= (caddr (car rest)) prevKey)))
    (setq noi (and (cdr rest)
                   (< (abs (- (car (car (cdr rest))) s2)) 1.0)
                   (= (caddr (car rest)) (caddr (car (cdr rest))))))
    (setq a1 (if lien s1 (+ s1 lui)))
    (setq b1 (if noi s2 (- s2 lui)))
    (cond
      ((<= (- s2 s1) 1.0e-6) nil)

      ((and (not lien) (not noi) (<= (- s2 s1) (* 2.0 lui)))
       (if (> (- s2 s1) (max 1.0 (* 0.2 aa)))
         (setq res (cons (list (/ (+ s1 s2) 2.0) s1 s2) res)
               prevLast (/ (+ s1 s2) 2.0))))
      (T
       (setq s (if lien (+ prevLast aa) a1))
       (while (< s (- a1 1.0e-6)) (setq s (+ s aa)))
       (setq cuoi (if lien prevLast nil))
       (while (<= s (+ b1 1.0e-6))
         (setq res (cons (list s s1 s2) res) cuoi s)
         (setq s (+ s aa)))
       (if (and cuoi (not noi) (>= (- b1 cuoi) (* 0.5 aa)))
         (setq res (cons (list b1 s1 s2) res) cuoi b1))
       (setq prevLast cuoi))
    )
    (setq prevS2 s2 prevKey (caddr (car rest)))
    (setq rest (cdr rest))
  )
  (QS-SapVT res)
)

(defun QS-HopBao (objs / p1 p2 x1 y1 x2 y2 r)
  (foreach o objs
    (setq r (vl-catch-all-apply 'vla-GetBoundingBox (list o 'p1 'p2)))
    (if (not (vl-catch-all-error-p r))
      (progn
        (setq p1 (vlax-safearray->list p1) p2 (vlax-safearray->list p2))
        (if (null x1)
          (setq x1 (car p1) y1 (cadr p1) x2 (car p2) y2 (cadr p2))
          (setq x1 (min x1 (car p1)) y1 (min y1 (cadr p1))
                x2 (max x2 (car p2)) y2 (max y2 (cadr p2)))
        )
      )
    )
  )
  (if x1 (list x1 y1 x2 y2) nil)
)

(defun QS-R0 (x) (fix (if (< x 0) (- x 0.5) (+ x 0.5))))

(defun QS-DeuKe (records step / left right rr out h1 h2)
  ;; Keep straight ends straight; round positive hooks upward, never shorten.
  (setq left 0.0 right 0.0 step (max 1.0 step))
  (foreach rr records
    (setq left (max left (nth 4 rr)) right (max right (nth 5 rr))))
  (setq left (* step (fix (+ (/ left step) 0.999999)))
        right (* step (fix (+ (/ right step) 0.999999))))
  (foreach rr records
    (setq h1 (if (> (nth 4 rr) 0.0) left 0.0)
          h2 (if (> (nth 5 rr) 0.0) right 0.0))
    (setq out (cons (append (list (nth 0 rr) (nth 1 rr) (nth 2 rr)
                                  (nth 3 rr) h1 h2) (cddr (cddddr rr))) out)))
  (reverse out))

(defun QS-LThanh (rr)
  (+ (- (nth 3 rr) (nth 2 rr)) (nth 4 rr) (nth 5 rr) (nth 6 rr))
)

(defun QS-TTinBT (bars / Ls mn mx sm)
  (setq Ls (mapcar (function QS-LThanh) bars))
  (setq mn (car Ls) mx (car Ls) sm 0.0)
  (foreach x Ls
    (if (< x mn) (setq mn x))
    (if (> x mx) (setq mx x))
    (setq sm (+ sm x)))
  (list mn mx sm (length Ls))
)

(defun QS-LayDoan (lst i j / r k)
  (setq r nil k i)
  (while (< k j) (setq r (append r (list (nth k lst)))) (setq k (1+ k)))
  r
)

(defun QS-BTBoundaryKey (pos / result entry obj hits hit)
  (foreach entry (list
      (cons "EDGE:" dsNgoai)
      (cons "HOLE:" dsLo)
      (cons "ZONE:" (if (boundp 'dsZone) dsZone nil))
      ;; v20.15: ranh VUNG SAN (OS_VUNGSAN) va mien huong rai
      (cons "VUNG:" (append (if vgClip vgClip nil) (if vgTru vgTru nil)
                            (if vsObjs vsObjs nil))))
    (foreach obj (cdr entry)
      (setq hits (QS-GiaoT lnObj (list obj) u))
      (foreach hit hits
        (if (< (abs (- hit pos)) 1.0)
          (setq result (cons (strcat (car entry) (vla-get-Handle obj)) result))))))
  (QS-Sap result '<))

(defun QS-BTSupportKey (lo hi / obj spans iv left right crossed hd)
  ;; The live scan line and beam geometry belong to the current slab region.
  (foreach obj dsDamSan
    (setq spans (QS-TsToKhoang (QS-GiaoT lnObj (list obj) u))
          hd (vla-get-Handle obj))
    (foreach iv spans
      (if (and (<= (car iv) (+ lo 0.5)) (>= (cadr iv) (- lo 0.5)))
        (setq left (cons hd left)))
      (if (and (<= (car iv) (+ hi 0.5)) (>= (cadr iv) (- hi 0.5)))
        (setq right (cons hd right)))
      (if (and (> (cadr iv) (+ lo 0.5)) (< (car iv) (- hi 0.5)))
        (setq crossed (cons hd crossed)))))
  (if (null left) (setq left (QS-BTBoundaryKey lo)))
  (if (null right) (setq right (QS-BTBoundaryKey hi)))
  (list (QS-Sap left '<) (QS-Sap right '<) (QS-Sap crossed '<)))

(defun QS-GopBT1 (grps aa dmin ds ng buoc)
  (QS-V4Plan grps aa dmin ds buoc))

(defun QS-TronBT (A B / ra ba rb bb res bts)
  (setq ra (car A) ba (cadr A) rb (car B) bb (cadr B) res nil bts nil)
  (while (or ra rb)
    (if (or (null rb)
            (and ra (< (nth 0 (car (car ra))) (nth 0 (car (car rb))))))
      (progn
        (setq res (append res (list (car ra))) bts (append bts (list (car ba))))
        (setq ra (cdr ra) ba (cdr ba)))
      (progn
        (setq res (append res (list (car rb))) bts (append bts (list (car bb))))
        (setq rb (cdr rb) bb (cdr bb)))))
  (list res bts)
)

(defun QS-SlabZoneRuns (grps / out g r run flag)
  ;; Geometry groups can contain both zone and ordinary rows.
  (setq out nil)
  (foreach g grps
    (setq run nil flag nil)
    (foreach r g
      (if (and run (not (equal flag (nth 10 r))))
        (progn (setq out (cons (reverse run) out)) (setq run nil)))
      (setq flag (nth 10 r) run (cons r run)))
    (if run (setq out (cons (reverse run) out))))
  (reverse out))

(defun QS-GopBT (grps aa dmin ds ng buoc / plain ch0 ch1 g)
  (if (= buoc 2)
    (progn
      (setq plain nil ch0 nil ch1 nil)
      (foreach g (QS-SlabZoneRuns grps)
        (cond
          ((not (nth 10 (car g)))
           (setq plain (append plain (list g))))
          ((= 0 (rem (nth 0 (car g)) 2))
           (setq ch0 (append ch0 (list g))))
          (T (setq ch1 (append ch1 (list g))))))
      ;; Stagger only rows terminated at a zone, not the whole slab.
      (QS-TronBT (QS-GopBT1 plain aa dmin ds ng 1)
        (QS-TronBT (QS-GopBT1 ch0 aa dmin ds ng 2)
                   (QS-GopBT1 ch1 aa dmin ds ng 2)))
    )
    (QS-GopBT1 grps aa dmin ds ng 1)
  )
)

(defun QS-TachKT (str kt / res i c cur n)
  (setq res nil cur "" i 1 n (strlen str))
  (while (<= i n)
    (setq c (substr str i 1))
    (if (= c kt)
      (setq res (append res (list cur)) cur "")
      (setq cur (strcat cur c)))
    (setq i (1+ i)))
  (append res (list cur))
)

(defun QS-DocXDBT (ent / x ls res p)
  (setq res nil)
  (if (and ent (entget ent))
    (progn
      (setq x (cdr (assoc -3 (entget ent (list "DceBT")))))
      (if x
        (progn
          (setq ls (cdr (car x)))
          (foreach p ls
            (if (= (car p) 1000) (setq res (append res (list (cdr p))))))))))
  res
)

(defun QS-GhiXDBT (ent lst / xd c base p)
  (if (and ent (entget ent))
    (progn
      (regapp "DceBT")
      (setq xd nil)
      (foreach c lst
        (setq xd (append xd (list (cons 1000 c)))))
      (setq base nil)
      (foreach p (entget ent)
        (if (or (/= (car p) -3)
                (not (assoc "DceBT" (cdr p))))
          (setq base (append base (list p)))))
      (vl-catch-all-apply 'entmod
        (list (append base (list (list -3 (cons "DceBT" xd))))))))
  (princ)
)

(defun QS-VeBaoBT (grp u v lay / pts r1 r2 eLst p)
  (setq r1 (car grp) r2 (last grp))
  (setq pts (list (QS-Pt u v (nth 1 r1) (nth 2 r1))
                  (QS-Pt u v (nth 1 r2) (nth 2 r2))
                  (QS-Pt u v (nth 1 r2) (nth 3 r2))
                  (QS-Pt u v (nth 1 r1) (nth 3 r1))))
  (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                   (cons 8 lay) '(100 . "AcDbPolyline")
                   (cons 90 (length pts)) '(70 . 1)))
  (foreach p pts
    (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))
  (if (entmake eLst) (entlast) nil)
)

(defun QS-TagCuaEnt (e / xd f r owner)
  (if (and e (entget e))
    (progn
      (if (= (cdr (assoc 0 (entget e))) "ATTRIB")
        (setq e (cdr (assoc 330 (entget e)))))
      (setq xd (QS-DocXDBT2 e))
      (if xd
        (progn
          (setq f (QS-TachKT (car xd) ";"))
          (cond
            ((= (car f) "BT2") (setq r e))
            ((member (car f) '("BAO2" "REP2" "RAI2" "CON2"))
             (if (cadr f) (setq r (handent (cadr f)))))))
        (progn
          (setq xd (QS-DocXDBT e))
          (if xd
            (progn
              (setq f (QS-TachKT (car xd) ";"))
              (cond
                ((= (car f) "BT") (setq r e))
                ((member (car f) '("BAO" "REP" "CON"))
                 (if (cadr f) (setq r (handent (cadr f))))))))))
  )
  )
  (if (and r (entget r) (= (cdr (assoc 0 (entget r))) "INSERT")) r nil)
)

(defun QS-KeyBT (rr bt)
  (if bt
    (strcat "BT|" (itoa (QS-R0 (car bt))) "|" (itoa (QS-R0 (cadr bt)))
            "|" (itoa (cadddr bt)) "|" (itoa (length (nth 7 rr))))
    (QS-KeySH rr))
)

(defun QS-ChiaChuoi (str n / res i)
  (setq res nil i 1)
  (while (<= i (strlen str))
    (setq res (cons (substr str i n) res))
    (setq i (+ i n)))
  (reverse res)
)

(defun QS-DocXDBT2 (ent / raw x app p res)
  (setq res nil)
  (if (and ent (entget ent))
    (progn
      (setq raw (entget ent (list "DceBT2")))
      (setq x (cdr (assoc -3 raw)))
      (if x
        (foreach app (cdr (car x))
          (if (= (car app) 1000) (setq res (append res (list (cdr app)))))))))
  res
)

(defun QS-GhiXDBT2 (ent lst / raw old base c p)
  (if (and ent (entget ent))
    (progn
      (regapp "DceBT2")
      (setq raw (entget ent (list "DceBT2")) old (assoc -3 raw) base nil)
      (foreach p raw (if (/= (car p) -3) (setq base (append base (list p)))))
      (setq c nil)
      (foreach p lst (setq c (append c (list (cons 1000 p)))))
      (vl-catch-all-apply 'entmod
        (list (append base (list (list -3 (cons "DceBT2" c))))))))
  (princ)
)

(defun QS-GanXDBT2 (eTag eRep bt grp u v eBao eRai rnd / r1 r i L lst hTag hRai hBao)
  (if (and eTag bt grp (entget eTag))
    (progn
      (setq r1 (car grp) hTag (cdr (assoc 5 (entget eTag)))
            hRai (if eRai (cdr (assoc 5 (entget eRai))) "")
            hBao (if eBao (cdr (assoc 5 (entget eBao))) ""))
      (setq lst
        (list
          (strcat "BT2;" (itoa (length grp)) ";" (rtos (car bt) 2 3) ";"
                  (rtos (cadr bt) 2 3) ";" (rtos (caddr bt) 2 3) ";"
                  (rtos (nth 4 r1) 2 3) ";" (rtos (nth 5 r1) 2 3) ";"
                  hBao ";" hRai ";" (itoa (fix rnd)))
          (strcat "G;" (rtos (car u) 2 8) ";" (rtos (cadr u) 2 8) ";"
                  (rtos (car v) 2 8) ";" (rtos (cadr v) 2 8) ";"
                  (rtos (nth 1 r1) 2 3) ";"
                  (rtos (nth 2 r1) 2 3) ";" (rtos (nth 3 r1) 2 3))))
      (setq i 0)
      (foreach r grp
        (setq L (+ (- (nth 3 r) (nth 2 r)) (nth 4 r) (nth 5 r)))
        (setq lst (append lst
                    (list (strcat "BAR;" (itoa i) ";" (rtos (nth 1 r) 2 3) ";"
                                  (rtos (nth 2 r) 2 3) ";" (rtos (nth 3 r) 2 3) ";"
                                  (rtos L 2 3) ";" (rtos (nth 4 r) 2 3) ";"
                                  (rtos (nth 5 r) 2 3)))))
        (setq i (1+ i)))
      (QS-GhiXDBT2 eTag lst)
      (if eRep
        (QS-GhiXDBT2 eRep (list (strcat "REP2;" hTag))))
      (if eBao
        (QS-GhiXDBT2 eBao (list (strcat "BAO2;" hTag))))
      (if eRai
        (QS-GhiXDBT2 eRai (list (strcat "RAI2;" hTag))))))
  (princ)
)

(defun QS-GanXDBT (ent bt grp u v nx ny eBao rnd / s0 g0 r rr r1 lst)
  (if (and ent bt (entget ent))
    (progn
      (setq r1 (car grp))
      (setq s0 (strcat "BT;" (itoa (cadddr bt)) ";"
                       (itoa (QS-R0 (car bt))) ";" (itoa (QS-R0 (cadr bt))) ";"
                       (itoa (QS-R0 (caddr bt))) ";"
                       (rtos (nth 4 r1) 2 3) ";"
                       (rtos (nth 5 r1) 2 3) ";"
                       (rtos (angle (list 0.0 0.0) (list nx ny)) 2 6) ";"
                       (if eBao (cdr (assoc 5 (entget eBao))) "") ";"
                       (itoa (fix rnd))))
      (setq g0 (strcat "G;" (rtos (car u) 2 8) ";" (rtos (cadr u) 2 8) ";"
                            (rtos (car v) 2 8) ";" (rtos (cadr v) 2 8) ";"
                            (rtos (nth 1 r1) 2 3) ";"
                            (rtos (nth 2 r1) 2 3) ";"
                            (rtos (nth 3 r1) 2 3)))
      (setq r "")
      (foreach rr grp
        (setq r (strcat r (if (= r "") "" ",")
                        (itoa (QS-R0 (- (nth 1 rr) (nth 1 r1)))) ","
                        (itoa (QS-R0 (- (nth 2 rr) (nth 2 r1)))) ","
                        (itoa (QS-R0 (- (nth 3 rr) (nth 3 r1)))))))
      (setq lst (cons s0 (cons g0 (QS-ChiaChuoi (strcat "D;" r) 240))))
      (QS-GhiXDBT ent lst)
    )
  )
  (princ)
)

(defun QS-LayDiemChinh (e h1 h2 / pts n)
  (setq pts (QS-DinhDuong e) n (length pts))
  (if (< n 2)
    nil
    (list (nth (if (> h1 1.0e-6) 1 0) pts)
          (nth (- n 1 (if (> h2 1.0e-6) 1 0)) pts)))
)

(defun QS-ChuoiREP (eBar hTag h1 h2 / c)
  (setq c (QS-LayDiemChinh eBar h1 h2))
  (if c
    (strcat "REP;" hTag ";"
            (rtos (car  (car c)) 2 4) ";" (rtos (cadr (car c)) 2 4) ";"
            (rtos (car  (cadr c)) 2 4) ";" (rtos (cadr (cadr c)) 2 4))
    (strcat "REP;" hTag))
)

(defun QS-LayTagBT (eTag / obj a r)
  (setq r nil obj (vl-catch-all-apply 'vlax-ename->vla-object (list eTag)))
  (if (not (vl-catch-all-error-p obj))
    (foreach a (vlax-invoke obj 'GetAttributes)
      (if (and (null r) (= (strcase (vla-get-TagString a)) "DKVAKC"))
        (setq r (vla-get-TextString a)))))
  r
)

(defun QS-B2Dot (p u) (+ (* (car p) (car u)) (* (cadr p) (cadr u))))
(defun QS-B2Write (e app strings / result)
  (regapp app)
  (setq result (entmod (append (entget e)
    (list (list -3 (cons app (mapcar '(lambda (x) (cons 1000 x)) strings)))))))
  (if (null result) (QS-BTFail (strcat "BT2: khong ghi duoc du lieu " app)))
  result
)
(defun QS-BT2Model (eTag / xd ft gv rows rec vals ok idx nums lens total mn mx)
  (setq xd (QS-DocXDBT2 eTag) ok T rows nil idx 0 total 0.0)
  (if (and xd (>= (length xd) 3))
    (progn
      (setq ft (QS-TachKT (car xd) ";") gv (QS-TachKT (cadr xd) ";"))
      (if (not (and (= (car ft) "BT2") (= (length ft) 10)
                    (= (car gv) "G") (member (length gv) '(6 8))))
        (setq ok nil))
      (if ok
        (progn
          (setq nums (mapcar 'QS-Num (cdr gv)))
          (if (member nil nums) (setq ok nil))
          (foreach rec (cddr xd)
            (setq vals (QS-TachKT rec ";"))
            (if (and (= (car vals) "BAR") (= (length vals) 8))
              (progn
                (setq vals (mapcar 'QS-Num (cdr vals)))
                (if (or (member nil vals) (/= (car vals) idx))
                  (setq ok nil)
                  (if (or (<= (nth 3 vals) (nth 2 vals))
                          (< (nth 5 vals) 0.0) (< (nth 6 vals) 0.0)
                          (> (abs (- (nth 4 vals)
                             (+ (- (nth 3 vals) (nth 2 vals))
                                (nth 5 vals) (nth 6 vals)))) 0.01))
                    (setq ok nil)))
                (setq rows (cons vals rows) idx (1+ idx)))
              (setq ok nil)))
          (if (or (null (QS-Num (nth 1 ft))) (/= (atoi (nth 1 ft)) idx)
                  (= idx 0)) (setq ok nil))
          (if ok
            (progn
              (setq lens (mapcar '(lambda (r) (nth 4 r)) rows))
              (setq mn (apply 'min lens) mx (apply 'max lens) total (apply '+ lens))
              (if (not (and (QS-Num (nth 2 ft)) (QS-Num (nth 3 ft)) (QS-Num (nth 4 ft))
                            (< (abs (- mn (atof (nth 2 ft)))) 0.01)
                            (< (abs (- mx (atof (nth 3 ft)))) 0.01)
                            (< (abs (- total (atof (nth 4 ft)))) (+ 0.01 (* idx 0.001)))))
                (setq ok nil))
              (if (or (> (abs (- (+ (* (car nums) (car nums))
                                       (* (cadr nums) (cadr nums))) 1.0)) 0.00001)
                      (> (abs (- (+ (* (nth 2 nums) (nth 2 nums))
                                       (* (nth 3 nums) (nth 3 nums))) 1.0)) 0.00001)
                      (> (abs (+ (* (car nums) (nth 2 nums))
                                 (* (cadr nums) (nth 3 nums)))) 0.00001))
                (setq ok nil)))))))
    (setq ok nil))
  (if ok (list ft nums (reverse rows)) nil)
)

(defun QS-KeySH (rr / g tg)
  (setq g 0.0)
  (foreach tg (nth 7 rr) (setq g (+ g (car tg))))
  (strcat (itoa (QS-R0 (nth 2 rr))) "|" (itoa (QS-R0 (nth 3 rr)))
          "|" (itoa (QS-R0 (nth 4 rr))) "|" (itoa (QS-R0 (nth 5 rr)))
          "|" (itoa (length (nth 7 rr))) "|" (itoa (QS-R0 g)))
)

(defun QS-TrungVoi (o lst / bbO bbX r)
  (setq bbO (QS-HopBao (list o)) r nil)
  (foreach x lst
    (setq bbX (QS-HopBao (list x)))
    (if (and bbO bbX (null r)
             (< (+ (abs (- (car bbO)    (car bbX)))
                   (abs (- (cadr bbO)   (cadr bbX)))
                   (abs (- (caddr bbO)  (caddr bbX)))
                   (abs (- (cadddr bbO) (cadddr bbX)))) 2.0))
      (setq r T))
  )
  r
)

(defun QS-HopThoai4 ( / dclId rc lap pe)
  (setq *QS4-OK* nil)
  (setq dclId (QS-NapDCL))
  (if (not dclId)
    (princ "\n[Loi] Khong nap duoc giao dien.")
    (progn
      (setq lap T)
      (while lap
        (if (not (new_dialog "qs_thepsan" dclId))
          (progn (princ "\n[Loi] Khong khoi tao duoc dialog qs_thepsan.") (setq lap nil))
          (progn
            (foreach pr (list
                (list "sd" '*QS4-D* "8") (list "sa" '*QS4-A* "200") (list "ssh" '*QS4-SH* "1")
                (list "slui" '*QS4-LUI* "50") (list "sohep" '*QS4-OHEP* "0")
                (list "sneo" '*QS4-NEO* "40") (list "sbeke" '*QS4-BEKE* "0") (list "sbv" '*QS4-BV* "25")
                (list "lngoai" '*QS4-LNG* "") (list "ldam" '*QS4-LDAM* "")
                (list "styl" '*QS4-TYL* "50") (list "srl" '*QS4-RL* "0") (list "smck" '*QS4-MCK* "")
                (list "srnd" '*QS4-RND* "5")
                (list "sdim" '*QS4-DIM* "1") (list "sdao" '*QS4-DAO* "0") (list "sgom" '*QS4-GOM* "1")
                (list "skedeu" '*QS4-KEDEU* "0")
                (list "snguong" '*QS4-NG* "50") (list "snhan" '*QS4-NHAN* "6")
                (list "shsmd" '*QS4-HSMD* "0") (list "sctmd" '*QS4-CTMD* "0")
                (list "szone" '*QS4-LZONE* "") (list "szcho1" '*QS4-ZCHO1* "500")
                (list "szcho2" '*QS4-ZCHO2* "1000") (list "szlech" '*QS4-ZLECH* "0")
                (list "snlt" '*QS4-NLT* "1") (list "sneq" '*QS4-NEQ* "1") (list "sngt" '*QS4-NGT* "0")
                (list "scmep" '*QS4-CMEP* "0") (list "sltach" '*QS4-LTACH* "0")
                (list "skeodai" '*QS4-KEODAI* "0") (list "sdneo" '*QS4-DNEO* "1")
                (list "skneo" '*QS4-KNEO* "150") (list "sbdim" '*QS4-BDIM* "0")
                (list "sbxien" '*QS4-BXIEN* "0")
                (list "sbtn" '*QS4-BTN* "4") (list "sbtds" '*QS4-BTDS* "50")
                (list "sbtmaxn" '*QS4-BTMAXN* "0"))
              (set_tile (car pr) (if (eval (cadr pr)) (eval (cadr pr)) (caddr pr))))
            (if (not *QS4-PHUONG*) (setq *QS4-PHUONG* "pw_ngang"))
            (set_tile "sphuong" *QS4-PHUONG*)
            (if (not *QS4-MT*) (setq *QS4-MT* "mt_dac"))
            (set_tile "smuiten" *QS4-MT*)
            (if (not *QS4-LOP*) (setq *QS4-LOP* "lp_duoi"))
            (set_tile "slop" *QS4-LOP*)
            (set_tile "scaochu"
              (strcat "Cao chu that = "
                      (if (QS-Num (if *QS4-TYL* *QS4-TYL* "50"))
                        (rtos (* 2.5 (QS-Num (if *QS4-TYL* *QS4-TYL* "50"))) 2 0) "?")
                      " mm"))
            (set_tile "sghichu" "Bam \"Pick <\" de lay ten layer tu doi tuong tren ban ve.")
            (action_tile "pk1" "(QS-Doc4)(done_dialog 2)")
            (action_tile "pk2" "(QS-Doc4)(done_dialog 3)")
            (action_tile "pk5" "(QS-Doc4)(done_dialog 6)")
            (action_tile "accept" "(QS-Accept4)")
            (action_tile "cancel" "(done_dialog 0)")
            (setq rc (progn (QS-PJInit "qs_thepsan") (start_dialog)))
            (cond
              ((= rc 2)
               (setq pe (entsel "\nChon 1 doi tuong thuoc layer MEP NGOAI SAN: "))
               (if pe (setq *QS4-LNG* (cdr (assoc 8 (entget (car pe)))))))
              ((= rc 3)
               (setq pe (entsel "\nChon 1 doi tuong thuoc layer MAT TRONG DAM: "))
               (if pe (setq *QS4-LDAM* (cdr (assoc 8 (entget (car pe)))))))
              ((= rc 6)
               (setq pe (entsel "\nChon 1 duong PHAN ZONE thi cong: "))
               (if pe (setq *QS4-LZONE* (cdr (assoc 8 (entget (car pe)))))))
              (T (setq lap nil))
            )
          )
        )
      )
      (QS-DongDCL)
    )
  )
  (princ)
)

;; Explicit context supplied by QS_MATBANG_THEPSAN.lsp; legacy command stays unchanged.
(defun QS-MB-Ready () T)

(defun c:OS_THEPSAN ( / *error* doc spc d aa shStart lui lneo beke bv cao rnd tyle dao
                          coTag coRai coDim ux uy vx vy u v nx ny p1 p2 ss i n ent lay etype
                          dsNgoai dsDam soMo bb R lnObj eps tmin tmax mocs dsS s0 smin smax
                          s k recs tsN tsD khN khD kh iv t1 t2 kOut B1 B2 r1 r2 la1 la2 h1
                          h2 ta tb entBar og key g found grps grp rr nBar Ltot dkvakc ptTag
                          ptA ptB tagObj tagEnt shNo dsDim tt ttR ptR soThanh soVe origDim
                          oldecho lechRai mck maMT maNeo dsLo big bigA bb2 ar coDam khL o dsLoSel
                          gocTag lnV bbV soDam sanAm gBase dsVung vg gU vgClip tongDai khNA
                          matsan nguong nhanN hsMD ctMD ohep tD soBo dsIv hsct tsR nhanLT
                          nhanEQ nhanGT soLopTxt kieuDam khSan chogom Lmax bodim boxien dais
                          dsDamSan dsDamHo khHo dsKey dsDem gkey pr shOf nTong nGhi s0L sLo
                          sHi keoDai cachMep lechTach ivOk dsL dimNeo dsNeo raiEnt kNeo
                          dsZone ssZn iz nz soZ tsZ zCho1 zCho2 soTachZ buocRai aBand coZone
                          eZn lyZn soLoaiZ goBT btMin btDS btNG btKQ dsBT btI iG soBT eBao
                          zKin chg soBoZ dsTagPt rrK dvTag dtTag aMin aPrev g2 zLech zl
                          *QS-SLABUNION* *QS-SLAB-STRICT* dsVSsel dsVS vsOn vsObjs vsTru vgTru vsR
                          vsMiss vsHit)

  (defun *error* (msg)
    (QS-DongDCL)
    (if (and lnObj (not (vl-catch-all-error-p
                          (vl-catch-all-apply 'vla-get-ObjectID (list lnObj)))))
      (vl-catch-all-apply 'vla-Delete (list lnObj)))
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (princ "\n[OS_ShopThepSan v1.0.0]")
  (princ "\n=== OS_THEPSAN - TU DONG BO TRI THEP SAN ===")
  (setq doc (QS-Doc) spc (QS-Space doc))
  (vla-StartUndoMark doc)

  (QS-HopThoai4)

  ;; Bridge input has already been validated. Do not scan unrelated global layers.
  (if (and (boundp '*QS-MB-CONTEXT*) *QS-MB-CONTEXT*)
    (setq *QS4-LZONE* ""))

  (if (not *QS4-OK*)
    (princ "\nDa huy lenh.")
    (progn
      (setq d       (QS-Num *QS4-D*)
            aa      (QS-Num *QS4-A*)
            shStart (if (QS-Num *QS4-SH*) (fix (QS-Num *QS4-SH*)) 1)
            lui     (if (QS-Num *QS4-LUI*) (QS-Num *QS4-LUI*) 0.0)
            ohep    (if (QS-Num *QS4-OHEP*) (QS-Num *QS4-OHEP*) 0.0)
            beke    (if (QS-Num *QS4-BEKE*) (QS-Num *QS4-BEKE*) 0.0)
            bv      (QS-Num *QS4-BV*)
            tyle    (QS-Num *QS4-TYL*)
            lechRai (if (QS-Num *QS4-RL*) (QS-Num *QS4-RL*) 0.0)
            mck     (if *QS4-MCK* *QS4-MCK* "")
            rnd     (if (QS-Num *QS4-RND*) (QS-Num *QS4-RND*) 1.0)
            dao     (= *QS4-DAO* "1")
            chogom  (= *QS4-GOM* "1")
            sanAm   nil
            matsan  (= *QS4-LOP* "lp_tren")
            soLopTxt (if (= *QS4-LOP* "lp_tren") "2" "1")
            nguong  (if (QS-Num *QS4-NG*)   (QS-Num *QS4-NG*)   50.0)
            nhanN   (if (QS-Num *QS4-NHAN*) (QS-Num *QS4-NHAN*) 6.0)
            cachMep (if (QS-Num *QS4-CMEP*) (QS-Num *QS4-CMEP*) 0.0)
            lechTach (if (QS-Num *QS4-LTACH*) (QS-Num *QS4-LTACH*) 0.0)
            hsMD    (if (QS-Num *QS4-HSMD*) (QS-Num *QS4-HSMD*) 0.0)
            ctMD    (if (QS-Num *QS4-CTMD*) (QS-Num *QS4-CTMD*) 0.0)
            nhanLT  (/= *QS4-NLT* "0")
            nhanEQ  (/= *QS4-NEQ* "0")
            nhanGT  (= *QS4-NGT* "1")
            keoDai  (= *QS4-KEODAI* "1")
            bodim   (= *QS4-BDIM* "1")
            boxien  (= *QS4-BXIEN* "1")
            coTag   T
            coRai   T
            coDim   (= *QS4-DIM* "1")
            dimNeo  (/= *QS4-DNEO* "0")
            kNeo    (if (QS-Num *QS4-KNEO*) (QS-Num *QS4-KNEO*) 150.0)
            zCho1   (if (QS-Num *QS4-ZCHO1*) (QS-Num *QS4-ZCHO1*) 500.0)
            zCho2   (if (QS-Num *QS4-ZCHO2*) (QS-Num *QS4-ZCHO2*) 1000.0)
            zLech   (if (QS-Num *QS4-ZLECH*) (QS-Num *QS4-ZLECH*) 0.0)
            goBT    T
            btMin   (if (QS-Num *QS4-BTN*) (fix (QS-Num *QS4-BTN*)) 3)
            btDS    (if (QS-Num *QS4-BTDS*) (QS-Num *QS4-BTDS*) 50.0)
            btNG    500.0)
  (if (< btMin 2) (setq btMin 2))
  (setq soBT 0)
      (setq lneo (* (QS-Num *QS4-NEO*) d))

      (setq cao (* 2.5 tyle))
      (setq maMT (cond ((= *QS4-MT* "mt_cheo") "O") ((= *QS4-MT* "mt_cham") "D") (T "F")))
      (setq maNeo "O")
      (if (<= lui 0.0) (setq lui 50.0))

      (cond
        ((= *QS4-PHUONG* "pw_dung") (setq ux 0.0 uy 1.0))
        ((= *QS4-PHUONG* "pw_pick")
         (princ "\nPick diem thu nhat xac dinh phuong rai thep: ")
         (setq p1 (getpoint))
         (if p1 (setq p2 (getpoint p1 "\nPick diem thu hai: ")))
         (if (and p1 p2 (> (distance p1 p2) 1.0e-6))
           (progn
             (setq ux (/ (- (car p2) (car p1)) (distance p1 p2))
                   uy (/ (- (cadr p2) (cadr p1)) (distance p1 p2))))
           (progn (princ "\n[Chu y] Khong lay duoc phuong - dung mac dinh nam ngang.")
                  (setq ux 1.0 uy 0.0))))
        (T (setq ux 1.0 uy 0.0))
      )
      (setq u (list ux uy) vx (- uy) vy ux v (list vx vy))

      (setq nx vx ny vy)
      (if (or (> ny 1.0e-8) (and (< (abs ny) 1.0e-8) (> nx 0.0)))
        (setq nx (- nx) ny (- ny)))
      (if dao (setq nx (- nx) ny (- ny)))

      (setq gocTag (QS-GocDoc u))

      (if (and (boundp '*QS-MB-CONTEXT*) *QS-MB-CONTEXT*)
        (setq ss (cdr (assoc 'selection *QS-MB-CONTEXT*)))
        (progn
          (princ "\n\nQuet chon mat bang (chi lay doi tuong tren layer thep san: ")
          (princ (strcat (QS-LayThepSan) "): "))
          (setq ss (ssget (list '(-4 . "<OR") '(0 . "LWPOLYLINE") '(0 . "POLYLINE")
                                '(0 . "CIRCLE") '(0 . "ELLIPSE") '(0 . "LINE") '(0 . "ARC")
                                '(-4 . "OR>")
                                (cons 8 (QS-LayThepSan)))))
          (if ss (princ (strcat "\n  Loc duoc " (itoa (sslength ss)) " doi tuong thep san."))))) 
      (if (not ss)
        (princ "\nKhong chon duoc duong bao nao. Huy lenh.")
        (progn
          (setq n (sslength ss) i 0 dsNgoai nil dsDam nil soMo 0 dsVSsel nil dsLoSel nil)
          (while (< i n)
            (setq ent (ssname ss i))
            (setq lay (cdr (assoc 8 (entget ent))))
            (setq etype (cdr (assoc 0 (entget ent))))
            (cond
              ((and (boundp '*QS-MB-CONTEXT*) *QS-MB-CONTEXT*)
               (cond
                 ((equal ent (cdr (assoc 'outer *QS-MB-CONTEXT*)))
                  (setq dsNgoai (list (vlax-ename->vla-object ent))))
                 ((member ent (cdr (assoc 'beams *QS-MB-CONTEXT*)))
                  (setq dsDam (cons (vlax-ename->vla-object ent) dsDam)))))
              ((and (/= *QS4-LNG* "") (= (strcase lay) (strcase *QS4-LNG*)))
               (setq dsNgoai (cons (vlax-ename->vla-object ent) dsNgoai)))
              ((and (/= *QS4-LDAM* "") (= (strcase lay) (strcase *QS4-LDAM*)))
               (setq dsDam (cons (vlax-ename->vla-object ent) dsDam)))
              ;; v20.20: lo mo tren layer QS_LoMo (OS_MBTK ve) - chi lay net KIN, bo chu X
              ((= (strcase lay) (strcase (QS-LayLoMo)))
               (if (and (member etype '("LWPOLYLINE" "POLYLINE" "CIRCLE" "ELLIPSE"))
                        (not (vl-catch-all-error-p (vl-catch-all-apply 'vlax-curve-isClosed (list ent))))
                        (vlax-curve-isClosed ent))
                 (setq dsLoSel (cons (vlax-ename->vla-object ent) dsLoSel))))
              ;; v20.15: polyline VUNG SAN (OS_VUNGSAN) cung la duong bao san
              ((and (= etype "LWPOLYLINE") (QSVS-Doc ent))
               (setq dsVSsel (cons (vlax-ename->vla-object ent) dsVSsel)))
            )
            (setq i (1+ i))
          )

          (setq dsZone nil soZ 0)
          (if (QS-TrungTen *QS4-LZONE*
                (list *QS4-LNG* *QS4-LDAM*))
            (progn
              (princ (strcat "\n[CANH BAO] Layer PHAN ZONE \"" *QS4-LZONE*
                             "\" dang TRUNG voi layer mep ngoai / dam."))
              (princ "\n           -> BO QUA phan zone (khong noi cho zone).")
              (setq *QS4-LZONE* "")))
          (if (and *QS4-LZONE* (/= *QS4-LZONE* ""))
            (progn
              (setq ssZn (ssget "_X" (list (cons 8 *QS4-LZONE*)
                          '(-4 . "<OR") '(0 . "LINE") '(0 . "LWPOLYLINE")
                          '(0 . "POLYLINE") '(-4 . "OR>"))))
              (if ssZn
                (progn
                  (setq iz 0 nz (sslength ssZn) soLoaiZ 0)
                  (while (< iz nz)
                    (setq eZn (ssname ssZn iz))
                    (setq lyZn (cdr (assoc 8 (entget eZn))))
                    (if (= (strcase lyZn) (strcase *QS4-LZONE*))
                      (setq dsZone (cons (vlax-ename->vla-object eZn) dsZone))
                      (setq soLoaiZ (1+ soLoaiZ)))
                    (setq iz (1+ iz)))
                  (setq soZ (length dsZone))
                  (if (> soLoaiZ 0)
                    (princ (strcat "\n[CANH BAO] Da loai " (itoa soLoaiZ)
                                   " doi tuong KHONG thuoc layer \"" *QS4-LZONE*
                                   "\" ra khoi tap phan zone.")))
                )
              )
            )
          )

          (setq coZone (if dsZone T nil))
          (if coZone
            (princ (strcat "\nPHAN ZONE: layer " *QS4-LZONE* " - " (itoa soZ)
                           " duong  ->  CO noi cho / thut thep tai ranh zone.")))
          (setq zKin (and coZone (QS-CoKin dsZone)))
          (cond
           ((and (boundp '*QS-MB-CONTEXT*) *QS-MB-CONTEXT*)
            (setq dsLo (mapcar 'vlax-ename->vla-object (cdr (assoc 'holes *QS-MB-CONTEXT*)))
                  big (car dsNgoai) *QS-SLABUNION* nil))
           ;; Khong co duong mep ngoai -> dung cac VUNG SAN da chon lam duong bao
           ((and (null dsNgoai) dsVSsel)
            (setq dsNgoai dsVSsel dsLo nil *QS-SLABUNION* T big nil bigA -1.0)
            (foreach o dsNgoai
              (setq bb2 (QS-HopBao (list o))
                    ar (if bb2 (* (- (caddr bb2) (car bb2)) (- (cadddr bb2) (cadr bb2))) 0.0))
              (if (> ar bigA) (setq bigA ar big o)))
            (princ (strcat "\n[VUNG SAN] Khong co duong mep ngoai san trong tap chon -> dung "
                           (itoa (length dsNgoai)) " vung san OS_VUNGSAN lam duong bao.")))
           (T
              (setq *QS-SLABUNION* nil)
              (setq dsLo nil big nil bigA -1.0)
              (foreach o dsNgoai
                (setq bb2 (QS-HopBao (list o)))
                (if bb2
                  (progn
                    (setq ar (* (- (caddr bb2) (car bb2)) (- (cadddr bb2) (cadr bb2))))
                    (if (> ar bigA) (setq bigA ar big o)))))
              (if big
                (foreach o dsNgoai
                  (if (not (equal (vlax-vla-object->ename o) (vlax-vla-object->ename big)))
                    (setq dsLo (cons o dsLo)))))
            )
          ) ; explicit MATBANG context / vung san / boundary inference
          ;; v20.20: lo mo tren layer QS_LoMo -> them vao lo mo (va duong bao khi khong dung vung san)
          (if dsLoSel
            (progn
              (setq dsLo (append dsLoSel dsLo))
              (if (and dsNgoai (not *QS-SLABUNION*)) (setq dsNgoai (append dsNgoai dsLoSel)))
              (princ (strcat "\n[LO MO] " (itoa (length dsLoSel)) " lo mo tren layer " (QS-LayLoMo) "."))))
          (setq soMo (length dsLo))

          (cond
            ((null dsNgoai)
             (princ (strcat "\n[Loi] Tap chon khong co duong bao san: can duong tren layer \""
                            *QS4-LNG* "\" hoac polyline VUNG SAN (lenh OS_VUNGSAN). Huy lenh.")))
            (T
             (setq coDam (if dsDam T nil))

             (setq dsDamSan nil)

             (foreach o dsDam
               (if (and (not (QS-TrungVoi o dsNgoai))
                        (not (vl-catch-all-error-p
                               (vl-catch-all-apply 'vlax-curve-isClosed (list o))))
                        (vlax-curve-isClosed o))
                 (setq dsDamSan (cons o dsDamSan))))
             (if (null dsDamSan) (setq dsDamSan dsDam))

             (setq dsDamHo nil)
             (foreach o dsDam
               (if (and (not (QS-TrungVoi o dsNgoai))
                        (or (vl-catch-all-error-p
                              (vl-catch-all-apply 'vlax-curve-isClosed (list o)))
                            (not (vlax-curve-isClosed o))))
                 (setq dsDamHo (cons o dsDamHo))))
             (if (< (length dsDamSan) (length dsDam))
               (princ (strcat "\nCo " (itoa (- (length dsDam) (length dsDamSan)))
                              " net dam ve trung mep ngoai san - chi dung de do"
                              " be rong dam bien.")))
             (if (null dsDam)
               (progn
                 (princ "\n[Chu y] Khong co duong bao trong (mat trong dam) - rai thep theo")
                 (princ "\n        duong bao ngoai; hai dau lui vao 1 lop bao ve.")
                 (setq dsDam dsNgoai dsDamSan dsNgoai)))

             (princ (strcat "\nDuong bao mep ngoai + lo mo: " (itoa (length dsNgoai))
                            "   |   duong dam: " (itoa (length dsDam))))

             ;; v20.15: VUNG SAN tu OS_VUNGSAN (polyline kin mang Hs / Cote / huong)
             (setq vsOn T dsVS nil vsObjs nil vsTru nil vsMiss 0 vsHit 0)
             (if vsOn (setq dsVS (QSVS-ThuThap (QS-HopBao dsNgoai))))
             (if dsVS
               (progn
                 (setq vsObjs (mapcar (function (lambda (r) (nth 5 r))) dsVS))
                 (princ (strcat "\n[VUNG SAN] " (itoa (length dsVS))
                                " vung OS_VUNGSAN -> Hs / Cote lay theo vung,"
                                " cat thep tai ranh vung khac Hs / Cote."))
                 (setq sanAm T))
               (princ (strcat "\n[VUNG SAN] Khong co vung OS_VUNGSAN tren mat bang nay -> Hs="
                              (rtos hsMD 2 0) " Cote=" (rtos ctMD 2 3) " cho toan bo.")))

             (QS-DamBaoLayer "QS_ThepChu" 1)
             (QS-DamBaoLayer "QS_Block"   7)
             (QS-DamBaoLayer "QS_Dim"     254)
             (QS-DamBaoLayer "QS_Symbol"  8)
             (QS-TaoBlockTag)
             (QS-CanGiuaSH-Block "Dce_KhtThepDai2")

             (setq eps 0.5)

             (setq gBase (angle (list 0.0 0.0) u))
             (setq dsVung (list (list gBase)))
             (if (and dsVS (setq vsR (QSVS-NhomHuong dsVS gBase)))
               (progn
                 (setq dsVung (car vsR) vsTru (cdr vsR))
                 (princ (strcat "\n   [VUNG SAN] " (itoa (length vsTru)) " vung co HUONG RIENG ("
                                (itoa (1- (length dsVung))) " nhom goc); phan con lai theo huong lenh."))))
             (princ (strcat "\n   [HUONG RAI] " (itoa (length dsVung))
                            " vung rai  (moi vung mot huong)."))
             (setq dsKey nil shNo shStart dsDim nil dsNeo nil dsTagPt nil
                   soThanh 0 soVe 0 tongDai 0
                   *QS-SOGOP* 0 *QS-SONHAN* 0 soTachZ 0 soBoZ 0 soDam 0)

             (foreach vg dsVung
             (setq gU (car vg) vgClip (cdr vg))
             (setq vgTru (if (and vsTru (null vgClip)) vsTru nil))
             (setq ux (cos gU) uy (sin gU))
             (setq u (list ux uy) vx (- uy) vy ux v (list vx vy))
             (setq nx vx ny vy)
             (if (or (> ny 1.0e-8) (and (< (abs ny) 1.0e-8) (> nx 0.0)))
               (setq nx (- nx) ny (- ny)))
             (if dao (setq nx (- nx) ny (- ny)))
             (setq gocTag (QS-GocDoc u))
             (princ (strcat "\n\n   --- Huong rai " (rtos (/ (* gU 180.0) pi) 2 2)
                            " do  (" (itoa (length vgClip)) " mien) ---"))

             (setq mocs (QS-MocChia (append (if coDam dsDam nil)
                                            (if vgClip vgClip (list big))
                                            (if coZone dsZone nil)
                                            (if vgTru vgTru nil)
                                            (if dsVS vsObjs nil)) v))

             (setq bb (QS-PhamViChieu dsNgoai u))
             (setq tmin (car bb) tmax (cadr bb))
             (setq R (+ 1000.0 lneo beke (* 2.0 aa)))
             (setq tmin (- tmin R) tmax (+ tmax R))

             (if (> (QS-DemHo dsNgoai) 0)
               (princ (strcat "\n[Canh bao] Co " (itoa (QS-DemHo dsNgoai))
                              " duong bao ngoai KHONG khep kin - ket qua co the sai.")))
             (if (and coDam (> (QS-DemHo dsDam) 0))
               (princ (strcat "\n[Canh bao] Co " (itoa (QS-DemHo dsDam))
                              " net dam KHONG khep kin - nen ve bang polyline kin"
                              " hoac rectang.")))

             (setq kieuDam
               (if coDam
                 (if *QS-SLABUNION* "RECT"
                   (QS-NhanKieuDam spc dsNgoai dsDamSan u v (car mocs)
                                   (last mocs) tmin tmax))
                 "BAO"))
             (setq *QS-SLAB-STRICT* (and coDam (= kieuDam "RECT")))
             (if *QS-SLAB-STRICT*
               (progn
                 (if dsDamHo
                   (QS-VT-Err "Dam ho khong xac dinh duoc than dam. Can polyline dam KIN truoc khi rai."))
                 (setq keoDai nil)
                 (princ (if chogom
                   "\n[SLAB] Gom qua dam khi be rong theo huong thep <= 2Lneo."
                   "\n[SLAB] Chi rai trong o san tru hop than dam; khong gom xuyen dam."))))
             (if coDam
               (princ (strcat "\nNet dam nhan dang la: "
                              (if (= kieuDam "RECT")
                                "RECTANG / vung dam  (mien san = ben NGOAI net dam)"
                                "DUONG BAO TRONG o san  (mien san = ben TRONG net dam)"))))

             (setq dais (QS-LocDai spc mocs dsNgoai dsDamSan dsDamHo dsLo kieuDam coDam
                                   u v tmin tmax))
             (setq dsS  (QS-ViTriQuet dais lui aa))
             (princ (strcat "\n" (itoa (1- (length mocs))) " dai giua cac moc  ->  con "
                            (itoa (length dais))
                            " dai rai thep (da loai than dam va gop cac dai lien tuc)."))
             (if (null dsS)
               (progn
                 (princ "\n[Loi] Khong xac dinh duoc vi tri rai thep.")
                 (princ "\n      Kiem tra lai khoang cach a / cach mep dam so voi kich thuoc san.")))

             (setq recs nil k 0)
             (if dsS
               (progn
                 (setq bbV (QS-PhamViChieu dsNgoai v))
                 (setq smin (- (car bbV) 100.0) smax (+ (cadr bbV) 100.0))
                 (setq lnV (vla-AddLine spc
                             (vlax-3d-point (QS-Pt v u 0.0 smin))
                             (vlax-3d-point (QS-Pt v u 0.0 smax))))
                 (setq lnObj (vla-AddLine spc
                               (vlax-3d-point (QS-Pt u v (car (car dsS)) tmin))
                               (vlax-3d-point (QS-Pt u v (car (car dsS)) tmax))))))

             (foreach s0L dsS

               (setq s0 (car s0L) sLo (cadr s0L) sHi (caddr s0L))
               (setq s (+ s0 0.0137))
               (vla-put-StartPoint lnObj (vlax-3d-point (QS-Pt u v s tmin)))
               (vla-put-EndPoint   lnObj (vlax-3d-point (QS-Pt u v s tmax)))

               (setq tsN (QS-GiaoT lnObj dsNgoai u))
               (setq tsD (QS-GiaoT lnObj dsDam    u))
               (setq khN (QS-SlabIntervals lnObj dsNgoai u))
               (setq khNA khN)
               (if vgClip
                 (progn
                   (setq khN (QS-GiaoKhoang khN (QS-GiaoTHop lnObj vgClip u)))
                   (setq khN (vl-remove-if
                               (function (lambda (x) (< (- (cadr x) (car x)) 100.0)))
                               khN))))
               (if vgTru
                 (progn
                   (setq khN (QS-TruKhoang khN (QS-GiaoTHop lnObj vgTru u)))
                   (setq khN (vl-remove-if
                               (function (lambda (x) (< (- (cadr x) (car x)) 100.0)))
                               khN))))
               (setq khD (QS-GiaoTHop lnObj dsDamSan u))
               (if *QS-SLAB-STRICT* (setq tsD (QS-BeamEdges khD)))
               (if (and coDam khD)
                 (setq khNA (QS-HopKhoang (append khNA khD))))
               (setq khL (if dsLo (QS-TsToKhoang (QS-GiaoT lnObj dsLo u)) nil))
               (setq tsR nil)

               (setq chg (if (= 0 (rem k 2)) zCho1 zCho2))
               (setq tsZ (if coZone (QS-GiaoT lnObj dsZone u) nil))

               (setq khSan
                 (cond ((not coDam) khN)
                       ((= kieuDam "RECT") (QS-TruKhoang khN khD))
                       (T khD)))
               (setq khHo (if dsDamHo (QS-TsToKhoang (QS-GiaoT lnObj dsDamHo u)) nil))
               (setq kh (QS-TruKhoang (QS-TruKhoang khSan khL) khHo))

               (setq tsZ (QS-LocTrung tsZ))
               (if (and zKin tsZ (= 0 (rem (length tsZ) 2)))
                 (progn
                   (setq kh (QS-GiaoKhoang kh (QS-TsToKhoang tsZ)))
                   (if (null kh) (setq soBoZ (1+ soBoZ)))
                 )
               )

               (if dsVS
                 (setq tsR (append tsR (QSVS-Cat (QS-GiaoT lnObj vsObjs u) kh dsVS u v s tsR))))
               (setq kh (QS-ChiaKhoang kh tsR))
               (if vgClip
                 (setq kh (QS-TagRanhBien kh (QS-GiaoT lnObj vgClip u))))
               (if vgTru
                 (setq kh (QS-TagRanhBien kh (QS-GiaoT lnObj vgTru u))))
               (if (and coZone zKin) (setq kh (QS-TagZoneKh kh tsZ)))

               (setq dsIv nil)
               (foreach iv kh
                 (setq t1 (car iv) t2 (cadr iv))

                 (if (and (> ohep 0.0) (< (- t2 t1) ohep))
                   (setq soBo (1+ (if soBo soBo 0)) t1 nil))

                 (if (and t1 coDam (= kieuDam "RECT")
                          (QS-TrongMotDam lnObj dsDamSan u t1 t2))
                   (setq soDam (1+ (if soDam soDam 0)) t1 nil))
                 (if (and t1 coDam
                          (not (QS-OHopLe lnV u v s t1 t2 dsNgoai dsDamSan
                                          dsDamHo dsLo kieuDam coDam
                                          smin smax ohep)))
                   (setq soDam (1+ (if soDam soDam 0)) t1 nil))
                 (if t1
                 (progn

                 (cond

                   ((and coZone (= (caddr iv) "ZONE")) (setq la1 chg h1 0.0))
                   ((= (caddr iv) "RANH")
                    (setq kOut (QS-KhoangChua khNA (- t1 eps)))
                    (setq B1 (if kOut (- t1 (car kOut)) 0.0))
                    (setq tD (QS-TTruoc tsD t1 eps))
                    (if (or (null kOut)
                            (and coDam tD (>= tD (car kOut))
                                 (<= (- t1 tD) 1000.0)))
                      (progn
                        (if (> B1 0.0) (setq B1 (min B1 (- t1 tD))))
                        (setq r1 (QS-TinhNeo B1 lneo beke bv)
                              la1 (car r1) h1 (cadr r1)))
                      (setq la1 lneo h1 beke)))
                   (T
                   (progn
                     (setq kOut (QS-KhoangChua khNA (- t1 eps)))
                     (setq B1 (if kOut (- t1 (car kOut)) 0.0))

                     (setq tD (QS-TTruoc tsD t1 eps))
                     (if (and tD (> B1 0.0)) (setq B1 (min B1 (- t1 tD))))
                     (setq r1 (QS-TinhNeo B1 lneo beke bv) la1 (car r1) h1 (cadr r1))))
                 )
                 (cond
                   ((and coZone (= (cadddr iv) "ZONE")) (setq la2 chg h2 0.0))
                   ((= (cadddr iv) "RANH")
                    (setq kOut (QS-KhoangChua khNA (+ t2 eps)))
                    (setq B2 (if kOut (- (cadr kOut) t2) 0.0))
                    (setq tD (QS-TKe tsD t2 eps))
                    (if (or (null kOut)
                            (and coDam tD (<= tD (cadr kOut))
                                 (<= (- tD t2) 1000.0)))
                      (progn
                        (if (> B2 0.0) (setq B2 (min B2 (- tD t2))))
                        (setq r2 (QS-TinhNeo B2 lneo beke bv)
                              la2 (car r2) h2 (cadr r2)))
                      (setq la2 lneo h2 beke)))
                   (T
                   (progn
                     (setq kOut (QS-KhoangChua khNA (+ t2 eps)))
                     (setq B2 (if kOut (- (cadr kOut) t2) 0.0))
                     (setq tD (QS-TKe tsD t2 eps))
                     (if (and tD (> B2 0.0)) (setq B2 (min B2 (- tD t2))))
                     (setq r2 (QS-TinhNeo B2 lneo beke bv) la2 (car r2) h2 (cadr r2))))
                 )
                 (if *QS-SLAB-STRICT*
                   (progn
                     (if (and (not (= (caddr iv) "ZONE"))
                              (or (not (= (caddr iv) "RANH"))
                                  (> (QS-BeamWidth khD t1 -1) 0.5)))
                       (progn
                         (setq r1 (QS-TinhNeo (QS-BeamWidth khD t1 -1) lneo beke bv))
                         (setq la1 (car r1) h1 (cadr r1))))
                     (if (and (not (= (cadddr iv) "ZONE"))
                              (or (not (= (cadddr iv) "RANH"))
                                  (> (QS-BeamWidth khD t2 1) 0.5)))
                       (progn
                         (setq r2 (QS-TinhNeo (QS-BeamWidth khD t2 1) lneo beke bv))
                         (setq la2 (car r2) h2 (cadr r2))))))
                 (setq ta (- t1 la1) tb (+ t2 la2))

                 (if (and coZone (= (caddr iv)  "ZONE") (< chg 0.0)) (setq t1 ta))
                 (if (and coZone (= (cadddr iv) "ZONE") (< chg 0.0)) (setq t2 tb))
                 (setq hsct (cond
                              ((and dsVS
                                    (QSVS-TraDiem dsVS (QS-Pt u v s (/ (+ t1 t2) 2.0))))
                               (setq vsHit (1+ vsHit))
                               (QSVS-TraDiem dsVS (QS-Pt u v s (/ (+ t1 t2) 2.0))))
                              (T
                               (if dsVS (setq vsMiss (1+ vsMiss)))
                               (list hsMD ctMD))))
                 (setq dsIv (cons (list t1 t2 ta tb h1 h2 (car hsct) (cadr hsct)
                                        (caddr iv) (cadddr iv)) dsIv))
                 ))
               )

               (setq dsIv (QS-GomKhoang (reverse dsIv) khN sanAm nguong matsan
                                        nhanN nhanLT nhanEQ nhanGT chogom
                                        bodim boxien lneo keoDai cachMep))

               (cond

                 ((and coZone zKin tsZ) (setq soTachZ (+ soTachZ (length tsZ))))

                 ((and coZone (not zKin))
                  (progn
                    (if tsZ
                      (progn
                        (setq dsIv (QS-TachZoneIv dsIv tsZ chg lneo))
                        (setq soTachZ (+ soTachZ (length tsZ)))))
                  )
                 )
               )

               (setq ivOk nil)
               (foreach iv dsIv
                 (if (and (> (- (nth 3 iv) (nth 2 iv)) (max 1.0 (* 2.0 bv)))
                          (> (- (nth 1 iv) (nth 0 iv)) 1.0))
                   (setq ivOk (cons iv ivOk))))
               (setq ivOk (reverse ivOk))
               (setq dsL (QS-LechTach ivOk lechTach) i 0)
               (foreach iv ivOk
                 (setq recs (cons (list k (+ s (nth i dsL)) (nth 2 iv) (nth 3 iv)
                                        (nth 4 iv) (nth 5 iv)
                                        (nth 10 iv) (nth 11 iv)
                                        (nth 0 iv) (nth 1 iv)
                                        (QS-CoZone iv)
                                        (QS-BTSupportKey (nth 0 iv) (nth 1 iv))) recs))
                 (setq i (1+ i))
               )
               (setq k (1+ k))
             )
             (if lnV (vl-catch-all-apply 'vla-Delete (list lnV)))
             (setq lnV nil)
             (setq recs (reverse recs))
             (if (= *QS4-KEDEU* "1") (setq recs (QS-DeuKe recs rnd)))

             (if (null recs)
               (progn
                 (if lnObj (vl-catch-all-apply 'vla-Delete (list lnObj)))
                 (setq lnObj nil)
                 (princ "\n   [Vung nay] khong sinh duoc thanh thep nao."))
               (progn

                 (setq buocRai (if (and coZone (> soTachZ 0)
                                        (> (abs (- zCho1 zCho2)) 0.5)) 2 1))
                 (setq og nil)
                 (foreach rr recs
                   (setq key (strcat (itoa (QS-R0 (nth 2 rr))) "|" (itoa (QS-R0 (nth 3 rr)))
                                     "|" (itoa (length (nth 7 rr)))
                                     (if (nth 10 rr) "|ZONE" "|PLAIN")))
                   (setq found nil)
                   (foreach g og
                     (if (and (null found) (= (car g) key)
                              (or (= (cadr g) (1- (car rr)))
                                  (and (= buocRai 2) (nth 10 rr)
                                       (= (cadr g) (- (car rr) 2))))
                              (QS-SlabLinkClear (car (nth 3 g)) rr)
                              (<= (- (nth 1 rr) (caddr g))
                                  (* 1.5 aa (if (= (cadr g) (1- (car rr)))
                                              1.0 2.0))))
                       (setq found g)))
                   (if found
                     (setq og (cons (list key (car rr) (nth 1 rr)
                                          (cons rr (nth 3 found)))
                                    (vl-remove found og)))
                     (setq og (cons (list key (car rr) (nth 1 rr) (list rr)) og)))
                 )
                 (setq grps (mapcar (function (lambda (g) (reverse (nth 3 g)))) og))
                 (setq grps (mapcar '(lambda (ix) (nth ix grps))
                              (vl-sort-i grps
                                '(lambda (x y) (< (car (car x)) (car (car y)))))))
                 (setq dsBT nil)
                 (if goBT
                   (progn
                     (setq *QS-V3-GROUPING* T *QS-V4-STAT* nil)
                     (setq btKQ (QS-GopBT grps aa btMin btDS btNG buocRai))
                     (setq *QS-V3-GROUPING* nil)
                     (QS-V4InStat (length grps))
                     (setq grps (car btKQ) dsBT (cadr btKQ))
                     (foreach btI dsBT (if btI (setq soBT (1+ soBT))))))

                 (if lnObj (vl-catch-all-apply 'vla-Delete (list lnObj)))
                 (setq lnObj nil)

                 (setq origDim (getvar "DIMSTYLE"))
                 (setq oldecho (getvar "CMDECHO"))
                 (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
                 (if coRai (QS-ChuanBiRaiStyle cao maMT))

                 (setq dsDem nil iG 0)
                 (foreach grp grps
                   (setq btI (if dsBT (nth iG dsBT) nil))
                   (setq rr (nth (/ (length grp) 2) grp))
                   (setq gkey (QS-V4Key rr btI))
                   (setq pr (assoc gkey dsDem))
                   (if pr
                     (setq dsDem (subst (cons gkey (+ (cdr pr) (length grp))) pr dsDem))
                     (setq dsDem (cons (cons gkey (length grp)) dsDem)))
                   (if (not (assoc gkey dsKey))
                     (progn (setq dsKey (cons (cons gkey shNo) dsKey))
                            (setq shNo (1+ shNo))))
                   (setq iG (1+ iG))
                 )

                 (setq dsDem dsDem)

                 (setq dvTag (* 8.0 tyle) dtTag (* 30.0 tyle))

                 (setq iG 0)
                 (foreach grp grps
                   (setq btI (if dsBT (nth iG dsBT) nil))
                   (setq iG (1+ iG))
                   (setq nBar (length grp))
                   (setq soThanh (+ soThanh nBar))
                   (setq rrK (nth (/ nBar 2) grp))

                   (setq rr (QS-ChonDaiDien grp dsTagPt dvTag dtTag))
                   (setq gkey (QS-V4Key rrK btI))
                   (setq shOf  (cdr (assoc gkey dsKey)))
                   (setq nTong (cdr (assoc gkey dsDem)))

                   (setq nGhi nBar)

                   (setq entBar nil tagEnt nil raiEnt nil)
                   (setq entBar (QS-VeThanhThep u v (nth 1 rr) (nth 2 rr) (nth 3 rr)
                                                (nth 4 rr) (nth 5 rr) nx ny (nth 7 rr)))
                   (if entBar (setq soVe (1+ soVe)))

                   (if entBar
                     (progn

                       (setq Ltot (QS-LamTron (+ (- (nth 3 rr) (nth 2 rr))
                                                 (nth 4 rr) (nth 5 rr) (nth 6 rr))
                                              (fix rnd)))

                       (setq aBand aa aMin nil aPrev nil)
                       (foreach r2 grp
                         (if aPrev
                           (progn
                             (setq g2 (abs (- (nth 1 r2) aPrev)))
                             (if (and (> g2 1.0) (or (null aMin) (< g2 aMin)))
                               (setq aMin g2))))
                         (setq aPrev (nth 1 r2)))
                       (if aMin (setq aBand aMin))
                       (setq aBand (* aa (max 1 (fix (+ 0.5 (/ aBand aa))))))
                       (if btI
                         (setq Ltot (QS-R0 (/ (caddr btI) (float (cadddr btI))))))
                       (setq dkvakc
                         (if btI
                           (strcat (itoa nGhi) "%%c" (rtos d 2 0)
                                   "a" (rtos aBand 2 0)
                                   " (L=" (QS-ChuoiChieuDai (car btI) (cadr btI) (fix rnd)) ")")
                           (strcat (itoa nGhi) "%%c" (rtos d 2 0)
                                   "a" (rtos aBand 2 0)
                                   " (L=" (itoa Ltot) ")")))
                       (if (> Ltot 11700) (setq Lmax (1+ (if Lmax Lmax 0))))

                       (setq ptTag (QS-GiuaDoanDai (QS-DinhDuong entBar)))
                       (setq tt (+ (* (car ptTag) (car u)) (* (cadr ptTag) (cadr u))))

                       (setq zl (if (and (> zLech 0.0) (nth 10 rr))
                                  (if (= 0 (rem (car rr) 2))
                                    (- (/ zLech 2.0)) (/ zLech 2.0))
                                  0.0))
                       (setq tt  (+ tt zl))
                       (setq ptTag (list (+ (car ptTag) (* zl (car u)))
                                         (+ (cadr ptTag) (* zl (cadr u)))))
                       (setq ttR (+ tt lechRai))
                       (setq dsTagPt (cons (list (nth 1 rr) tt) dsTagPt))

                       (if coTag
                         (progn
                           (setq tagObj (QS-ChenTagThep spc ptTag tyle dkvakc
                                                        (itoa shOf) "" gocTag))
                           (QS-CanGiuaTagU tagObj ptTag u)
                           (setq tagEnt (vlax-vla-object->ename tagObj))
                         )
                       )

                       (if (> nBar 1)
                         (progn
                           (setq ptA (QS-Pt u v (nth 1 (car grp)) ttR))
                           (setq ptB (QS-Pt u v (nth 1 (last grp)) ttR))
                           (setq ptR (QS-Pt u v (QS-STaiT (nth 1 rr) (nth 7 rr)
                                                          nx ny v ttR) ttR))
                           (setq raiEnt (QS-VeDuongRai spc ptA ptB ptR cao))
                         )
                       )

                       (QS-GanBoLienKet entBar tagEnt raiEnt mck (itoa shOf)
                                        (itoa shOf) (rtos d 2 0) soLopTxt aBand
                                        nBar ";1/0;")
                       ;; Nhom >= 2 thanh: luu TUNG thanh vao nhom V3 (tag + rai + thanh dai dien)
                       (if (and btI (> nBar 1))
                         (setq eBao (QS-V3Slab32 grp rr u v nx ny entBar tagEnt raiEnt
                           mck (itoa shOf) (rtos d 2 0) soLopTxt aBand rnd)))

                       (if coDim (setq dsDim (cons entBar dsDim)))

                       (if (and coDim dimNeo)
                         (progn
                           (if (> (- (nth 8 rr) (nth 2 rr)) 1.0)
                             (setq dsNeo
                               (cons (list (QS-Pt u v (QS-STaiT (nth 1 rr) (nth 7 rr)
                                                               nx ny v (nth 2 rr))
                                                  (nth 2 rr))
                                           (QS-Pt u v (QS-STaiT (nth 1 rr) (nth 7 rr)
                                                               nx ny v (nth 8 rr))
                                                  (nth 8 rr)))
                                     dsNeo)))
                           (if (> (- (nth 3 rr) (nth 9 rr)) 1.0)
                             (setq dsNeo
                               (cons (list (QS-Pt u v (QS-STaiT (nth 1 rr) (nth 7 rr)
                                                               nx ny v (nth 9 rr))
                                                  (nth 9 rr))
                                           (QS-Pt u v (QS-STaiT (nth 1 rr) (nth 7 rr)
                                                               nx ny v (nth 3 rr))
                                                  (nth 3 rr)))
                                     dsNeo)))
                         )
                       )
                     )
                   )
                 )

                 (setq tongDai (+ tongDai (length grps)))
               )
             )
             )

                 (if dsDim (QS-GhiDimThep (reverse dsDim) cao (fix rnd) 0.0 0.0
                                          nil maMT T))

                 (if (and coDim dimNeo dsNeo)
                   (QS-GhiDimCap (reverse dsNeo) cao (fix rnd)
                                 (if (> kNeo 0.0) kNeo (* 2.5 cao)) maNeo))
                 (if (and origDim (/= origDim "") (tblsearch "DIMSTYLE" origDim))
                   (command "_.-DIMSTYLE" "_R" origDim))
                 (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))

                 (princ (strcat "\n\n[HOAN TAT] " (itoa (length dsKey)) " so hieu (SH "
                                (itoa shStart) " -> " (itoa (1- shNo)) ") tren "
                                (itoa tongDai) " dai rai  -  tong "
                                (itoa soThanh) " thanh, da VE " (itoa soVe)
                                " thanh dai dien (QS_BT_V3)."))
                 (if (> tongDai (length dsKey))
                   (princ (strcat "\n   Co " (itoa (- tongDai (length dsKey)))
                                  " nhom dung CHUNG so hieu (cung hinh dang thanh).")))
                 (princ (strcat "\n   Duong kinh " (rtos d 2 0) " - khoang cach a" (rtos aa 2 0)
                                " - neo " (rtos (QS-Num *QS4-NEO*) 2 0) "d = " (rtos lneo 2 0) " mm"))
                 (princ (strcat "\n   Be ke toi thieu " (rtos beke 2 0)
                                " mm - lop bao ve " (rtos bv 2 0)
                                " mm - cach mep/ranh " (rtos lui 2 0) " mm"))
                 (princ (strcat "\n   Ty le 1:" (rtos tyle 2 0) "  ->  cao chu that "
                                (rtos cao 2 0) " mm"
                                (if (/= mck "") (strcat "   -   Cau kien: " mck) "")))
                 (princ (strcat "\n   Dang ve LOP " (if matsan "TREN" "DUOI")
                                "  ->  so cao do " (if matsan "MAT" "DAY")
                                " san (XDATA so lop = " soLopTxt ")"))
                 (if (> soTachZ 0)
                   (progn
                     (princ (strcat "\n   ZONE THI CONG: layer " *QS4-LZONE*
                                    " (" (itoa soZ) " duong) - da tach "
                                    (itoa soTachZ) " cho."))
                     (princ (if zKin
                              (strcat "\n      Duong zone KHEP KIN -> CHI ve thep"
                                      " BEN TRONG zone; ben ngoai la ZONE KE BEN."
                                      (if (> soBoZ 0)
                                        (strcat " (" (itoa soBoZ)
                                                " duong quet nam ngoai zone da bi bo.)")
                                        ""))
                              "\n      [Luu y] Duong zone KHONG khep kin -> chay che do CU (chi tach khoang). Nen ve duong zone khep kin de chi ve thep ben trong zone."))
                     (princ (strcat "\n      2 thanh ke nhau cho "
                                    (rtos zCho1 2 0) " va " (rtos zCho2 2 0)
                                    " mm -> moi noi tai ranh zone SO LE."))
                     (if (= buocRai 2)
                       (princ (strcat "\n      2 doan cho KHAC NHAU -> TACH lam 2"
                                      " so hieu, moi so hieu khoang rai a"
                                      (rtos (* 2.0 aa) 2 0) ".")))))
                 (if (> soDam 0)
                   (princ (strcat "\n   Da bo " (itoa soDam)
                                  " o nam trong THAN DAM / CHO GIAO DAM"
                                  " (khong rai thep san trong dam).")))
                 (if (> soMo 0)
                   (princ (strcat "\n   Da tru " (itoa soMo)
                                  " duong bao ben trong (lo mo san) ra khoi vung rai thep.")))
                 (if (> *QS-SOGOP* 0)
                   (princ (strcat "\n   Da GOM " (itoa *QS-SOGOP*)
                                  " vi tri thanh 1 thanh lien tuc (khong co dam ket cau"
                                  " hoac nhan thep).")))
                 (if (and soBo (> soBo 0))
                   (princ (strcat "\n   Da BO QUA " (itoa soBo)
                                  " o san hep hon " (rtos ohep 2 0) " mm.")))
                 (if (and Lmax (> Lmax 0))
                   (princ (strcat "\n[Canh bao] Co " (itoa Lmax)
                                  " so hieu co chieu dai > 11700 mm (dai hon 1 cay"
                                  " thep thuong pham) - can noi hoac tach bot.")))
                 (if dsVS
                   (princ (strcat "\n   VUNG SAN: " (itoa vsHit) " doan lay Hs/Cote tu vung"
                                  (if (> vsMiss 0)
                                    (strcat ", " (itoa vsMiss) " doan NGOAI moi vung -> dung Hs/Cote mac dinh"
                                            " (nen ve vung phu kin mat bang)")
                                    "") ".")))
                 (if sanAm
                   (progn
                     (princ (strcat "\n   San chenh cao do: nguong " (rtos nguong 2 0)
                                    " mm - do doc nhan 1/" (rtos nhanN 2 0)))
                     (princ (strcat "\n   Xu ly:  chenh < nguong = "
                                    (if nhanLT "NHAN" "KEO THANG")
                                    "  |  = nguong = " (if nhanEQ "NHAN" "KEO THANG")
                                    "  |  > nguong = " (if nhanGT "NHAN" "TACH")))
                     (princ (strcat "\n   Trong do co " (itoa *QS-SONHAN*)
                                    " vi tri NHAN THEP."))
                     (if keoDai
                       (princ (strcat "\n   Cho TACH do chenh cote: KEO thanh DAI"
                                      " qua thanh NGAN (bo thanh ngan).")))
))
            )
          )
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-GanXDataThep (ent maCauKien sh dia soLop soNhanh hdl / xdStr)
  (regapp "DcePro")
  (setq xdStr (strcat "(0)_" maCauKien "(1)_" sh "(2)_" hdl
                      "(3)_" dia "(4)_" soLop "(5)_" soNhanh))
  (entmod (append (entget ent) (list (list -3 (list "DcePro" (cons 1000 xdStr))))))
  xdStr
)

(defun QS-DocXDataTho (ent / raw xd appEntry item2)
  (setq raw (entget ent (list "DcePro")))
  (if (setq xd (assoc -3 raw))
    (progn
      (setq appEntry (cadr xd))
      (setq item2 (nth 1 appEntry))
      (if (and item2 (= (car item2) 1000)) (cdr item2) nil)
    )
  )
)

(defun QS-TachFieldXData (xdStr fieldNo / tag pos posEnd sub)
  (if (not xdStr)
    ""
    (progn
      (setq tag (strcat "(" (itoa fieldNo) ")_"))
      (if (setq pos (vl-string-search tag xdStr))
        (progn
          (setq sub (substr xdStr (+ pos (strlen tag) 1)))
          (setq posEnd (vl-string-search "(" sub))
          (if posEnd (substr sub 1 posEnd) sub)
        )
        ""
      )
    )
  )
)

(defun QS-CapNhatXData (ent f3 f5 / xd s0 s1 s2 s3 s4 s5)
  (if (setq xd (QS-DocXDataTho ent))
    (progn
      (setq s0 (QS-TachFieldXData xd 0) s1 (QS-TachFieldXData xd 1)
            s2 (QS-TachFieldXData xd 2) s3 (QS-TachFieldXData xd 3)
            s4 (QS-TachFieldXData xd 4) s5 (QS-TachFieldXData xd 5))
      (if (and f3 (/= f3 "")) (setq s3 f3))
      (if (and f5 (/= f5 "")) (setq s5 f5))
      (regapp "DcePro")
      (entmod (append (entget ent)
                      (list (list -3 (list "DcePro"
                        (cons 1000 (strcat "(0)_" s0 "(1)_" s1 "(2)_" s2
                                           "(3)_" s3 "(4)_" s4 "(5)_" s5)))))))
      T
    )
  )
)

(defun QS-LayAttDKVAKC (insObj / attList a found)
  (setq found nil)
  (if (and insObj
           (not (vl-catch-all-error-p
                  (vl-catch-all-apply 'vla-get-HasAttributes (list insObj))))
           (= (vla-get-HasAttributes insObj) :vlax-true))
    (progn
      (setq attList (vlax-invoke insObj 'GetAttributes))
      (foreach a attList
        (if (and (null found) (= (strcase (vla-get-TagString a)) "DKVAKC"))
          (setq found a))
      )
    )
  )
  found
)

(defun QS-TachDKVAKC (oldStr / pos)
  (setq pos (vl-string-search "(" oldStr))
  (if pos
    (list (vl-string-right-trim " " (substr oldStr 1 pos)) (substr oldStr (1+ pos)))
    (list oldStr "")
  )
)

(defun QS-TachThongSoDau (headPart / soNhanh dia spacing pctPos rest apos)
  (setq soNhanh "" dia "" spacing "")
  (setq pctPos (vl-string-search "%%C" (strcase headPart)))
  (if pctPos
    (progn
      (setq soNhanh (substr headPart 1 pctPos))
      (setq rest (substr headPart (+ 4 pctPos)))
      (setq apos (vl-string-search "A" (strcase rest)))
      (if apos
        (progn
          (setq dia (substr rest 1 apos))
          (setq spacing (substr rest (+ 2 apos)))
        )
        (setq dia rest)
      )
    )
  )
  (list soNhanh dia spacing)
)

(defun QS-BTBaoPointsOK (pts / area p q edges rest x y bad)
  (setq area 0.0 p (last pts) edges nil bad nil)
  (foreach q pts
    (setq area (+ area (- (* (car p) (cadr q)) (* (car q) (cadr p)))))
    (if (< (distance p q) 0.001) (setq bad T))
    (setq edges (cons (list p q) edges) p q))
  (setq rest edges)
  (while rest
    (setq x (car rest))
    (foreach y (cdr rest)
      (if (and (not (equal (car x) (cadr y) 0.001))
               (not (equal (cadr x) (car y) 0.001))
               (inters (car x) (cadr x) (car y) (cadr y) T))
        (setq bad T)))
    (setq rest (cdr rest)))
  (and (>= (length pts) 3) (> (abs area) 0.01) (not bad)))

(defun QS-PickBaoBT (/ pts p q done ed first e)
  (princ "\n[BT] Ve bao Defpoints: pick cac dinh; Enter/C de dong kin.")
  (setq first (getpoint "\nDinh dau duong bao (Enter = bo qua): "))
  (if first
    (progn
      (setq pts (list first) p first done nil)
      (while (not done)
        (initget "Close")
        (setq q (getpoint p "\nDinh tiep theo [Close] <dong kin>: "))
        (cond
          ((or (null q) (= (type q) 'STR)) (setq done T))
          ((and (>= (length pts) 3) (equal q first 0.001)) (setq done T))
          ((equal p q 0.001) (princ "\nDinh trung: chon diem khac."))
          (T (grdraw p q 7 1) (setq pts (append pts (list q)) p q))))
      (setq pts (mapcar '(lambda (x) (trans x 1 0)) pts))
      (cond
        ((not (QS-BTBaoPointsOK pts))
         (princ "\n[BT] Bao can >= 3 dinh, khong tu cat, dien tich > 0."))
        ((vl-some '(lambda (x) (> (abs (caddr x)) 0.001)) pts)
         (princ "\n[BT] Chi ho tro bao tren mat phang WCS XY, Z=0."))
        (T
         (QS-DamBaoLayer "Defpoints" 7)
         (setq ed (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                  '(8 . "Defpoints") '(100 . "AcDbPolyline")
                  (cons 90 (length pts)) '(70 . 1)))
         (foreach p pts (setq ed (append ed (list (cons 10 (list (car p) (cadr p)))))))
         (if (entmake ed) (setq e (entlast)))))))
  (redraw)
  e
)

(defun QS-GroupBaoBT (bar tag rai bao / members e ed grp arr name result)
  (setq members (list bar bao))
  (if rai
    (progn
      (setq members (append members (list rai)) e (entnext rai))
      (if (and e (= (cdr (assoc 0 (setq ed (entget e)))) "CIRCLE")
               (member (cdr (assoc 8 ed)) '("QS_Symbol" "DCE_Symbol")))
        (setq members (append members (list e))))))
  (setq name (strcat "QS_BT_" (cdr (assoc 5 (entget bao)))))
  (setq result (vl-catch-all-apply 'vla-Add
                 (list (vla-get-Groups (QS-Doc)) name)))
  (if (vl-catch-all-error-p result)
    (princ (strcat "\n[BT] Khong tao duoc Group: " (vl-catch-all-error-message result)))
    (progn
      (setq grp result arr (vlax-make-safearray vlax-vbObject (cons 0 (1- (length members)))))
      (vlax-safearray-fill arr (mapcar 'vlax-ename->vla-object members))
      (setq result (vl-catch-all-apply 'vla-AppendItems (list grp arr)))
      (if (vl-catch-all-error-p result)
        (progn (vla-Delete grp) (princ "\n[BT] Them doi tuong vao Group that bai."))
        (progn
                  (princ (strcat "\n[BT] Da tao Group " name " gom " (itoa (length members)) " doi tuong."))
          (princ "\n[BT] Bao + Group da tao; chua tu dong tinh/rai thep theo bao.")))))
  (princ)
)


(defun QS-VTDrawLineTemp (msg lay / p1 p2 e)
  (setq p1 (getpoint (strcat "\n" msg " - diem 1 <Enter bo qua>: ")))
  (if p1
    (progn
      (setq p2 (getpoint p1 "\nDiem 2 <Enter bo qua>: "))
      (if p2
        (progn
          (setq p1 (trans p1 1 0) p2 (trans p2 1 0))
          (if (or (> (abs (caddr p1)) 0.001) (> (abs (caddr p2)) 0.001))
            (QS-VT-Err "Line phai nam tren WCS XY, Z=0."))
          (if (< (distance p1 p2) 0.001) (QS-VT-Err "Hai diem line trung nhau."))
          (QS-DamBaoLayer lay 3)
          (setq e (entmakex (list '(0 . "LINE") (cons 8 lay) (cons 10 p1) (cons 11 p2))))
          (if (null e) (QS-VT-Err "Khong tao duoc line tam."))
          (setq *QS-VT-TEMP* (cons e *QS-VT-TEMP*))
          (list p1 p2 e))))))


(defun QS-VTShiftPts (pts v d / )
  (mapcar '(lambda (p) (list (+ (car p) (* d (car v))) (+ (cadr p) (* d (cadr v))))) pts))
(defun QS-VTCleanupBeams (/ e) (foreach e (if (boundp (quote *QS-VT-TEMP*)) *QS-VT-TEMP* nil) (if (and e (entget e)) (vl-catch-all-apply (function entdel) (list e)))) (setq *QS-VT-TEMP* nil) (princ))
(defun QS-VTBeamPick (label / beam)
  (princ (strcat "\n" label))
  (setq beam (QS-VTDrawLineTemp "Ve LINE do dam song song thep" "QS_BeamMeas"))
  (if beam (list (car beam) (cadr beam) (caddr beam))))

(defun QS-VTEndPlan (p near beam neo cover kemin up / u a b width base usable h la nn oldA oldB)
  (if (null beam) (list p nil)
    (progn
      (setq u (QS-DVi near p))
      (if (null u) (QS-VT-Err "Doan dau/cuoi thanh co chieu dai bang 0."))
      (setq a (+ (* (- (caar beam) (car p)) (car u))
                 (* (- (cadar beam) (cadr p)) (cadr u)))
            b (+ (* (- (caadr beam) (car p)) (car u))
                 (* (- (cadadr beam) (cadr p)) (cadr u))))
      (if (> a b) (progn (setq oldA a oldB b a oldB b oldA)))
      (setq width (- b a))
      (if (<= width 1e-6) (QS-VT-Err "Line do dam co 2 dau trung nhau."))
      (if (<= (- width cover) 1e-6) (QS-VT-Err "Be rong dam tru bao ve khong du neo."))
      (setq base (list (+ (car p) (* a (car u))) (+ (cadr p) (* a (cadr u))))
            usable (- width cover)
            h (max kemin (- neo usable) 0.0)
            la (max 0.0 (min usable (- neo h)))
            base (list (+ (car base) (* la (car u))) (+ (cadr base) (* la (cadr u))))
            nn (list (- (cadr u)) (car u)))
      (if (or (< (cadr nn) -1e-8) (and (< (abs (cadr nn)) 1e-8) (< (car nn) 0.0)))
        (setq nn (mapcar '- nn)))
      (if (not up) (setq nn (mapcar '- nn)))
      (list base (if (> h 1e-8)
        (list (+ (car base) (* h (car nn))) (+ (cadr base) (* h (cadr nn)))))))))

(defun QS-VTZoneEnd (p near zone offset / u w hit)
  (setq u (QS-DVi near p) w (QS-DVi (car zone) (cadr zone)))
  (if (or (null u) (null w)) (QS-VT-Err "Truc thep/line zone khong hop le."))
  (if (< (abs (- (* (car u) (cadr w)) (* (cadr u) (car w)))) 1.0e-6)
    (QS-VT-Err "Line zone song song truc thep, khong co giao duy nhat."))
  (if (> (abs (+ (* (car u) (car w)) (* (cadr u) (cadr w)))) 0.5)
    (princ "\n[CANH BAO] Line zone khong vuong goc thep; van dung giao hinh hoc."))
  (setq hit (inters (list (car near) (cadr near)) (list (car p) (cadr p))
                    (list (caar zone) (cadar zone)) (list (caadr zone) (cadadr zone)) nil))
  (if (null hit) (QS-VT-Err "Khong tim duoc giao truc thep / zone."))
  (list (list (+ (car hit) (* offset (car u))) (+ (cadr hit) (* offset (cadr u)))) nil))

(defun QS-VTResolvePoints (pts b1 b2 z1 z2 neo cover kemin up offset / a b out u)
  (if (< (length pts) 2) (QS-VT-Err "Can it nhat hai diem thep."))
  (setq a (if z1 (QS-VTZoneEnd (car pts) (cadr pts) z1 offset)
                (QS-VTEndPlan (car pts) (cadr pts) b1 neo cover kemin up))
        b (if z2 (QS-VTZoneEnd (last pts) (nth (- (length pts) 2) pts) z2 offset)
                (QS-VTEndPlan (last pts) (nth (- (length pts) 2) pts) b2 neo cover kemin up)))
  (if (= (length pts) 2)
    (progn
      (setq u (QS-DVi (car pts) (cadr pts)))
      (if (or (null u) (<= (+ (* (- (caar b) (caar a)) (car u))
                               (* (- (cadar b) (cadar a)) (cadr u))) 0.001))
        (QS-VT-Err "L1 lam hai dau thep trung nhau hoac dao chieu."))))
  (setq out (append (list (car a)) (QS-LayDoan pts 1 (1- (length pts))) (list (car b))))
  (if (cadr a) (setq out (cons (cadr a) out)))
  (if (cadr b) (setq out (append out (list (cadr b)))))
  out)

(defun QS-VTNeoInput (pts dia / b1 b2 z1 z2 neo cover kemin offset)
  (setq neo (* dia (if (QS-Num *QS4-NEO*) (QS-Num *QS4-NEO*) 40.0))
        cover (if (QS-Num *QS4-BV*) (QS-Num *QS4-BV*) 25.0)
        kemin (if (QS-Num *QS4-BEKE*) (QS-Num *QS4-BEKE*) 0.0)
        offset (if (QS-Num *QS1-ZONEL1*) (QS-Num *QS1-ZONEL1*) 0.0))
  (if (= *QS1-NEOON* "1") (setq b1 (QS-VTBeamPick "DAM DAU THANH")))
  (if (= *QS1-ZONEON* "1") (setq z1 (QS-VTDrawLineTemp "Ve LINE ZONE DAU THANH" "QS_ZoneMeas")))
  (if (= *QS1-NEOON* "1") (setq b2 (QS-VTBeamPick "DAM CUOI THANH")))
  (if (= *QS1-ZONEON* "1") (setq z2 (QS-VTDrawLineTemp "Ve LINE ZONE CUOI THANH" "QS_ZoneMeas")))
  (QS-VTResolvePoints pts b1 b2 z1 z2 neo cover kemin (/= *QS1-KEUP* "0") offset))

(defun QS-VT-Err (msg) (princ (strcat "\n[Loi] " msg)) (exit))
(defun QS-S22Plan (pts ctl r1 r2 step l1 l2 / u v span count i delta base geom out)
  (if (/= (length pts) 2) (QS-VT-Err "So le: thanh mau phai la doan thang 2 diem."))
  (setq u (QS-DVi (car pts) (cadr pts)) v (QS-DVi r1 r2))
  (if (or (null u) (null v) (<= step 0.0)) (QS-VT-Err "Thanh/duong rai/buoc a khong hop le."))
  (if (> (abs (+ (* (car u) (car v)) (* (cadr u) (cadr v)))) 0.001)
    (QS-VT-Err "Duong rai phai vuong goc thanh mau."))
  (setq span (distance r1 r2) count (1+ (fix (+ 1e-7 (/ span step)))))
  (if (or (< count 2) (> count 1000)) (QS-VT-Err "So le can tu 2 den 1000 thanh."))
  (setq delta (+ (* (- (car r1) (caar pts)) (car v)) (* (- (cadr r1) (cadar pts)) (cadr v))) i 0)
  (repeat count
    (setq base (QS-VTShiftPts pts v (+ delta (* i step))))
    (setq geom (apply 'QS-VTResolvePoints
      (append (list base) ctl (list (if (= (rem i 2) 0) l1 l2)))))
    (setq out (cons (list i geom (QS-Them r1 v (* i step))) out) i (1+ i)))
  (reverse out))

(defun QS-S22Write (e strings / data)
  (regapp "QS_BT_V3")
  (setq data (mapcar '(lambda (x) (cons 1000 x)) strings))
  (if (null (entmod (append (entget e) (list (list -3 (cons "QS_BT_V3" data))))))
    (QS-VT-Err "Khong ghi duoc QS_BT_V3.")))


(defun QS-S23Read (e / xd)
  (setq xd (assoc -3 (entget e '("QS_BT_V3"))))
  (if xd (mapcar 'cdr (cdr (cadr xd)))))

(defun QS-S23Envelope (plan / left right row pts e ed p u0 v0 a b rs)
  (if (< (length plan) 2) (QS-VT-Err "Bao can it nhat 2 thanh."))
  ;; v1.0.0: mep trai / phai theo 1 huong chung (thanh cat nguoc chieu van dung), sap theo tram
  (setq u0 (QS-V3HuongChuan (cadr (car plan))) v0 (list (- (cadr u0)) (car u0)))
  (foreach row plan
    (setq a (car (cadr row)) b (last (cadr row)))
    (if (> (QS-B2Dot a u0) (QS-B2Dot b u0)) (setq p a a b b p))
    (setq rs (cons (list (QS-B2Dot a v0) a b) rs)))
  (setq rs (vl-sort rs '(lambda (x y) (< (car x) (car y)))))
  (if *QS-V3-BAOTHANG*
    ;; v1.0.0: nhom SAU CAT -> bao 4 dinh, moi mep la 1 duong thang (qua thanh dau / cuoi, day ra
    ;; ngoai phu het dau thanh) -> thanh bi dich moi noi khong lam bao gay khuc / "<"
    (progn
      (setq left (QS-V3CanhThang (mapcar '(lambda (r) (list (car r) (QS-B2Dot (cadr r) u0))) rs) 1.0)
            right (QS-V3CanhThang (mapcar '(lambda (r) (list (car r) (QS-B2Dot (caddr r) u0))) rs) -1.0)
            a (car (car rs)) b (car (last rs)))
      (setq pts (list (QS-V3DiemST a (car left) u0 v0) (QS-V3DiemST b (cadr left) u0 v0)
                      (QS-V3DiemST b (cadr right) u0 v0) (QS-V3DiemST a (car right) u0 v0))))
    (progn
      (foreach r rs (setq left (cons (cadr r) left) right (cons (caddr r) right)))
      (setq pts (append (reverse left) right))))
  (setq pts (mapcar '(lambda (p) (list (car p) (cadr p))) pts))
  (QS-DamBaoLayer "Defpoints" 7)
  (setq e (QS-VePts pts "Defpoints"))
  (if (null e) (QS-VT-Err "Khong tao duoc bao bien thien."))
  (setq ed (entget e))
  (if (null (entmod (subst '(70 . 1) (assoc 70 ed) ed)))
    (QS-VT-Err "Khong dong kin duoc bao bien thien."))
  e)


;; v1.0.0: 1 mep bao = duong thang qua diem dau / cuoi, tinh tien ra ngoai phu het cac diem.
;; ps = ((s t) ...) sap theo s; sg 1 = mep t nho, -1 = mep t lon -> (tDau tCuoi)
(defun QS-V3CanhThang (ps sg / a z k d dm p)
  (setq a (car ps) z (last ps) dm 0.0
        k (if (> (abs (- (car z) (car a))) 1.0e-9) (/ (- (cadr z) (cadr a)) (- (car z) (car a))) 0.0))
  (foreach p ps
    (setq d (- (cadr p) (+ (cadr a) (* k (- (car p) (car a))))))
    (if (< (* sg d) (* sg dm)) (setq dm d)))
  (list (+ (cadr a) dm) (+ (cadr z) dm)))

(defun QS-V3DiemST (s tt u0 v0)
  (list (+ (* tt (car u0)) (* s (car v0))) (+ (* tt (cadr u0)) (* s (cadr v0)))))

(defun QS-V3Attach32 (rows bars bar tag rai members step l1 l2 parity / lens gid data index row rec p envelope rootHandle entity groups grp arr)
  (setq lens (mapcar '(lambda (r) (QS-DaiPts (cadr r))) rows) gid (cdr (assoc 5 (entget tag))))
  ;; dev47: TRUOC DAY chi lap nhom V3 khi chieu dai cac thanh KHAC nhau
  ;; (> 0.01mm) - nen phuong dung/ngang (cac thanh dai bang nhau) khong
  ;; duoc gop: moi thanh 1 nhom, ve het tung thanh va tag chong nhau.
  ;; Gio lap nhom cho MOI chuoi tu 2 thanh tro len, khong phan biet co
  ;; bien thien hay khong.
  (if (>= (length rows) 2)
      (progn
        (setq data (list (strcat "V3;1;SOLE;" gid ";" (itoa parity) ";" (itoa (length rows))
          ";" (rtos step 2 6) ";" (rtos l1 2 6) ";" (rtos l2 2 6))))
        (setq index 0)
        (foreach row rows
          (setq rec (strcat "BAR;" (itoa (car row)) ";" (cdr (assoc 5 (entget (nth index bars))))))
          (foreach p (cadr row) (setq rec (strcat rec ";" (rtos (car p) 2 8) "," (rtos (cadr p) 2 8))))
          (setq data (append data (QS-ChiaChuoi rec 240)))
          (QS-S22Write (nth index bars) (list (strcat "V3;1;BAR;" gid ";" (itoa (car row)))))
          (setq index (1+ index)))
        (QS-S22Write tag data)
        (if rai (QS-S22Write rai (list (strcat "V3;1;RAI;" gid))))
        (setq envelope (QS-S23Envelope rows) members (cons envelope members)
              rootHandle (cdr (assoc 5 (entget envelope))))
        (foreach entity members
          (setq data (QS-S23Read entity))
          (QS-S22Write entity
            (append (if data data (list (strcat "V3;1;MARK;" rootHandle)))
                    (list (strcat "ROOT;" rootHandle)))))
        (setq data (list (strcat "V3;1;ROOT;" rootHandle)
          (strcat "ENVELOPE;DISPLAY_ONLY;" rootHandle)
          (strcat "PARAM;" (rtos step 2 8) ";" (rtos l1 2 8) ";" (rtos l2 2 8))
          (strcat "TAG;" gid)))
        (foreach entity members
          (setq data (append data (list (strcat "MEMBER;" (cdr (assoc 5 (entget entity))))))))
        (setq groups (vla-get-Groups (QS-Doc))
              grp (vla-Add groups (strcat "QS_BT_V3_" gid))
              *QS-S22-GROUP* grp
              *QS-S24-GROUPS* (cons grp *QS-S24-GROUPS*)
              arr (vlax-make-safearray vlax-vbObject (cons 0 (1- (length members)))))
        (vlax-safearray-fill arr (mapcar 'vlax-ename->vla-object members))
        (vla-AppendItems grp arr)
        (QS-S22Write envelope (append data (list (strcat "GROUP;" (vla-get-Name grp)))))
        (foreach entity bars
          (vla-put-Visible (vlax-ename->vla-object entity)
            (if (equal entity bar) :vlax-true :vlax-false)))))
  envelope)

(defun QS-S22Draw (plan step l1 l2 dia sh mck lap ty rnd / spc parity rows row bars bar lens pt text tag rai before after members groups arr grp gid data index p rec tags olddim oldecho envelope root rootHandle entity item link ptsData repIndex repRow)
  (setq spc (QS-Space (QS-Doc)) olddim (getvar "DIMSTYLE") oldecho (getvar "CMDECHO"))
  (QS-DamBaoLayer "QS_ThepChu" 1) (QS-DamBaoLayer "QS_Block" 7)
  (QS-DamBaoLayer "QS_Symbol" 8) (QS-TaoBlockTag)
  (QS-ChuanBiRaiStyle (* 2.5 ty) "F")
  (foreach parity '(0 1)
    (setq rows (vl-remove-if-not '(lambda (x) (= (rem (car x) 2) parity)) plan)
          bars nil lens nil members nil)
    (foreach row rows
      (setq bar (QS-VePts (cadr row) "QS_ThepChu"))
      (if (null bar) (QS-VT-Err "Khong ve duoc thanh so le."))
      (setq bars (cons bar bars) members (cons bar members)
            lens (cons (QS-DaiPts (cadr row)) lens)))
    (setq bars (reverse bars) repIndex (fix (/ (1- (length rows)) 2.0))
          repRow (nth repIndex rows) bar (nth repIndex bars)
          pt (QS-GiuaDoanDai (QS-DinhDuong bar)))
    (setq text (strcat (itoa (length rows)) "%%c" dia "a" (rtos (* 2 step) 2 0)
      " (L=" (QS-ChuoiChieuDai (apply 'min lens) (apply 'max lens) rnd) ")"))
    (setq tag (vlax-vla-object->ename (QS-ChenTagThep spc pt ty text
      (strcat sh "." (itoa (1+ parity))) "" (QS-GocDoc (QS-HuongPts (cadar rows))))))
    (setq members (cons tag members) tags (cons tag tags) rai nil)
    (if (> (length rows) 1)
      (progn
        (setq before (entlast))
        (setq rai (QS-VeDuongRai spc (nth 2 (car rows)) (nth 2 (last rows)) (nth 2 repRow) (* 2.5 ty)))
        (if (null rai) (QS-VT-Err "Khong ve duoc duong rai so le."))
        (setq after (entnext before))
        (while after (if (member (cdr (assoc 0 (entget after))) '("DIMENSION" "CIRCLE")) (setq members (cons after members))) (setq after (entnext after)))))
    (setq gid (cdr (assoc 5 (entget tag))))
    (QS-GanBoLienKet bar tag rai mck (strcat sh "." (itoa (1+ parity)))
      (strcat sh "." (itoa (1+ parity))) dia lap (* 2 step) (length rows) "")
    (foreach entity bars
      (QS-GanXDThep entity mck (strcat sh "." (itoa (1+ parity))) dia lap
        (if rai (QS-TachFieldXData (QS-DocXDataTho rai) 2) "") (* 2 step))
      (if rai (QS-GanLinkRai entity (cdr (assoc 5 (entget rai))))))
    (QS-V3Attach32 rows bars bar tag rai members step l1 l2 parity))
  (command "_.-DIMSTYLE" "_R" olddim)
  (setvar "CMDECHO" oldecho)
  (reverse tags))

(defun QS-S28Clip (polygon u v s / prev p sa sb ta tb hits ratio)
  (setq prev (last polygon))
  (foreach p polygon
    (setq sa (QS-B2Dot prev v) sb (QS-B2Dot p v)
          ta (QS-B2Dot prev u) tb (QS-B2Dot p u))
    (if (or (and (<= sa s) (> sb s)) (and (<= sb s) (> sa s)))
      (progn
        (setq ratio (/ (- s sa) (- sb sa)))
        (setq hits (cons (+ ta (* ratio (- tb ta))) hits))))
    (setq prev p))
  (QS-TsToKhoang (QS-Sap hits '<)))


(defun QS-S30InsetInterval (polygon u v pos cover iv / area prev q orient edge n cross rhs slope bound lo hi ok)
  (setq area 0.0 prev (last polygon))
  (foreach q polygon
    (setq area (+ area (- (* (car prev) (cadr q)) (* (car q) (cadr prev)))))
    (setq prev q))
  (setq orient (if (> area 0.0) 1.0 -1.0) prev (last polygon)
        lo (car iv) hi (cadr iv) ok T)
  (foreach q polygon
    (setq edge (QS-DVi prev q))
    (if edge
      (progn
        (setq n (list (* orient (- (cadr edge))) (* orient (car edge))))
        (foreach bound polygon
          (if (< (- (QS-B2Dot bound n) (QS-B2Dot prev n)) -0.001)
            (QS-VT-Err "Bao bi lom: hay chia thanh cac bao loi truoc khi tinh bao ve vuong goc.")))
        (setq rhs (- (+ cover (QS-B2Dot prev n)) (* pos (QS-B2Dot v n)))
              slope (QS-B2Dot u n))
        (cond
          ((< (abs slope) 1e-10) (if (> rhs 1e-7) (setq ok nil)))
          ((> slope 0.0) (setq lo (max lo (/ rhs slope))))
          (T (setq hi (min hi (/ rhs slope)))))))
    (setq prev q))
  (if (and ok (> (- hi lo) 0.001)) (list lo hi)))

(defun QS-S28Plan (pts ctl r1 r2 step l1 l2 bao edge / u v polygon projections low high count i s cuts iv base geom out cover covU covL covR)
  (setq u (QS-DVi (car pts) (cadr pts)) v (QS-DVi r1 r2))
  (if (or (/= (length pts) 2) (null u) (null v) (<= step 0.0) (< edge 0.0))
    (QS-VT-Err "Thong so bao / so le khong hop le."))
  (if (> (abs (QS-B2Dot u v)) 0.001) (QS-VT-Err "Duong rai phai vuong goc thep."))
  (setq polygon (QS-DinhDuong bao))
  (if (or (/= (cdr (assoc 0 (entget bao))) "LWPOLYLINE")
          (= 0 (logand 1 (cdr (assoc 70 (entget bao)))))
          (not (QS-BTBaoPointsOK polygon))
          (vl-some '(lambda (x) (and (= (car x) 42) (/= (cdr x) 0.0))) (entget bao)))
    (QS-VT-Err "Bao phai kin, canh thang, khong tu cat."))
  (setq projections (mapcar '(lambda (p) (QS-B2Dot p v)) polygon)
        low (+ (apply 'min projections) edge) high (- (apply 'max projections) edge)
        cover (nth 5 ctl) i 0)
  (setq count (1+ (fix (+ 1e-7 (/ (- high low) step)))))
  (if (or (< count 2) (> count 1000)) (QS-VT-Err "Bao can 2..1000 vi tri rai."))
  (repeat count
    (setq s (+ low (* i step)) cuts (QS-S28Clip polygon u v s))
    (if (/= (length cuts) 1) (QS-VT-Err "Bao bi tach nhieu khoang tai mot thanh; hay chia bao."))
    (setq iv (car cuts))
    (if (<= (- (cadr iv) (car iv)) (* 2 cover))
      (QS-VT-Err "Goc bao qua hep so voi bao ve; chinh pham vi/bao truoc khi ve."))
    (setq covU nil)
    (if (or (not (or (nth 0 ctl) (nth 2 ctl))) (not (or (nth 1 ctl) (nth 3 ctl))))
      (progn
        (setq covU (QS-S30InsetInterval polygon u v s cover iv))
        (if (null covU) (QS-VT-Err "Khong du cho bao ve tai goc bao; can dieu chinh pham vi rai."))))
    (setq base (list
      (QS-Pt u v s (if (or (nth 0 ctl) (nth 2 ctl)) (car iv) (car covU)))
      (QS-Pt u v s (if (or (nth 1 ctl) (nth 3 ctl)) (cadr iv) (cadr covU)))))
    (setq geom (apply 'QS-VTResolvePoints (append (list base) ctl (list (if (= (rem i 2) 0) l1 l2)))))
    (setq out (cons (list i geom (QS-Pt u v s (QS-B2Dot r1 u))) out) i (1+ i)))
  (reverse out))

(defun QS-S22Run (pts dia spacing sh mck lap ty rnd / b1 b2 z1 z2 r1 r2 neo cover kemin ctl plan bao edge)
  (setq *QS-S22-MARK* (entlast) *QS-S22-DIM* (getvar "DIMSTYLE") *QS-S22-ECHO* (getvar "CMDECHO"))
  (if (/= (length pts) 2) (QS-VT-Err "So le hien chi ho tro thanh mau thang 2 diem."))
  (if (= *QS1-NEOON* "1") (setq b1 (QS-VTBeamPick "DAM DAU THANH")))
  (if (= *QS1-ZONEON* "1") (setq z1 (QS-VTDrawLineTemp "Ve LINE ZONE DAU" "QS_ZoneMeas")))
  (if (= *QS1-NEOON* "1") (setq b2 (QS-VTBeamPick "DAM CUOI THANH")))
  (if (= *QS1-ZONEON* "1") (setq z2 (QS-VTDrawLineTemp "Ve LINE ZONE CUOI" "QS_ZoneMeas")))
  (setq r1 (getpoint "\nVi tri dau duong rai so le: "))
  (if (null r1) (QS-VT-Err "Huy duong rai."))
  (setq r2 (getpoint r1 "\nVi tri cuoi duong rai so le: "))
  (if (null r2) (QS-VT-Err "Huy duong rai."))
  (setq r1 (trans r1 1 0) r2 (trans r2 1 0))
  (if (or (> (abs (caddr r1)) 0.001) (> (abs (caddr r2)) 0.001)) (QS-VT-Err "Duong rai phai o Z=0."))
  (setq neo (* (QS-Num dia) (if (QS-Num *QS4-NEO*) (QS-Num *QS4-NEO*) 40.0))
    cover (if (QS-Num *QS4-BV*) (QS-Num *QS4-BV*) 25.0)
    kemin (if (QS-Num *QS4-BEKE*) (QS-Num *QS4-BEKE*) 0.0)
    ctl (list b1 b2 z1 z2 neo cover kemin (/= *QS1-KEUP* "0")))
  (if (= *QS1-BTVUNG* "1")
    (progn
      (setq bao (QS-PickBaoBT))
      (if (null bao) (QS-VT-Err "Huy bao bien thien."))
      (setq *QS-VT-TEMP* (cons bao *QS-VT-TEMP*) edge 50.0)
      (setq plan (QS-S28Plan pts ctl r1 r2 (QS-Num spacing)
        (QS-Num *QS1-ZONEL1*) (QS-Num *QS1-ZONEL2*) bao edge)))
    (setq plan (QS-S22Plan pts ctl r1 r2 (QS-Num spacing) (QS-Num *QS1-ZONEL1*) (QS-Num *QS1-ZONEL2*))))
  (QS-S22Draw plan (QS-Num spacing) (QS-Num *QS1-ZONEL1*) (QS-Num *QS1-ZONEL2*) dia sh mck lap ty rnd)
  (setq *QS-S22-MARK* nil *QS-S22-GROUP* nil *QS-S24-GROUPS* nil)
  (princ (strcat "\n[SO LE] Da ve " (itoa (length plan)) " thanh that; 2 tag va 2 nhom buoc 2a. L1/L2 chi ap tai zone.")))

(defun QS-S22Rollback (/ e next g)
  (foreach g *QS-S24-GROUPS* (vl-catch-all-apply 'vla-Delete (list g)))
  (setq *QS-S24-GROUPS* nil)
  (if *QS-S22-GROUP* (vl-catch-all-apply 'vla-Delete (list *QS-S22-GROUP*)))
  (if *QS-S22-MARK*
    (progn
      (setq e (entnext *QS-S22-MARK*))
      (while e (setq next (entnext e)) (entdel e) (setq e next))))
  (if *QS-S22-ECHO* (setvar "CMDECHO" *QS-S22-ECHO*))
  (if (and *QS-S22-DIM* (tblsearch "DIMSTYLE" *QS-S22-DIM*))
    (vl-catch-all-apply
      '(lambda ( / d)
         (setq d (QS-Doc))
         (vla-put-ActiveDimStyle d (vla-Item (vla-get-DimStyles d) *QS-S22-DIM*)))))
  (princ))

(defun c:OS_VETHEP ( / *error* doc spc blkName dclId
                          soNhanh dia spacing chieuCao buocLamTron
                          shVal viTriVal maCauKien soLop tyle
                          pts pt idx n p eLst plEnt plObj midPt
                          totalLen totalLenLT insObj attList a dkvakcStr
                          tagEnt hdlPl hdlTag kqDim
                          coRai pR1 pR2 aKC Lrai snRai wv ttB ptB raiEnt
                          maMT olddim oldecho *QS-DIMTHEOHUONG* baoBT *QS-VT-TEMP* *QS-S22-MARK* *QS-S22-GROUP* *QS-S22-DIM* *QS-S22-ECHO* *QS-S24-GROUPS*)

  (defun *error* (msg)
    (QS-DongDCL)
    (QS-S22Rollback)
    (QS-VTCleanupBeams)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (setq blkName "Dce_KhtThepDai2")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)

  (QS-DamBaoLayer "QS_ThepChu" 1)
  (QS-DamBaoLayer "QS_Block"   7)
  (QS-TaoBlockTag)

  (if (QS-CanGiuaSH-Block blkName)
    (princ "\n[OK] Da can lai so hieu (SH) vao giua vong tron trong dinh nghia block.")
  )

  (if (not (tblsearch "BLOCK" blkName))
    (progn
      (princ (strcat "\n[Loi] Khong tim thay block \"" blkName "\" trong ban ve nay."))
      (princ "\nHay dung lenh 'Tao TKT' cua DBim Apps 1 lan de tao block truoc.")
    )
    (progn

      (setq *QS1-SN* nil *QS1-MAU* nil *QS1-TK* nil)
      (setq dclId (QS-NapDCL))
      (if (not dclId)
        (princ "\n[Loi] Khong nap duoc giao dien.")
        (progn
          (if (not (new_dialog "qs_vethepdce" dclId))
            (princ "\n[Loi] Khong khoi tao duoc dialog qs_vethepdce.")
            (progn
              (set_tile "sonhanh"     (if *QSL-SN*  *QSL-SN*  "1"))
              (set_tile "duongkinh"   (if *QSL-DK*  *QSL-DK*  ""))
              (set_tile "khoangcach"  (if *QSL-KC*  *QSL-KC*  ""))
              (set_tile "tyle1"       (if *QSL-TL*  *QSL-TL*  "100"))
              (set_tile "buoclamtron" (if *QSL-BT*  *QSL-BT*  "1"))
              (set_tile "sh"          (if *QSL-SH*  *QSL-SH*  ""))
              (set_tile "vitri"       (if *QSL-VT*  *QSL-VT*  ""))
              (set_tile "macauKien"   (if *QSL-MCK* *QSL-MCK* ""))
              (set_tile "solop"       (if *QSL-SL*  *QSL-SL*  "1"))
              (set_tile "dimdoan"     (if *QSL-DIM* *QSL-DIM* "0"))
              (set_tile "dimrai"      (if *QSL-DRAI* *QSL-DRAI* "0"))
              (set_tile "bt_vung" (if *QS1-BTVUNG* *QS1-BTVUNG* "0"))
              (set_tile "vtneo" (if *QS1-NEOON* *QS1-NEOON* "1"))
              (set_tile "vtkeup" (if *QS1-KEUP* *QS1-KEUP* "1"))
              (set_tile "vtzone" (if *QS1-ZONEON* *QS1-ZONEON* "0"))
              (set_tile "vtl1" (if *QS1-ZONEL1* *QS1-ZONEL1* "0"))
              (set_tile "vtsole" (if *QS1-SOLE* *QS1-SOLE* "0"))
              (set_tile "vtl2" (if *QS1-ZONEL2* *QS1-ZONEL2* "0"))
              (set_tile "ghichu" "De trong khoang cach neu la thep chu (khong rai).")

              (set_tile "preview"
                (strcat (if *QSL-SN* *QSL-SN* "1") "%%c"
                        (if (and *QSL-DK* (/= *QSL-DK* "")) *QSL-DK* "??")
                        (if (and *QSL-KC* (/= *QSL-KC* "")) (strcat "a" *QSL-KC*) "")
                        "   (L = tu dong theo hinh hoc)"))
              (action_tile "btmau" "(setq *QS1-MAU* T)(done_dialog 5)")
              (action_tile "bttk" "(QS-DocTK)(done_dialog 6)")
              (action_tile "accept" "(QS-Accept1)")
              (action_tile "cancel" "(done_dialog 0)")
              (progn (QS-PJInit "qs_vethepdce") (start_dialog))
            )
          )
          (QS-DongDCL)
        )
      )

      (if *QS1-MAU* (QS-VeTheoMau))
      (if *QS1-TK* (QS-VeTheoTK))

      (if (or *QS1-MAU* *QS1-TK* (not *QS1-SN*))
        (if (not (or *QS1-MAU* *QS1-TK*)) (princ "\nDa huy lenh."))
        (progn
          (setq soNhanh *QS1-SN*  dia *QS1-DK*  spacing *QS1-KC*
                chieuCao *QS1-CC* buocLamTron (fix (QS-Num *QS1-BT*))
                shVal *QS1-SH*    viTriVal *QS1-VT*
                maCauKien *QS1-MCK* soLop *QS1-SL*)

          (setq *QSL-SN* soNhanh *QSL-DK* dia *QSL-KC* spacing
                *QSL-CC* chieuCao *QSL-TL* *QS1-TL* *QSL-BT* *QS1-BT* *QSL-SH* shVal
                *QSL-VT* viTriVal *QSL-MCK* maCauKien *QSL-SL* soLop
                *QSL-DIM* *QS1-DIM* *QSL-DRAI* *QS1-DRAI*)

          (setq tyle (/ (QS-Num chieuCao) 2.5))

          (princ "\nPick diem dau thanh thep: ")
          (setq pt (getpoint))
          (if (not pt)
            (princ "\nHuy lenh - khong co diem nao duoc pick.")
            (progn
              (setq pts (list pt) idx 1)
              (while
                (progn
                  (setq pt (getpoint (car pts)
                             (strcat "\nPick diem tiep theo (Enter de ket thuc), da pick "
                                     (itoa idx) " diem: ")))
                  (if pt
                    (progn
                      (grdraw (car pts) pt 1 1)
                      (setq pts (cons pt pts))
                      (setq idx (1+ idx))))
                  pt
                )
              )
              (setq pts (reverse pts))

              (if (< (length pts) 2)
                (princ "\n[Loi] Can it nhat 2 diem de ve duong thep. Huy lenh.")
                (progn
                  (setq pts (mapcar '(lambda (x) (trans x 1 0)) pts))
                  (if (vl-some '(lambda (x) (> (abs (caddr x)) 0.001)) pts)
                    (QS-VT-Err "Chi ho tro thep tren mat phang WCS XY, Z=0."))
                  (if (= *QS1-SOLE* "1")
                    (QS-S22Run pts dia spacing shVal maCauKien soLop tyle buocLamTron)
                    (progn
                  (if (or (= *QS1-NEOON* "1") (= *QS1-ZONEON* "1")) (setq pts (QS-VTNeoInput pts (QS-Num dia))))
                  (setq n (length pts))
                  (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                                   '(8 . "QS_ThepChu") '(100 . "AcDbPolyline")
                                   (cons 90 n) '(70 . 0)))
                  (foreach p pts
                    (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))

                  (if (not (entmake eLst))
                    (princ "\n[Loi] Khong tao duoc duong thep (kiem tra layer DCE_ThepChu).")
                    (progn
                      (setq plEnt (entlast))
                      (setq plObj (vlax-ename->vla-object plEnt))
                      (setq totalLen (vlax-curve-getDistAtParam
                                       plObj (vlax-curve-getEndParam plObj)))
                      (setq totalLenLT (QS-LamTron totalLen buocLamTron))

                      (setq midPt (QS-GiuaDoanDai (QS-DinhDuong plEnt)))
                      (if (null midPt)
                        (setq midPt (vlax-curve-getPointAtDist plObj
                                      (/ totalLen 2.0))))

                      (setq aKC (if (/= spacing "") (QS-Num spacing) nil))
                      (setq coRai (and (= *QS1-DRAI* "1") aKC (> aKC 0.0)))
                      (if coRai
                        (progn
                          (setq pR1 (getpoint "\nPick diem DAU duong rai thep: "))
                          (if pR1
                            (setq pR2 (getpoint pR1 "\nPick diem CUOI duong rai thep: ")))
                          (if (and pR1 pR2 (> (distance pR1 pR2) 1.0))
                            (progn
                              (setq Lrai (distance pR1 pR2))
                              (setq snRai (1+ (fix (+ 0.5 (/ Lrai aKC)))))
                              (if (< snRai 1) (setq snRai 1))
                              (setq soNhanh (itoa snRai))
                            )
                            (progn
                              (setq coRai nil)
                              (princ "\n   [Bo qua] Chua pick du 2 diem duong rai."))
                          )
                        )
                      )

                      (setq spc (QS-Space doc))
                      (setq insObj
                        (vla-InsertBlock spc
                          (vlax-3d-point (car midPt) (cadr midPt) 0.0)
                          blkName tyle tyle tyle
                          (QS-GocDoc (QS-HuongPts (QS-DinhDuong plEnt)))))
                      (vla-put-Layer insObj "QS_Block")

                      (setq dkvakcStr (strcat soNhanh "%%c" dia))
                      (if (/= spacing "") (setq dkvakcStr (strcat dkvakcStr "a" spacing)))
                      (setq dkvakcStr (strcat dkvakcStr " (L=" (itoa totalLenLT) ")"))

                      (setq attList (vlax-invoke insObj 'GetAttributes))
                      (foreach a attList
                        (cond
                          ((= (strcase (vla-get-TagString a)) "DKVAKC")
                           (vla-put-TextString a dkvakcStr))
                          ((= (strcase (vla-get-TagString a)) "SH")
                           (vla-put-TextString a shVal))
                          ((= (strcase (vla-get-TagString a)) "VITRI")
                           (vla-put-TextString a viTriVal))
                        )
                      )
                      (vla-Update insObj)
                      (QS-CanGiuaTagU insObj (list (car midPt) (cadr midPt))
                                      (QS-HuongPts (QS-DinhDuong plEnt)))

                      (setq tagEnt (vlax-vla-object->ename insObj))
                      (setq hdlPl  (cdr (assoc 5 (entget plEnt))))
                      (setq hdlTag (cdr (assoc 5 (entget tagEnt))))
                      (QS-GanXDataThep plEnt  maCauKien shVal dia soLop soNhanh hdlTag)
                      (QS-GanXDataThep tagEnt maCauKien shVal dia soLop soNhanh hdlPl)

                      (if coRai
                        (progn
                          (QS-DamBaoLayer "QS_Symbol" 8)
                          (setq maMT (cond ((= *QS4-MT* "mt_cheo") "O")
                                           ((= *QS4-MT* "mt_cham") "D")
                                           (T "F")))
                          (setq oldecho (getvar "CMDECHO"))
                          (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
                          (setq olddim (getvar "DIMSTYLE"))
                          (QS-ChuanBiRaiStyle (QS-Num chieuCao) maMT)
                          (setq wv (QS-DVi pR1 pR2))
                          (setq ttB (+ (* (- (car midPt) (car pR1)) (car wv))
                                       (* (- (cadr midPt) (cadr pR1)) (cadr wv))))
                          (if (< ttB 0.0) (setq ttB 0.0))
                          (if (> ttB Lrai) (setq ttB Lrai))
                          (setq ptB (list (+ (car pR1) (* ttB (car wv)))
                                          (+ (cadr pR1) (* ttB (cadr wv)))))
                          (setq raiEnt (QS-VeDuongRai spc
                                         (list (car pR1) (cadr pR1))
                                         (list (car pR2) (cadr pR2))
                                         ptB (QS-Num chieuCao)))
                          (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
                            (command "_.-DIMSTYLE" "_R" olddim))
                          (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
                          (if raiEnt
                            (QS-GanBoLienKet plEnt tagEnt raiEnt maCauKien shVal shVal
                                             dia soLop aKC snRai ""))
                        )
                      )

                      (if (= *QS1-BTVUNG* "1")
                        (progn
                          (setq baoBT (QS-PickBaoBT))
                          (if baoBT
                            (QS-GroupBaoBT plEnt tagEnt raiEnt baoBT)
                            (princ "\n[BT] Khong tao bao; giu nguyen thanh thep thuong."))))

                      (princ "\n\n[OK] Da ve thanh thep moi:")
                      (princ (strcat "\n   Chieu dai hinh hoc      : " (rtos totalLen 2 1) " mm"))
                      (princ (strcat "\n   Chieu dai da lam tron   : " (itoa totalLenLT)
                                     " mm  (buoc=" (itoa buocLamTron) ")"))
                      (princ (strcat "\n   Tag DKVAKC              : " dkvakcStr))
                      (princ (strcat "\n   Ty le ban ve            : 1 : " *QS1-TL*
                                     "   (cao chu " (rtos (* tyle 2.5) 2 1) " mm)"))
                      (if coRai
                        (progn
                          (princ (strcat "\n   Duong rai dai           : " (rtos Lrai 2 0)
                                         " mm, a = " (rtos aKC 2 0)))
                          (princ (strcat "\n   So thanh tu tinh        : " (itoa snRai)
                                         "  (da lien ket tag <-> rai <-> thep)"))
                        )
                      )

                      (if (= *QS1-DIM* "1")
                        (progn
                          (setq *QS-DIMTHEOHUONG* T)
                          (setq kqDim (QS-GhiDimThep (list plEnt) (QS-Num chieuCao)
                                                     buocLamTron 0.0 0.0 nil "F" T))
                          (princ (strcat "\n   Dim tung doan           : " (itoa (car kqDim))
                                         " doan da ghi kich thuoc"))
                        )
                      )
                    )
                  )
                )))
              )
            )
          )
        )
      )
    )
  )
  (QS-VTCleanupBeams)
  (vla-EndUndoMark doc)
  (princ)
)

(defun c:OS_VETHEPDCE ( / ) (c:OS_VETHEP))

(defun c:OS_CAPNHATTHEP ( / *error* doc dclId che_do doCapNhatDai doCapNhatTS
                            newSoNhanh newDia newSpacing buocLamTron
                            ss n i ent etype obj
                            dsDuong dsTag dsKhoa dsCap dsDInfo inf
                            tEnt dEnt hdlT xd2T duongMatch usedDuong
                            ptTag dmin dcur
                            confirmStr soOK soLoi
                            dEntC tEntC dObj tObj totalLen totalLenLT
                            ssR jR mR eR demR tongR
                            attObj oldStr parts headPart lenPart tsOld
                            newHead newStr kq res)

  (defun *error* (msg)
    (QS-DongDCL)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (princ "\n=== OS_CAPNHATTHEP - CAP NHAT NHIEU THANH THEP CUNG LUC ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)

  (setq *QS2-CD* nil)
  (setq dclId (QS-NapDCL))
  (if dclId
    (progn
      (if (not (new_dialog "qs_capnhatthep" dclId))
        (princ "\n[Loi] Khong khoi tao duoc dialog qs_capnhatthep.")
        (progn
          (if (not *QSL-CD*) (setq *QSL-CD* "cd_cahai"))
          (set_tile "chedo" *QSL-CD*)
          (set_tile "newsonhanh" "")
          (set_tile "newduongkinh" "")
          (set_tile "newkhoangcach" "")
          (set_tile "buoclamtron2" (if *QSL-BT2* *QSL-BT2* "1"))
          (set_tile "cnrai"  (if *QSL-RAI* *QSL-RAI* "1"))
          (set_tile "cnlive" (if *QS-RAI-REAC* "1" (if *QSL-LIVE* *QSL-LIVE* "0")))
          (set_tile "ghichu2" "Bam OK roi quet chon cac thanh thep + tag can cap nhat.")
          (QS-ApDungCheDo *QSL-CD*)
          (action_tile "accept" "(QS-Accept2)")
          (action_tile "cancel" "(done_dialog 0)")
          (progn (QS-PJInit "qs_capnhatthep") (start_dialog))
        )
      )
      (QS-DongDCL)
    )
  )

  (if (not *QS2-CD*)
    (princ "\nDa huy lenh.")
    (progn
      (setq che_do     *QS2-CD*
            newSoNhanh *QS2-SN*
            newDia     *QS2-DK*
            newSpacing *QS2-KC*
            buocLamTron (fix (QS-Num *QS2-BT*)))
      (setq *QSL-CD* che_do *QSL-BT2* *QS2-BT*
            *QSL-RAI* *QS2-RAI* *QSL-LIVE* *QS2-LIVE*)

      (if (= *QS2-RAI* "1")
        (progn
          (setq ssR (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol"))))
          (setq jR 0 mR (if ssR (sslength ssR) 0) demR 0 tongR 0)
          (while (< jR mR)
            (setq eR (ssname ssR jR))
            (if (QS-TagCuaRai eR) (setq tongR (1+ tongR)))
            (if (QS-CapNhatMotRai eR) (setq demR (1+ demR)))
            (setq jR (1+ jR)))
          (princ (strcat "\n[DUONG RAI] Xet " (itoa mR) " duong, "
                         (itoa tongR) " duong tim duoc tag, da cap nhat "
                         (itoa demR) " tag."))
        )
      )

      (if (= *QS2-LIVE* "1")
        (progn
          (QS-BoReactorRai)
          (setq ssR (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol"))))
          (setq jR 0 mR (if ssR (sslength ssR) 0) demR 0
                *QS-RAI-REAC* nil *QS-RAI-BUSY* nil)
          (while (< jR mR)
            (setq eR (ssname ssR jR))
            (if (QS-TagCuaRai eR)
              (progn
                (setq *QS-RAI-REAC*
                  (cons (QS-TaoReactor
                          (list (vlax-ename->vla-object eR)) "QSRai"
                          '((:vlr-modified . QS-RaiPhanUng)))
                        *QS-RAI-REAC*))
                (setq demR (1+ demR))))
            (setq jR (1+ jR)))
          (princ (strcat "\n[LIVE] Da BAT tu cap nhat cho " (itoa demR)
                         " duong rai - keo dai duong rai la so thanh tu doi."))
          (princ "\n        (Che do chi con trong PHIEN nay.)")
        )
        (if *QS-RAI-REAC*
          (progn (QS-BoReactorRai)
                 (princ "\n[LIVE] Da TAT che do tu cap nhat khi keo duong rai.")))
      )

      (setq doCapNhatDai (and (member che_do '("cd_daionly" "cd_cahai")) T))
      (setq doCapNhatTS  (and (member che_do '("cd_tsonly"  "cd_cahai")) T))
      (if (not doCapNhatTS)
        (setq newSoNhanh "" newDia "" newSpacing ""))

      (princ "\n\nQuet chon TAT CA duong thep (LINE/POLYLINE) va tag (INSERT) can cap nhat: ")
      (setq ss (ssget '((-4 . "<OR") (0 . "LINE") (0 . "LWPOLYLINE")
                        (0 . "POLYLINE") (0 . "INSERT") (-4 . "OR>"))))

      (if (not ss)
        (princ "\nKhong chon duoc doi tuong nao. Huy lenh.")
        (progn
          (setq n (sslength ss) i 0 dsDuong nil dsTag nil dsKhoa 0)
          (while (< i n)
            (setq ent (ssname ss i))
            (setq etype (cdr (assoc 0 (entget ent))))
            (if (QS-LayerBiKhoa ent)
              (setq dsKhoa (1+ dsKhoa))
              (cond
                ((member etype '("LINE" "LWPOLYLINE" "POLYLINE"))
                 (setq dsDuong (cons ent dsDuong)))
                ((= etype "INSERT")
                 (setq obj (vlax-ename->vla-object ent))
                 (if (QS-LayAttDKVAKC obj) (setq dsTag (cons ent dsTag))))
              )
            )
            (setq i (1+ i))
          )
          (setq dsDuong (reverse dsDuong) dsTag (reverse dsTag))

          (princ (strcat "\nDa nhan dang: " (itoa (length dsDuong)) " duong thep, "
                         (itoa (length dsTag)) " tag thep."))
          (if (> dsKhoa 0)
            (princ (strcat "\n[Canh bao] Bo qua " (itoa dsKhoa)
                           " doi tuong nam tren layer BI KHOA.")))

          (if (or (= (length dsDuong) 0) (= (length dsTag) 0))
            (princ "\n[Loi] Can it nhat 1 duong thep va 1 tag trong tap chon. Huy lenh.")
            (progn

              (setq dsCap nil usedDuong nil)

              (setq dsDInfo nil)
              (foreach dEnt dsDuong
                (setq dsDInfo (cons (list dEnt
                                          (cdr (assoc 5 (entget dEnt)))
                                          (QS-TachFieldXData (QS-DocXDataTho dEnt) 2))
                                    dsDInfo)))
              (setq dsDInfo (reverse dsDInfo))

              (foreach tEnt dsTag
                (setq hdlT (cdr (assoc 5 (entget tEnt))))
                (setq xd2T (QS-TachFieldXData (QS-DocXDataTho tEnt) 2))
                (setq duongMatch nil)
                (foreach inf dsDInfo
                  (if (and (null duongMatch)
                           (not (member (car inf) usedDuong))
                           (or (and (/= xd2T "") (= (cadr inf) xd2T))
                               (and (/= (caddr inf) "") (= (caddr inf) hdlT))))
                    (setq duongMatch (car inf)))
                )
                (if duongMatch
                  (progn
                    (setq dsCap (cons (list tEnt duongMatch "XDATA" 0.0) dsCap))
                    (setq usedDuong (cons duongMatch usedDuong)))
                )
              )

              (foreach tEnt dsTag
                (if (not (assoc tEnt dsCap))
                  (progn
                    (setq ptTag (cdr (assoc 10 (entget tEnt))))
                    (setq duongMatch nil dmin nil)
                    (foreach inf dsDInfo
                      (if (not (member (car inf) usedDuong))
                        (progn
                          (setq dcur (distance ptTag
                                       (vlax-curve-getClosestPointTo (car inf) ptTag)))
                          (if (or (null dmin) (< dcur dmin))
                            (setq dmin dcur duongMatch (car inf)))
                        )
                      )
                    )
                    (if duongMatch
                      (progn
                        (setq dsCap (cons (list tEnt duongMatch "GAN-NHAT" dmin) dsCap))
                        (setq usedDuong (cons duongMatch usedDuong)))
                    )
                  )
                )
              )
              (setq dsCap (reverse dsCap))

              (princ "\n\n--- DANH SACH GHEP CAP (kiem tra ky truoc khi xac nhan) ---")
              (setq i 1)
              (foreach kq dsCap
                (princ (strcat "\n  [" (itoa i) "] Tag " (cdr (assoc 5 (entget (car kq))))
                               "  <->  Duong " (cdr (assoc 5 (entget (cadr kq))))
                               "   (" (caddr kq)
                               (if (= (caddr kq) "GAN-NHAT")
                                 (strcat ", cach " (rtos (cadddr kq) 2 1) " mm") "")
                               ")"))
                (setq i (1+ i))
              )
              (if (< (length dsCap) (length dsTag))
                (princ (strcat "\n\n[Canh bao] Co " (itoa (- (length dsTag) (length dsCap)))
                               " tag khong ghep duoc (thieu duong tuong ung trong tap chon).")))

              (initget "Y N")
              (setq confirmStr (getkword "\n\nXac nhan ghi cap nhat theo danh sach tren? [Y] Co [N] Khong <Y>: "))
              (if (not confirmStr) (setq confirmStr "Y"))

              (if (= confirmStr "N")
                (princ "\nDa huy - khong ghi thay doi nao.")
                (progn
                  (setq soOK 0 soLoi 0)
                  (foreach kq dsCap
                    (setq tEntC (car kq) dEntC (cadr kq))
                    (setq dObj (vlax-ename->vla-object dEntC))
                    (setq tObj (vlax-ename->vla-object tEntC))
                    (setq attObj (QS-LayAttDKVAKC tObj))
                    (if attObj
                      (progn
                        (setq oldStr (vla-get-TextString attObj))
                        (setq parts (QS-TachDKVAKC oldStr))
                        (setq headPart (nth 0 parts) lenPart (nth 1 parts))

                        (if doCapNhatTS
                          (progn
                            (setq tsOld (QS-TachThongSoDau headPart))
                            (setq newHead
                              (strcat (if (/= newSoNhanh "") newSoNhanh (nth 0 tsOld))
                                      "%%c"
                                      (if (/= newDia "") newDia (nth 1 tsOld))))
                            (setq newHead
                              (cond
                                ((= newSpacing "0") newHead)
                                ((/= newSpacing "") (strcat newHead "a" newSpacing))
                                ((/= (nth 2 tsOld) "") (strcat newHead "a" (nth 2 tsOld)))
                                (T newHead)))
                            (setq headPart newHead)

                            (QS-CapNhatXData tEntC newDia newSoNhanh)
                            (QS-CapNhatXData dEntC newDia newSoNhanh)
                          )
                        )

                        (if doCapNhatDai
                          (progn
                            (setq totalLen (vlax-curve-getDistAtParam
                                             dObj (vlax-curve-getEndParam dObj)))
                            (setq totalLenLT (QS-LamTron totalLen buocLamTron))
                            (setq lenPart (strcat "(L=" (itoa totalLenLT) ")"))
                          )
                        )

                        (setq newStr (if (/= lenPart "")
                                       (strcat headPart " " lenPart) headPart))

                        (setq res (vl-catch-all-apply
                                    'vla-put-TextString (list attObj newStr)))
                        (if (vl-catch-all-error-p res)
                          (progn
                            (setq soLoi (1+ soLoi))
                            (princ (strcat "\n  [Bo qua] Tag " (cdr (assoc 5 (entget tEntC)))
                                           " : " (vl-catch-all-error-message res))))
                          (progn
                            (vla-Update tObj)
                            (setq soOK (1+ soOK))
                            (princ (strcat "\n  [OK] Tag " (cdr (assoc 5 (entget tEntC)))
                                           " : " oldStr "  ->  " newStr)))
                        )
                      )
                    )
                  )
                  (princ (strcat "\n\n[HOAN TAT] Da cap nhat " (itoa soOK) " cap duong-tag"
                                 (if (> soLoi 0) (strcat ", " (itoa soLoi) " cap loi.") ".")))
                )
              )
            )
          )
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-SoDau (s / i n c r)
  (setq i 1 n (strlen s) r "")
  (while (and (<= i n)
              (setq c (substr s i 1))
              (or (and (>= (ascii c) 48) (<= (ascii c) 57)) (= c ".")))
    (setq r (strcat r c) i (1+ i))
  )
  r
)

(defun QS-TachSo (s / res cur i n c)
  (setq res nil cur "" i 1 n (strlen s))
  (while (<= i n)
    (setq c (substr s i 1))
    (if (or (and (>= (ascii c) 48) (<= (ascii c) 57)) (= c "."))
      (setq cur (strcat cur c))
      (progn (if (/= cur "") (setq res (cons (atof cur) res))) (setq cur ""))
    )
    (setq i (1+ i))
  )
  (if (/= cur "") (setq res (cons (atof cur) res)))
  (reverse res)
)

(defun QS-DoanCat (L Lcay Lnoi minCat tv mau soLe
                   / n Ltot R qs i dau sh p2)
  (if (or (<= Lcay (+ Lnoi 10.0)) (<= L (+ Lcay 1.0)))
    nil
    (progn
      (setq n (fix (+ 0.9999 (/ (- L Lnoi) (- Lcay Lnoi)))))
      (if (< n 2) (setq n 2))
      (setq Ltot (+ L (* (float (1- n)) Lnoi)))
      (setq R (- Ltot (* (float (1- n)) Lcay)))
      (if (< R minCat)

        (progn
          (setq R (/ Ltot (float n)))
          (setq sh (* (float mau) soLe))
          (if (or (> (+ R sh) Lcay) (< (- R sh) minCat)) (setq sh (- sh)))
          (if (or (> (+ R sh) Lcay) (< (- R sh) minCat)) (setq sh 0.0))
          (setq qs nil i 1)
          (while (< i n)
            (setq qs (cons (+ (- R (/ Lnoi 2.0))
                              (* (float (1- i)) (- R Lnoi)) sh) qs))
            (setq i (1+ i)))
          (setq qs (reverse qs))
        )

        (progn
          (setq dau (if (= (rem mau 2) 0) Lcay R))
          (setq qs nil i 1)
          (while (< i n)
            (setq qs (cons (+ (- dau (/ Lnoi 2.0))
                              (* (float (1- i)) (- Lcay Lnoi))) qs))
            (setq i (1+ i)))
          (setq qs (reverse qs))
        )
      )
      (QS-QsToDoan qs L Lnoi)
    )
  )
)

(defun QS-DinhDuong (ent / ed et)
  (setq ed (entget ent))
  (setq et (cdr (assoc 0 ed)))
  (cond
    ((= et "LINE") (list (cdr (assoc 10 ed)) (cdr (assoc 11 ed))))
    ((= et "LWPOLYLINE")
     (mapcar (function cdr)
             (vl-remove-if-not (function (lambda (x) (= (car x) 10))) ed)))
    (T nil)
  )
)

(defun QS-LaKin (ent pts / ed f)
  (setq ed (entget ent))
  (setq f (cdr (assoc 70 ed)))
  (if (and f (= 1 (logand 1 f)))
    T
    (if (and pts (> (length pts) 2)
             (< (distance (car pts) (last pts)) 1.0))
      T
      nil)
  )
)

(defun QS-DaiPts (pts / L r p)
  (setq L 0.0 p (car pts) r (cdr pts))
  (foreach q r (setq L (+ L (distance p q)) p q))
  L
)

(defun QS-HuongPts (pts / best u p q dd)
  (setq best 0.0 u '(1.0 0.0) p (car pts))
  (foreach q (cdr pts)
    (setq dd (distance p q))
    (if (> dd best)
      (setq best dd
            u (list (/ (- (car q) (car p)) dd) (/ (- (cadr q) (cadr p)) dd))))
    (setq p q)
  )
  u
)

(defun QS-DiemTai (pts d / p q dd acc res k)
  (setq acc 0.0 res nil p (car pts))
  (foreach q (cdr pts)
    (setq dd (distance p q))
    (if (and (null res) (<= d (+ acc dd 0.000001)))
      (progn
        (setq k (if (< dd 0.000001) 0.0 (/ (- d acc) dd)))
        (setq res (list (+ (car p) (* k (- (car q) (car p))))
                        (+ (cadr p) (* k (- (cadr q) (cadr p))))))
      )
      (setq acc (+ acc dd))
    )
    (setq p q)
  )
  (if res res (list (car (last pts)) (cadr (last pts))))
)

(defun QS-PtsDoan (pts p1 p2 dx dy / p q acc res)
  (setq res (list (QS-DiemTai pts p1)) acc 0.0 p (car pts))
  (foreach q (cdr pts)
    (setq acc (+ acc (distance p q)))
    (if (and (> acc (+ p1 1.0)) (< acc (- p2 1.0)))
      (setq res (append res (list q))))
    (setq p q)
  )
  (setq res (append res (list (QS-DiemTai pts p2))))
  (mapcar (function (lambda (z) (list (+ (car z) dx) (+ (cadr z) dy)))) res)
)

(defun QS-GiuaDoanDai (pts / p q best res dd)
  (setq best 0.0 res nil p (car pts))
  (foreach q (cdr pts)
    (setq dd (distance p q))
    (if (> dd best)
      (setq best dd
            res (list (/ (+ (car p) (car q)) 2.0)
                      (/ (+ (cadr p) (cadr q)) 2.0))))
    (setq p q)
  )
  (if res res (list (car (car pts)) (cadr (car pts))))
)

(defun QS-LocTrungCap (lst / res z k ds)
  (setq res nil ds nil)
  (foreach z lst
    (setq k (strcat (itoa (QS-R0 (car (car z))))  "|"
                    (itoa (QS-R0 (cadr (car z)))) "|"
                    (itoa (QS-R0 (car (cadr z)))) "|"
                    (itoa (QS-R0 (cadr (cadr z))))))
    (if (not (member k ds))
      (setq ds (cons k ds) res (cons z res)))
  )
  (reverse res)
)

(defun QS-VePts (pts lay / eLst p)
  (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                   '(100 . "AcDbPolyline") (cons 90 (length pts)) '(70 . 0)))
  (foreach p pts
    (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))
  (if (entmake eLst) (entlast) nil)
)

(defun QS-KhoaPts (pts rnd / n d1 d2)
  (setq n (length pts))
  (setq d1 (distance (nth 0 pts) (nth 1 pts)))
  (setq d2 (distance (nth (- n 2) pts) (nth (1- n) pts)))
  (strcat (itoa (QS-LamTron (QS-DaiPts pts) rnd)) "|" (itoa n)
          "|" (itoa (QS-R0 d1)) "|" (itoa (QS-R0 d2)))
)

(defun QS-TagCuaThep (ent ptG ssTag / xd h e i n t2 p bd best)
  (setq xd (QS-DocXDataTho ent))
  (setq h (if xd (QS-TachFieldXData xd 2) ""))
  (if (and h (/= h ""))
    (setq e (vl-catch-all-apply 'handent (list h))))
  (if (and e (not (vl-catch-all-error-p e))
           (= (cdr (assoc 0 (entget e))) "INSERT"))
    e
    (progn
      (setq e nil)
      (if ssTag
        (progn
          (setq i 0 n (sslength ssTag) best nil)
          (while (< i n)
            (setq t2 (ssname ssTag i))

            (if (and t2 (entget t2)
                     (setq p (cdr (assoc 10 (entget t2)))))
              (progn
                (setq bd (distance (list (car ptG) (cadr ptG))
                                   (list (car p) (cadr p))))
                (if (or (null best) (< bd best)) (setq best bd e t2))
              )
            )
            (setq i (1+ i))
          )
        )
      )
      e
    )
  )
)

(defun QS-DocTag (e / dk sn dia ty gx a obj sh)
  (setq sn 0 dia "" ty 1.0 gx 0.0 sh nil)
  (if (and e (entget e))
    (progn
      (setq obj (vl-catch-all-apply 'vlax-ename->vla-object (list e)))
      (if (vl-catch-all-error-p obj) (setq obj nil))
    )
  )
  (if obj
    (progn
      (setq ty (vl-catch-all-apply 'vla-get-XScaleFactor (list obj)))
      (if (or (vl-catch-all-error-p ty) (not (numberp ty))) (setq ty 1.0))
      (setq gx (vl-catch-all-apply 'vla-get-Rotation (list obj)))
      (if (or (vl-catch-all-error-p gx) (not (numberp gx))) (setq gx 0.0))
      (setq a (vl-catch-all-apply 'vlax-invoke (list obj 'GetAttributes)))
      (if (vl-catch-all-error-p a) (setq a nil))
      (foreach a (if a a nil)
        (cond
          ((= (strcase (vla-get-TagString a)) "DKVAKC")
           (setq dk (vla-get-TextString a)))
          ((= (strcase (vla-get-TagString a)) "SH")
           (setq sh (vla-get-TextString a)))
        )
      )
      (if dk
        (progn
          (setq sn (atoi (QS-SoDau dk)))
          (setq a (vl-string-search "%%c" dk))
          (if a (setq dia (QS-SoDau (substr dk (+ a 4)))))
        )
      )
    )
  )
  (list sn dia ty gx (if (and sh (/= sh "")) sh "0") (if dk dk ""))
)

(defun QS-VeRanhVung (pt d cao lay / w p1 p2)
  (setq w (list (- (cadr d)) (car d)))
  (setq p1 (list (- (car pt) (* (/ cao 2.0) (car w)))
                 (- (cadr pt) (* (/ cao 2.0) (cadr w)))))
  (setq p2 (list (+ (car pt) (* (/ cao 2.0) (car w)))
                 (+ (cadr pt) (* (/ cao 2.0) (cadr w)))))
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                 '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                 (cons 10 p1) (cons 10 p2)))
)

(defun QS-NhipTuDam (curves u minG / kh pr)
  (setq kh (strcat (rtos (car u) 2 3) "|" (rtos (cadr u) 2 3) "|" (rtos minG 2 1)))
  (setq pr (assoc kh *QS-NHIPC*))
  (if pr (cdr pr) (QS-NhipTinh curves u minG kh))
)

(defun QS-NhipTinh (curves u minG kh / lst res prev x)
  (setq lst (QS-MocChia curves u) res nil prev nil)
  (foreach x lst
    (if (or (null prev) (> (- x prev) 30.0))
      (progn (setq res (cons x res) prev x))))
  (setq res (reverse res) lst nil prev nil)
  (foreach x res
    (if (and prev (>= (- x prev) minG)) (setq lst (cons (list prev x) lst)))
    (setq prev x))
  (setq lst (reverse lst))
  (setq *QS-NHIPC* (cons (cons kh lst) *QS-NHIPC*))
  lst
)

(defun QS-VeRanhU (s u p0 p1 lay / w pa pb)
  (setq w (list (- (cadr u)) (car u)))
  (setq pa (list (+ (* s (car u)) (* p0 (car w)))
                 (+ (* s (cadr u)) (* p0 (cadr w)))))
  (setq pb (list (+ (* s (car u)) (* p1 (car w)))
                 (+ (* s (cadr u)) (* p1 (cadr w)))))
  (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                 '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                 (cons 10 pa) (cons 10 pb)))
)

(defun QS-PhamViW (bb u / w c mn mx t0)
  (setq w (list (- (cadr u)) (car u)) mn nil mx nil)
  (foreach c (list (list (car bb) (cadr bb))   (list (caddr bb) (cadr bb))
                   (list (car bb) (cadddr bb)) (list (caddr bb) (cadddr bb)))
    (setq t0 (+ (* (car c) (car w)) (* (cadr c) (cadr w))))
    (if (or (null mn) (< t0 mn)) (setq mn t0))
    (if (or (null mx) (> t0 mx)) (setq mx t0)))
  (list mn mx)
)

(defun QS-VeNhipTD (dsC u bb nchia dau lay minG / pv nh s1 s2 a dem)
  (setq pv (QS-PhamViW bb u) dem 0)
  (foreach nh (QS-NhipTuDam dsC u minG)
    (setq s1 (car nh) s2 (cadr nh) a (/ (- s2 s1) nchia))
    (if dau (progn (QS-VeRanhU s1 u (car pv) (cadr pv) lay) (setq dem (1+ dem))))
    (QS-VeRanhU (+ s1 a) u (car pv) (cadr pv) lay)
    (QS-VeRanhU (- s2 a) u (car pv) (cadr pv) lay)
    (if dau (progn (QS-VeRanhU s2 u (car pv) (cadr pv) lay) (setq dem (1+ dem))))
    (setq dem (+ dem 2))
    (princ (strcat "\n  Nhip L = " (rtos (- s2 s1) 2 0) "  ->  "
                   (rtos a 2 0) " | " (rtos (- (- s2 s1) (* 2.0 a)) 2 0)
                   " | " (rtos a 2 0)))
  )
  dem
)

(defun c:OS_VUNGCAT ( / *error* doc nchia cao lay pts p p1 p2 d L a i n soV soD s
                        layDam minG ssD dsC iD nD bb dem phg)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n=== OS_VUNGCAT - VE DUONG RANH VUNG DUOC PHEP CAT / NOI THEP ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)

  (if (not *QSV-CHIA*) (setq *QSV-CHIA* 4))
  (if (not *QSV-CAO*)  (setq *QSV-CAO* 0.0))
  (if (not *QSV-LAY*)  (setq *QSV-LAY* "QS_VungCat"))

  (initget 6)
  (setq n (getint (strcat "\nChia nhip de dat vung cat: L / n, n = <" (itoa *QSV-CHIA*) ">: ")))
  (if n (setq *QSV-CHIA* n))
  (setq nchia (float *QSV-CHIA*))

  (initget 4)
  (setq a (getreal (strcat "\nChieu dai duong ranh (mm, 0 = tu dong) <"
                           (rtos *QSV-CAO* 2 0) ">: ")))
  (if a (setq *QSV-CAO* a))

  (if (not *QSV-DAU*) (setq *QSV-DAU* "Co"))
  (initget "Co Khong")
  (setq s (getkword (strcat "\nVe them duong ranh tai 2 DAU nhip? [Co/Khong] <"
                            *QSV-DAU* ">: ")))
  (if s (setq *QSV-DAU* s))

  (setq s (getstring T (strcat "\nLayer duong ranh <" *QSV-LAY* ">: ")))
  (if (/= s "") (setq *QSV-LAY* s))
  (setq lay *QSV-LAY*)
  (QS-DamBaoLayer lay 6)

  (if (not *QSV-CHEDO*) (setq *QSV-CHEDO* "TUdong"))
  (initget "Pick TUdong")
  (setq s (getkword (strcat "\nXac dinh nhip [Pick/TUdong] <" *QSV-CHEDO* ">: ")))
  (if s (setq *QSV-CHEDO* s))

  (if (= *QSV-CHEDO* "TUdong")
   (progn
      (if (not *QSV-LDAM*)
        (setq *QSV-LDAM* (if (and *QS4-LDAM* (/= *QS4-LDAM* "")) *QS4-LDAM* "")))
      (if (= *QSV-LDAM* "")
        (progn
          (setq p (entsel "\nChon 1 doi tuong thuoc layer NET DAM: "))
          (if p (setq *QSV-LDAM* (cdr (assoc 8 (entget (car p))))))))
      (setq s (getstring T (strcat "\nLayer net dam <" *QSV-LDAM* ">: ")))
      (if (/= s "") (setq *QSV-LDAM* s))
      (setq layDam *QSV-LDAM*)

      (if (not *QSV-MING*) (setq *QSV-MING* 1500.0))
      (initget 6)
      (setq a (getreal (strcat "\nNhip nho nhat (mm) - nho hon coi la BE RONG DAM <"
                               (rtos *QSV-MING* 2 0) ">: ")))
      (if a (setq *QSV-MING* a))
      (setq minG *QSV-MING*)

      (if (not *QSV-PHG*) (setq *QSV-PHG* "CAhai"))
      (initget "Ngang Dung CAhai")
      (setq s (getkword (strcat "\nPhuong ve duong ranh [Ngang/Dung/CAhai] <"
                                *QSV-PHG* ">: ")))
      (if s (setq *QSV-PHG* s))
      (setq phg *QSV-PHG*)

      (setq ssD (if (= layDam "") nil
                  (ssget "_X" (list (cons 8 layDam)
                    '(-4 . "<OR") '(0 . "LINE") '(0 . "LWPOLYLINE")
                    '(0 . "POLYLINE") '(-4 . "OR>")))))
      (if (null ssD)
        (princ (strcat "\n[Loi] Khong co doi tuong nao tren layer net dam. Huy lenh."))
        (progn
          (setq dsC nil iD 0 nD (sslength ssD))
          (while (< iD nD)
            (setq dsC (cons (vlax-ename->vla-object (ssname ssD iD)) dsC))
            (setq iD (1+ iD)))
          (setq bb (QS-HopBao dsC) dem 0)
          (if (/= phg "Dung")
            (progn
              (princ "\n\n--- Phuong NGANG (thep chay ngang, duong ranh DUNG) ---")
              (setq dem (+ dem (QS-VeNhipTD dsC (list 1.0 0.0) bb nchia
                                            (= *QSV-DAU* "Co") lay minG)))))
          (if (/= phg "Ngang")
            (progn
              (princ "\n\n--- Phuong DUNG (thep chay dung, duong ranh NGANG) ---")
              (setq dem (+ dem (QS-VeNhipTD dsC (list 0.0 1.0) bb nchia
                                            (= *QSV-DAU* "Co") lay minG)))))
          (princ (strcat "\n\n[HOAN TAT] Da ve TU DONG " (itoa dem)
                         " duong ranh vung cat tren layer " lay "."))
          (princ "\n   Khi cat thep: chon 2 duong = 1 VUNG duoc phep dat moi noi.")
        )
      )
   )
   (progn
  (princ "\n\nPick cac diem dau / cuoi cua tung nhip (2, 4, 6 ... diem).")
  (princ "\nEnter de ket thuc.")
  (setq pts nil i 1)
  (while (setq p (getpoint (strcat "\n  Diem " (itoa i) ": ")))
    (setq pts (append pts (list p)) i (1+ i))
  )
  (cond
    ((< (length pts) 2)
     (princ "\nCan it nhat 2 diem. Huy lenh."))
    ((/= 0 (rem (length pts) 2))
     (princ (strcat "\n[Loi] Da pick " (itoa (length pts))
                    " diem - SO DIEM PHAI CHAN (2, 4, 6 ...) vi moi 2 diem"
                    " la 1 nhip. Huy lenh.")))
    (T
     (setq soV 0 soD 0)
     (while pts
       (setq p1 (car pts) p2 (cadr pts) pts (cddr pts))
       (setq L (distance (list (car p1) (cadr p1)) (list (car p2) (cadr p2))))
       (if (> L 1.0)
         (progn
           (setq d (list (/ (- (car p2) (car p1)) L) (/ (- (cadr p2) (cadr p1)) L)))
           (setq a (/ L nchia))
           (setq cao (if (> *QSV-CAO* 0.0) *QSV-CAO* (* 0.15 L)))

           (if (= *QSV-DAU* "Co")
             (progn
               (QS-VeRanhVung (list (car p1) (cadr p1)) d cao lay)
               (setq soD (+ soD 2))))
           (QS-VeRanhVung (list (+ (car p1) (* a (car d))) (+ (cadr p1) (* a (cadr d))))
                          d cao lay)
           (QS-VeRanhVung (list (- (car p2) (* a (car d))) (- (cadr p2) (* a (cadr d))))
                          d cao lay)
           (if (= *QSV-DAU* "Co")
             (QS-VeRanhVung (list (car p2) (cadr p2)) d cao lay))
           (setq soV (1+ soV))
           (princ (strcat "\n  Nhip L = " (rtos L 2 0) "  ->  "
                          (rtos a 2 0) " | " (rtos (- L (* 2.0 a)) 2 0)
                          " | " (rtos a 2 0)))
         )
       )
     )
     (princ (strcat "\n\n[HOAN TAT] Da ve " (itoa (+ (* 2 soV) soD))
                    " duong ranh cho " (itoa soV) " nhip tren layer " lay "."))
     (princ "\n   Khi cat thep: chon 2 duong = 1 VUNG duoc phep dat moi noi.")
     (if (= *QSV-DAU* "Co")
       (progn
         (princ "\n   Moi nhip co 4 duong (dau | L/n | L-L/n | cuoi) nen chon duoc:")
         (princ "\n      duong 1+2 va 3+4  ->  2 vung o HAI DAU nhip (thep lop DUOI)")
         (princ "\n      duong 2+3         ->  1 vung o GIUA nhip  (thep lop TREN)"))
       (princ "\n   Moi nhip co 2 duong -> chon ca 2 duoc vung GIUA nhip."))
    )
  )
   )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-PTaiChieu (pts u tv / p q acc dd t1 t2 res k)
  (setq acc 0.0 p (car pts) res nil)
  (foreach q (cdr pts)
    (setq dd (distance p q))
    (setq t1 (+ (* (car p) (car u)) (* (cadr p) (cadr u))))
    (setq t2 (+ (* (car q) (car u)) (* (cadr q) (cadr u))))
    (if (and (null res)
             (or (and (<= t1 tv) (<= tv t2)) (and (>= t1 tv) (>= tv t2))))
      (progn
        (setq k (if (< (abs (- t2 t1)) 1.0e-9) 0.0 (/ (- tv t1) (- t2 t1))))
        (setq res (+ acc (* k dd)))
      )
    )
    (setq acc (+ acc dd) p q)
  )
  res
)

(defun QS-PlanBar (dsSub L Lcay Lnoi minCat vungs mau soLe tv
                   / plan sub zA Ls pl2 pc)
  (setq plan nil)
  (foreach sub dsSub
    (setq zA (car sub) Ls (- (cadr sub) (car sub)))
    (setq pl2 (if vungs
                (QS-DoanCatVungUu Ls Lcay Lnoi minCat (QS-DoiVung vungs zA)
                                  mau soLe)
                (QS-DoanCat Ls Lcay Lnoi minCat tv mau soLe)))
    (if (null pl2) (setq pl2 (list (list 0.0 Ls 0))))
    (foreach pc pl2
      (setq plan (append plan
        (list (list (+ zA (car pc)) (+ zA (cadr pc)) (caddr pc)))))))
  plan
)

(defun QS-QTaiChieu (pts u L tv / pv)
  (setq pv (QS-PTaiChieu pts u tv))
  (if pv
    pv
    (if (< tv (+ (* (car (car pts)) (car u)) (* (cadr (car pts)) (cadr u))))
      0.0 L))
)

(defun QS-VungTD (nhs nchia lopTren / res nh prev s1 s2 a)
  (setq res nil prev nil)
  (foreach nh nhs
    (setq s1 (car nh) s2 (cadr nh) a (/ (- s2 s1) nchia))
    (if lopTren
      (setq res (cons (list (+ s1 a) (- s2 a)) res))
      (progn
        (if prev
          (setq res (cons (list (- (car prev) (cadr prev)) (+ s1 a)) res))
          (setq res (cons (list s1 (+ s1 a)) res)))
        (setq prev (list s2 a))
      )
    )
  )
  (if (and (not lopTren) prev)
    (setq res (cons (list (- (car prev) (cadr prev)) (car prev)) res)))
  (reverse res)
)

(defun QS-VungCatTD (dsC pts u L vuot nchia minG lopTren
                     / res z z1 z2 tmin tmax q1 q2 pp tv)
  (setq tmin nil tmax nil)
  (foreach pp pts
    (setq tv (+ (* (car pp) (car u)) (* (cadr pp) (cadr u))))
    (if (or (null tmin) (< tv tmin)) (setq tmin tv))
    (if (or (null tmax) (> tv tmax)) (setq tmax tv)))
  (setq res nil)
  (foreach z (QS-VungTD (QS-NhipTuDam dsC u minG) nchia lopTren)
    (setq z1 (car z) z2 (cadr z))
    (if (and (> z2 tmin) (< z1 tmax) (> (- z2 z1) 1.0))
      (progn
        (setq q1 (QS-QTaiChieu pts u L (max z1 tmin)))
        (setq q2 (QS-QTaiChieu pts u L (min z2 tmax)))
        (if (> (abs (- q2 q1)) 1.0)
          (setq res (cons (list (- (min q1 q2) vuot) (+ (max q1 q2) vuot)) res))))))
  (reverse res)
)

(defun QS-VungCat (ss pts u L vuot / i n e ed ptv tv lst pv z res a b)
  (setq lst nil i 0 n (if ss (sslength ss) 0))
  (while (< i n)
    (setq e (ssname ss i) ed nil)
    (setq ptv (QS-DinhDuong e))
    (if (and ptv (>= (length ptv) 2))
      (progn
        (setq a (car ptv) b (last ptv))
        (setq ptv (list (/ (+ (car a) (car b)) 2.0) (/ (+ (cadr a) (cadr b)) 2.0)))
        (setq tv (+ (* (car ptv) (car u)) (* (cadr ptv) (cadr u))))
        (setq pv (QS-PTaiChieu pts u tv))
        (if (null pv)
          (setq pv (if (< tv (+ (* (car (car pts)) (car u))
                                (* (cadr (car pts)) (cadr u))))
                     0.0 L)))
        (setq lst (cons pv lst))
      )
    )
    (setq i (1+ i))
  )
  (setq lst (QS-Sap lst '<))
  (setq res nil)
  (while (>= (length lst) 2)
    (setq res (cons (list (- (car lst) vuot) (+ (cadr lst) vuot)) res))
    (setq lst (cddr lst))
  )
  (reverse res)
)

(defun QS-TrongVung (q vungs nua / ok z)
  (setq ok nil)
  (foreach z vungs
    (if (and (>= q (+ (car z) nua)) (<= q (- (cadr z) nua))) (setq ok T)))
  ok
)

(defun QS-QTrongVung (qmax qmin vungs nua / best z lo hi)
  (setq best nil)
  (foreach z vungs
    (setq lo (+ (car z) nua) hi (- (cadr z) nua))
    (if (and (<= lo hi) (<= lo qmax) (>= hi qmin))
      (progn
        (setq hi (min hi qmax))
        (if (>= hi qmin)
          (if (or (null best) (> hi best)) (setq best hi)))
      )
    )
  )
  best
)

(defun QS-QsToDoan (qs L Lnoi / res i n p1 p2)
  (setq n (1+ (length qs)) i 1 res nil)
  (while (<= i n)
    (setq p1 (if (= i 1) 0.0 (- (nth (- i 2) qs) (/ Lnoi 2.0))))
    (setq p2 (if (= i n) L  (+ (nth (1- i) qs) (/ Lnoi 2.0))))
    (setq res (cons (list p1 p2 (rem (1- i) 2)) res))
    (setq i (1+ i))
  )
  (reverse res)
)

(defun QS-DoanCatVung (L Lcay Lnoi minCat vungs mau soLe
                       / qs prev qmax qmin q q2 dau lap)
  (if (<= L (+ Lcay 1.0))
    nil
    (progn
      (setq qs nil prev 0.0 dau T lap 0)
      (while (and (< lap 200)
                  (> (if dau L (+ (- L prev) (/ Lnoi 2.0))) Lcay))
        (setq lap (1+ lap))
        (setq qmax (if dau (- Lcay (/ Lnoi 2.0)) (+ prev (- Lcay Lnoi))))
        (setq qmax (min qmax (- (+ L (/ Lnoi 2.0)) minCat)))
        (setq qmin (if dau (- minCat (/ Lnoi 2.0)) (+ prev (- minCat Lnoi))))
        (if (< qmin 0.0) (setq qmin 0.0))
        (if (< qmax qmin) (setq qmax qmin))
        (setq q (QS-QTrongVung qmax qmin vungs (/ Lnoi 2.0)))
        (if (null q)
          (setq q qmax
                *QS-NGOAIVUNG* (1+ (if *QS-NGOAIVUNG* *QS-NGOAIVUNG* 0))))
        (if (> mau 0)
          (progn
            (setq q2 (- q (* (float mau) soLe)))
            (if (and (>= q2 qmin) (QS-TrongVung q2 vungs (/ Lnoi 2.0)))
              (setq q q2))
          )
        )
        (if (<= q (+ prev 1.0)) (setq q (max qmax (+ prev 1.0))))
        (setq qs (append qs (list q)) prev q dau nil)
      )
      (QS-QsToDoan qs L Lnoi)
    )
  )
)

(defun QS-CachPts (pts pt / p q best d)
  (setq best nil p (car pts))
  (foreach q (cdr pts)
    (setq d (distance (list (car pt) (cadr pt))
                      (QS-ChanVuongGoc p q pt)))
    (if (or (null best) (< d best)) (setq best d))
    (setq p q)
  )
  (if best best 1.0e9)
)

(defun QS-ChanVuongGoc (p q pt / dx dy L2 k)
  (setq dx (- (car q) (car p)) dy (- (cadr q) (cadr p)))
  (setq L2 (+ (* dx dx) (* dy dy)))
  (if (< L2 1.0e-12)
    (list (car p) (cadr p))
    (progn
      (setq k (/ (+ (* (- (car pt) (car p)) dx) (* (- (cadr pt) (cadr p)) dy)) L2))
      (if (< k 0.0) (setq k 0.0))
      (if (> k 1.0) (setq k 1.0))
      (list (+ (car p) (* k dx)) (+ (cadr p) (* k dy)))
    )
  )
)

(defun QS-LayDimNeo2 (pts u v tolV / ss i n e ed st p1 p2 res t1 t2 uu sv a b um tm)

  (setq t1 nil t2 nil)
  (foreach a pts
    (setq uu (+ (* (car a) (car u)) (* (cadr a) (cadr u))))
    (if (or (null t1) (< uu t1)) (setq t1 uu))
    (if (or (null t2) (> uu t2)) (setq t2 uu))
  )
  (setq a (QS-DiemTai pts (/ (QS-DaiPts pts) 2.0)))
  (setq sv (+ (* (car a) (car v)) (* (cadr a) (cadr v))))
  (setq res nil)
  (if (null *QS-SSDIM*)
    (setq *QS-SSDIM* (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Dim,DCE_Dim")))))
  (setq ss *QS-SSDIM*)
  (if ss
    (progn
      (setq i 0 n (sslength ss))
      (while (< i n)
        (setq e (ssname ss i) ed (entget e))
        (setq st (cdr (assoc 3 ed)))
        (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
        (if (and p1 p2 st (wcmatch (strcase st) "QS_NEO*"))
          (progn
            (setq a (+ (* (car p1) (car u)) (* (cadr p1) (cadr u))))
            (setq b (+ (* (car p2) (car u)) (* (cadr p2) (cadr u))))
            (setq um (/ (+ a b) 2.0))
            (setq uu (/ (+ (+ (* (car p1) (car v)) (* (cadr p1) (cadr v)))
                           (+ (* (car p2) (car v)) (* (cadr p2) (cadr v))))
                        2.0))
            (if (and (< (abs (- uu sv)) tolV)
                     (>= um (- t1 1.0)) (<= um (+ t2 1.0)))
              (progn
                (setq tm (QS-PTaiChieu pts u um))
                (if (and tm (not (member e *QS-NEODONE*)))
                  (progn
                    (setq *QS-NEODONE* (cons e *QS-NEODONE*))
                    (setq res (cons (list e a b tm) res))))))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (reverse res)
)

(defun QS-XoaDimCuaThep (pts tol / ss i n e ed p1 p2 dem)
  (setq dem 0)
  (setq ss (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Dim,DCE_Dim"))))
  (if ss
    (progn
      (setq i 0 n (sslength ss))
      (while (< i n)
        (setq e (ssname ss i) ed (entget e))
        (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
        (if (and p1 p2
                 (< (QS-CachPts pts p1) tol)
                 (< (QS-CachPts pts p2) tol))
          (progn (entdel e) (setq dem (1+ dem))))
        (setq i (1+ i))
      )
    )
  )
  dem
)

(defun QS-TimDuongRai (pts u v tol ssCir ssRai
                       / ss i n e ed p1 p2 d1 d2 v1 v2 uu t1 t2 sv p
                         best bd c cu cx um)
  (setq t1 nil t2 nil)
  (foreach p pts
    (setq uu (+ (* (car p) (car u)) (* (cadr p) (cadr u))))
    (if (or (null t1) (< uu t1)) (setq t1 uu))
    (if (or (null t2) (> uu t2)) (setq t2 uu))
  )

  (setq p (QS-DiemTai pts (/ (QS-DaiPts pts) 2.0)))
  (setq sv (+ (* (car p) (car v)) (* (cadr p) (cadr v))))
  (setq ss (if ssRai ssRai
             (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol")))))
  (setq best nil bd nil)
  (if ss
    (progn
      (setq i 0 n (sslength ss))
      (while (< i n)
        (setq e (ssname ss i) ed (entget e))
        (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
        (if (and p1 p2)
          (progn
            (setq d1 (+ (* (car p1) (car u)) (* (cadr p1) (cadr u))))
            (setq d2 (+ (* (car p2) (car u)) (* (cadr p2) (cadr u))))
            (setq v1 (+ (* (car p1) (car v)) (* (cadr p1) (cadr v))))
            (setq v2 (+ (* (car p2) (car v)) (* (cadr p2) (cadr v))))
            (if (> v1 v2) (progn (setq uu v1 v1 v2 v2 uu)))
            (setq um (/ (+ d1 d2) 2.0))
            (if (and (< (abs (- d1 d2)) (* 50.0 tol))
                     (> (- v2 v1) 1.0)
                     (>= um (- t1 (* 100.0 tol)))
                     (<= um (+ t2 (* 100.0 tol)))
                     (>= sv (- v1 (* 200.0 tol)))
                     (<= sv (+ v2 (* 200.0 tol))))
              (progn
                (setq uu (abs (- sv (/ (+ v1 v2) 2.0))))
                (if (or (null bd) (< uu bd))
                  (setq bd uu best (list e p1 p2 um)))
              )
            )
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (if (null best)
    nil
    (progn

      (setq c nil bd nil)
      (setq ss (if ssCir ssCir
                 (ssget "_X" '((0 . "CIRCLE") (8 . "QS_Symbol,DCE_Symbol")))))
      (if ss
        (progn
          (setq i 0 n (sslength ss))
          (while (< i n)
            (setq e (ssname ss i) ed (entget e))
            (setq p1 (cdr (assoc 10 ed)))
            (if p1
              (progn
                (setq cx (+ (* (car p1) (car v)) (* (cadr p1) (cadr v))))
                (setq cu (+ (* (car p1) (car u)) (* (cadr p1) (cadr u))))
                (if (and (< (abs (- cx sv)) (* 50.0 tol))
                         (< (abs (- cu (nth 3 best))) (* 50.0 tol)))
                  (progn
                    (setq uu (abs (- cx sv)))
                    (if (or (null bd) (< uu bd)) (setq bd uu c e))
                  )
                )
              )
            )
            (setq i (1+ i))
          )
        )
      )
      (list (car best) c (cadr best) (caddr best))
    )
  )
)

(defun QS-DocKhoangCach (dk / p s q)
  (setq p (vl-string-search "%%c" dk))
  (if (null p)
    0.0
    (progn
      (setq s (substr dk (+ p 4)))
      (setq s (substr s (1+ (strlen (QS-SoDau s)))))
      (if (and (> (strlen s) 1) (= (strcase (substr s 1 1)) "A"))
        (atof (QS-SoDau (substr s 2)))
        0.0
      )
    )
  )
)

(defun QS-Cong (p dir len)
  (list (+ (car p) (* len (car dir))) (+ (cadr p) (* len (cadr dir))))
)

(defun QS-DichPlan (plan d L / res i n p)
  (setq n (length plan) i 0 res nil)
  (foreach p plan
    (setq i (1+ i))
    (setq res (cons (list (if (= i 1) 0.0 (+ (car p) d))
                          (if (= i n) L  (+ (cadr p) d))
                          (caddr p))
                    res))
  )
  (reverse res)
)

(defun QS-PlanHopLe (plan L Lcay minCat vungs Lnoi / ok i n p len q)
  (setq ok T n (length plan) i 0)
  (foreach p plan
    (setq len (- (cadr p) (car p)))
    (if (or (> len (+ Lcay 0.5)) (< len (- minCat 0.5))) (setq ok nil))
  )
  (if (and ok vungs)
    (progn
      (setq i 0)
      (while (< i (1- n))
        (setq q (/ (+ (cadr (nth i plan)) (car (nth (1+ i) plan))) 2.0))
        (if (not (QS-TrongVung q vungs (/ Lnoi 2.0))) (setq ok nil))
        (setq i (1+ i))
      )
    )
  )
  ok
)

(defun QS-HaoDoan (len Lcay / k)
  (if (or (<= len 1.0) (> len Lcay))
    0.0
    (progn
      (setq k (fix (/ Lcay len)))
      (if (< k 1) (setq k 1))
      (- Lcay (* (float k) len))
    )
  )
)

(defun QS-HaoPlan (plan Lcay / h p len ds)
  (setq h 0.0 ds nil)
  (foreach p plan
    (setq len (- (cadr p) (car p)))
    (if (and (< len (- Lcay 1.0))
             (not (vl-some (function (lambda (x) (< (abs (- x len)) 1.0))) ds)))
      (progn (setq ds (cons len ds))
             (setq h (+ h (QS-HaoPhoi len Lcay))))
    )
  )
  h
)

(defun QS-DichToiUu (plan L Lcay minCat vungs Lnoi tol buoc dcam dcamTol
                     / d best bd p2 h)
  (if (or (null plan) (<= tol 0.0))
    0.0
    (progn
      (setq best 0.0 bd nil d (- 0.0 tol))
      (if (< buoc 1.0) (setq buoc 5.0))
      (while (<= d (+ tol 0.001))
        (if (and dcam (< (abs (- d dcam)) dcamTol))
          nil
          (progn
            (setq p2 (QS-DichPlan plan d L))
            (if (QS-PlanHopLe p2 L Lcay minCat vungs Lnoi)
              (progn
                (setq h (QS-HaoPlan p2 Lcay))
                (if (or (null bd) (< h (- bd 0.5))
                        (and (< (abs (- h bd)) 0.5) (< (abs d) (abs best))))
                  (setq bd h best d))
              )
            )
          )
        )
        (setq d (+ d buoc))
      )
      best
    )
  )
)

(defun QS-GhiPhoi (plan cnt / p len pr)
  (foreach p plan
    (setq len (float (QS-R0 (- (cadr p) (car p)))))
    (setq pr (assoc len *QS-PHOI*))
    (if pr
      (setq *QS-PHOI* (subst (cons len (+ (cdr pr) cnt)) pr *QS-PHOI*))
      (setq *QS-PHOI* (cons (cons len cnt) *QS-PHOI*)))
  )
  (princ)
)

(defun QS-BungDoan (ds / res pr i)
  (setq res nil)
  (foreach pr ds
    (setq i 0)
    (while (< i (cdr pr))
      (setq res (cons (car pr) res) i (1+ i))))
  (QS-Sap res '>)
)

(defun QS-XepCay (lens Lcay / bins x best res b)
  (setq bins nil)
  (foreach x lens
    (setq best nil)
    (foreach b bins
      (if (and (>= (car b) (- x 0.5))
               (or (null best) (< (car b) (car best))))
        (setq best b)))
    (if best
      (progn
        (setq res nil)
        (foreach b bins
          (setq res (append res
            (list (if (eq b best)
                    (cons (- (car b) x) (append (cdr b) (list x)))
                    b)))))
        (setq bins res))
      (setq bins (append bins (list (cons (- Lcay x) (list x))))))
  )
  bins
)

(defun QS-KhoaMau (b / s x)
  (setq s "")
  (foreach x (cdr b) (setq s (strcat s (if (= s "") "" " + ") (rtos x 2 0))))
  s
)

(defun QS-BaoCaoPhoi (Lcay / lens bins mau pr k tong cay hao n i ds)
  (setq lens (QS-BungDoan *QS-PHOI*))
  (setq tong 0.0)
  (foreach k lens (setq tong (+ tong k)))
  (setq bins (QS-XepCay lens Lcay))
  (setq cay (length bins))

  (setq mau nil)
  (foreach b bins
    (setq k (QS-KhoaMau b))
    (setq pr (assoc k mau))
    (if pr
      (setq mau (subst (list k (1+ (cadr pr)) (car b)) pr mau))
      (setq mau (cons (list k 1 (car b)) mau)))
  )
  (setq mau (vl-sort mau (function (lambda (a b)
              (if (= (cadr a) (cadr b)) (< (car a) (car b))
                (> (cadr a) (cadr b)))))))
  (princ (strcat "\n\n--- PHOI HOP THEP  (cay " (rtos Lcay 2 0) " mm) ---"))
  (setq i 0)
  (foreach pr mau
    (if (< i 20)
      (princ (strcat "\n   " (itoa (cadr pr)) " cay :  " (car pr)
                     (if (> (caddr pr) 0.5)
                       (strcat "   ->  thua " (rtos (caddr pr) 2 0) " mm") "")))
      (if (= i 20) (princ "\n   ... (con nua, xem bang thong ke)")))
    (setq i (1+ i))
  )
  (setq hao (- (* (float cay) Lcay) tong))
  (princ (strcat "\n   TONG: " (itoa (length lens)) " doan  ->  " (itoa cay)
                 " cay " (rtos Lcay 2 0) " mm"))
  (princ (strcat "\n         thep dung that " (rtos tong 2 0)
                 " mm  -  hao hut " (rtos hao 2 0) " mm  ("
                 (rtos (* 100.0 (/ hao (max 1.0 (* (float cay) Lcay)))) 2 1) " %)"))
  (princ (strcat "\n         so cay TOI THIEU ve ly thuyet: "
                 (itoa (fix (+ 0.9999 (/ tong Lcay)))) " cay"))

  (setq ds (list 0 0 0 0))
  (foreach k lens
    (cond ((< (abs (- k Lcay))         1.0) (setq ds (list (1+ (nth 0 ds)) (nth 1 ds) (nth 2 ds) (nth 3 ds))))
          ((< (abs (- k (/ Lcay 2.0))) 1.0) (setq ds (list (nth 0 ds) (1+ (nth 1 ds)) (nth 2 ds) (nth 3 ds))))
          ((< (abs (- k (/ Lcay 3.0))) 1.0) (setq ds (list (nth 0 ds) (nth 1 ds) (1+ (nth 2 ds)) (nth 3 ds))))
          (T (setq ds (list (nth 0 ds) (nth 1 ds) (nth 2 ds) (1+ (nth 3 ds)))))))
  (princ (strcat "\n   UU TIEN CHIEU DAI:  "
                 (itoa (nth 0 ds)) " doan " (rtos Lcay 2 0)
                 "  |  " (itoa (nth 1 ds)) " doan " (rtos (/ Lcay 2.0) 2 0)
                 "  |  " (itoa (nth 2 ds)) " doan " (rtos (/ Lcay 3.0) 2 0)
                 "  |  " (itoa (nth 3 ds)) " doan khac"))
  (princ "\n   (3 chieu dai tren cat tu 1 cay deu KHONG THUA met nao.)")
  (princ)
)

(defun QS-HaoPhoi (len Lcay / h pr best)
  (setq h (QS-HaoDoan len Lcay))
  (if (and (> h 1.0) *QS-PHOI*)
    (progn
      (setq best nil)
      (foreach pr *QS-PHOI*
        (if (and (> (car pr) 1.0) (<= (car pr) h)
                 (or (null best) (> (car pr) best)))
          (setq best (car pr))))
      (if best (setq h (- h best)))
    )
  )
  h
)

(defun QS-UuTienDoan (len Lcay)
  (cond ((< (abs (- len Lcay))          1.0) 3.0)
        ((< (abs (- len (/ Lcay 2.0)))  1.0) 2.0)
        ((< (abs (- len (/ Lcay 3.0)))  1.0) 1.0)
        (T 0.0))
)

(defun QS-DiemDoan (len Lcay)
  (- (+ (- 0.0 (QS-HaoPhoi len Lcay))
        (QS-UuTienDoan len Lcay))
     20000.0)
)

(defun QS-UngVienQ (qmax qmin vungs nua prev dau Lcay Lnoi
                    / uu zc z lo hi q n out res)

  (setq uu nil)
  (foreach q (list Lcay (/ Lcay 2.0) (/ Lcay 3.0))
    (setq q (if dau (- q (/ Lnoi 2.0)) (+ prev (- q Lnoi))))
    (if (and (>= q qmin) (<= q qmax) (QS-TrongVung q vungs nua))
      (setq uu (append uu (list q)))))

  (setq zc nil)
  (foreach z vungs
    (setq lo (+ (car z) nua) hi (- (cadr z) nua))
    (if (<= lo hi)
      (progn
        (if (and (<= hi qmax) (>= hi qmin)) (setq zc (cons hi zc)))
        (if (and (>= lo qmin) (<= lo qmax)) (setq zc (cons lo zc)))
        (if (and (<= lo qmax) (> hi qmax) (>= qmax qmin))
          (setq zc (cons qmax zc)))
      )
    )
  )
  (setq zc (QS-Sap zc '>))

  (setq out nil)
  (foreach q (append uu zc)
    (if (not (vl-some (function (lambda (x) (< (abs (- x q)) 1.0))) out))
      (setq out (append out (list q)))))
  (setq n 0 res nil)
  (foreach q out
    (if (< n 10) (setq res (append res (list q)) n (1+ n))))
  res
)

(defun QS-TimCat (L Lcay Lnoi minCat vungs prev dau sau / kh pr r)
  (setq kh (strcat (if dau "D" "K") (itoa (QS-R0 prev)) "|" (itoa sau)))
  (setq pr (assoc kh *QS-MEMOC*))
  (if pr
    (cdr pr)
    (progn
      (setq r (QS-TimCat1 L Lcay Lnoi minCat vungs prev dau sau))
      (setq *QS-MEMOC* (cons (cons kh r) *QS-MEMOC*))
      r
    )
  )
)

(defun QS-TimCat1 (L Lcay Lnoi minCat vungs prev dau sau
                  / qmax qmin uv q r best bs sc lenC lenL n2 out)
  (setq lenL (if dau L (+ (- L prev) (/ Lnoi 2.0))))
  (if (<= lenL (+ Lcay 0.5))
    (if (>= lenL (- minCat 0.5))
      (cons (QS-DiemDoan lenL Lcay) nil)
      nil)
    (if (<= sau 0)
      nil
      (progn
        (setq qmax (if dau (- Lcay (/ Lnoi 2.0)) (+ prev (- Lcay Lnoi))))
        (setq qmax (min qmax (- (+ L (/ Lnoi 2.0)) minCat)))
        (setq qmin (if dau (- minCat (/ Lnoi 2.0)) (+ prev (- minCat Lnoi))))
        (if (< qmin 0.0) (setq qmin 0.0))
        (setq uv (QS-UngVienQ qmax qmin vungs (/ Lnoi 2.0) prev dau Lcay Lnoi))
        (if (not dau)
          (progn (setq n2 0 out nil)
                 (foreach q uv
                   (if (< n2 5) (setq out (append out (list q)) n2 (1+ n2))))
                 (setq uv out)))
        (setq best nil bs nil)
        (foreach q uv
          (setq lenC (if dau (+ q (/ Lnoi 2.0)) (+ (- q prev) Lnoi)))
          (setq r (QS-TimCat L Lcay Lnoi minCat vungs q nil (1- sau)))
          (if r
            (progn
              (setq sc (+ (QS-DiemDoan lenC Lcay) (car r)))
              (if (or (null bs) (> sc bs))
                (setq bs sc best (cons q (cdr r))))
            )
          )
        )
        (if best (cons bs best) nil)
      )
    )
  )
)

(defun QS-SoLeQs (qs vungs d nua L Lcay Lnoi minCat / q2 ok x)
  (setq q2 (mapcar (function (lambda (x) (- x d))) qs) ok T)
  (foreach x q2 (if (not (QS-TrongVung x vungs nua)) (setq ok nil)))
  (if (and ok (QS-PlanHopLe (QS-QsToDoan q2 L Lnoi) L Lcay minCat vungs Lnoi))
    q2
    (progn
      (setq q2 (mapcar (function (lambda (x) (+ x d))) qs) ok T)
      (foreach x q2 (if (not (QS-TrongVung x vungs nua)) (setq ok nil)))
      (if (and ok (QS-PlanHopLe (QS-QsToDoan q2 L Lnoi) L Lcay minCat vungs Lnoi))
        q2
        qs)
    )
  )
)

(defun QS-DoanCatVungUu (L Lcay Lnoi minCat vungs mau soLe / r qs)
  (if (<= L (+ Lcay 1.0))
    nil
    (progn
      (setq *QS-MEMOC* nil)
      (setq r (QS-TimCat L Lcay Lnoi minCat vungs 0.0 T 12))
      (if (null r)
        (QS-DoanCatVung L Lcay Lnoi minCat vungs mau soLe)
        (progn
          (setq qs (cdr r))
          (if (and (> mau 0) qs)
            (setq qs (QS-SoLeQs qs vungs (* (float mau) soLe) (/ Lnoi 2.0)
                                L Lcay Lnoi minCat)))
          (QS-QsToDoan qs L Lnoi)
        )
      )
    )
  )
)

(defun QS-GiaoDoan (p1 p2 q1 q2 / r s d t1 t2)
  (setq r (list (- (car p2) (car p1)) (- (cadr p2) (cadr p1))))
  (setq s (list (- (car q2) (car q1)) (- (cadr q2) (cadr q1))))
  (setq d (- (* (car r) (cadr s)) (* (cadr r) (car s))))
  (if (< (abs d) 1.0e-12)
    nil
    (progn
      (setq t1 (/ (- (* (- (car q1) (car p1)) (cadr s))
                     (* (- (cadr q1) (cadr p1)) (car s))) d))
      (setq t2 (/ (- (* (- (car q1) (car p1)) (cadr r))
                     (* (- (cadr q1) (cadr p1)) (car r))) d))
      (if (and (>= t1 -1.0e-9) (<= t1 1.000000001)
               (>= t2 -1.0e-9) (<= t2 1.000000001))
        (list (+ (car p1) (* t1 (car r))) (+ (cadr p1) (* t1 (cadr r))) t1)
        nil
      )
    )
  )
)

(defun QS-ViTriZone (ssZ pts / res i n zp acc p q a b g)
  (setq res nil i 0 n (if ssZ (sslength ssZ) 0))
  (while (< i n)
    (setq zp (QS-DinhDuong (ssname ssZ i)))
    (if (and zp (>= (length zp) 2))
      (progn
        (setq acc 0.0 p (car pts))
        (foreach q (cdr pts)
          (setq a (car zp))
          (foreach b (cdr zp)
            (setq g (QS-GiaoDoan p q a b))
            (if g (setq res (cons (+ acc (* (caddr g) (distance p q))) res)))
            (setq a b)
          )
          (setq acc (+ acc (distance p q)) p q)
        )
      )
    )
    (setq i (1+ i))
  )
  (if res (QS-LocTrung (QS-Sap res '<)) nil)
)

(defun QS-ChiaZone (L dsZ cho / res prev z zj)
  (if (null dsZ)
    (list (list 0.0 L))
    (progn
      (setq res nil prev 0.0)
      (foreach z dsZ
        (setq zj (+ z cho))
        (if (and (> zj (+ prev 1.0)) (< zj (- L 1.0))
                 (> z  (+ prev 1.0)) (< z  (- L 1.0)))
          (progn
            (setq res (append res (list (list prev zj))))
            (setq prev (if (> cho 0.0) z zj))
          )
        )
      )
      (append res (list (list prev L)))
    )
  )
)

(defun QS-DoiVung (vungs d / res z)
  (setq res nil)
  (foreach z vungs
    (setq res (cons (list (- (car z) d) (- (cadr z) d)) res)))
  (reverse res)
)

(defun QS-Doc5 ( / tmpQS)
  (setq *QS5-CAY*  (vl-string-trim " " (get_tile "ccay"))
        *QS5-NOI*  (vl-string-trim " " (get_tile "cnoi"))
        *QS5-NOING* (vl-string-trim " " (get_tile "cnoing"))
        *QS5-MIN*  (vl-string-trim " " (get_tile "cmin"))
        *QS5-RND*  (vl-string-trim " " (get_tile "crnd"))
        *QS5-SOLE* (vl-string-trim " " (get_tile "csole"))
        *QS5-LECH* (vl-string-trim " " (get_tile "clech"))
        *QS5-KC*   (vl-string-trim " " (get_tile "ckc"))
        *QS5-TYL*  (vl-string-trim " " (get_tile "ctyle"))
        *QS5-TV*   (vl-string-trim " " (get_tile "ctv"))
        *QS5-VRAI* (get_tile "cvrai")
        *QS5-KRAI* (get_tile "ckrai")
        *QS5-KCRAI* (vl-string-trim " " (get_tile "ckcrai"))
        *QS5-BT_ENABLE* (get_tile "cbt_enable")
        *QS5-BT_NOFIRST* (get_tile "cbt_nofirst")
        *QS5-BT_SOLE* (get_tile "cbt_sole")
        *QS5-BT_L1* (vl-string-trim " " (get_tile "cbt_l1"))
        *QS5-BT_L2* (vl-string-trim " " (get_tile "cbt_l2"))
        *QS5-BT_SINGLE* (get_tile "cbt_single")
        *QS5-BT_GROUP* (get_tile "cbt_group")
        *QS5-BT_HUONG* (get_tile "cbt_huong")
        *QS5-BT_DAODAU* (get_tile "cbt_daodau")
        *QS5-XOA*  (get_tile "cxoa")
        *QS5-TAG*  (get_tile "ctag")
        *QS5-DAO*  (get_tile "cdao")
        *QS5-DIM*  (get_tile "cdim")
        *QS5-VUNG* (get_tile "cvung")
        *QS5-VUOT* (vl-string-trim " " (get_tile "cvuot"))
        *QS5-VTD*  (get_tile "cvtd")
        *QS5-LDAM* (vl-string-trim " " (get_tile "cldam"))
        *QS5-CHIA* (vl-string-trim " " (get_tile "cchia"))
        *QS5-MING* (vl-string-trim " " (get_tile "cming"))
        *QS5-LOPV* (get_tile "clopv")
        *QS5-SOLE2* (get_tile "csolea")
        *QS5-DNOI* (get_tile "cdnoi")
        *QS5-DMIN* (vl-string-trim " " (get_tile "cdmin"))
        *QS5-KNOI* (vl-string-trim " " (get_tile "cknoi"))
        *QS5-DNEOC* (get_tile "cdneoc")
        *QS5-KNEO* (vl-string-trim " " (get_tile "ckneo"))
        *QS5-PHOI* (get_tile "cphoi")
        *QS5-DSAI* (vl-string-trim " " (get_tile "cdsai"))
        *QS5-LTHEP* (vl-string-trim " " (get_tile "clthep")))
  (princ)
)
(defun QS-Accept5 ( / tmpQS l1 l2)
  (QS-Doc5)
  (setq l1 (QS-Num *QS5-BT_L1*) l2 (QS-Num *QS5-BT_L2*))
  (if (and (= *QS5-BT_ENABLE* "1") (/= *QS5-BT_NOFIRST* "1")
           (or (null l1) (<= l1 0.0) (> l1 (QS-Num *QS5-CAY*))))
    (progn (set_tile "cghichu" "[Loi] L1 phai nam trong gioi han cay thep.") (mode_tile "cbt_l1" 2))
    (if (and (= *QS5-BT_ENABLE* "1") (/= *QS5-BT_NOFIRST* "1") (= *QS5-BT_SOLE* "1")
             (or (null l2) (<= l2 0.0) (> l2 (QS-Num *QS5-CAY*))))
      (progn (set_tile "cghichu" "[Loi] L2 phai nam trong gioi han cay thep.") (mode_tile "cbt_l2" 2))
      (progn (setq *QS5-OK* T) (done_dialog 1))))
)

(defun QS-HopThoai5 ( / dclId lap rc pe)
  (setq *QS5-OK* nil)
  (setq dclId (QS-NapDCL) lap T)
  (while (and dclId lap)
    (progn
      (if (not (new_dialog "qs_catthep" dclId))
        (progn (princ "\n[Loi] Khong khoi tao duoc dialog qs_catthep.")
               (setq lap nil))
        (progn
          (set_tile "ccay"  (if *QS5-CAY*  *QS5-CAY*  "11700"))
          (set_tile "cnoi"  (if *QS5-NOI*  *QS5-NOI*  "50d"))
          (set_tile "cnoing" (if *QS5-NOING* *QS5-NOING* ""))
          (set_tile "cmin"  (if *QS5-MIN*  *QS5-MIN*  "2000"))
          (set_tile "crnd"  (if *QS5-RND*  *QS5-RND*  "5"))
          (set_tile "csole" (if *QS5-SOLE* *QS5-SOLE* "600"))
          (set_tile "clech" (if *QS5-LECH* *QS5-LECH* "70"))
          (set_tile "ckc"   (if *QS5-KC*   *QS5-KC*   "500"))
          (set_tile "ctyle" (if *QS5-TYL*  *QS5-TYL*  "50"))
          (set_tile "ctv"   (if *QS5-TV*   *QS5-TV*   ""))
          (set_tile "cvrai" (if *QS5-VRAI* *QS5-VRAI* "1"))
          (if (not *QS5-KRAI*) (setq *QS5-KRAI* "kr_trung"))
          (set_tile "ckrai" *QS5-KRAI*)
          (set_tile "ckcrai" (if *QS5-KCRAI* *QS5-KCRAI* "500"))
          (set_tile "cbt_enable" (if *QS5-BT_ENABLE* *QS5-BT_ENABLE* "0"))
          (set_tile "cbt_nofirst" (if *QS5-BT_NOFIRST* *QS5-BT_NOFIRST* "0"))
          (set_tile "cbt_sole" (if *QS5-BT_SOLE* *QS5-BT_SOLE* "0"))
          (set_tile "cbt_l1" (if *QS5-BT_L1* *QS5-BT_L1* "11700"))
          (set_tile "cbt_l2" (if *QS5-BT_L2* *QS5-BT_L2* "5850"))
          (set_tile "cbt_single" (if *QS5-BT_SINGLE* *QS5-BT_SINGLE* "0"))
          (set_tile "cbt_group" (if *QS5-BT_GROUP* *QS5-BT_GROUP* "1"))
          (set_tile "cbt_huong" (if *QS5-BT_HUONG* *QS5-BT_HUONG* "bh_trai"))
          (set_tile "cbt_daodau" (if *QS5-BT_DAODAU* *QS5-BT_DAODAU* "0"))
          (set_tile "cxoa"  (if *QS5-XOA*  *QS5-XOA*  "1"))
          (set_tile "ctag"  (if *QS5-TAG*  *QS5-TAG*  "1"))
          (set_tile "cdao"  (if *QS5-DAO*  *QS5-DAO*  "0"))
          (set_tile "cdim"  (if *QS5-DIM*  *QS5-DIM*  "1"))
          (set_tile "cvung" (if *QS5-VUNG* *QS5-VUNG* "1"))
          (set_tile "cvuot" (if *QS5-VUOT* *QS5-VUOT* "0"))
          (set_tile "cvtd"  (if *QS5-VTD*  *QS5-VTD*  "0"))
          (set_tile "cldam" (if *QS5-LDAM* *QS5-LDAM*
                              (if (and *QS4-LDAM* (/= *QS4-LDAM* ""))
                                *QS4-LDAM* "QS_NetKhuat")))
          (set_tile "cchia" (if *QS5-CHIA* *QS5-CHIA* "4"))
          (set_tile "cming" (if *QS5-MING* *QS5-MING* "1500"))
          (if (not *QS5-LOPV*) (setq *QS5-LOPV* "lv_duoi"))
          (set_tile "clopv" *QS5-LOPV*)
          (set_tile "csolea" (if *QS5-SOLE2* *QS5-SOLE2* "1"))
          (set_tile "cdnoi" (if *QS5-DNOI* *QS5-DNOI* "1"))
          (set_tile "cdmin" (if *QS5-DMIN* *QS5-DMIN* "0"))
          (set_tile "cknoi" (if *QS5-KNOI* *QS5-KNOI* "0"))
          (set_tile "cdneoc" (if *QS5-DNEOC* *QS5-DNEOC* "1"))
          (set_tile "ckneo" (if *QS5-KNEO* *QS5-KNEO* "150"))
          (set_tile "cphoi" (if *QS5-PHOI* *QS5-PHOI* "1"))
          (set_tile "cdsai" (if *QS5-DSAI* *QS5-DSAI* "600"))
          (set_tile "clthep" (if *QS5-LTHEP* *QS5-LTHEP* "QS_ThepChu"))
          (set_tile "cghichu"
            "Sau khi bam OK: quet chon cac duong thep can cat.")
          (action_tile "pkld" "(QS-Doc5)(done_dialog 8)")
          (action_tile "pkvc" "(QS-Doc5)(done_dialog 9)")
          (action_tile "accept" "(QS-Accept5)")
          (action_tile "cancel" "(done_dialog 0)")
          (setq rc (progn (QS-PJInit "qs_catthep") (start_dialog)))
          (cond
            ((= rc 8)
             (setq pe (entsel "\nChon 1 doi tuong thuoc layer NET DAM: "))
             (if pe (setq *QS5-LDAM* (cdr (assoc 8 (entget (car pe)))))))
            ((= rc 9)
             (QS-DongDCL)
             (c:OS_VUNGCAT)
             (setq dclId (QS-NapDCL)))
            (T (setq lap nil))
          )
        )
      )
    )
  )
  (QS-DongDCL)
  (princ)
)

(defun QS-BTOneEndPlan (L first stock lap minimum / out start remaining firstlen)
  (if (and (numberp L) (numberp first) (numberp stock) (numberp lap) (numberp minimum)
           (> L 0.0) (>= lap 0.0) (> stock lap) (> minimum lap)
           (<= minimum stock) (>= first minimum) (<= first stock))
    (if (<= L first)
      (list (list 0.0 L "FIRST"))
      (progn
        (setq out (list (list 0.0 first "FIRST")) start (- first lap)
              remaining (- L start))
        (while (> remaining (+ stock 0.000001))
          (setq out (append out (list (list start stock "MIDDLE")))
                start (+ start (- stock lap)) remaining (- L start)))
        (if (>= remaining (- minimum 0.000001))
          (append out (list (list start remaining "LAST"))) nil)))
    nil)
)

(defun QS-BTOneEndPlans (bars first1 first2 stock lap minimum soLe / res b first plan ok)
  (setq res nil ok (if bars T nil))
  (foreach b bars
    (setq first (if (and soLe (= 1 (rem (fix (car b)) 2))) first2 first1))
    (setq plan (QS-BTOneEndPlan (nth 4 b) first stock lap minimum))
    (if plan (setq res (cons (list (car b) first plan) res)) (setq ok nil)))
  (if ok (reverse res) nil)
)

(defun QS-BTOneEndCheck (bars plans stock lap minimum / ok p q b L total prev endpt n idx seen)
  (setq ok (and bars plans (= (length bars) (length plans))) seen nil)
  (foreach p plans
    (setq b (assoc (car p) bars) n (length (caddr p)) prev nil total 0.0 idx 0)
    (if (or (null b) (member (car p) seen) (= n 0)) (setq ok nil))
    (setq seen (cons (car p) seen))
    (if b
      (progn
        (setq L (nth 4 b))
        (foreach q (caddr p)
          (setq endpt (+ (car q) (cadr q)))
          (if (or (< (car q) -0.001) (<= (cadr q) 0.0)
                  (> (cadr q) (+ stock 0.001))
                  (and (> n 1) (< (cadr q) (- minimum 0.001)))
                  (> endpt (+ L 0.001))) (setq ok nil))
          (if (= idx 0)
            (if (or (> (abs (car q)) 0.001) (/= (caddr q) "FIRST")
                    (> (abs (- (cadr q) (min L (cadr p)))) 0.001)) (setq ok nil))
            (progn
              (if (> (abs (- (- (+ (car prev) (cadr prev)) (car q)) lap)) 0.001)
                (setq ok nil))
              (if (< idx (1- n))
                (if (or (/= (caddr q) "MIDDLE") (> (abs (- (cadr q) stock)) 0.001)) (setq ok nil))
                (if (/= (caddr q) "LAST") (setq ok nil)))))
          (setq total (+ total (cadr q)) prev q idx (1+ idx)))
        (if (or (> (abs (- endpt L)) 0.001)
                (> (abs (- total (+ L (* (1- n) lap)))) 0.001)) (setq ok nil)))))
  (if ok T nil)
)

(defun QS-BTFail (msg)
  (setq *QS-BT-LAST-ERROR* msg)
  (princ (strcat "\n[BT2] " msg))
  (/ 1 0)
)

(defun QS-BTSourceEntities (tag / ss i e x f h out)
  (setq h (cdr (assoc 5 (entget tag))) out (list tag)
        ss (ssget "_X" '((-3 ("DceBT2")))) i 0)
  (repeat (if ss (sslength ss) 0)
    (setq e (ssname ss i) x (QS-DocXDBT2 e))
    (if x
      (progn
        (setq f (QS-TachKT (car x) ";"))
        (if (and (member (car f) '("REP2" "BAO2" "RAI2" "CON2" "DIM2"))
                 (= (cadr f) h))
          (setq out (cons e out)))))
    (setq i (1+ i)))
  out
)

(defun QS-BTCommonMidCandidates (stock tv / out x)
  (setq out nil)
  (foreach x (append tv (list stock (/ stock 2.0) (/ stock 3.0)))
    (if (and (numberp x) (> x 0.0) (<= x stock)
             (not (vl-some (function (lambda (y) (< (abs (- x y)) 0.001))) out)))
      (setq out (append out (list x)))))
  out
)

(defun QS-CMIntersect (aa bb / out a b lo hi)
  (foreach a aa
    (foreach b bb
      (setq lo (max (car a) (car b)) hi (min (cadr a) (cadr b)))
      (if (<= lo (+ hi 0.000001))
        (setq out (cons (list lo (max lo hi)) out)))))
  (reverse out)
)

(defun QS-CMFirstRange (bar n mid stock lap minimum zones / L total lo hi allowed j shift region ranges)
  (setq L (nth 4 bar) total (- (+ L (* (1- n) lap)) (* (- n 2) mid)))
  (setq lo (max minimum (- total stock)) hi (min stock (- total minimum))
        allowed (if (<= lo hi) (list (list lo hi)) nil) j 0)
  (if (and (> n 2) (or (< mid minimum) (<= mid lap) (> mid stock))) (setq allowed nil))
  (while (and allowed zones (< j (1- n)))
    (setq ranges nil shift (* j (- mid lap)))
    (foreach region zones
      (if (>= (- (cadr region) (car region)) lap)
        (setq ranges (cons (list (- (+ (car region) lap) shift)
                                 (- (cadr region) shift)) ranges))))
    (setq allowed (QS-CMIntersect allowed ranges) j (1+ j)))
  allowed
)

(defun QS-CMFixedFirst (bar n mid firstlen lap / total lengths len start out j)
  (if (= n 1)
    (list (list 0.0 (nth 4 bar) "FIRST"))
    (progn
      (setq total (- (+ (nth 4 bar) (* (1- n) lap)) (* (- n 2) mid))
            lengths (list firstlen))
      (repeat (- n 2) (setq lengths (append lengths (list mid))))
      (setq lengths (append lengths (list (- total firstlen))) start 0.0 out nil j 0)
      (foreach len lengths
        (setq out (append out (list (list start len
          (cond ((= j 0) "FIRST") ((= j (1- n)) "LAST") (T "MIDDLE")))))
              start (+ start (- len lap)) j (1+ j)))
      out))
)

(defun QS-BTCommonMidForGroup (bars stock lap minimum tv zonesById / n L b cand ok out chosen entry allowed ranges firstlen)
  (setq n 1)
  (foreach b bars
    (setq L (nth 4 b))
    (while (> L (- (* n stock) (* (1- n) lap))) (setq n (1+ n))))
  (setq chosen nil)
  (foreach cand (QS-BTCommonMidCandidates stock tv)
    (if (null chosen)
      (progn
        (setq ok T out nil allowed (list (list minimum stock)))
        (foreach b bars
          (if (> n 1)
            (progn
              (setq entry (assoc (car b) zonesById))
              (setq ranges (if (and zonesById (null (cdr entry))) nil
                (QS-CMFirstRange b n cand stock lap minimum (cdr entry))))
              (setq allowed (QS-CMIntersect allowed ranges)))))
        (if allowed
          (progn
            (setq firstlen (apply 'max (mapcar 'cadr allowed)))
            (foreach b bars
              (setq out (append out (list (list (car b) 0.0
                (QS-CMFixedFirst b n cand firstlen lap))))))
            (setq chosen (list (if (> n 2) cand nil) out)))))))
  chosen
)

(defun QS-BTCommonMidPlan (bars stock lap minimum tv sole zonesById / groups row key out p n valid)
  (setq groups nil out nil valid (and bars (numberp stock) (numberp lap) (numberp minimum)
                  (> stock lap) (>= lap 0.0) (>= minimum lap) (> minimum 0.0) (<= minimum stock)))
  (if valid
    (progn
      (foreach p bars
        (if (<= (nth 4 p) 0.0) (setq valid nil))
        (setq n 1)
        (while (> (nth 4 p) (- (* n stock) (* (1- n) lap))) (setq n (1+ n)))
        (setq key (list (if sole (rem (fix (car p)) 2) 0) n) row (assoc key groups))
        (if row (setq groups (subst (append row (list p)) row groups))
          (setq groups (append groups (list (list key p))))))
      (foreach row groups
        (setq p (QS-BTCommonMidForGroup (cdr row) stock lap minimum tv zonesById))
        (if p (setq out (append out (list (list (car row) (car p) (cadr p)))))
          (setq valid nil)))))
  (if valid out nil)
)

(defun QS-BTSharedPlans (bars u v stock lap minimum sole / zones b pts regions model result group)
  (setq zones nil result nil)
  (if *QS-BT-REGIONS*
    (foreach b bars
      (setq pts (list (QS-Pt u v (nth 1 b) (nth 2 b)) (QS-Pt u v (nth 1 b) (nth 3 b))))
      (setq regions (QS-VungCat *QS-BT-REGIONS* pts u (nth 4 b)
        (if *QS-BT-ALLOW* *QS-BT-ALLOW* 0.0)))
      (setq zones (cons (cons (car b) regions) zones))))
  (setq model (QS-BTCommonMidPlan bars stock lap minimum
    (QS-TachSo (if *QS5-TV* *QS5-TV* "")) sole zones))
  (foreach group model (setq result (append result (nth 2 group))))
  result
)

(defun QS-BTMakePieces (tag stock noi minimum first1 first2 sole / model bars plans gv u v res pl b q p1 p2 ord)
  (setq model (QS-BT2Model tag) res nil)
  (if model
    (progn
      (setq bars (caddr model) gv (cadr model)
            u (list (nth 0 gv) (nth 1 gv)) v (list (nth 2 gv) (nth 3 gv))
            plans (if (eq first1 'REGION) (QS-BTSharedPlans bars u v stock noi minimum sole)
              (QS-BTOneEndPlans bars first1 first2 stock noi minimum sole)))
      (if (and plans (or (eq first1 'REGION) (QS-BTOneEndCheck bars plans stock noi minimum)))
        (foreach pl plans
          (setq b (assoc (car pl) bars) ord 0)
          (foreach q (caddr pl)
            (setq p1 (QS-Pt u v (nth 1 b) (+ (nth 2 b) (car q)))
                  p2 (QS-Pt u v (nth 1 b) (+ (nth 2 b) (car q) (cadr q))))
            (setq res (cons (list (fix (car b)) ord (caddr q) p1 p2 (cadr q)) res)
                  ord (1+ ord)))))))
  (reverse res)
)

(defun QS-BTDrawPiecesRaw (tag pieces lay single / made p e h text ok groups key pr g info pt tg sh count members item records rr u v chosen used ty)
  (setq made nil ok T h (cdr (assoc 5 (entget tag))) groups nil)
  (if single
    (foreach p pieces
      (setq e (QS-VePts (list (nth 3 p) (nth 4 p)) lay))
      (if e
        (progn
          (setq made (cons e made) *QS-CutMade* (cons e *QS-CutMade*))
          (QS-B2Write e "DceBTCut"
            (list (strcat "CUT;" h ";" (itoa (car p)) ";" (itoa (cadr p)) ";"
                          (nth 2 p) ";" (rtos (nth 5 p) 2 3))))
          (if (> (abs (- (QS-DaiPts (QS-DinhDuong e)) (nth 5 p))) 0.01)
            (setq ok nil)))
        (setq ok nil)))
    (foreach p pieces
      (setq key (list (rem (car p) 2) (cadr p) (nth 2 p) (if (and (= *QS5-BT_GROUP* "1") (= (nth 2 p) "LAST")) "VARIABLE" (rtos (nth 5 p) 2 3)))
            pr (assoc key groups))
      (if pr
        (setq groups (subst (append pr (list p)) pr groups))
        (setq groups (append groups (list (list key p))))))
  )
  (if (not single)
    (foreach g groups
      (setq p (cadr g) u (QS-DVi (nth 3 p) (nth 4 p)) v (list (- (cadr u)) (car u))
            records nil ty (nth 2 (QS-DocTag tag)))
      (foreach item (cdr g)
        (setq records (append records (list (list (car item)
          (QS-B2Dot (nth 3 item) v) (QS-B2Dot (nth 3 item) u) (QS-B2Dot (nth 4 item) u))))))
      (setq records (vl-sort records '(lambda (a b) (< (nth 1 a) (nth 1 b)))))
      (setq chosen (QS-ChonDaiDien records used (* 8.0 ty) (* 30.0 ty)))
      (setq used (cons (list (nth 1 chosen) (/ (+ (nth 2 chosen) (nth 3 chosen)) 2.0)) used))
      (setq p (assoc (car chosen) (cdr g)) e (QS-VePts (list (nth 3 p) (nth 4 p)) lay))
      (if e
        (progn
          (setq made (cons e made) *QS-CutMade* (cons e *QS-CutMade*) count (length (cdr g))
                text (strcat "CUTG;" h ";" (itoa count) ";"
                             (itoa (car p)) ";" (itoa (cadr p)) ";"
                             (nth 2 p) ";" (rtos (nth 5 p) 2 3)))
          (setq members (list text))
          (foreach item (cdr g)
            (setq members (append members
              (list (strcat "MEM;" (itoa (car item)) ";" (itoa (cadr item)) ";"
                (nth 2 item) ";" (rtos (car (nth 3 item)) 2 6) ";"
                (rtos (cadr (nth 3 item)) 2 6) ";"
                (rtos (car (nth 4 item)) 2 6) ";"
                (rtos (cadr (nth 4 item)) 2 6) ";" (rtos (nth 5 item) 2 6))))))
          (QS-B2Write e "DceBTCut" members))
        (setq ok nil))))
  (if ok (reverse made)
    (progn (foreach e made (if (entget e) (entdel e))) nil))
)

(defun QS-CutRead (e / app pair out)
  (setq app (assoc "DceBTCut" (cdr (assoc -3 (entget e '("DceBTCut"))))))
  (foreach pair (cdr app) (if (= (car pair) 1000) (setq out (cons (cdr pair) out))))
  (reverse out)
)
(defun QS-CutRequire (ok text)
  (if (not ok) (progn (setq *QS-CutError* text) (/ 1 0)))
  ok
)
(defun QS-CutTrack (e)
  (QS-CutRequire (and e (entget e)) "Khong tao duoc ghi chu doan cat")
  (setq *QS-CutMade* (cons e *QS-CutMade*))
  e
)
(defun QS-CutAnnotate (source bar label rnd / data f mem rows k pa pb u v rr info ti spc pt tag bao rai
                                           pos step gap prev row gx mn mx mck layers text raiStyle)
  (setq data (QS-CutRead bar) f (QS-TachKT (car data) ";") k 0)
  (setq u (QS-DVi (car (QS-DinhDuong bar)) (cadr (QS-DinhDuong bar))))
  (setq v (list (- (cadr u)) (car u)))
  (if (= (car f) "CUTG")
    (foreach mem (cdr data)
      (setq gx (QS-TachKT mem ";"))
      (QS-CutRequire (and (= (car gx) "MEM") (= (length gx) 9)) "Malformed MEM")
      (setq pa (list (atof (nth 4 gx)) (atof (nth 5 gx)))
            pb (list (atof (nth 6 gx)) (atof (nth 7 gx))))
      (setq rows (cons (list k (QS-B2Dot pa v) (QS-B2Dot pa u) (QS-B2Dot pb u) 0.0 0.0 0.0 nil) rows)
            k (1+ k)))
    (progn
      (setq pa (car (QS-DinhDuong bar)) pb (cadr (QS-DinhDuong bar)))
      (setq rows (list (list 0 (QS-B2Dot pa v) (QS-B2Dot pa u) (QS-B2Dot pb u) 0.0 0.0 0.0 nil)))))
  (setq rows (vl-sort rows '(lambda (a b) (< (nth 1 a) (nth 1 b)))))
  (QS-CutRequire (and rows (or (/= (car f) "CUTG") (= (length rows) (atoi (nth 2 f))))) "Mat thanh vien trong nhom")
  (setq info (QS-TTinBT rows) ti (QS-DocTag source) spc (QS-Space (QS-Doc)) pt (QS-GiuaDoanDai (QS-DinhDuong bar)))
  (setq step 0.0 prev nil)
  (foreach row rows
    (if prev
      (progn
        (setq gap (- (nth 1 row) prev))
        (if (= step 0.0) (setq step gap))
        (QS-CutRequire (and (> gap 0) (< (abs (- gap step)) 0.01)) "Khoang cach cac thanh trong nhom khong deu")))
    (setq prev (nth 1 row)))
  (setq text (strcat (itoa (length rows)) "%%c" (nth 1 ti)
    (if (> step 0) (strcat "a" (rtos step 2 0)) "")
    " (L=" (QS-ChuoiChieuDai (car info) (cadr info) rnd) ")"))
  (setq tag (QS-CutTrack (vlax-vla-object->ename (QS-ChenTagThep spc pt (nth 2 ti) text label "" (QS-GocDoc u)))))
  (setq bao nil rai nil)
  (if (> (length rows) 1)
    (progn
      (setq raiStyle (QS-CutRaiStyle (* 2.5 (nth 2 ti))
        (cond ((= *QS4-MT* "mt_cheo") "O") ((= *QS4-MT* "mt_cham") "D") (T "F"))))
      (setq bao (QS-CutTrack (QS-VeBaoBT rows u v "Defpoints")) pos (QS-B2Dot pt u))
      (setq rai (QS-CutTrack (QS-VeDuongRai spc (QS-Pt u v (nth 1 (car rows)) pos)
                       (QS-Pt u v (nth 1 (last rows)) pos) nil (* 2.5 (nth 2 ti)))))))
  (if rai (QS-DatKieuDim rai raiStyle))
  (setq mck (QS-TachFieldXData (QS-DocXDataTho source) 0) layers (QS-TachFieldXData (QS-DocXDataTho source) 4))
  (QS-GanBoLienKet bar tag rai (if mck mck "") label label (nth 1 ti) (if layers layers "1") step (length rows) "")
  (QS-GanXDBT tag info rows u v 0.0 -1.0 bao rnd)
  (QS-GhiXDBT bar (list (QS-ChuoiREP bar (cdr (assoc 5 (entget tag))) 0.0 0.0)))
  (if bao (QS-GhiXDBT bao (list (strcat "BAO;" (cdr (assoc 5 (entget tag)))))))
  (QS-GanXDBT2 tag bar info rows u v bao rai rnd)
  (QS-B2Write tag "DceBTCut" data)
  (QS-CutRequire (QS-BT2Model tag) "Nhom BT2 vua tao doc lai khong khop")
  (QS-CutRequire (= text (QS-LayTagBT tag)) "Doc lai tag khong khop")
  (length rows)
)
(defun QS-CutLapDims (source groups original displayed / h rnd ofs style bar data f bid ord p prev
                        u v spc dir pa pb startpt endpt mid tp obj e taglink src)
  (if (= *QS5-DNOI* "1")
    (progn
      (setq h (* 2.5 (nth 2 (QS-DocTag source))) rnd (QS-Num *QS5-RND*) ofs (QS-Num *QS5-KNOI*)
            spc (QS-Space (QS-Doc)) dir (if (= *QS5-DAO* "1") -1.0 1.0))
      (if (null rnd) (setq rnd 5.0))
      (if (or (null ofs) (<= ofs 0.0)) (setq ofs (* 2.5 h)))
      (QS-DamBaoLayer "QS_Dim" 254)
      (setq style (QS-CutNoiStyle h rnd "O"))
      (foreach bar groups
        (setq data (QS-CutRead bar) f (QS-TachKT (car data) ";"))
        (if (= (car f) "CUTG")
          (setq bid (atoi (nth 3 f)) ord (atoi (nth 4 f)))
          (setq bid (atoi (nth 2 f)) ord (atoi (nth 3 f))))
        (setq p nil prev nil)
        (foreach src original
          (if (and (= (car src) bid) (= (cadr src) (1- ord))) (setq prev src)))
        (foreach src displayed
          (if (and (= (car src) bid) (= (cadr src) ord)) (setq p src)))
        (if (and p prev)
          (progn
            (setq u (QS-DVi (nth 3 p) (nth 4 p)) v (list (- (cadr u)) (car u))
                  startpt (QS-B2Dot (nth 3 p) u) endpt (QS-B2Dot (nth 4 prev) u))
            (QS-CutRequire (> (- endpt startpt) 0.001) "Khong co doan chong de ghi dim moi noi")
            (setq pa (QS-Pt u v (QS-B2Dot (car (QS-DinhDuong bar)) v) startpt)
                  pb (QS-Pt u v (QS-B2Dot (car (QS-DinhDuong bar)) v) endpt)
                  mid (mapcar '(lambda (a b) (/ (+ a b) 2.0)) pa pb)
                  tp (QS-Cong mid v (* dir ofs)))
            (setq obj (vla-AddDimAligned spc (vlax-3d-point pa) (vlax-3d-point pb) (vlax-3d-point tp)))
            (setq e (QS-CutTrack (vlax-vla-object->ename obj)))
            (vla-put-Layer obj "QS_Dim")
            (vla-put-StyleName obj style)
            (vla-put-TextPosition obj (vlax-3d-point tp))
            (setq taglink (cadr (QS-TachKT (car (QS-DocXDBT2 bar)) ";")))
            (QS-GhiXDBT2 e (list (strcat "DIM2;" taglink)))
            (QS-CutRequire (< (abs (- (vla-get-Measurement obj) (- endpt startpt))) 0.01)
                           "Dim moi noi do sai chieu dai"))))))
)

(defun QS-CutDisplayShift (bar / tag model rows lens delta u v shift zero vec)
  (setq tag (QS-TagCuaEnt bar) model (if tag (QS-BT2Model tag)))
  (QS-CutRequire model "Thieu du lieu thanh thep thuc (BAR)")
  (setq rows (caddr model) lens (mapcar '(lambda (r) (nth 4 r)) rows)
        delta (QS-Num *QS5-LECH*))
  (if (null delta) (setq delta 70.0))
  (setq shift 0.0)
  (if (< (- (apply 'max lens) (apply 'min lens)) 0.01)
    (progn
      (setq vec (QS-TachKT (car (QS-CutRead bar)) ";"))
      (setq shift (* delta (if (= *QS5-DAO* "1") -1.0 1.0)
        (1+ (atoi (nth (if (= (car vec) "CUTG") 4 3) vec)))))))
  (setq u (list (nth 0 (cadr model)) (nth 1 (cadr model)))
        v (list (nth 2 (cadr model)) (nth 3 (cadr model)))
        zero (vlax-3d-point '(0.0 0.0 0.0))
        vec (vlax-3d-point (list (* shift (car v)) (* shift (cadr v)) 0.0)))
  (if (/= shift 0.0)
    (progn (vla-Move (vlax-ename->vla-object bar) zero vec)
           (vla-Move (vlax-ename->vla-object tag) zero vec)))
  (QS-B2Write bar "QS_CutDisplay" (list (strcat "OFFSET;" (rtos (* shift (car v)) 2 8)
      ";" (rtos (* shift (cadr v)) 2 8))))
  (QS-GhiXDBT bar (list (QS-ChuoiREP bar (cdr (assoc 5 (entget tag))) 0.0 0.0)))
)
(defun QS-CutBuild (tag pieces lay single / groups bar prefix count idx rnd q original)
  (QS-CutRequire (and tag (entget tag) pieces) "Khong co doan cat dau vao")
  (foreach q (list lay "QS_Block" "QS_Symbol" "Defpoints") (QS-DamBaoLayer q 7))
  (vla-put-Color (vla-Item (vla-get-Layers (QS-Doc)) lay) 1)
  (QS-TaoBlockTag)
  (setq original pieces)
  (setq groups (QS-BTDrawPiecesRaw tag pieces lay single))
  (foreach bar groups (vla-put-Color (vlax-ename->vla-object bar) 256))
  (setq *QS-CutMade* (append groups *QS-CutMade*))
  (QS-CutRequire groups "Cat doan that bai")
  (setq prefix (strcat (nth 4 (QS-DocTag tag)) ".") idx 0 count 0
        rnd (if (QS-Num *QS5-RND*) (max 1 (fix (QS-Num *QS5-RND*))) 5))
  (foreach bar groups
    (setq idx (1+ idx) count (+ count (QS-CutAnnotate tag bar (strcat prefix (itoa idx)) rnd))))
  (QS-CutRequire (= count (length pieces)) "Tong so doan cat khong khop")
  (foreach bar groups (QS-CutDisplayShift bar))
  (QS-CutLapDims tag groups original pieces)
  groups
)
(defun QS-BTDrawPieces (tag pieces lay single / *QS-CutMade* *QS-CutError* result e)
  (setq *QS-CutMade* nil *QS-CutError* nil)
  (setq result (vl-catch-all-apply 'QS-CutBuild (list tag pieces lay single)))
  (if (vl-catch-all-error-p result)
    (progn
      (foreach e *QS-CutMade* (if (entget e) (entdel e)))
      (princ (strcat "\n[CUT] " (if *QS-CutError* *QS-CutError* (vl-catch-all-error-message result)))) nil)
    result)
)

(defun QS-BTPointEqual (a b)
  (and a b (< (distance (list (car a) (cadr a)) (list (car b) (cadr b))) 0.01))
)
(defun QS-BTPairEqual (a b c d)
  (or (and (QS-BTPointEqual a c) (QS-BTPointEqual b d))
      (and (QS-BTPointEqual a d) (QS-BTPointEqual b c)))
)
(defun QS-BTPhuCu (tag source / e data f rep rai pts owner ss i ed a b p q hits out
                                    cross cp radius ti center candidates)
  (setq rep nil rai nil out nil)
  (foreach e source
    (setq data (QS-DocXDBT2 e) f (if data (QS-TachKT (car data) ";")))
    (cond ((equal (car f) "REP2") (setq rep e))
          ((equal (car f) "RAI2") (setq rai e))))
  (if (and rep (entget rep))
    (progn
      (setq pts (QS-DinhDuong rep) owner (cdr (assoc 330 (entget rep))))
      (setq ss (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Dim"))) i 0)
      (repeat (if ss (sslength ss) 0)
        (setq e (ssname ss i) ed (entget e) i (1+ i))
        (if (and (equal owner (cdr (assoc 330 ed)))
                 (wcmatch (cdr (assoc 3 ed)) "QS_Thep_*")
                 (member (logand 7 (cdr (assoc 70 ed))) '(0 1)))
          (progn
            (setq a (cdr (assoc 13 ed)) b (cdr (assoc 14 ed)) p (car pts))
            (foreach q (cdr pts)
              (if (and (not (member e out)) (QS-BTPairEqual a b p q))
                (setq out (cons e out)))
              (setq p q)))))
      (if (and rai (entget rai))
        (progn
          (setq ed (entget rai) a (cdr (assoc 13 ed)) b (cdr (assoc 14 ed))
                p (car pts) hits nil)
          (foreach q (cdr pts)
            (setq cross (if (and a b) (inters p q a b T)))
            (if cross (setq hits (cons cross hits)))
            (setq p q))
          (if (= (length hits) 1)
            (progn
              (setq center (car hits) ti (QS-DocTag tag) radius (* 0.625 (nth 2 ti)))
              (setq ss (ssget "_X" '((0 . "CIRCLE") (8 . "QS_Symbol,DCE_Symbol"))) i 0 candidates nil)
              (repeat (if ss (sslength ss) 0)
                (setq e (ssname ss i) ed (entget e) i (1+ i))
                (if (and (equal owner (cdr (assoc 330 ed)))
                         (QS-BTPointEqual (cdr (assoc 10 ed)) center)
                         (< (abs (- (cdr (assoc 40 ed)) radius)) 0.01))
                  (setq candidates (cons e candidates))))
              (cond ((= (length candidates) 1) (setq out (cons (car candidates) out)))
                    ((> (length candidates) 1)
                     (princ "\n[BT2] Nhieu ky hieu trung diem: giu lai de tranh xoa nham.")))))))))
  out
)

(defun QS-BTDeleteSource (source / deleted e ok)
  (setq deleted nil ok T)
  (foreach e source
    (if (entget e)
      (if (entdel e) (setq deleted (cons e deleted)) (setq ok nil))))
  (if (not ok)
    (foreach e deleted (if (null (entget e)) (entdel e))))
  ok
)

(defun QS-BTCutSingle (tag stock noi minimum first1 first2 sole eraseSource single / pieces source made e ti dia lap)
  (setq ti (QS-DocTag tag) dia (nth 1 ti)
        lap (if (and noi (vl-string-search "D" (strcase noi)))
              (* (atof (QS-SoDau noi)) (atof dia))
              (atof (if noi noi "0"))))
  (if (<= lap 0.0) (setq lap (* 50.0 (atof dia))))
  (setq pieces (QS-BTMakePieces tag stock lap minimum first1 first2 sole))
  (if pieces
    (progn
      (setq source (QS-BTSourceEntities tag))
      (setq source (append (QS-BTPhuCu tag source) source))
      (setq made (QS-BTDrawPieces tag pieces "QS_ThepCatBT" single))
      (if (and made eraseSource (not (QS-BTDeleteSource source)))
        (progn (foreach e made (if (entget e) (entdel e))) (setq made nil)))
      (if made (list (length pieces) (length made) eraseSource) nil))
    nil)
)

(defun c:OS_CATTHEP ( / *error* doc spc ss ssTag n i ent lst Lcay Lnoi minCat soLe lechY kcMau raiSR tnL pNew soLGTr soLGKh
                         tyleV rnd tv mau2 xoaGoc coTag daoL coDim noiStr sgn cao u v
                         L tag ti sn dia tyT gxT shT lay ptsG ptsD plan mau cnt cnt0
                         cnt1 pc dd dx dy e2 ptM base dsPiece dsPar dsSub par sub k
                         rec lab dkv dsDim soCat soBo oldecho hdlT tagObj tagEnt
                         coVung vuot ssV vungs soLeA coNoi dmin dkG aKC rai dsNoi pR1
                         pR2 wv Lb a2 ptB0 ptB1 sufx mckG truRai layThep ssRai ssCir
                         etype ed veRai kcRai pR2n svB svB0 vP1 soKRai a1 kieuRai pMid
                         tRai uRai ddR0 ddR1 dotwv idR dsIdR ndNoi kNoi coNeoC dsNeoG
                         dsNeoC z kNeoC coZone layZone cho1 cho2 choMax ssZ eZ dsZ
                         soZone lap rc pe maMT maNeo mauNeo coVTD layDamV nchiaV minGV
                         dsDamC lopTren flt noiNgStr LnoiNg LnoiC soNgoaiV ngv0 pA pB
                         ii coPhoi dsai ddich ddich0 raiH dsRaiH idBar hR eR dsRaiDone
                         btTags btTag btResult btL1 btL2 btSole btSingle *QS-BT-REGIONS* *QS-BT-ALLOW* v3Roots)

  (defun *error* (msg)
    (QS-DongDCL)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (princ "\n=== OS_CATTHEP - CAT / NOI THEP THEO CHIEU DAI CAY THEP ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)
  (setq spc (QS-Space doc))
  (setq *QS5-OK* nil)

  (QS-HopThoai5)

  (if (not *QS5-OK*)
    (princ "\nDa huy lenh.")
    (progn
      (setq Lcay   (if (QS-Num *QS5-CAY*)  (QS-Num *QS5-CAY*)  11700.0)
            minCat (if (QS-Num *QS5-MIN*)  (QS-Num *QS5-MIN*)  2000.0)
            rnd    (if (QS-Num *QS5-RND*)  (fix (QS-Num *QS5-RND*)) 5)
            soLe   (if (QS-Num *QS5-SOLE*) (QS-Num *QS5-SOLE*) 600.0)
            lechY  (if (QS-Num *QS5-LECH*) (QS-Num *QS5-LECH*) 70.0)
            kcMau  (if (QS-Num *QS5-KC*)   (QS-Num *QS5-KC*)   500.0)
            tyleV  (if (QS-Num *QS5-TYL*)  (QS-Num *QS5-TYL*)  50.0)
            noiStr (if *QS5-NOI* *QS5-NOI* "50d")
            noiNgStr (if *QS5-NOING* *QS5-NOING* "")
            tv     (QS-TachSo (if *QS5-TV* *QS5-TV* ""))
            soLeA  (= *QS5-SOLE2* "1")
            mau2   (= *QS5-SOLE2* "1")
            veRai  (/= *QS5-VRAI* "0")
            truRai (= *QS5-KRAI* "kr_trung")
            kcRai  (if (QS-Num *QS5-KCRAI*) (QS-Num *QS5-KCRAI*) 500.0)
            xoaGoc (= *QS5-XOA* "1")
            btL1 (if (QS-Num *QS5-BT_L1*) (QS-Num *QS5-BT_L1*) 11700.0)
            btL2 (if (QS-Num *QS5-BT_L2*) (QS-Num *QS5-BT_L2*) 5850.0)
            btSole (= *QS5-BT_SOLE* "1")
            btSingle (and (= *QS5-BT_SINGLE* "1") (/= *QS5-BT_GROUP* "1"))
            coTag  (= *QS5-TAG* "1")
            daoL   (= *QS5-DAO* "1")
            coDim  (= *QS5-DIM* "1")
            coVung (= *QS5-VUNG* "1")
            coVTD  (= *QS5-VTD* "1")
            layDamV (if *QS5-LDAM* *QS5-LDAM* "")
            nchiaV (if (QS-Num *QS5-CHIA*) (QS-Num *QS5-CHIA*) 4.0)
            minGV  (if (QS-Num *QS5-MING*) (QS-Num *QS5-MING*) 1500.0)
            lopTren (= *QS5-LOPV* "lv_tren")
            vuot   (if (QS-Num *QS5-VUOT*) (QS-Num *QS5-VUOT*) 0.0)
            coNoi  (= *QS5-DNOI* "1")
            dmin   (if (QS-Num *QS5-DMIN*) (QS-Num *QS5-DMIN*) 0.0)
            kNoi   (if (QS-Num *QS5-KNOI*) (QS-Num *QS5-KNOI*) 0.0)
            coNeoC (/= *QS5-DNEOC* "0")
            kNeoC  (if (QS-Num *QS5-KNEO*) (QS-Num *QS5-KNEO*) 150.0)
            coZone nil layZone "" cho1 500.0 cho2 1000.0 choMax 0.0
            coPhoi (= *QS5-PHOI* "1") *QS-LG-MN* nil soLGTr 0 soLGKh 0
            dsai   (if (QS-Num *QS5-DSAI*) (QS-Num *QS5-DSAI*) 600.0)
            layThep (if (and *QS5-LTHEP* (/= *QS5-LTHEP* ""))
                      *QS5-LTHEP* "QS_ThepChu"))
      (if (< rnd 1) (setq rnd 1))
      (setq sgn (if daoL -1.0 1.0))
      (setq cao (* 2.5 tyleV))

      (setq maMT (cond ((= *QS4-MT* "mt_cheo") "O")
                       ((= *QS4-MT* "mt_cham") "D")
                       (T "F")))
      (setq maNeo "O")
      (QS-TaoBlockTag)
      (QS-DamBaoLayer "QS_Block" 7)
      (QS-DamBaoLayer "QS_Dim" 3)

      (princ "\n\nQuet chon THANH THEP + TAG + DUONG RAI can cat:")
      (princ (strcat "\n   (da loc san - chi nhan duong thep layer " layThep
                     ", tag layer DCE_Block, duong rai layer DCE_Symbol"
                     (if (and coVTD (/= layDamV ""))
                       (strcat ", NET DAM layer " layDamV) "")
                     ")"))
      (if (and coVTD (/= layDamV ""))
        (princ "\n   QUET LUON NET DAM trong pham vi nay de xac dinh vung cat."))
      (setq flt (list '(-4 . "<OR")
                        '(-4 . "<AND")
                          '(-4 . "<OR") '(0 . "LWPOLYLINE") '(0 . "LINE") '(-4 . "OR>")
                          (cons 8 layThep)
                        '(-4 . "AND>")
                        '(-4 . "<AND") '(0 . "INSERT") '(8 . "QS_Block,DCE_Block") '(-4 . "AND>")
                        '(-4 . "<AND")
                          '(-4 . "<OR") '(0 . "DIMENSION") '(0 . "CIRCLE") '(-4 . "OR>")
                          '(8 . "QS_Symbol,DCE_Symbol")
                        '(-4 . "AND>")))
      (if (and coVTD (/= layDamV "") (/= (strcase layDamV) (strcase layThep)))
        (setq flt (append flt
                    (list '(-4 . "<AND")
                            '(-4 . "<OR") '(0 . "LINE") '(0 . "LWPOLYLINE")
                            '(0 . "POLYLINE") '(-4 . "OR>")
                            (cons 8 layDamV)
                          '(-4 . "AND>")))))
      (setq flt (append flt (list '(-4 . "OR>"))))
      (setq ss (ssget flt))
      ;; v20.15: tach nhom QS_BT_V3 - cat sau khi da co vung cat / net dam
      (setq v3Roots (QS-V3TachNhom ss) ss (cdr v3Roots) v3Roots (car v3Roots))
      (if (and (null ss) v3Roots) (setq ss (ssadd)))
      (if (not ss)
        (princ "\nKhong chon duoc thanh thep nao. Huy lenh.")
        (progn
          (setq ssV nil dsDamC nil)
          (if coVTD (setq coVung T))
          (if (and coVung (not coVTD))
            (progn
              (princ "\n\nChon cac duong RANH VUNG CAT  (2 duong = 1 vung duoc phep noi): ")
              (setq ssV (ssget '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "LINE")
                                 (-4 . "OR>"))))
              (if (null ssV)
                (princ "\n[Chu y] Khong chon duoc duong ranh nao - se cat tu do.")
                (if (/= 0 (rem (sslength ssV) 2))
                  (progn
                    (princ (strcat "\n[Chu y] Da chon " (itoa (sslength ssV))
                                   " duong ranh - SO DUONG PHAI CHAN (2 duong = 1 vung)."
                                   " Duong le cuoi cung se bi bo qua."))
                  )
                )
              )
            )
          )

          (setq ssZ nil)
          (if coZone
            (progn
              (if (= layZone "")
                (progn
                  (princ "\n\nPick 1 duong RANH ZONE thi cong de lay layer: ")
                  (setq eZ (entsel))
                  (if eZ
                    (setq layZone (cdr (assoc 8 (entget (car eZ))))))
                )
              )
              (if (/= layZone "")
                (progn
                  (setq ssZ (ssget "_X" (list (cons 8 layZone)
                              '(-4 . "<OR") '(0 . "LINE") '(0 . "LWPOLYLINE")
                              '(0 . "POLYLINE") '(-4 . "OR>"))))
                  (princ (strcat "\n   Layer ranh zone: " layZone "  -  "
                                 (itoa (if ssZ (sslength ssZ) 0)) " duong."))
                )
                (princ "\n[Chu y] Chua co layer ranh zone - bo qua buoc tach theo zone.")
              )
            )
          )
          (setq *QS-NGOAIVUNG* 0 *QS-PHOI* nil soNgoaiV 0
                *QS-NHIPC* nil *QS-MEMOC* nil *QS-SSDIM* nil)

          (setq ssTag (ssadd) ssRai (ssadd) ssCir (ssadd) lst nil btTags nil)
          (setq n (sslength ss) i 0)
          (while (< i n)
            (setq ent (ssname ss i) ed (entget ent))
            (setq etype (cdr (assoc 0 ed)))
            (cond
              ((and (= etype "INSERT") (QS-DocXDBT2 ent))
               (setq btTag (QS-TagCuaEnt ent))
               (if (and btTag (not (member btTag btTags))) (setq btTags (cons btTag btTags))))
              ((and (= etype "LWPOLYLINE") (QS-DocXDBT2 ent))
               (setq btTag (QS-TagCuaEnt ent))
               (if (and btTag (not (member btTag btTags))) (setq btTags (cons btTag btTags))))
              ((= etype "INSERT")    (ssadd ent ssTag))
              ((= etype "DIMENSION") (ssadd ent ssRai))
              ((= etype "CIRCLE")    (ssadd ent ssCir))
              ((and coVTD (/= layDamV "")
                    (= (strcase (cdr (assoc 8 ed))) (strcase layDamV)))
               (setq dsDamC (cons (vlax-ename->vla-object ent) dsDamC)))
              (T (setq lst (cons ent lst))))
            (setq i (1+ i))
          )
          (setq lst (reverse lst))
          (if (= 0 (sslength ssTag)) (setq ssTag nil))
          (if (= 0 (sslength ssRai)) (setq ssRai nil))
          (if (= 0 (sslength ssCir)) (setq ssCir nil))
          (if (null ssTag)
            (setq ssTag (ssget "_X" '((0 . "INSERT") (8 . "QS_Block,DCE_Block")))))
          (princ (strcat "\n   -> " (itoa (length lst)) " thanh thep, "
                         (itoa (if ssTag (sslength ssTag) 0)) " tag, "
                         (itoa (if ssRai (sslength ssRai) 0)) " duong rai, "
                         (itoa (if ssCir (sslength ssCir) 0)) " vong tron"
                         (if coVTD (strcat ", " (itoa (length dsDamC))
                                           " net dam") "") "."))
          (if coVTD
            (if (null dsDamC)
              (progn
                (princ (strcat "\n[Chu y] Tap chon khong co net dam nao tren layer \""
                               layDamV "\" - tat che do tu dong, se cat tu do."))
                (setq coVTD nil coVung nil))
              (progn
                (princ (strcat "\n   VUNG CAT TU DONG: chia L/" (rtos nchiaV 2 0)
                               ", nhip min " (rtos minGV 2 0) " mm."))
                (princ (if lopTren
                         "\n      Thep LOP TREN -> moi noi dat o GIUA nhip."
                         "\n      Thep LOP DUOI -> moi noi dat tai GOI (om qua dam)."))
              )
            )
          )
          (setq *QS-BT-REGIONS* ssV *QS-BT-ALLOW* vuot)
          (if (and btTags (= *QS5-BT_ENABLE* "1"))
            (foreach btTag btTags
              (setq btResult
                (if (= *QS5-BT_NOFIRST* "1")
                  (if (or coVTD (and ssV (/= 0 (rem (sslength ssV) 2))))
                    (progn (princ "\n[BT2] Chon cap ranh thu cong hop le; giu nguon.") nil)
                    (QS-BTCutSingle btTag Lcay noiStr minCat 'REGION nil soLeA xoaGoc btSingle))
                  (QS-BTCutSingle btTag Lcay noiStr minCat btL1 btL2 btSole xoaGoc btSingle)))
              (if btResult
                (princ (strcat "\n[BT2] Da cat " (itoa (car btResult)) " doan BT2."))
                (princ "\n[BT2] Cat BT2 that bai - giu nguyen nguon."))))
          (if (and btTags (/= *QS5-BT_ENABLE* "1"))
            (princ "\n[BT2] Da nhan dien nhom BT2 nhung dang tat tuy chon cat BT2."))
          (if (and (null lst) (null v3Roots))
            (princ "\n[Chu y] Tap chon khong co thanh thep nao (kiem tra lai layer thep)."))
          (if v3Roots (QS-V3CatNhom v3Roots))

          (setq dsPiece nil soCat 0 soBo 0 dsDim nil dsNoi nil
                dsRaiH nil dsIdR nil idBar 0 dsRaiDone nil soKRai 0
                dsNeoC nil *QS-NEODONE* nil soZone 0)
          (foreach ent lst
            (setq ptsG (QS-DinhDuong ent))
            (setq L (if ptsG (QS-DaiPts ptsG) 0.0))
            (if (or (null ptsG) (< (length ptsG) 2) (<= L (+ Lcay 1.0)))
              (setq soBo (1+ soBo))
              (progn
                (setq lay (cdr (assoc 8 (entget ent))))
                (setq tag (QS-TagCuaThep ent (QS-DiemTai ptsG (/ L 2.0)) ssTag))
                (setq ti  (QS-DocTag tag))
                (setq sn (nth 0 ti) dia (nth 1 ti) tyT (nth 2 ti)
                      gxT (nth 3 ti) shT (nth 4 ti) dkG (nth 5 ti))
                (setq aKC (QS-DocKhoangCach dkG))

                (setq mckG (QS-TachFieldXData (QS-DocXDataTho ent) 0))
                (if (or (null mckG) (= mckG ""))
                  (setq mckG (if tag
                               (QS-TachFieldXData (QS-DocXDataTho tag) 0) "")))
                (if (null mckG) (setq mckG ""))
                (if (<= sn 0) (setq sn 1))
                (if (or (null dia) (= dia "")) (setq dia "10"))

                (if (or (null tag) (null tyT) (<= tyT 0.001)) (setq tyT tyleV))

                (setq cao (* 2.5 tyT))

                (if (vl-string-search "D" (strcase noiStr))
                  (setq Lnoi (* (atof (QS-SoDau noiStr)) (atof dia)))
                  (setq Lnoi (atof (QS-SoDau noiStr))))
                (if (<= Lnoi 0.0) (setq Lnoi (* 50.0 (atof dia))))

                (setq LnoiNg 0.0)
                (if (/= noiNgStr "")
                  (progn
                    (if (vl-string-search "D" (strcase noiNgStr))
                      (setq LnoiNg (* (atof (QS-SoDau noiNgStr)) (atof dia)))
                      (setq LnoiNg (atof (QS-SoDau noiNgStr))))
                    (if (< LnoiNg 0.0) (setq LnoiNg 0.0))))
                (setq u (QS-HuongPts ptsG))
                (setq v (list (- (cadr u)) (car u)))
                (if mau2
                  (setq cnt0 (fix (/ (+ sn 1) 2)) cnt1 (- sn (fix (/ (+ sn 1) 2))))
                  (setq cnt0 sn cnt1 0))
                (setq vungs
                  (cond (coVTD (QS-VungCatTD dsDamC ptsG u L vuot nchiaV minGV
                                             lopTren))
                        (ssV   (QS-VungCat ssV ptsG u L vuot))
                        (T nil)))
                (setq idBar (1+ idBar))
                (setq soKRai (if soKRai soKRai 0))
                (setq rai (if (or veRai soLeA xoaGoc)
                            (QS-TimDuongRai ptsG u v (max 1.0 (* 0.02 cao))
                                            ssCir ssRai)
                            nil))

                ;; v20.28: pham vi rai (vuong goc) cua thanh -> xet "ke ben" giua cac thanh trong lan quet
                (setq raiSR (QS-LGDaiRai ptsG
                              (if rai rai (QS-TimDuongRai ptsG u v (max 1.0 (* 0.02 cao)) ssCir ssRai))
                              aKC))
                (setq sufx (if (> aKC 0.0)
                             (strcat "a" (rtos (if soLeA (* 2.0 aKC) aKC) 2 0))
                             ""))

                (setq pMid (QS-DiemTai ptsG (/ L 2.0)))
                (setq svB0 (+ (* (car pMid) (car v)) (* (cadr pMid) (cadr v))))

                (setq tRai nil ddR0 0.0 ddR1 (if mau2 (* sgn kcMau) 0.0))
                (if (and rai (car rai) (caddr rai))
                  (progn
                    (setq uRai (+ (* (car (caddr rai)) (car u))
                                  (* (cadr (caddr rai)) (cadr u))))
                    (setq tRai (QS-PTaiChieu ptsG u uRai))
                  )
                )

                (setq dsZ (if (and coZone ssZ) (QS-ViTriZone ssZ ptsG) nil))
                (if dsZ (setq soZone (+ soZone (length dsZ))))
                (setq dsNeoG (if coNeoC
                               (QS-LayDimNeo2 ptsG u v
                                 (max 200.0 (+ (* 1.5 (if (> kNeoC 0.0) kNeoC
                                                        (* 2.5 cao))) 100.0)))
                               nil))

                (setq mauNeo (if (and mau2 (> (* sgn kcMau) 0.0)) 1 0))
                (setq mau 0 ddich0 0.0)
                (while (<= mau (if (and mau2 (> cnt1 0)) 1 0))

                  (setq dsSub (QS-ChiaZone L dsZ (if (= mau 0) cho1 cho2)))
                  (setq ngv0 *QS-NGOAIVUNG* LnoiC Lnoi)
                  (setq plan (QS-PlanBar dsSub L Lcay LnoiC minCat vungs
                                         mau soLe tv))

                  (if (and vungs plan (> LnoiNg Lnoi)
                           (not (QS-PlanHopLe plan L Lcay minCat vungs Lnoi)))
                    (progn
                      (setq *QS-NGOAIVUNG* ngv0 LnoiC LnoiNg)
                      (setq plan (QS-PlanBar dsSub L Lcay LnoiC minCat vungs
                                             mau soLe tv))
                      (setq soNgoaiV (1+ (if soNgoaiV soNgoaiV 0)))
                    )
                  )
                  (if (null plan) (setq plan nil))

                  (if (and coPhoi plan vungs (null dsZ))
                    (progn

                      (setq ddich
                        (QS-DichToiUu plan L Lcay minCat vungs LnoiC
                                      dsai (float rnd)
                                      (if (= mau 0) nil (- ddich0 soLe))
                                      (* 0.5 soLe)))
                      (if (= mau 0) (setq ddich0 ddich))
                      (if (/= ddich 0.0)
                        (setq plan (QS-DichPlan plan ddich L)))
                    )
                  )
                  ;; v20.28: khong trung moi noi voi thanh KHAC trong lan quet (nhom rai xen ke)
                  (if (and plan (cdr plan) soLe (> soLe 0.0))
                    (progn
                      (setq tnL (QS-LGKeBen ent ptsG raiSR))
                      (if (QS-V3TrungT ptsG plan tnL)
                        (progn
                          (setq pNew (if vungs (QS-V3TranhVung (list idBar ent ptsG plan) ptsG L vungs tnL Lcay LnoiC minCat)))
                          (if (null pNew)
                            (setq pNew (QS-V3NeTrung (list idBar ent ptsG plan) vungs L Lcay LnoiC minCat tnL)))
                          (if pNew
                            (setq plan (QS-LGParity pNew) soLGTr (1+ soLGTr))
                            (setq soLGKh (1+ soLGKh)))))
                      (QS-LGGhi ent ptsG plan raiSR)))
                  (setq cnt (if (= mau 0) cnt0 cnt1))
                  (setq base (if (= mau 0) 0.0 (* sgn kcMau)))
                  (if (= mau 0) (setq ddR0 base) (setq ddR1 base))

                  (if (and mau2 (> cnt1 0))
                    (setq ndNoi (if (= mau 0)
                                  (list (* -1.0 sgn (car v)) (* -1.0 sgn (cadr v)))
                                  (list (* sgn (car v)) (* sgn (cadr v)))))
                    (progn
                      (setq ndNoi (list (- (cadr u)) (car u)))
                      (if (or (< (cadr ndNoi) -1.0e-9)
                              (and (< (abs (cadr ndNoi)) 1.0e-9)
                                   (> (car ndNoi) 0.0)))
                        (setq ndNoi (list (- (car ndNoi)) (- (cadr ndNoi)))))
                    )
                  )

                  (if plan (QS-GhiPhoi plan (max 1 cnt)))
                  (foreach pc plan
                    (setq dd (+ base (* sgn lechY (float (caddr pc)))))
                    (if (and tRai (<= (car pc) tRai) (>= (cadr pc) tRai))
                      (if (= mau 0) (setq ddR0 dd) (setq ddR1 dd)))

                    (if (= mau mauNeo)
                      (foreach z dsNeoG
                        (if (and (<= (car pc) (nth 3 z)) (>= (cadr pc) (nth 3 z)))
                          (setq dsNeoC
                            (cons (list (QS-Pt u v (+ svB0 dd) (nth 1 z))
                                        (QS-Pt u v (+ svB0 dd) (nth 2 z)))
                                  dsNeoC)))))
                    (setq dx (* (car v) dd) dy (* (cadr v) dd))
                    (setq ptsD (QS-PtsDoan ptsG (car pc) (cadr pc) dx dy))
                    (setq e2 (QS-VePts ptsD lay))
                    (if e2
                      (progn
                        (setq soCat (1+ soCat))

                        (setq ptM (QS-GiuaDoanDai ptsD))
                        (setq dsPiece
                          (cons (list e2 shT (QS-KhoaPts ptsD rnd)
                                      (QS-DaiPts ptsD) cnt ptM tyT gxT dia sufx
                                      (list idBar mau) mckG sn)
                                dsPiece))
                      )
                    )
                  )

                  (if (and coNoi plan (> (length plan) 1))
                    (progn
                      (setq ii 0)
                      (while (< ii (1- (length plan)))
                        (setq pA (QS-DiemTai ptsG (car (nth (1+ ii) plan)))
                              pB (QS-DiemTai ptsG (cadr (nth ii plan))))
                        (setq dsNoi
                          (cons (list (QS-Cong pA v base) (QS-Cong pB v base)
                                      ndNoi)
                                dsNoi))
                        (setq ii (1+ ii))
                      )
                    )
                  )
                  (setq mau (1+ mau))
                )

                (if (and (or veRai soLeA) (null rai))
                  (setq soKRai (1+ soKRai)))

                (if (and rai (car rai))
                  (progn
                    (setq pR1 (caddr rai) pR2n (cadddr rai))
                    (setq pR1 (list (car pR1) (cadr pR1)))
                    (setq pR2n (list (car pR2n) (cadr pR2n)))
                    (setq Lb (distance pR1 pR2n))
                    (if (or (not veRai) (< Lb 1.0))

                      (progn
                        (setq raiH (cdr (assoc 5 (entget (car rai)))))
                        (setq idR (QS-IDNhomRai (car rai)))
                        (if (or (null idR) (= idR "")) (setq idR (QS-IDMoi)))
                        (QS-GanXDRai (car rai) mckG shT dia "1" idR sn "")
                        (setq dsRaiH (cons (cons (list idBar 0) raiH) dsRaiH))
                        (setq dsIdR (cons (cons (list idBar 0) idR) dsIdR))
                        (if (and mau2 (> cnt1 0))
                          (progn
                            (setq dsRaiH (cons (cons (list idBar 1) raiH) dsRaiH))
                            (setq dsIdR (cons (cons (list idBar 1) idR) dsIdR))))
                      )

                      (progn
                        (setq wv (list (/ (- (car pR2n) (car pR1)) Lb)
                                       (/ (- (cadr pR2n) (cadr pR1)) Lb)))

                        (setq svB svB0)
                        (setq dotwv (+ (* (car wv) (car v)) (* (cadr wv) (cadr v))))
                        (setq vP1 (+ (* (car pR1) (car v)) (* (cadr pR1) (cadr v))))

                        (setq ptB0 (QS-Cong pR1 wv
                                     (* (+ (- svB vP1) ddR0) dotwv)))

                        (setq a1 (if (> aKC 0.0) aKC
                                   (/ Lb (max 1.0 (float (1- sn))))))
                        (setq a2 (if mau2 (* 2.0 a1) a1))

                        (setq kieuRai (cdr (assoc 3 (entget (car rai)))))

                        (QS-XoaVongTronRai pR1 pR2n nil (max 1.0 (* 0.6 cao)))
                        (setq raiH (QS-VeDuongRai spc pR1
                                     (QS-Cong pR1 wv (* (float (1- cnt0)) a2))
                                     ptB0 cao))
                        (QS-DatKieuDim raiH kieuRai)
                        (if raiH
                          (progn
                            (setq idR (QS-IDMoi))
                            (QS-GanXDRai raiH mckG shT dia "1" idR sn "")
                            (setq dsRaiH (cons (cons (list idBar 0)
                                                     (cdr (assoc 5 (entget raiH))))
                                               dsRaiH))
                            (setq dsIdR (cons (cons (list idBar 0) idR) dsIdR))))
                        (if (and mau2 (> cnt1 0))
                          (progn

                            (setq pR2 (QS-Cong pR1 wv a1))
                            (if (not truRai)
                              (setq pR2 (QS-Cong pR2 u (* sgn kcRai))))

                            (setq ptB1 (QS-Cong
                                         (QS-Cong pR1 wv
                                           (+ a1 (* (+ (- svB vP1) ddR1) dotwv)))
                                         u (if truRai 0.0 (* sgn kcRai))))
                            (setq raiH (QS-VeDuongRai spc pR2
                                         (QS-Cong pR2 wv (* (float (1- cnt1)) a2))
                                         ptB1 cao))
                            (QS-DatKieuDim raiH kieuRai)
                            (if raiH
                              (progn
                                (setq idR (QS-IDMoi))
                                (QS-GanXDRai raiH mckG shT dia "1" idR sn "")
                                (setq dsRaiH (cons (cons (list idBar 1)
                                                         (cdr (assoc 5 (entget raiH))))
                                                   dsRaiH))
                                (setq dsIdR (cons (cons (list idBar 1) idR) dsIdR))))
                          )
                        )

                        (vl-catch-all-apply 'entdel (list (car rai)))
                        (if (cadr rai)
                          (vl-catch-all-apply 'entdel (list (cadr rai))))
                      )
                    )
                  )
                )
                (if xoaGoc
                  (progn
                    (QS-XoaDimCuaThep ptsG (max 1.0 (* 0.02 cao)))

                    (foreach z dsNeoG
                      (vl-catch-all-apply 'entdel (list (car z))))
                    (entdel ent)
                    (if tag (entdel tag))))
              )
            )
          )
          (setq dsPiece (reverse dsPiece))

          (if (null dsPiece)
            (princ (strcat "\nKhong co thanh nao dai hon " (rtos Lcay 2 0)
                           " mm  -  khong can cat."))
            (progn

              (setq dsPar nil)
              (foreach rec dsPiece
                (if (not (member (nth 1 rec) dsPar))
                  (setq dsPar (append dsPar (list (nth 1 rec))))))
              (setq dsSub nil)
              (foreach par dsPar
                (setq lst nil)
                (foreach rec dsPiece
                  (if (and (= (nth 1 rec) par) (not (assoc (nth 2 rec) lst)))
                    (setq lst (cons (cons (nth 2 rec) (nth 3 rec)) lst))))
                (setq lst (vl-sort lst
                            (function (lambda (a b)
                              (if (equal (cdr a) (cdr b) 0.6)
                                (< (car a) (car b))
                                (> (cdr a) (cdr b)))))))
                (setq sub 1)
                (foreach k lst
                  (setq dsSub (cons (cons (strcat par "##" (car k))
                                          (strcat par "." (itoa sub))) dsSub))
                  (setq sub (1+ sub)))
              )

              (setq oldecho (getvar "CMDECHO"))
              (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
              (foreach rec dsPiece
                (setq lab (cdr (assoc (strcat (nth 1 rec) "##" (nth 2 rec)) dsSub)))
                (if (null lab) (setq lab (nth 1 rec)))
                (if coTag
                  (progn
                    (setq dkv (strcat (itoa (nth 4 rec)) "%%c" (nth 8 rec)
                                      (nth 9 rec)
                                      " (L=" (itoa (QS-LamTron (nth 3 rec) rnd)) ")"))
                    (setq tagObj (QS-ChenTagThep spc (nth 5 rec) (nth 6 rec)
                                                 dkv lab "" (nth 7 rec)))

                    (QS-CanGiuaTagU tagObj (nth 5 rec)
                                    (list (cos (nth 7 rec)) (sin (nth 7 rec))))
                    (setq tagEnt (vlax-vla-object->ename tagObj))
                    (setq hdlT (cdr (assoc 5 (entget tagEnt))))
                    (setq hR (cdr (assoc (nth 10 rec) dsRaiH)))
                    (setq eR (if (and hR (/= hR ""))
                               (vl-catch-all-apply 'handent (list hR))))
                    (if (or (null eR) (vl-catch-all-error-p eR)) (setq eR nil))

                    (setq idR (cdr (assoc (nth 10 rec) dsIdR)))
                    (if (null idR) (setq idR (QS-IDMoi)))
                    (QS-GanXDThep (nth 0 rec) (nth 11 rec) lab (nth 8 rec) "1"
                                  idR (QS-DocKhoangCach
                                        (strcat "%%c" (nth 8 rec) (nth 9 rec))))
                    (QS-GanXDTag tagEnt (nth 11 rec) lab (nth 8 rec) "1"
                                 (cdr (assoc 5 (entget (nth 0 rec))))
                                 (nth 12 rec))

                    (setq hR (cdr (assoc (nth 10 rec) dsRaiH)))
                    (if hR
                      (progn
                        (QS-GanLinkRai tagEnt hR)
                        (QS-GanLinkRai (nth 0 rec) hR)

                      )
                    )
                  )
                )
                (if coDim (setq dsDim (cons (nth 0 rec) dsDim)))
              )
              (if dsDim (QS-GhiDimThep (reverse dsDim) cao rnd 0.0 dmin nil maMT T))

              (setq dsNeoC (QS-LocTrungCap (reverse dsNeoC)))
              (setq dsNoi  (QS-LocTrungCap (reverse dsNoi)))
              (if (and coNeoC dsNeoC)
                (QS-GhiDimCap dsNeoC cao rnd
                              (if (> kNeoC 0.0) kNeoC (* 2.5 cao)) maNeo))

              (if (and coNoi dsNoi)
                (QS-GhiDimNoiCap dsNoi cao rnd
                                 (if (> kNoi 0.0) kNoi (* 2.5 cao)) maNeo))
              (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))

              (princ (strcat "\n\n[HOAN TAT] Da cat " (itoa (length dsPar))
                             " so hieu me thanh " (itoa soCat) " doan thep."))
              (if (> (+ soLGTr soLGKh) 0)
                (princ (strcat "\n   So le giua cac thanh quet chung: dich " (itoa soLGTr)
                               " phuong an de moi noi cach >= " (rtos soLe 2 0) " mm"
                               (if (> soLGKh 0) (strcat "; " (itoa soLGKh) " khong tach duoc (vung / cay qua hep)") ""))))
              (princ (strcat "\n   Cay thep " (rtos Lcay 2 0) " mm  -  noi "
                             (rtos Lnoi 2 0) " mm  -  so le moi noi "
                             (rtos soLe 2 0) " mm  -  lech Y "
                             (rtos lechY 2 0) " mm"))
              (if (not coVung)
                (princ "\n   Khong co vung cat: cat lien tiep cay NGUYEN 11700, phan du don ve mot dau (mau so le dao dau)."))
              (if soLeA
                (princ "\n   CAT SO LE: moi mau nua so thanh, tag ghi khoang cach a x 2.")
                (princ "\n   Khong so le: cat theo dung khoang rai cu, 1 duong rai."))
              (if veRai
                (princ (strcat "\n   Da ve lai duong rai"
                               (if (and soLeA truRai) " (2 duong TRUNG len nhau)"
                                 (if soLeA
                                   (strcat " (2 duong canh nhau " (rtos kcRai 2 0) " mm)")
                                   ""))
                               " va lien ket voi thep + tag."))
                (princ "\n   Da GIU duong rai goc - cac doan cat deu link vao duong rai cu."))
              (if (> soKRai 0)
                (princ (strcat "\n[Canh bao] Co " (itoa soKRai)
                               " thanh thep KHONG tim thay duong rai -"
                               " hay quet chon luon duong rai (DIMENSION tren"
                               " layer DCE_Symbol) cung voi thanh thep.")))
              (if dsRaiH
                (princ (strcat "\n   Da lien ket " (itoa (length dsRaiH))
                               " nhom doan cat voi duong rai (XDATA QS_Rai).")))
              (if (and coNoi dsNoi)
                (princ (strcat "\n   Da ghi dim cho " (itoa (length dsNoi))
                               " doan noi chong nhau.")))
              (if (and coNeoC dsNeoC)
                (princ (strcat "\n   Da ve lai dim cho " (itoa (length dsNeoC))
                               " doan neo o hai dau.")))
              (if tv
                (princ (strcat "\n   Thu vien L co " (itoa (length tv))
                               " gia tri - da uu tien chon cay it phe lieu nhat.")))
              (if (> soZone 0)
                (progn
                  (princ (strcat "\n   ZONE THI CONG: da tach tai " (itoa soZone)
                                 " cho cat ranh zone."))
                  (princ (strcat "\n      thanh 1: " (rtos cho1 2 0) " mm  ->  "
                                 (if (> cho1 0.0)
                                   (strcat "CHO ra khoi ranh zone, 2 doan CHONG NHAU "
                                           (rtos cho1 2 0) " mm")
                                   (strcat "thep zone KE BEN di qua zone nay "
                                           (rtos (abs cho1) 2 0) " mm"))))
                  (princ (strcat "\n      thanh 2: " (rtos cho2 2 0) " mm  ->  "
                                 (if (> cho2 0.0)
                                   (strcat "CHO ra khoi ranh zone, 2 doan CHONG NHAU "
                                           (rtos cho2 2 0) " mm")
                                   (strcat "thep zone KE BEN di qua zone nay "
                                           (rtos (abs cho2) 2 0) " mm"))))
                  (if (or (and (> cho1 0.0) (< cho1 Lnoi))
                          (and (> cho2 0.0) (< cho2 Lnoi)))
                    (princ (strcat "\n[Canh bao] Doan cho NGAN HON chieu dai noi ("
                                   (rtos Lnoi 2 0)
                                   " mm) - doan chong nhau khong du de noi thep.")))
                  (if (equal cho1 cho2 0.5)
                    (princ "\n[Canh bao] 2 doan cho BANG NHAU - moi noi tai ranh zone se THANG HANG, khong so le."))
                )
              )
              (if (> soBo 0)
                (princ (strcat "\n   Bo qua " (itoa soBo)
                               " thanh ngan hon 1 cay thep (khong can cat).")))
              (if (and (> soNgoaiV 0) (/= noiNgStr ""))
                (princ (strcat "\n   Co " (itoa soNgoaiV)
                               " thanh khong dat het moi noi trong vung"
                               " -> da cat lai voi chieu dai noi NGOAI VUNG = "
                               noiNgStr ".")))
              (if coVung
                (if ssV
                  (progn
                    (princ (strcat "\n   Gioi han moi noi trong "
                                   (itoa (/ (sslength ssV) 2))
                                   " vung cat (cho vuot " (rtos vuot 2 0) " mm)."))
                    (if (> *QS-NGOAIVUNG* 0)
                      (princ (strcat "\n[Canh bao] Co " (itoa *QS-NGOAIVUNG*)
                                     " moi noi KHONG dat duoc trong vung cho phep"
                                     " (vung qua xa nhau so voi 1 cay thep)"
                                     " - da dat tai vi tri toi da.")))
                  )
                  (princ "\n   Khong co duong ranh vung cat - da cat tu do.")))
              (princ "\n   So hieu phu danh theo chieu dai GIAM DAN trong tung so hieu me.")
              (if *QS-PHOI* (QS-BaoCaoPhoi Lcay))
            )
          )
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-DocLinkRai (ent / raw xd app it)
  (setq raw (vl-catch-all-apply 'entget (list ent (list "QS_Rai"))))
  (if (or (vl-catch-all-error-p raw) (null raw))
    nil
    (if (setq xd (assoc -3 raw))
      (progn
        (setq app (cadr xd) it (nth 1 app))
        (if (and it (= (car it) 1000)) (cdr it) nil)
      )
    )
  )
)

(defun QS-DatDKVAKC (eTag s / obj a)
  (setq obj (vl-catch-all-apply 'vlax-ename->vla-object (list eTag)))
  (if (not (vl-catch-all-error-p obj))
    (progn
      (foreach a (vlax-invoke obj 'GetAttributes)
        (if (= (strcase (vla-get-TagString a)) "DKVAKC")
          (vla-put-TextString a s)))
      (vl-catch-all-apply 'vla-Update (list obj))
      T
    )
  )
)

(defun QS-TagGanRai (eDim / ed p1 p2 wl w ss j m eT pt dx dy tu tv best bd)
  (setq ed (vl-catch-all-apply 'entget (list eDim)))
  (if (or (vl-catch-all-error-p ed) (null ed))
    nil
    (progn
      (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
      (if (null p1) (setq p1 (cdr (assoc 10 ed))))
      (if (and p1 p2
               (> (setq wl (distance (list (car p1) (cadr p1))
                                     (list (car p2) (cadr p2)))) 1.0))
        (progn
          (setq w (list (/ (- (car p2) (car p1)) wl)
                        (/ (- (cadr p2) (cadr p1)) wl)))
          (setq ss (if *QS-IXTSS* *QS-IXTSS*
                     (ssget "_X" '((0 . "INSERT") (8 . "QS_Block,DCE_Block")))))
          (setq j 0 m (if ss (sslength ss) 0) best nil bd nil)
          (while (< j m)
            (setq eT (ssname ss j))
            (setq pt (cdr (assoc 10 (entget eT))))
            (if pt
              (progn
                (setq dx (- (car pt) (car p1)) dy (- (cadr pt) (cadr p1)))
                (setq tu (+ (* dx (car w)) (* dy (cadr w))))
                (setq tv (abs (- (* dx (cadr w)) (* dy (car w)))))
                (if (and (> tu (* -0.30 wl)) (< tu (* 1.30 wl))
                         (or (null bd) (< tv bd)))
                  (setq bd tv best eT))))
            (setq j (1+ j)))
          best
        )
      )
    )
  )
)

(defun QS-TagCuaRai (eDim / h e)
  (setq h (QS-DocLinkRai eDim))
  (if (or (null h) (= h ""))
    (setq h (QS-TachFieldXData (QS-DocXDataTho eDim) 2)))
  (if (and h (/= h ""))
    (progn
      (setq e (vl-catch-all-apply 'handent (list h)))
      (if (and e (not (vl-catch-all-error-p e)) (entget e)
               (= (cdr (assoc 0 (entget e))) "INSERT"))
        e (QS-TagGanRai eDim))
    )
    (QS-TagGanRai eDim)
  )
)

(defun QS-ThepTheoIDRaiHet (idRai / ss i n e res)
  (if *QS-IX*
    (cdr (assoc idRai *QS-IXBAR*))
    (progn
  (setq ss (ssget "_X" '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "LINE")
                         (-4 . "OR>") (8 . "QS_ThepChu,DCE_ThepChu"))))
  (setq i 0 n (if ss (sslength ss) 0) res nil)
  (while (< i n)
    (setq e (ssname ss i))
    (if (equal (QS-IDNhomRai e) idRai) (setq res (cons e res)))
    (setq i (1+ i))
  )
  (reverse res)
    )
  )
)

(defun QS-GhiSoThanhTag (eTag n / ti dk moi)
  (setq ti (QS-DocTag eTag) dk (nth 5 ti))
  (if (and dk (/= dk ""))
    (progn
      (setq moi (strcat (itoa n) (substr dk (1+ (strlen (QS-SoDau dk))))))
      (if (/= moi dk) (progn (QS-DatDKVAKC eTag moi) T) nil)
    )
  )
)

(defun QS-CapNhatMotRai (eDim / ed p1 p2 L eTag eBar dsBar b ti dk dia aKC n
                              idRai hB xd dem)
  (setq ed (vl-catch-all-apply 'entget (list eDim)))
  (if (or (vl-catch-all-error-p ed) (null ed))
    nil
    (progn
      (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
      (setq idRai (QS-IDNhomRai eDim))
      (setq dsBar (if idRai (QS-ThepTheoIDRaiHet idRai) nil))
      (setq eBar (car dsBar))
      (if (null eBar) (setq eBar (if idRai (QS-ThepTheoIDRai idRai nil))))
      (setq eTag (if eBar
                   (QS-TagTheoHandleThep (cdr (assoc 5 (entget eBar))) nil)))
      (if (null eTag) (setq eTag (QS-TagCuaRai eDim)))
      (if (and p1 p2 (or eTag dsBar))
        (progn
          (setq L (distance (list (car p1) (cadr p1)) (list (car p2) (cadr p2))))
          (setq aKC (if eBar (QS-KCTrenThep eBar) 0.0))
          (if (<= aKC 0.0)
            (progn
              (setq ti (if eTag (QS-DocTag eTag)))
              (setq dk (if ti (nth 5 ti)))
              (if dk (setq aKC (QS-DocKhoangCach dk)))))
          (if (and aKC (> aKC 0.0) (> L 0.0))
            (progn
              (setq n (1+ (fix (+ 0.5 (/ L aKC)))))
              (if (< n 1) (setq n 1))
              (setq dem 0)

              (foreach b dsBar
                (setq eTag (QS-TagTheoHandleThep (cdr (assoc 5 (entget b))) nil))
                (if (and eTag (QS-GhiSoThanhTag eTag n)) (setq dem (1+ dem))))

              (if (and (= dem 0) (null dsBar))
                (progn
                  (setq eTag (QS-TagCuaRai eDim))
                  (if (and eTag (QS-GhiSoThanhTag eTag n)) (setq dem 1))))
              (if (> dem 0)
                (progn
                  (setq xd (QS-DocXDataTho eDim))
                  (if xd
                    (progn
                      (setq hB (vl-string-search "(5)_" xd))
                      (if hB
                        (QS-GanXDataChuoi eDim
                          (strcat (substr xd 1 (+ hB 4)) (itoa n))))))
                  T
                )
                nil
              )
            )
          )
        )
      )
    )
  )
)

(defun c:OS_CAPNHATRAI ( / *error* doc ss i n e dem tong oldecho cuBusy)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n=== OS_CAPNHATRAI - CAP NHAT SO THANH THEO DUONG RAI ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)
  (setq oldecho (getvar "CMDECHO"))
  (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
  (setq cuBusy *QS-RAI-BUSY*)
  (setq *QS-RAI-BUSY* T)
  (princ "\n\nQuet chon cac DUONG RAI can cap nhat  (Enter = ca ban ve): ")
  (setq ss (ssget '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol"))))
  (if (null ss)
    (setq ss (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol")))))
  (if (null ss)
    (princ "\nKhong co duong rai nao tren layer DCE_Symbol.")
    (progn
      (setq i 0 n (sslength ss) dem 0 tong 0)
      (princ (strcat "\n   Dang lap chi muc thep + tag ..."))
      (QS-LapChiMuc)
      (princ (strcat "\n   " (itoa n) " duong rai  |  "
                     (itoa (length *QS-IXBAR*)) " nhom thep  |  "
                     (itoa (length *QS-IXTAG*)) " tag co lien ket."))
      (while (< i n)
        (setq e (ssname ss i))
        (if (QS-TagCuaRai e) (setq tong (1+ tong)))
        (if (QS-CapNhatMotRai e) (setq dem (1+ dem)))
        (setq i (1+ i))
      )
      (QS-XoaChiMuc)
      (princ (strcat "\n\n[HOAN TAT] Xet " (itoa n) " duong rai, "
                     (itoa tong) " duong co lien ket voi tag, da cap nhat "
                     (itoa dem) " tag."))
      (if (= tong 0)
        (princ (strcat "\n[Chu y] Khong duong rai nao co lien ket."
                       " Thep ve bang ban cu chua co XDATA lien ket -"
                       " ve lai bang OS_THEPSAN (v8.3 tro len) hoac chay"
                       " OS_NOILAIRAI de noi lai lien ket theo hinh hoc.")))
    )
  )
  (QS-XoaChiMuc)
  (setq *QS-RAI-BUSY* cuBusy)
  (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
  (vla-EndUndoMark doc)
  (princ)
)

(defun c:OS_NOILAIRAI ( / *error* doc ssD ssT i n j m eD eT ed p1 p2 pt
                          w wl best bd dem hT hD)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n=== OS_NOILAIRAI - NOI LAI LIEN KET DUONG RAI <-> TAG ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)
  (setq ssD (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol"))))
  (setq ssT (ssget "_X" '((0 . "INSERT") (8 . "QS_Block,DCE_Block"))))
  (if (or (null ssD) (null ssT))
    (princ "\nKhong tim thay duong rai hoac tag trong ban ve.")
    (progn
      (setq i 0 n (sslength ssD) dem 0)
      (while (< i n)
        (setq eD (ssname ssD i) ed (entget eD))
        (setq p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
        (if (and p1 p2 (> (distance (list (car p1) (cadr p1))
                                    (list (car p2) (cadr p2))) 1.0))
          (progn
            (setq wl (distance (list (car p1) (cadr p1)) (list (car p2) (cadr p2))))
            (setq w (list (/ (- (car p2) (car p1)) wl)
                          (/ (- (cadr p2) (cadr p1)) wl)))
            (setq j 0 m (sslength ssT) best nil bd nil)
            (while (< j m)
              (setq eT (ssname ssT j))
              (setq pt (cdr (assoc 10 (entget eT))))
              (if pt
                (progn

                  (setq hT (+ (* (- (car pt) (car p1)) (car w))
                              (* (- (cadr pt) (cadr p1)) (cadr w))))
                  (if (and (>= hT -1.0) (<= hT (+ wl 1.0)))
                    (progn
                      (setq hD (distance (list (car pt) (cadr pt))
                                 (list (+ (car p1) (* hT (car w)))
                                       (+ (cadr p1) (* hT (cadr w))))))
                      (if (or (null bd) (< hD bd)) (setq bd hD best eT))
                    )
                  )
                )
              )
              (setq j (1+ j))
            )
            (if best
              (progn
                (QS-GanLinkRai eD (cdr (assoc 5 (entget best))))
                (QS-GanLinkRai best (cdr (assoc 5 (entget eD))))
                (setq dem (1+ dem))
              )
            )
          )
        )
        (setq i (1+ i))
      )
      (princ (strcat "\n\n[HOAN TAT] Da noi lai lien ket cho " (itoa dem)
                     " / " (itoa n) " duong rai."))
      (princ "\n   Gio chay OS_CAPNHATRAI sau moi lan keo dai duong rai.")
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-RaiPhanUng (obj reac par / e)
  (if (not *QS-RAI-BUSY*)
    (progn
      (setq *QS-RAI-BUSY* T)
      (setq e (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (and e (not (vl-catch-all-error-p e)))
        (vl-catch-all-apply 'QS-CapNhatMotRai (list e)))
      (setq *QS-RAI-BUSY* nil)
    )
  )
  (princ)
)

(defun QS-BoReactorRai ( / r)
  (foreach r (if *QS-RAI-REAC* *QS-RAI-REAC* nil)
    (vl-catch-all-apply 'vlr-remove (list r)))
  (setq *QS-RAI-REAC* nil)
  (princ)
)

(defun c:OS_RAILIVE ( / ss i n e dem)
  (princ "\n=== OS_RAILIVE - TU CAP NHAT SO THANH KHI KEO DUONG RAI ===")
  (if *QS-RAI-REAC*
    (progn
      (QS-BoReactorRai)
      (princ "\nDa TAT che do tu cap nhat.")
    )
    (progn
      (setq ss (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Symbol,DCE_Symbol"))))
      (if (null ss)
        (princ "\nKhong tim thay duong rai nao.")
        (progn
          (setq i 0 n (sslength ss) dem 0 *QS-RAI-REAC* nil *QS-RAI-BUSY* nil)
          (while (< i n)
            (setq e (ssname ss i))
            (if (QS-TagCuaRai e)
              (progn
                (setq *QS-RAI-REAC*
                  (cons (QS-TaoReactor
                          (list (vlax-ename->vla-object e)) "QSRai"
                          '((:vlr-modified . QS-RaiPhanUng)))
                        *QS-RAI-REAC*))
                (setq dem (1+ dem))
              )
            )
            (setq i (1+ i))
          )
          (princ (strcat "\nDa BAT che do tu cap nhat cho " (itoa dem)
                         " duong rai co lien ket."))
          (princ "\n   Keo dai / thu ngan duong rai -> so thanh trong tag tu doi.")
          (princ "\n   Che do nay chi con trong PHIEN nay; mo lai ban ve phai bat lai.")
          (princ "\n   Go OS_RAILIVE lan nua de TAT.")
        )
      )
    )
  )
  (princ)
)

(defun QS-DVi (a b / L)
  (setq L (distance a b))
  (if (< L 1.0e-9) nil (list (/ (- (car b) (car a)) L) (/ (- (cadr b) (cadr a)) L)))
)

(defun QS-Them (p d t1)
  (list (+ (car p) (* t1 (car d))) (+ (cadr p) (* t1 (cadr d))))
)

(defun QS-VeThanh2 (p1 p2 lay / e)
  (if (entmake (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)
                     '(100 . "AcDbPolyline") '(90 . 2) '(70 . 0)
                     (cons 10 (list (car p1) (cadr p1)))
                     (cons 10 (list (car p2) (cadr p2)))))
    (entlast) nil)
)

(defun QS-TamDinh (pts / sx sy n p)
  (setq sx 0.0 sy 0.0 n 0)
  (foreach p pts (setq sx (+ sx (car p)) sy (+ sy (cadr p)) n (1+ n)))
  (if (> n 0) (list (/ sx n) (/ sy n)) nil)
)

(defun QS-PhapNgoai (a b cen / d m mid s)
  (setq d (QS-DVi a b))
  (if (null d)
    nil
    (progn
      (setq m (list (- (cadr d)) (car d)))
      (setq mid (list (/ (+ (car a) (car b)) 2.0) (/ (+ (cadr a) (cadr b)) 2.0)))
      (setq s (+ (* (- (car mid) (car cen)) (car m)) (* (- (cadr mid) (cadr cen)) (cadr m))))
      (if (< s 0.0) (list (- (car m)) (- (cadr m))) m)
    )
  )
)

(defun QS-LaGocVuong (a b c / d1 d2)
  (setq d1 (QS-DVi b a) d2 (QS-DVi b c))
  (if (or (null d1) (null d2))
    nil
    (< (abs (+ (* (car d1) (car d2)) (* (cadr d1) (cadr d2)))) 0.09)
  )
)

(defun QS-NapLinetype (ten / r)
  (if (tblsearch "LTYPE" ten)
    T
    (progn
      (command "_.-LINETYPE" "_L" ten "acadiso.lin" "")
      (if (not (tblsearch "LTYPE" ten))
        (command "_.-LINETYPE" "_L" ten "acad.lin" ""))
      (if (tblsearch "LTYPE" ten) T nil)
    )
  )
)

(defun QS-TaoLayer (ten mau lt / moi)
  (setq moi (not (tblsearch "LAYER" ten)))
  (if (and moi lt (/= lt "Continuous")) (QS-NapLinetype lt))
  (if moi
    (entmakex
      (list '(0 . "LAYER")
            '(100 . "AcDbSymbolTableRecord")
            '(100 . "AcDbLayerTableRecord")
            (cons 2 ten) '(70 . 0) (cons 62 mau)
            (cons 6 (if (and lt (tblsearch "LTYPE" lt)) lt "Continuous"))
      )
    )
  )
  (QS-DamBaoLayer ten mau)
  moi
)

(defun c:OS_LAYER ( / *error* doc ds z moi cu s)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n=== OS_LAYER - TAO BO LAYER CHUAN CHO CAC LENH QS ===")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)

  (setq ds (list
    (list "QS_BaoBeTong" 4   "Continuous" "Mep ngoai san / bao be tong (CYAN)")
    (list "QS_NetKhuat"  8   "DASHED"     "Net dam - mat trong dam (net dut)")
    (list "QS_RanhGioi"  2   "DASHED"     "Ranh gioi vung san chenh cao do")
    (list "QS_Zone"      1   "DASHED"     "Duong phan ZONE thi cong")
    (list "QS_HuongRai"  30  "Continuous" "Line huong rai thep (dung cho OS_VUNGSAN)")
    (list "QS_VungCat"   6   "Continuous" "Ranh VUNG duoc phep cat / noi thep")
    (list "QS_LoMo"      5   "Continuous" "Lo mo san")
    (list "QS_TextSan"   3   "Continuous" "Text ghi chieu day / cao do san (tham khao)")
    (list "QS_ThepChu"   1   "Continuous" "Thanh thep")
    (list "QS_Block"     7   "Continuous" "Tag so hieu thep")
    (list "QS_Symbol"    8   "Continuous" "Duong rai thep + vong tron")
    (list "QS_Dim"       254 "Continuous" "Duong kich thuoc")
    (list "QS_ViTriThep" 7   "Continuous" "Vi tri thep (DBim Apps)")
  ))

  (setq moi 0 cu 0)
  (foreach z ds
    (if (QS-TaoLayer (nth 0 z) (nth 1 z) (nth 2 z))
      (progn (setq moi (1+ moi))
             (princ (strcat "\n  [TAO MOI] " (nth 0 z) "  -  " (nth 3 z))))
      (progn (setq cu (1+ cu))
             (princ (strcat "\n  [da co  ] " (nth 0 z) "  -  " (nth 3 z))))
    )
  )
  (princ (strcat "\n\n[HOAN TAT] Tao moi " (itoa moi) " layer, giu nguyen "
                 (itoa cu) " layer da co."))

  (initget "Co Khong")
  (setq s (getkword "\nDien luon cac layer nay vao o chon layer cua cac lenh? [Co/Khong] <Co>: "))
  (if (or (null s) (= s "Co"))
    (progn
      (setq *QS4-LNG*   "QS_BaoBeTong"
            *QS4-LDAM*  "QS_NetKhuat"
            *QS4-LRANH* "QS_RanhGioi"
            *QS4-LZONE* "QS_Zone"
            *QS4-LTXT*  "QS_TextSan"
            *QS5-LTHEP* "QS_ThepChu"
            *QS5-LDAM*  "QS_NetKhuat"
            *QSV-LAY*   "QS_VungCat"
            *QSV-LDAM*  "QS_NetKhuat"
            *QS4-LHR*   "QS_HuongRai")
      (princ "\n   Da dien san vao OS_THEPSAN, OS_CATTHEP va OS_VUNGCAT.")
    )
    (princ "\n   Giu nguyen cac o chon layer dang co.")
  )
  (princ "\n   Luu y: layer da ton tai thi GIU NGUYEN mau / net cua ban ve.")
  (vla-EndUndoMark doc)
  (princ)
)

(defun c:OS_GIACUONGLOMO ( / *error* doc spc dclId lap rc pe
                            sn dn an sd dd ad sx dx ax cxmin
                            lay kc cm tyle mck shStart rnd coTag coDim
                            cao ss i n ent pts cen np j a b c d m
                            L1 dsBar e1 p1 p2 dia LA soT gr k
                            dsNhom key sh nGhi dsDim dsDim2 soLo soThanh
                            d1 d2 bis xn off tam
                            tuDong achu nT bbL kcanh dsCanh nCanh sTxt
                            tagObj tagEnt bund ofT ofD htg hdm gtL
                            tgn dmn tgd dmd tgx dmx
                            xtn xdn xtd xdd xtx xdx xtg xdm uu
                            kin ncanh ngoc ex0 ex1
                            laydam ndam bvdam kemin tdam dsDam elay q0 q1 pa pb neoD
                            klo nhomin snho xnho lonho bbx bby nX)

  (defun *error* (msg)
    (QS-DongDCL)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )

  (princ "\n[OS_ShopThepSan v1.0.0]")
  (princ "\n=== OS_GIACUONGLOMO - THEP GIA CUONG QUANH LO MO SAN ===")
  (setq doc (QS-Doc) spc (QS-Space doc))
  (vla-StartUndoMark doc)
  (setq *QS6-OK* nil)

  (setq dclId (QS-NapDCL) lap T)
  (while (and dclId lap)
    (if (not (new_dialog "qs_lomo" dclId))
      (progn (princ "\n[Loi] Khong khoi tao duoc dialog qs_lomo.") (setq lap nil))
      (progn
        (set_tile "lsn"   (if *QS6-SN*  *QS6-SN*  "2"))
        (set_tile "ldn"   (if *QS6-DN*  *QS6-DN*  "12"))
        (set_tile "lan"   (if *QS6-AN*  *QS6-AN*  "600"))
        (set_tile "lsd"   (if *QS6-SD*  *QS6-SD*  "2"))
        (set_tile "ldd"   (if *QS6-DD*  *QS6-DD*  "12"))
        (set_tile "lad"   (if *QS6-AD*  *QS6-AD*  "600"))
        (set_tile "lsx"   (if *QS6-SX*  *QS6-SX*  "2"))
        (set_tile "ldx"   (if *QS6-DX*  *QS6-DX*  "12"))
        (set_tile "lax"   (if *QS6-AX*  *QS6-AX*  "600"))
        (set_tile "lcx"   (if *QS6-CX*  *QS6-CX*  "500"))
        (set_tile "llay"  (if *QS6-LAY* *QS6-LAY* "QS_BaoBeTong"))
        (set_tile "lkc"   (if *QS6-KC*  *QS6-KC*  "50"))
        (set_tile "lcm"   (if *QS6-CM*  *QS6-CM*  "50"))
        (set_tile "lnho"  (if *QS6-NHO*  *QS6-NHO*  "500"))
        (set_tile "lsnho" (if *QS6-SNHO* *QS6-SNHO* "1"))
        (set_tile "lxnho" (if *QS6-XNHO* *QS6-XNHO* "0"))
        (set_tile "lldam" (if *QS6-LDAM* *QS6-LDAM* "QS_NetKhuat"))
        (set_tile "lnd"   (if *QS6-ND*  *QS6-ND*  "40"))
        (set_tile "lbv"   (if *QS6-BV*  *QS6-BV*  "50"))
        (set_tile "lke"   (if *QS6-KE*  *QS6-KE*  "100"))
        (set_tile "ltd"   (if *QS6-TD*  *QS6-TD*  "1500"))
        (set_tile "lauto" (if *QS6-AUTO* *QS6-AUTO* "1"))
        (set_tile "lachu" (if *QS6-ACHU* *QS6-ACHU* "200"))
        (set_tile "ltyle" (if *QS6-TYL* *QS6-TYL* "100"))
        (set_tile "lmck"  (if *QS6-MCK* *QS6-MCK* ""))
        (set_tile "lsh"   (if *QS6-SH*  *QS6-SH*  "1"))
        (set_tile "lrnd"  (if *QS6-RND* *QS6-RND* "5"))
        (set_tile "ltgn"  (if *QS6-TGN* *QS6-TGN* "4"))
        (set_tile "ldmn"  (if *QS6-DMN* *QS6-DMN* "5"))
        (set_tile "ltgd"  (if *QS6-TGD* *QS6-TGD* "4"))
        (set_tile "ldmd"  (if *QS6-DMD* *QS6-DMD* "6"))
        (set_tile "ltgx"  (if *QS6-TGX* *QS6-TGX* "5"))
        (set_tile "ldmx"  (if *QS6-DMX* *QS6-DMX* "6"))
        (set_tile "lxtn"  (if *QS6-XTN* *QS6-XTN* "4.5"))
        (set_tile "lxdn"  (if *QS6-XDN* *QS6-XDN* "0"))
        (set_tile "lxtd"  (if *QS6-XTD* *QS6-XTD* "3"))
        (set_tile "lxdd"  (if *QS6-XDD* *QS6-XDD* "0"))
        (set_tile "lxtx"  (if *QS6-XTX* *QS6-XTX* "-2"))
        (set_tile "lxdx"  (if *QS6-XDX* *QS6-XDX* "0"))
        (set_tile "ltag"  (if *QS6-TAG* *QS6-TAG* "1"))
        (set_tile "ldim"  (if *QS6-DIM* *QS6-DIM* "1"))
        (set_tile "lghichu" "Bam OK roi quet chon cac duong LO MO (polyline).")
        (QS-ModeLM)
        (action_tile "lauto" "(QS-ModeLM)")
        (action_tile "pkl" "(QS-Doc6)(done_dialog 7)")
        (action_tile "pkd" "(QS-Doc6)(done_dialog 8)")
        (action_tile "accept" "(QS-Accept6)")
        (action_tile "cancel" "(done_dialog 0)")
        (setq rc (start_dialog))
        (cond
          ((= rc 7)
           (setq pe (entsel "\nChon 1 duong LO MO de lay layer: "))
           (if pe (setq *QS6-LAY* (cdr (assoc 8 (entget (car pe)))))))
          ((= rc 8)
           (setq pe (entsel "\nChon 1 net DAM de lay layer: "))
           (if pe (setq *QS6-LDAM* (cdr (assoc 8 (entget (car pe)))))))
          (T (setq lap nil)))
      )
    )
  )
  (QS-DongDCL)

  (if (not *QS6-OK*)
    (princ "\nDa huy lenh.")
    (progn
      (setq sn (if (QS-Num *QS6-SN*) (fix (QS-Num *QS6-SN*)) 2)
            dn (if *QS6-DN* *QS6-DN* "12")
            an (if (QS-Num *QS6-AN*) (QS-Num *QS6-AN*) 600.0)
            sd (if (QS-Num *QS6-SD*) (fix (QS-Num *QS6-SD*)) 2)
            dd (if *QS6-DD* *QS6-DD* "12")
            ad (if (QS-Num *QS6-AD*) (QS-Num *QS6-AD*) 600.0)
            sx (if (QS-Num *QS6-SX*) (fix (QS-Num *QS6-SX*)) 2)
            dx (if *QS6-DX* *QS6-DX* "12")
            ax (if (QS-Num *QS6-AX*) (QS-Num *QS6-AX*) 600.0)
            cxmin (if (QS-Num *QS6-CX*) (QS-Num *QS6-CX*) 500.0)
            lay (if *QS6-LAY* *QS6-LAY* "QS_BaoBeTong")
            kc (if (QS-Num *QS6-KC*) (QS-Num *QS6-KC*) 50.0)
            cm (if (QS-Num *QS6-CM*) (QS-Num *QS6-CM*) 50.0)
            nhomin (if (QS-Num *QS6-NHO*) (QS-Num *QS6-NHO*) 500.0)
            snho (if (QS-Num *QS6-SNHO*) (fix (QS-Num *QS6-SNHO*)) 1)
            xnho (= *QS6-XNHO* "1")
            laydam (if *QS6-LDAM* *QS6-LDAM* "QS_NetKhuat")
            ndam (if (QS-Num *QS6-ND*) (QS-Num *QS6-ND*) 40.0)
            bvdam (if (QS-Num *QS6-BV*) (QS-Num *QS6-BV*) 50.0)
            kemin (if (QS-Num *QS6-KE*) (QS-Num *QS6-KE*) 100.0)
            tdam (if (QS-Num *QS6-TD*) (QS-Num *QS6-TD*) 1500.0)
            tuDong (= *QS6-AUTO* "1")
            achu (if (QS-Num *QS6-ACHU*) (QS-Num *QS6-ACHU*) 200.0)
            tyle (if (QS-Num *QS6-TYL*) (QS-Num *QS6-TYL*) 100.0)
            mck (if *QS6-MCK* *QS6-MCK* "")
            shStart (if (QS-Num *QS6-SH*) (fix (QS-Num *QS6-SH*)) 1)
            rnd (if (QS-Num *QS6-RND*) (fix (QS-Num *QS6-RND*)) 5)
            tgn (if (QS-Num *QS6-TGN*) (QS-Num *QS6-TGN*) 4.0)
            dmn (if (QS-Num *QS6-DMN*) (QS-Num *QS6-DMN*) 5.0)
            tgd (if (QS-Num *QS6-TGD*) (QS-Num *QS6-TGD*) 4.0)
            dmd (if (QS-Num *QS6-DMD*) (QS-Num *QS6-DMD*) 6.0)
            tgx (if (QS-Num *QS6-TGX*) (QS-Num *QS6-TGX*) 5.0)
            dmx (if (QS-Num *QS6-DMX*) (QS-Num *QS6-DMX*) 6.0)
            xtn (if (QS-Num *QS6-XTN*) (QS-Num *QS6-XTN*) 4.5)
            xdn (if (QS-Num *QS6-XDN*) (QS-Num *QS6-XDN*) 0.0)
            xtd (if (QS-Num *QS6-XTD*) (QS-Num *QS6-XTD*) 3.0)
            xdd (if (QS-Num *QS6-XDD*) (QS-Num *QS6-XDD*) 0.0)
            xtx (if (QS-Num *QS6-XTX*) (QS-Num *QS6-XTX*) -2.0)
            xdx (if (QS-Num *QS6-XDX*) (QS-Num *QS6-XDX*) 0.0)
            coTag (= *QS6-TAG* "1")
            coDim (= *QS6-DIM* "1"))
      (if (< rnd 1) (setq rnd 1))
      (if (< achu 10.0) (setq achu 200.0))
      (if (< ndam 0.0) (setq ndam 40.0))
      (if (< bvdam 0.0) (setq bvdam 50.0))
      (if (< kemin 0.0) (setq kemin 0.0))
      (if (< snho 1) (setq snho 1))
      (setq cao (* 2.5 tyle))
      (QS-TaoBlockTag)
      (QS-DamBaoLayer "QS_ThepChu" 1)
      (QS-DamBaoLayer "QS_Block" 7)
      (QS-DamBaoLayer "QS_Dim" 254)

      (princ "\n\nQuet chon cac duong LO MO (polyline)")
      (if (/= laydam "")
        (princ (strcat " va NET DAM layer " laydam)))
      (princ " :")
      (setq ss (ssget '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "POLYLINE")
                        (0 . "LINE") (0 . "ARC") (-4 . "OR>"))))
      (setq dsDam nil)
      (if (and ss (/= laydam ""))
        (progn
          (setq i 0 n (sslength ss))
          (while (< i n)
            (setq ent (ssname ss i))
            (setq elay (cdr (assoc 8 (entget ent))))
            (if (= (strcase elay) (strcase laydam))
              (setq dsDam (cons (vlax-ename->vla-object ent) dsDam)))
            (setq i (1+ i))
          )
          (princ (strcat "\n   Nhan duoc " (itoa (length dsDam)) " net dam."))
        )
      )
      (if (null ss)
        (princ "\nKhong chon duoc lo mo nao. Huy lenh.")
        (progn
          (setq dsBar nil dsNhom nil soLo 0 soThanh 0 i 0 n (sslength ss))
          (while (< i n)
            (setq ent (ssname ss i))
            (setq elay (cdr (assoc 8 (entget ent))))
            (setq pts (if (or (and (/= laydam "")
                                   (= (strcase elay) (strcase laydam)))
                              (and (/= lay "")
                                   (/= (strcase elay) (strcase lay))))
                        nil
                        (QS-DinhDuong ent)))
            (if (and pts (>= (length pts) 2))
              (progn
                (setq soLo (1+ soLo))
                (setq pts (mapcar (function (lambda (x) (list (car x) (cadr x)))) pts))
                (setq kin (QS-LaKin ent pts))
                (if (and (> (length pts) 2)
                         (< (distance (car pts) (last pts)) 1.0))
                  (setq pts (reverse (cdr (reverse pts)))))
                (setq cen (QS-TamDinh pts) np (length pts))
                (setq klo (itoa soLo))
                (setq bbx (QS-RongTheo pts (list 1.0 0.0)))
                (setq bby (QS-RongTheo pts (list 0.0 1.0)))
                (setq lonho (and (> nhomin 0.0) (< (max bbx bby) nhomin)))
                (setq ncanh (if kin np (1- np)))
                (setq ngoc (if kin np (1- np)))
                (if (and lonho (not xnho)) (setq ngoc 0))

                (setq j 0)
                (while (< j ncanh)
                  (setq a (nth j pts) b (nth (rem (1+ j) np) pts))
                  (setq L1 (distance a b))
                  (if (> L1 1.0)
                    (progn
                      (setq d (QS-DVi a b) m (QS-PhapNgoai a b cen))
                      (setq xn (abs (car d)))
                      (if (> xn 0.7)
                        (setq nT sn dia dn LA an htg tgn hdm dmn xtg xtn xdm xdn)
                        (setq nT sd dia dd LA ad htg tgd hdm dmd xtg xtd xdm xdd))
                      (if tuDong
                        (progn
                          (setq bbL (QS-RongTheo pts m))
                          (setq nT (fix (+ 0.999 (/ bbL achu))))))
                      (if lonho (setq nT snho))
                      (if (< nT 1) (setq nT 1))
                      (setq bund (* (float (1- nT)) kc))
                      (setq kcanh (strcat "C" (itoa i) "_" (itoa j)))
                      (setq ex0 (if (or kin (> j 0)) LA 0.0))
                      (setq ex1 (if (or kin (< (1+ j) (1- np))) LA 0.0))
                      (setq k 0)
                      (while (< k nT)
                        (setq off (+ cm (* (float k) kc)))
                        (setq pa (QS-Them a m off) pb (QS-Them b m off))
                        (setq neoD (* ndam (if (QS-Num dia) (QS-Num dia) 12.0)))
                        (setq q0 (QS-NeoKe
                                   (QS-TimMepDam spc pa
                                     (list (- (car d)) (- (cadr d))) tdam dsDam)
                                   neoD bvdam kemin))
                        (setq q1 (QS-NeoKe
                                   (QS-TimMepDam spc pb d tdam dsDam)
                                   neoD bvdam kemin))
                        (setq p1 (QS-Them pa d (if q0 (- (car q0)) (- ex0))))
                        (setq p2 (QS-Them pb d (if q1 (car q1) ex1)))
                        (setq e1 (QS-VeThanhKe p1 p2
                                   (if q0 (cadr q0) 0.0)
                                   (if q1 (cadr q1) 0.0)
                                   m "QS_ThepChu"))
                        (if e1
                          (progn
                            (setq soThanh (1+ soThanh))
                            (setq dsBar (cons (list e1 dia
                                                    (QS-LamTron
                                                      (+ (distance p1 p2)
                                                         (if q0 (cadr q0) 0.0)
                                                         (if q1 (cadr q1) 0.0)) rnd)
                                                    p1 p2 kcanh m bund htg hdm
                                                    xtg xdm klo) dsBar))))
                        (setq k (1+ k))
                      )
                    )
                  )
                  (setq j (1+ j))
                )

                (setq j (if kin 0 1))
                (while (< j ngoc)
                  (setq a (nth (rem (+ j np -1) np) pts)
                        b (nth j pts)
                        c (nth (rem (1+ j) np) pts))
                  (if (and (QS-LaGocVuong a b c)
                           (or (and lonho xnho)
                               (>= (max (distance a b) (distance b c)) cxmin)))
                    (progn
                      (setq d1 (QS-DVi b a) d2 (QS-DVi b c))
                      (setq bis (QS-DVi (list 0.0 0.0)
                                        (list (+ (car d1) (car d2))
                                              (+ (cadr d1) (cadr d2)))))
                      (if bis
                        (progn
                          (setq m (list (- (car bis)) (- (cadr bis))))
                          (setq d (list (- (cadr bis)) (car bis)))
                          (setq kcanh (strcat "X" (itoa i) "_" (itoa j)))
                          (setq nX (if lonho snho sx))
                          (if (< nX 1) (setq nX 1))
                          (setq bund (* (float (1- nX)) kc))
                          (setq htg tgx hdm dmx xtg xtx xdm xdx)
                          (setq k 0)
                          (while (< k nX)
                            (setq off (+ cm (* (float k) kc)))
                            (setq tam (QS-Them b m off))
                            (setq p1 (QS-Them tam d (- ax)))
                            (setq p2 (QS-Them tam d ax))
                            (setq e1 (QS-VeThanh2 p1 p2 "QS_ThepChu"))
                            (if e1
                              (progn
                                (setq soThanh (1+ soThanh))
                                (setq dsBar (cons (list e1 dx
                                                        (QS-LamTron (distance p1 p2) rnd)
                                                        p1 p2 kcanh m bund htg hdm
                                                        xtg xdm klo) dsBar))))
                            (setq k (1+ k))
                          )
                        )
                      )
                    )
                  )
                  (setq j (1+ j))
                )
              )
            )
            (setq i (1+ i))
          )
          (setq dsBar (reverse dsBar))

          (foreach gr dsBar
            (setq key (strcat (nth 12 gr) "|" (nth 1 gr) "|" (itoa (nth 2 gr))))
            (if (not (assoc key dsNhom))
              (setq dsNhom (append dsNhom (list (cons key 0))))))
          (setq sh shStart)
          (setq dsNhom (mapcar (function (lambda (x)
                        (setq sh (1+ sh)) (cons (car x) (1- sh)))) dsNhom))

          (setq dsDim nil)
          (foreach gr dsBar
            (setq key (strcat (nth 12 gr) "|" (nth 1 gr) "|" (itoa (nth 2 gr))))
            (setq k (assoc key dsNhom))
            (if k
              (setq dsDim (cons (list key (nth 0 gr) (nth 1 gr) (nth 2 gr)
                                      (nth 3 gr) (nth 4 gr) (cdr k)
                                      (nth 5 gr) (nth 6 gr) (nth 7 gr)
                                      (nth 8 gr) (nth 9 gr)
                                      (nth 10 gr) (nth 11 gr)) dsDim))))
          (setq dsDim (reverse dsDim))

          (setq soT nil dsCanh nil)
          (foreach gr dsDim
            (setq key (car gr))
            (setq k (assoc key soT))
            (if k
              (setq soT (subst (cons key (1+ (cdr k))) k soT))
              (setq soT (cons (cons key 1) soT)))
            (setq k (assoc key dsCanh))
            (if k
              (if (not (member (nth 7 gr) (cdr k)))
                (setq dsCanh (subst (cons key (cons (nth 7 gr) (cdr k))) k dsCanh)))
              (setq dsCanh (cons (list key (nth 7 gr)) dsCanh))))
          (foreach gr dsDim
            (QS-GanXDThepKC0 (nth 1 gr) mck (itoa (nth 6 gr)) (nth 2 gr) "1"))
          (if coTag
            (progn
              (setq dsNhom nil)
              (foreach gr dsDim
                (setq key (car gr))
                (if (not (member key dsNhom))
                  (progn
                    (setq dsNhom (cons key dsNhom))
                    (setq nGhi (cdr (assoc key soT)))
                    (setq nCanh (length (cdr (assoc key dsCanh))))
                    (if (and (> nCanh 0) (= 0 (rem nGhi nCanh)))
                      (setq sTxt (strcat (itoa nCanh) "x" (itoa (/ nGhi nCanh)) "x2"))
                      (setq sTxt (strcat (itoa nGhi) "x2")))
                    (setq p1 (nth 4 gr) p2 (nth 5 gr))
                    (setq m (nth 8 gr) ofT (+ (nth 9 gr) (* (nth 10 gr) cao)))
                    (setq uu (QS-DVi p1 p2))
                    (if (null uu) (setq uu (list 1.0 0.0)))
                    (setq gtL (QS-GocDoc uu))
                    (setq uu (list (cos gtL) (sin gtL)))
                    (setq ofD (* (nth 12 gr) cao))
                    (setq tam (list (+ (/ (+ (car p1) (car p2)) 2.0)
                                       (* ofT (car m)) (* ofD (car uu)))
                                    (+ (/ (+ (cadr p1) (cadr p2)) 2.0)
                                       (* ofT (cadr m)) (* ofD (cadr uu)))))
                    (setq tagObj (QS-ChenTagThep spc tam tyle
                      (strcat sTxt "%%c" (nth 2 gr)
                              " (L=" (itoa (nth 3 gr)) ")")
                      (itoa (nth 6 gr)) "" gtL))
                    (QS-CanGiuaTagU tagObj tam uu)
                    (setq tagEnt (vlax-vla-object->ename tagObj))
                    (QS-GanXDTag tagEnt mck (itoa (nth 6 gr)) (nth 2 gr) "1"
                                 (cdr (assoc 5 (entget (nth 1 gr))))
                                 (* 2 nGhi))
                  )
                )
              )
            )
          )
          (if coDim
            (progn
              (setq dsNhom nil)
              (foreach gr dsDim
                (setq key (car gr))
                (if (not (member key dsNhom))
                  (progn
                    (setq dsNhom (cons key dsNhom))
                    (setq ofD (+ (nth 9 gr) (* (nth 11 gr) cao)))
                    (setq dsDim2 (cons (list (nth 4 gr) (nth 5 gr)
                                             (nth 8 gr) ofD
                                             (* (nth 13 gr) cao)) dsDim2)))))
              (if dsDim2
                (QS-GhiDimLM (reverse dsDim2) cao rnd "O"))
            )
          )
          (princ (strcat "\n   Moi polyline la MOT lo mo doc lap : so hieu va TAG rieng."))
          (princ (strcat "\n   Lo nho hon " (rtos nhomin 2 0) " mm : "
                         (itoa snho) " thanh moi lop, "
                         (if xnho "co" "khong") " thanh xien."))
          (princ (strcat "\n\n[HOAN TAT] " (itoa soLo) " lo mo  ->  "
                         (itoa soThanh) " thanh gia cuong, "
                         (itoa (length soT)) " so hieu (SH " (itoa shStart)
                         " -> " (itoa (1- sh)) ")."))
          (if tuDong
            (princ (strcat "\n   TU DONG : so thanh moi lop = do rong lo / khoang cach thep chu "
                           (rtos achu 2 0) " mm  (x2 cho lop tren + duoi)."))
            (princ (strcat "\n   Thanh ngang " (itoa sn) "%%c" dn " neo " (rtos an 2 0)
                           "  |  doc " (itoa sd) "%%c" dd " neo " (rtos ad 2 0))))
          (princ (strcat "\n   Thanh xien " (itoa sx) "%%c" dx " neo " (rtos ax 2 0)
                         "  (luon nhap tay so luong)."))
          (princ "\n   TAG ghi dang: so canh x so thanh x 2 lop (vd 2x5x2%%c12).")
          (princ (strcat "\n   Chi ve thanh xien o goc vuong co canh >= "
                         (rtos cxmin 2 0) " mm."))
        )
      )
    )
  )
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-AttTag (e ten / o a r)
  (setq r nil)
  (setq o (vl-catch-all-apply 'vlax-ename->vla-object (list e)))
  (if (not (vl-catch-all-error-p o))
    (foreach a (vlax-invoke o 'GetAttributes)
      (if (= (strcase (vla-get-TagString a)) (strcase ten))
        (setq r (vla-get-TextString a)))))
  r
)

(defun QS-LaSo (c)
  (and c (/= c "") (>= (ascii c) 48) (<= (ascii c) 57))
)

(defun QS-ToiChamPhay (s i n / k)
  (setq k i)
  (while (and (<= k n) (<= (- k i) 14) (/= (substr s k 1) ";"))
    (setq k (1+ k)))
  (if (and (<= k n) (= (substr s k 1) ";")) (1+ k) nil)
)

(defun QS-LamSachChu (s / i n c c2 r k)
  (if (null s)
    ""
    (progn
      (setq i 1 n (strlen s) r "")
      (while (<= i n)
        (setq c (substr s i 1))
        (setq c2 (if (< i n) (substr s (1+ i) 1) ""))
        (cond
          ((= c "\\")
           (cond
             ((and (= (strcase c2) "U") (= (substr s (+ i 2) 1) "+"))
              (setq i (+ i 7) r (strcat r " ")))
             ((= c2 "P") (setq i (+ i 2) r (strcat r " ")))
             ((and (/= c2 "") (wcmatch (strcase c2) "@")
                   (setq k (QS-ToiChamPhay s (+ i 2) n)))
              (setq i k r (strcat r " ")))
             (T (setq i (+ i 2) r (strcat r " ")))
           ))
          ((and (= c "%") (= c2 "%")) (setq i (+ i 3) r (strcat r " ")))
          ((or (= c "{") (= c "}")) (setq i (1+ i)))
          ((or (> (ascii c) 126) (< (ascii c) 32)) (setq i (1+ i) r (strcat r " ")))
          (T (setq r (strcat r c) i (1+ i)))
        )
      )
      r
    )
  )
)

(defun QS-ChuDoiTuong (e / ed et r a o s)
  (setq ed (vl-catch-all-apply 'entget (list e)))
  (if (vl-catch-all-error-p ed)
    ""
    (progn
      (setq et (cdr (assoc 0 ed)) r "")
      (cond
        ((or (= et "TEXT") (= et "ATTRIB") (= et "ATTDEF"))
         (setq r (cdr (assoc 1 ed))))
        ((= et "MTEXT")
         (foreach a ed
           (if (= (car a) 3) (setq r (strcat r (cdr a)))))
         (setq r (strcat r (if (cdr (assoc 1 ed)) (cdr (assoc 1 ed)) ""))))
        ((= et "INSERT")
         (setq s (QS-AttTag e "DKVAKC"))
         (if (and s (/= s ""))
           (setq r s)
           (progn
             (setq o (vl-catch-all-apply 'vlax-ename->vla-object (list e)))
             (if (not (vl-catch-all-error-p o))
               (foreach a (vl-catch-all-apply 'vlax-invoke (list o 'GetAttributes))
                 (if (= (type a) 'VLA-OBJECT)
                   (setq r (strcat r " " (vla-get-TextString a))))))
           )
         ))
      )
      (if r r "")
    )
  )
)

(defun QS-TimChieuDai (s / i n c c2 k num best)
  (setq i 1 n (strlen s) best nil)
  (while (<= i n)
    (setq c (strcase (substr s i 1)))
    (if (= c "L")
      (progn
        (setq k (1+ i))
        (while (and (<= k n)
                    (or (= (substr s k 1) " ") (= (substr s k 1) "=")
                        (= (substr s k 1) ":")))
          (setq k (1+ k)))
        (if (and (<= k n) (QS-LaSo (substr s k 1)))
          (progn
            (setq num "")
            (while (and (<= k n)
                        (or (QS-LaSo (substr s k 1)) (= (substr s k 1) ".")))
              (setq num (strcat num (substr s k 1)) k (1+ k)))
            (setq best (list i (atof num)))
          )
        )
      )
    )
    (setq i (1+ i))
  )
  best
)

(defun QS-TimMocA (s / i n c k best)
  (setq i 1 n (strlen s) best nil)
  (while (<= i n)
    (setq c (substr s i 1))
    (if (or (= (strcase c) "A") (= c "@"))
      (progn
        (setq k (1+ i))
        (while (and (<= k n) (= (substr s k 1) " ")) (setq k (1+ k)))
        (if (and (<= k n) (QS-LaSo (substr s k 1))) (setq best i))
      )
    )
    (setq i (1+ i))
  )
  best
)

(defun QS-DocDKVAKC (s0 / s pL pA sA sB ns dia sn kc k x)
  (setq s (QS-LamSachChu s0))
  (setq kc 0.0 sn 1.0)
  (setq pL (QS-TimChieuDai s))
  (setq sB (if pL (substr s 1 (1- (car pL))) s))
  (setq pA (QS-TimMocA sB))
  (if pA
    (progn
      (setq sA (substr sB 1 (1- pA)))
      (setq ns (QS-TachSo (substr sB (1+ pA))))
      (if ns (setq kc (car ns)))
    )
    (setq sA sB)
  )
  (setq ns (QS-TachSo sA))
  (if (null ns)
    nil
    (progn
      (setq dia (last ns))
      (setq k (reverse (cdr (reverse ns))))
      (foreach x k (if (> x 0.0) (setq sn (* sn x))))
      (list (fix sn) (rtos dia 2 0) kc (if pL (cadr pL) nil))
    )
  )
)

(defun QS-TyLeTuChu (e / ed et h)
  (setq ed (entget e) et (cdr (assoc 0 ed)))
  (if (= et "INSERT")
    (cdr (assoc 41 ed))
    (progn
      (setq h (cdr (assoc 40 ed)))
      (if (and h (> h 0.0)) (/ h 2.5) nil)
    )
  )
)

(defun QS-DiemChu (e / ed et p)
  (setq ed (entget e) et (cdr (assoc 0 ed)))
  (if (= et "TEXT")
    (progn
      (setq p (cdr (assoc 11 ed)))
      (if (and p (> (distance (list 0.0 0.0 0.0) p) 1.0e-8))
        p
        (cdr (assoc 10 ed))))
    (cdr (assoc 10 ed))
  )
)

(defun QS-DaiPolyline (e / o r)
  (setq o (vl-catch-all-apply 'vlax-ename->vla-object (list e)))
  (if (vl-catch-all-error-p o)
    0.0
    (progn
      (setq r (vl-catch-all-apply 'vlax-curve-getDistAtParam
                (list o (vlax-curve-getEndParam o))))
      (if (vl-catch-all-error-p r) 0.0 r)
    )
  )
)

(defun QS-VeTheoMau ( / doc spc ss i n ent et
                          eTag eBar eCir dsDim dd best
                          pts np u v u2 v2 d1 d2 hk1 hk2 nn sA sB
                          Lst0 mid0 pT pC dxA dyA rC hna hnb
                          tyle cao layBar mck soLop coRai coDim
                          ssT j m e2 dkv inf sn dia aKC Lt Lst
                          rot p0 mid p1 p2 nn2 eNew C R1 R2 raiEnt
                          olddim oldecho dem boQua shT x)

  (princ "\n=== VE THEP DONG LOAT THEO BO MAU ===")
  (setq doc (QS-Doc) spc (QS-Space doc))

  (princ "\n\nBUOC 1 - Quet chon BO MAU (tag + thanh thep + duong rai + dim):")
  (setq ss (ssget))
  (if (null ss)
    (princ "\nKhong chon duoc gi. Huy lenh.")
    (progn
      (setq i 0 n (sslength ss) dsDim nil best 0.0)
      (while (< i n)
        (setq ent (ssname ss i) et (cdr (assoc 0 (entget ent))))
        (cond
          ((and (null eTag)
                (member et (list "INSERT" "TEXT" "MTEXT"))
                (QS-DocDKVAKC (QS-ChuDoiTuong ent)))
           (setq eTag ent))
          ((= et "LWPOLYLINE")
           (setq dd (QS-DaiPolyline ent))
           (if (> dd best) (setq best dd eBar ent)))
          ((and (= et "CIRCLE") (null eCir)) (setq eCir ent))
          ((= et "DIMENSION") (setq dsDim (cons ent dsDim)))
        )
        (setq i (1+ i))
      )

      (if (or (null eTag) (null eBar))
        (princ "\n[Loi] Bo mau phai co it nhat 1 TAG (block co thuoc tinh DKVAKC) va 1 THANH THEP.")
        (progn
          (setq pts (QS-DinhDuong eBar))
          (setq pts (mapcar (function (lambda (x) (list (car x) (cadr x)))) pts))
          (setq np (length pts))
          (setq u (QS-HuongPts pts))
          (setq v (list (- (cadr u)) (car u)))
          (setq hk1 0.0 hk2 0.0 nn nil)
          (if (> np 2)
            (progn
              (setq d1 (QS-DVi (nth 1 pts) (nth 0 pts)))
              (if (and d1 (< (abs (+ (* (car d1) (car u)) (* (cadr d1) (cadr u)))) 0.3))
                (setq hk1 (distance (nth 0 pts) (nth 1 pts)) nn d1))
              (setq d2 (QS-DVi (nth (- np 2) pts) (nth (1- np) pts)))
              (if (and d2 (< (abs (+ (* (car d2) (car u)) (* (cadr d2) (cadr u)))) 0.3))
                (progn
                  (setq hk2 (distance (nth (- np 2) pts) (nth (1- np) pts)))
                  (if (null nn) (setq nn d2))))
            )
          )
          (if (null nn) (setq nn v))
          (setq sA (if (> hk1 0.0) (nth 1 pts) (nth 0 pts)))
          (setq sB (if (> hk2 0.0) (nth (- np 2) pts) (nth (1- np) pts)))
          (setq Lst0 (distance sA sB))
          (setq mid0 (list (/ (+ (car sA) (car sB)) 2.0)
                           (/ (+ (cadr sA) (cadr sB)) 2.0)))
          (setq pT (QS-DiemChu eTag))
          (setq dxA (+ (* (- (car pT) (car mid0)) (car u))
                       (* (- (cadr pT) (cadr mid0)) (cadr u))))
          (setq dyA (+ (* (- (car pT) (car mid0)) (car v))
                       (* (- (cadr pT) (cadr mid0)) (cadr v))))
          (setq hna (+ (* (car nn) (car u)) (* (cadr nn) (cadr u))))
          (setq hnb (+ (* (car nn) (car v)) (* (cadr nn) (cadr v))))
          (setq coRai (and eCir (> Lst0 1.0)))
          (setq rC 0.5)
          (if coRai
            (progn
              (setq pC (cdr (assoc 10 (entget eCir))))
              (setq rC (/ (+ (* (- (car pC) (car sA)) (car u))
                             (* (- (cadr pC) (cadr sA)) (cadr u))) Lst0))
              (if (< rC 0.0) (setq rC 0.0))
              (if (> rC 1.0) (setq rC 1.0))
            )
          )
          (setq coDim (> (length dsDim) (if coRai 1 0)))
          (setq tyle (QS-TyLeTuChu eTag))
          (if (or (null tyle) (<= tyle 0.0)) (setq tyle 100.0))
          (setq cao (* 2.5 tyle))
          (setq layBar (cdr (assoc 8 (entget eBar))))
          (setq mck (QS-TachFieldXData (QS-DocXDataTho eBar) 0))
          (setq soLop (QS-TachFieldXData (QS-DocXDataTho eBar) 4))
          (if (or (null soLop) (= soLop "")) (setq soLop "1"))

          (princ "\n\n   [DA DOC MAU]")
          (princ (strcat "\n   Layer thanh thep : " layBar
                         "   |  Ty le 1 : " (rtos tyle 2 0)))
          (princ (strcat "\n   Be ke 2 dau      : " (rtos hk1 2 0) " / " (rtos hk2 2 0) " mm"))
          (princ (strcat "\n   Tag lech so voi giua thanh : " (rtos dxA 2 0)
                         " doc, " (rtos dyA 2 0) " ngang"))
          (princ (strcat "\n   Duong rai        : " (if coRai "CO" "KHONG")
                         "   |  Dim tung doan : " (if coDim "CO" "KHONG")))

          (princ "\n\nBUOC 2 - Quet chon cac TAG / TEXT / MTEXT can ve thep:")
          (setq ssT (ssget '((-4 . "<OR") (0 . "INSERT") (0 . "TEXT")
                             (0 . "MTEXT") (-4 . "OR>"))))
          (if (null ssT)
            (princ "\nKhong chon duoc block nao. Huy lenh.")
            (progn
              (QS-DamBaoLayer layBar 1)
              (QS-DamBaoLayer "QS_Symbol" 8)
              (setq oldecho (getvar "CMDECHO"))
              (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
              (setq olddim (getvar "DIMSTYLE"))
              (setq dem 0 boQua 0 j 0 m (sslength ssT))
              (if coRai (QS-ChuanBiRaiStyle cao "F"))
              (while (< j m)
                (setq e2 (ssname ssT j))
                (setq dkv (QS-ChuDoiTuong e2))
                (setq inf (if (and dkv (/= dkv "")) (QS-DocDKVAKC dkv) nil))
                (if (or (eq e2 eTag) (null inf) (null (nth 3 inf))
                        (<= (nth 3 inf) (+ hk1 hk2 1.0)))
                  (setq boQua (1+ boQua))
                  (progn
                    (setq sn (nth 0 inf) dia (nth 1 inf)
                          aKC (nth 2 inf) Lt (nth 3 inf))
                    (setq Lst (- Lt hk1 hk2))
                    (setq rot (cdr (assoc 50 (entget e2))))
                    (if (null rot) (setq rot 0.0))
                    (setq u2 (list (cos rot) (sin rot)))
                    (setq v2 (list (- (cadr u2)) (car u2)))
                    (setq p0 (QS-DiemChu e2))
                    (setq mid (list (- (car p0) (* dxA (car u2)) (* dyA (car v2)))
                                    (- (cadr p0) (* dxA (cadr u2)) (* dyA (cadr v2)))))
                    (setq p1 (QS-Them mid u2 (- (/ Lst 2.0))))
                    (setq p2 (QS-Them mid u2 (/ Lst 2.0)))
                    (setq nn2 (list (+ (* hna (car u2)) (* hnb (car v2)))
                                    (+ (* hna (cadr u2)) (* hnb (cadr v2)))))
                    (setq eNew (QS-VeThanhKe p1 p2 hk1 hk2 nn2 layBar))
                    (if eNew
                      (progn
                        (setq dem (1+ dem))
                        (setq raiEnt nil)
                        (if (and coRai (> sn 1) (> aKC 0.0))
                          (progn
                            (setq C (QS-Them p1 u2 (* rC Lst)))
                            (setq R1 (QS-Them C v2 (- (* 0.5 (float (1- sn)) aKC))))
                            (setq R2 (QS-Them C v2 (* 0.5 (float (1- sn)) aKC)))
                            (setq raiEnt (QS-VeDuongRai spc R1 R2 C cao))
                          )
                        )
                        (if coDim
                          (QS-GhiDimThep (list eNew) cao 1 0.0 0.0 nil "F" T))
                        (setq shT (QS-AttTag e2 "SH"))
                        (if (null shT) (setq shT ""))
                        (QS-GanBoLienKet eNew e2 raiEnt mck shT shT
                                         dia soLop aKC sn "")
                      )
                      (setq boQua (1+ boQua))
                    )
                  )
                )
                (setq j (1+ j))
              )
              (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
                (command "_.-DIMSTYLE" "_R" olddim))
              (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
              (princ (strcat "\n\n[HOAN TAT] Da ve " (itoa dem) " thanh thep theo mau, bo qua "
                             (itoa boQua) " block."))
              (princ "\n   Block bi bo qua thuong do thuoc tinh DKVAKC khong co (L=...).")
            )
          )
        )
      )
    )
  )
  (princ)
)

(defun c:OS_VETHEPMAU ( / *error* doc)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n[OS_ShopThepSan v1.0.0]")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)
  (QS-VeTheoMau)
  (vla-EndUndoMark doc)
  (princ)
)

(defun QS-BienDoi (p p0 ang sx sy pb / x y)
  (setq x (* sx (- (car p) (car pb)))
        y (* sy (- (cadr p) (cadr pb))))
  (list (+ (car p0) (- (* x (cos ang)) (* y (sin ang))))
        (+ (cadr p0) (* x (sin ang)) (* y (cos ang))))
)

(defun QS-DoanGoc (bn / e ed2 et lst q pp xong)
  (setq lst nil xong nil)
  (setq e (tblobjname "BLOCK" bn))
  (if e (setq e (entnext e)))
  (while (and e (not xong))
    (setq ed2 (entget e) et (cdr (assoc 0 ed2)))
    (cond
      ((= et "ENDBLK") (setq xong T))
      ((= et "LINE")
       (setq lst (cons (list "L" (cdr (assoc 10 ed2)) (cdr (assoc 11 ed2))) lst)))
      ((or (= et "CIRCLE") (= et "ARC"))
       (setq lst (cons (list "C" (cdr (assoc 10 ed2)) (cdr (assoc 10 ed2))) lst)))
      ((= et "LWPOLYLINE")
       (setq q nil)
       (foreach pp ed2
         (if (= (car pp) 10)
           (progn
             (if q (setq lst (cons (list "L" q (cdr pp)) lst)))
             (setq q (cdr pp)))))
      )
    )
    (if (not xong) (setq e (entnext e)))
  )
  (reverse lst)
)

(defun QS-DoanTrongBlock (eIns / ed bn br pb p0 ang sx sy pr loc)
  (setq ed (entget eIns)
        bn (cdr (assoc 2 ed))
        p0 (cdr (assoc 10 ed))
        ang (cdr (assoc 50 ed))
        sx (cdr (assoc 41 ed))
        sy (cdr (assoc 42 ed)))
  (if (null ang) (setq ang 0.0))
  (if (or (null sx) (= sx 0.0)) (setq sx 1.0))
  (if (or (null sy) (= sy 0.0)) (setq sy 1.0))
  (setq pr (assoc bn *QS-BLKC*))
  (if pr
    (setq pb (car (cdr pr)) loc (cdr (cdr pr)))
    (progn
      (setq br (tblsearch "BLOCK" bn))
      (setq pb (if br (cdr (assoc 10 br)) (list 0.0 0.0 0.0)))
      (if (null pb) (setq pb (list 0.0 0.0 0.0)))
      (setq loc (QS-DoanGoc bn))
      (setq *QS-BLKC* (cons (cons bn (cons pb loc)) *QS-BLKC*))
    )
  )
  (mapcar
    (function (lambda (sg)
      (list (car sg)
            (QS-BienDoi (nth 1 sg) p0 ang sx sy pb)
            (QS-BienDoi (nth 2 sg) p0 ang sx sy pb))))
    loc)
)

(defun QS-ChonDoan (segs u song / best bl sg d L dot ok)
  (setq best 0.0 bl nil)
  (foreach sg segs
    (if (= (car sg) "L")
      (progn
        (setq L (distance (nth 1 sg) (nth 2 sg)))
        (setq d (if (> L 1.0) (QS-DVi (nth 1 sg) (nth 2 sg)) nil))
        (if d
          (progn
            (setq dot (abs (+ (* (car d) (car u)) (* (cadr d) (cadr u)))))
            (setq ok (if song (> dot 0.85) (< dot 0.15)))
            (if (and ok (> L best)) (setq best L bl sg))
          )
        )
      )
    )
  )
  bl
)

(defun QS-ChuoiThanh (segs seed bo minL / lst pts head tail found sg a b)
  (setq pts (list (nth 1 seed) (nth 2 seed)))
  (setq lst nil)
  (foreach sg segs
    (if (and (= (car sg) "L")
             (not (equal sg seed))
             (not (equal sg bo))
             (> (distance (nth 1 sg) (nth 2 sg)) minL))
      (setq lst (cons sg lst))))
  (setq found T)
  (while found
    (setq found nil)
    (foreach sg lst
      (if (null found)
        (progn
          (setq a (nth 1 sg) b (nth 2 sg))
          (setq head (car pts) tail (last pts))
          (cond
            ((< (distance b head) 1.0) (setq pts (cons a pts)) (setq found sg))
            ((< (distance a head) 1.0) (setq pts (cons b pts)) (setq found sg))
            ((< (distance a tail) 1.0) (setq pts (append pts (list b))) (setq found sg))
            ((< (distance b tail) 1.0) (setq pts (append pts (list a))) (setq found sg))
          )
        )
      )
    )
    (if found (setq lst (vl-remove found lst)))
  )
  pts
)

(defun QS-VePolyPts (pts lay / eLst p)
  (if (< (length pts) 2)
    nil
    (progn
      (setq eLst (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity")
                       (cons 8 lay) '(100 . "AcDbPolyline")
                       (cons 90 (length pts)) '(70 . 0)))
      (foreach p pts
        (setq eLst (append eLst (list (cons 10 (list (car p) (cadr p)))))))
      (if (entmake eLst) (entlast) nil)
    )
  )
)

(defun QS-TamTron (segs / r sg)
  (setq r nil)
  (foreach sg segs (if (and (null r) (= (car sg) "C")) (setq r (nth 1 sg))))
  r
)

(defun QS-KCDenDoan (p a b / ux uy L tp px py)
  (setq L (distance a b))
  (if (< L 1.0e-6)
    (distance (list (car p) (cadr p)) (list (car a) (cadr a)))
    (progn
      (setq ux (/ (- (car b) (car a)) L) uy (/ (- (cadr b) (cadr a)) L))
      (setq tp (+ (* (- (car p) (car a)) ux) (* (- (cadr p) (cadr a)) uy)))
      (if (< tp 0.0) (setq tp 0.0))
      (if (> tp L) (setq tp L))
      (setq px (+ (car a) (* tp ux)) py (+ (cadr a) (* tp uy)))
      (distance (list (car p) (cadr p)) (list px py))
    )
  )
)

(defun QS-KCDenSegs (p segs / best sg d)
  (setq best nil)
  (foreach sg segs
    (setq d (QS-KCDenDoan p (nth 1 sg) (nth 2 sg)))
    (if (or (null best) (< d best)) (setq best d)))
  (if best best 1.0e18)
)

(defun QS-GocDoiTuong (e / ed a)
  (setq ed (entget e) a (cdr (assoc 50 ed)))
  (if a a 0.0)
)

(defun QS-DoiLayer (e lay / ed)
  (setq ed (vl-catch-all-apply 'entget (list e)))
  (if (not (vl-catch-all-error-p ed))
    (vl-catch-all-apply 'entmod
      (list (subst (cons 8 lay) (assoc 8 ed) ed))))
  (princ)
)

(defun QS-VeTheoTK ( / doc spc tyle cao mck shStart soLop layThep layTK
                       pe pe2 eS eTS segS ut vt barS raiS cirS
                       ns viDia viKC dia0 kc0 mt minD coDim kw
                       ss i n ent et dsTxt dsBlk tx
                       e2 segs bar rai cir eT best bd txt
                       dia kc p1 p2 pm Lb Lr Lt snB eNew raiEnt tagObj tagEnt
                       dsNhom key sh dem boQua olddim oldecho C R1 R2 u2 v2 lab dr ub gt
                       ptsB pIns maxR d0 dsDimE tx)

  (princ "\n=== VE THEP QS THEO THEP THIET KE (block) ===")
  (setq doc (QS-Doc) spc (QS-Space doc))
  (setq *QS-BLKC* nil)
  (setq tyle (if (QS-Num *QS1-TKTL*) (QS-Num *QS1-TKTL*) 100.0))
  (setq cao (* 2.5 tyle))
  (setq mck (if *QS1-TKMCK* *QS1-TKMCK* ""))
  (setq shStart (if (QS-Num *QS1-TKSH*) (fix (QS-Num *QS1-TKSH*)) 1))
  (setq soLop (if (and *QS1-TKSL* (/= *QS1-TKSL* "")) *QS1-TKSL* "1"))

  (princ (strcat "\n   Ty le 1 : " (rtos tyle 2 0) "   |  Ma cau kien : "
                 (if (= mck "") "(trong)" mck)
                 "   |  SH bat dau : " (itoa shStart)))

  (setq pe (entsel "\n\nBUOC 1 - Chon 1 BLOCK thep thiet ke lam MAU: "))
  (if (or (null pe) (/= (cdr (assoc 0 (entget (car pe)))) "INSERT"))
    (princ "\n[Loi] Phai chon mot BLOCK (INSERT). Huy lenh.")
    (progn
      (setq eS (car pe))
      (setq pe2 (entsel "\nBUOC 2 - Chon TEXT ghi thep cua block do: "))
      (if (or (null pe2)
              (not (member (cdr (assoc 0 (entget (car pe2)))) (list "TEXT" "MTEXT"))))
        (princ "\n[Loi] Phai chon TEXT hoac MTEXT. Huy lenh.")
        (progn
          (setq eTS (car pe2))
          (setq ut (QS-GocDoiTuong eTS))
          (setq ut (list (cos ut) (sin ut)))
          (setq vt (list (- (cadr ut)) (car ut)))
          (setq segS (QS-DoanTrongBlock eS))
          (setq barS (QS-ChonDoan segS ut T))
          (setq raiS (QS-ChonDoan segS ut nil))
          (setq cirS (QS-TamTron segS))

          (if (null barS)
            (princ "\n[Loi] Khong tim thay duong thang SONG SONG voi text trong block.")
            (progn
              (princ (strcat "\n\n   [DOC MAU] Trong block co " (itoa (length segS))
                             " doi tuong."))
              (setq minD (getdist "\n   Bo qua doan ngan hon (mm) <40>: "))
              (if (null minD) (setq minD 40.0))
              (if (< minD 0.0) (setq minD 0.0))
              (setq ptsB (QS-ChuoiThanh segS barS raiS minD))
              (princ (strcat "\n   Thanh thep (theo text) : " (itoa (1- (length ptsB)))
                             " doan, tong dai " (rtos (QS-DaiPts ptsB) 2 0) " mm"))
              (princ (strcat "\n   Duong rai (vuong goc text) dai  : "
                             (if raiS (rtos (distance (nth 1 raiS) (nth 2 raiS)) 2 0) "khong co")
                             " mm"))
              (princ (strcat "\n   Vong tron danh dau : " (if cirS "co" "khong co")))

              (setq txt (QS-ChuDoiTuong eTS))
              (setq ns (QS-TachSo (QS-LamSachChu txt)))
              (princ (strcat "\n   Text mau : \"" txt "\"  ->  " (itoa (length ns)) " so : "))
              (setq i 1)
              (foreach tx ns
                (princ (strcat "[" (itoa i) "]=" (rtos tx 2 0) "  "))
                (setq i (1+ i)))

              (setq viDia 1 viKC 2)
              (setq dia0 (if (>= (length ns) 1) (nth 0 ns) nil))
              (setq kc0  (if (>= (length ns) 2) (nth 1 ns) 0.0))
              (if (or (null dia0) (< dia0 4.0) (> dia0 40.0)
                      (and kc0 (> kc0 0.0) (or (< kc0 50.0) (> kc0 600.0))))
                (progn
                  (princ "\n   [Khong chac] Hay chi dinh vi tri cac so:")
                  (setq viDia (getint "\n   So thu may la DUONG KINH <1>: "))
                  (if (null viDia) (setq viDia 1))
                  (setq viKC (getint "\n   So thu may la KHOANG RAI (0 = khong co) <2>: "))
                  (if (null viKC) (setq viKC 2))
                )
                (princ (strcat "\n   Hieu la: duong kinh = so [1], khoang rai = so [2]."))
              )

              (setq mt (getdist "\n   Chieu dai MUI TEN o 2 dau duong rai <300>: "))
              (if (null mt) (setq mt 300.0))
              (initget "Co Khong")
              (setq kw (getkword "\n   Ghi DIM chieu dai thanh? [Co/Khong] <Khong>: "))
              (setq coDim (= kw "Co"))
              (setq layThep (getstring "\n   Layer ve thep QS <QS_ThepChu>: "))
              (if (= layThep "") (setq layThep "QS_ThepChu"))
              (setq layTK (getstring "\n   Chuyen block thiet ke sang layer <QS_ThepTK>: "))
              (if (= layTK "") (setq layTK "QS_ThepTK"))

              (princ "\n\nBUOC 3 - Quet chon TAT CA block thep thiet ke + text cua chung:")
              (setq ss (ssget (list '(-4 . "<OR") '(0 . "INSERT") '(0 . "TEXT")
                                    '(0 . "MTEXT") '(-4 . "OR>"))))
              (if (null ss)
                (princ "\nKhong chon duoc gi. Huy lenh.")
                (progn
                  (QS-TaoBlockTag)
                  (QS-DamBaoLayer layThep 1)
                  (QS-DamBaoLayer "QS_Block" 7)
                  (QS-DamBaoLayer "QS_Symbol" 8)
                  (QS-DamBaoLayer layTK 8)
                  (setq dsTxt nil dsBlk nil i 0 n (sslength ss))
                  (while (< i n)
                    (setq ent (ssname ss i) et (cdr (assoc 0 (entget ent))))
                    (if (= et "INSERT")
                      (setq dsBlk (cons ent dsBlk))
                      (setq dsTxt (cons (list ent (QS-DiemChu ent)
                                              (QS-GocDoiTuong ent)
                                              (QS-TachSo (QS-LamSachChu
                                                           (QS-ChuDoiTuong ent))))
                                        dsTxt)))
                    (setq i (1+ i))
                  )
                  (setq dsBlk (reverse dsBlk) dsTxt (reverse dsTxt))
                  (setq oldecho (getvar "CMDECHO"))
                  (progn (if (null oldecho) (setq oldecho (getvar "CMDECHO"))) (if (or (null oldecho) (not (numberp oldecho))) (setq oldecho 1)) (setvar "CMDECHO" 0))
                  (setq olddim (getvar "DIMSTYLE"))
                  (setq dem 0 boQua 0 dsNhom nil sh shStart dsDimE nil)
                  (QS-ChuanBiRaiStyle cao "F")
                  (princ (strcat "\n   Dang ve " (itoa (length dsBlk)) " thanh thep ..."))

                  (foreach e2 dsBlk
                    (setq segs (QS-DoanTrongBlock e2))
                    (setq pIns (cdr (assoc 10 (entget e2))))
                    (setq maxR 0.0)
                    (foreach tx segs
                      (setq d0 (distance pIns (nth 1 tx)))
                      (if (> d0 maxR) (setq maxR d0))
                      (setq d0 (distance pIns (nth 2 tx)))
                      (if (> d0 maxR) (setq maxR d0)))
                    (setq eT nil best nil)
                    (foreach tx dsTxt
                      (setq d0 (- (distance pIns (nth 1 tx)) maxR))
                      (if (or (null best) (< d0 best))
                        (progn
                          (setq bd (QS-KCDenSegs (nth 1 tx) segs))
                          (if (or (null best) (< bd best)) (setq best bd eT tx)))))
                    (if (or (null segs) (null eT))
                      (setq boQua (1+ boQua))
                      (progn
                        (setq u2 (nth 2 eT))
                        (setq u2 (list (cos u2) (sin u2)))
                        (setq v2 (list (- (cadr u2)) (car u2)))
                        (setq bar (QS-ChonDoan segs u2 T))
                        (setq rai (QS-ChonDoan segs u2 nil))
                        (setq cir (QS-TamTron segs))
                        (setq ns (nth 3 eT))
                        (setq dia (if (and (>= (length ns) viDia) (> viDia 0))
                                    (rtos (nth (1- viDia) ns) 2 0) nil))
                        (setq kc (if (and (> viKC 0) (>= (length ns) viKC))
                                   (nth (1- viKC) ns) 0.0))
                        (if (or (null bar) (null dia))
                          (setq boQua (1+ boQua))
                          (progn
                            (setq ptsB (QS-ChuoiThanh segs bar rai minD))
                            (setq Lb (QS-DaiPts ptsB))
                            (setq Lr (if rai (distance (nth 1 rai) (nth 2 rai)) 0.0))
                            (setq Lt (if (> Lr 0.0) (+ Lr (* 2.0 mt)) 0.0))
                            (setq snB 1)
                            (if (and (> kc 0.0) (> Lt 0.0))
                              (setq snB (fix (+ 0.5 (/ Lt kc)))))
                            (if (< snB 1) (setq snB 1))
                            (setq eNew (QS-VePolyPts ptsB layThep))
                            (if (null eNew)
                              (setq boQua (1+ boQua))
                              (progn
                                (setq dem (1+ dem))
                                (setq pm (QS-GiuaDoanDai (QS-DinhDuong eNew)))
                                (if (null pm)
                                  (setq pm (list (/ (+ (car (car ptsB)) (car (last ptsB))) 2.0)
                                                 (/ (+ (cadr (car ptsB)) (cadr (last ptsB))) 2.0))))
                                (setq key (strcat dia "|" (itoa (QS-R0 Lb))
                                                  "|" (itoa (QS-R0 kc))))
                                (if (not (assoc key dsNhom))
                                  (progn
                                    (setq dsNhom (cons (cons key sh) dsNhom))
                                    (setq sh (1+ sh))))
                                (setq lab (strcat (itoa snB) "%%c" dia))
                                (if (> kc 0.0)
                                  (setq lab (strcat lab "a" (rtos kc 2 0))))
                                (setq lab (strcat lab " (L=" (itoa (QS-R0 Lb)) ")"))
                                (setq ub (QS-HuongPts (QS-DinhDuong eNew)))
                                (if (null ub) (setq ub u2))
                                (setq gt (QS-GocDoc ub))
                                (setq ub (list (cos gt) (sin gt)))
                                (setq tagObj (QS-ChenTagThep spc pm tyle lab
                                               (itoa (cdr (assoc key dsNhom))) "" gt))
                                (QS-CanGiuaTagU tagObj pm ub)
                                (setq tagEnt (vlax-vla-object->ename tagObj))
                                (setq raiEnt nil)
                                (if (and rai (> kc 0.0) (> snB 1))
                                  (progn
                                    (setq C (list (/ (+ (car (nth 1 rai)) (car (nth 2 rai))) 2.0)
                                                  (/ (+ (cadr (nth 1 rai)) (cadr (nth 2 rai))) 2.0)))
                                    (setq dr (QS-DVi (nth 1 rai) (nth 2 rai)))
                                    (if (null dr) (setq dr v2))
                                    (setq R1 (QS-Them (nth 1 rai) dr (- mt)))
                                    (setq R2 (QS-Them (nth 2 rai) dr mt))
                                    (setq raiEnt (QS-VeDuongRai spc R1 R2
                                                   (if cir cir C) cao))
                                  )
                                )
                                (if coDim (setq dsDimE (cons eNew dsDimE)))
                                (QS-GanBoLienKet eNew tagEnt raiEnt mck
                                                 (itoa (cdr (assoc key dsNhom)))
                                                 (itoa (cdr (assoc key dsNhom)))
                                                 dia soLop kc snB "")
                                (QS-DoiLayer e2 layTK)
                                (QS-DoiLayer (nth 0 eT) layTK)
                              )
                            )
                          )
                        )
                      )
                    )
                  )

                  (if (and coDim dsDimE)
                    (QS-GhiDimThep (reverse dsDimE) cao 1 0.0 0.0 nil "F" T))
                  (if (and olddim (/= olddim "") (tblsearch "DIMSTYLE" olddim))
                    (command "_.-DIMSTYLE" "_R" olddim))
                  (if (and oldecho (numberp oldecho)) (setvar "CMDECHO" oldecho) (setvar "CMDECHO" 1))
                  (princ (strcat "\n\n[HOAN TAT] Da ve " (itoa dem) " thanh thep QS, bo qua "
                                 (itoa boQua) " block."))
                  (princ (strcat "\n   So hieu tu " (itoa shStart) " den " (itoa (1- sh))
                                 "  (" (itoa (length dsNhom)) " nhom)."))
                  (princ (strcat "\n   Block + text thiet ke da chuyen sang layer " layTK "."))
                )
              )
            )
          )
        )
      )
    )
  )
  (princ)
)

(defun c:OS_THEPTK ( / *error* doc)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ)
  )
  (princ "\n[OS_ShopThepSan v1.0.0]")
  (setq doc (QS-Doc))
  (vla-StartUndoMark doc)
  (if (null *QS1-TKTL*) (setq *QS1-TKTL* "100"))
  (QS-VeTheoTK)
  (vla-EndUndoMark doc)
  (princ)
)

(princ "\nDa nap SHOP THEP SAN (OS_ShopThepSan) v1.0.0 - Tac gia: Nguyen Xuan Phat - banhbaonxp@gmail.com - 0898010995")
(princ "\nBo lenh:")
(princ "\n  OS_VETHEP       - Ve thanh thep moi kem tag + duong rai + XDATA")
(princ "\n  OS_VETHEPMAU    - (co san trong OS_VETHEP) ve thep DONG LOAT theo 1 bo thep MAU")
(princ "\n                    doc duoc TEXT / MTEXT / thuoc tinh block, moi font ky hieu thep")
(princ "\n  OS_THEPTK       - (co san trong OS_VETHEP) doc THEP THIET KE trong block roi ve thep QS")
(princ "\n  OS_CAPNHATTHEP  - Quet chon nhieu thanh thep, tu dong cap nhat chieu dai/thong so")
(princ "\n  OS_CANGIUASH    - Can so hieu (SH) vao giua vong tron cho tag da co trong ban ve")
(princ "\n  OS_DIMTHEP      - Ghi kich thuoc tung doan thanh thep (dim an duong giong)")
(princ "\n  OS_THEPSAN      - TU DONG bo tri thep san, GOP QS_BT_V3 (1 thanh dai dien moi nhom)")
(princ "\n  OS_CATTHEP      - CAT / NOI thep theo chieu dai cay, so le moi noi, danh so hieu phu")
(princ "\n  OS_VUNGCAT      - Ve duong ranh VUNG DUOC PHEP cat / noi thep (L/4, L/6 ...)")
(princ "\n  OS_CAPNHATRAI   - Keo dai duong rai xong, chay lenh nay de cap nhat SO THANH")
(princ "\n  OS_RAILIVE      - BAT / TAT che do TU cap nhat so thanh khi keo duong rai")
(princ "\n  OS_NOILAIRAI    - Noi lai lien ket duong rai <-> tag cho ban ve ve bang ban cu")
(princ "\n  OS_LAYER        - Tao san bo layer chuan (bao be tong, net dam, zone, vung cat ...)")
(princ "\n  OS_GIACUONGLOMO - Thep gia cuong quanh LO MO san (ngang / doc / xien 45 do)")
(princ "\n  OS_KIEMTRABT3 / OS_BUNGBT3 / OS_CAPNHATBT3 / OS_CATBT3 - quan ly nhom thep V3")
(princ "\n  OS_GOPBT3       - GOP LAI nhieu nhom V3 / thanh le da ve thanh 1 nhom")
(princ "\n  OS_VUNGSAN      - MAT BANG KET CAU: ve / gan VUNG SAN (Hs, Cote, huong rai) cho OS_THEPSAN")
(princ)

(defun QS-V3RootOf (e / data rec parts root)
  (if (and e (setq data (QS-S23Read e)))
    (progn
      (setq parts (QS-TachKT (car data) ";"))
      (if (and (= (car parts) "V3") (= (nth 1 parts) "1") (= (nth 2 parts) "ROOT"))
        (setq root e)
        (foreach rec data
          (if (= (substr rec 1 5) "ROOT;") (setq root (handent (substr rec 6))))))
      (if (and root (setq data (QS-S23Read root))
               (= (car data) (strcat "V3;1;ROOT;" (cdr (assoc 5 (entget root)))))) root))))

(defun QS-V3Audit (e / root data rec itemEnt members tags name obj grp actual problems h)
  (setq root (QS-V3RootOf e))
  (if (null root)
    (list nil (list "Khong phai nhom QS_BT_V3 hop le; khong xu ly du lieu cu.") nil)
    (progn
      (setq data (QS-S23Read root))
      (foreach rec data
        (cond
          ((= (substr rec 1 7) "MEMBER;")
           (setq itemEnt (handent (substr rec 8)))
           (cond
             ((null itemEnt) (setq problems (cons "Mat doi tuong thanh vien." problems)))
             ((member itemEnt members) (setq problems (cons "Thanh vien bi lap." problems)))
             (T (setq members (cons itemEnt members)))))
          ((= (substr rec 1 4) "TAG;") (setq tags (cons (handent (substr rec 5)) tags)))
          ((= (substr rec 1 6) "GROUP;") (setq name (substr rec 7)))))
      (if (not (and (= (length tags) 1) (car tags) (member (car tags) members)
                    (= (cdr (assoc 0 (entget (car tags)))) "INSERT")))
        (setq problems (cons "Nhom phai co dung 1 tag hop le." problems)))
      (if (not (member root members)) (setq problems (cons "Bao ROOT khong nam trong nhom." problems)))
      (foreach itemEnt members
        (if (not (equal root (QS-V3RootOf itemEnt)))
          (setq problems (cons "Lien ket ROOT cua thanh vien khong khop." problems)))
        (if (or (QS-DocXDBT itemEnt) (QS-DocXDBT2 itemEnt))
          (setq problems (cons "Thanh vien co du lieu BT cu; can tach rieng." problems))))
      (if name
        (setq grp (vl-catch-all-apply 'vla-Item (list (vla-get-Groups (QS-Doc)) name))))
      (if (or (null grp) (vl-catch-all-error-p grp))
        (setq problems (cons "Khong tim thay AutoCAD Group." problems))
        (progn
          (vlax-for obj grp (setq actual (cons (vlax-vla-object->ename obj) actual)))
          (if (or (/= (length actual) (length members))
                  (vl-some '(lambda (x) (not (member x actual))) members))
            (setq problems (cons "Danh sach Group khong khop XData." problems)))))
      (list root (reverse problems) members))))

(defun c:OS_KIEMTRABT3 (/ pick report ss e msg)
  (setq pick (entsel "\nChon thanh/tag/bao/duong rai cua nhom QS_BT_V3: "))
  (if pick
    (progn
      (setq report (QS-V3Audit (car pick)))
      (if (cadr report)
        (foreach msg (cadr report) (princ (strcat "\n[BT3] " msg)))
        (progn
          (setq ss (ssadd))
          (foreach e (nth 2 report) (ssadd e ss))
          (sssetfirst nil ss)
          (princ (strcat "\n[BT3] Lien ket hop le: " (itoa (length (nth 2 report)))
            " doi tuong. Chi kiem tra, khong sua ban ve."))))))
  (princ))

(defun QS-V3Toggle (e / report members bars item data tag rep hidden changes obj old val result failed x)
  (setq report (QS-V3Audit e))
  (if (cadr report)
    (list nil (cadr report))
    (progn
      (setq members (nth 2 report))
      (foreach item members
        (setq data (QS-TachKT (car (QS-S23Read item)) ";"))
        (cond
          ((= (nth 2 data) "BAR") (setq bars (cons item bars)))
          ((= (nth 2 data) "SOLE") (setq tag item))))
      (setq rep (if tag (handent (QS-TachFieldXData (QS-DocXDataTho tag) 2))))
      (if (not (and rep (member rep bars) (> (length bars) 1)))
        (list nil (list "Thieu thanh dai dien hoac danh sach BAR."))
        (progn
          (foreach item bars
            (if (and (not (equal item rep)) (= 1 (cdr (assoc 60 (entget item))))) (setq hidden T)))
          (foreach item bars
            (setq obj (vlax-ename->vla-object item)
                  old (vla-get-Visible obj)
                  val (if (or hidden (equal item rep)) :vlax-true :vlax-false))
            (setq changes (cons (list obj old) changes))
            (if (not failed)
              (progn
                (setq result (vl-catch-all-apply 'vla-put-Visible (list obj val)))
                (if (vl-catch-all-error-p result) (setq failed T)))))
          (if failed
            (progn
              (foreach x changes (vl-catch-all-apply 'vla-put-Visible (list (car x) (cadr x))))
              (list nil (list "Khong doi duoc hien thi; da khoi phuc.")))
            (list T (if hidden "BUNG" "THU") (length bars))))))))

(defun c:OS_BUNGBT3 (/ *error* doc pick result msg)
  (defun *error* (msg)
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if msg (princ (strcat "\n[BT3] " msg))) (princ))
  (setq pick (entsel "\nChon thanh/tag/bao/dim cua mot nhom QS_BT_V3: "))
  (if pick
    (progn
      (setq doc (QS-Doc)) (vla-StartUndoMark doc)
      (setq result (QS-V3Toggle (car pick)))
      (if (car result)
        (princ (strcat "\n[BT3] " (cadr result) " nhom " (itoa (nth 2 result))
                       " thanh. Giu nguyen hinh hoc va XData."))
        (foreach msg (cadr result) (princ (strcat "\n[BT3] " msg))))
      (vla-EndUndoMark doc) (setq doc nil)))
  (princ))
(princ "\n  OS_KIEMTRABT3 / OS_BUNGBT3 - Kiem tra, bung/thu rieng nhom V3")
(princ)

(defun QS-V3RecordParts (records / groups current r)
  (foreach r records
    (cond
      ((= (substr r 1 4) "BAR;")
       (if current (setq groups (append groups (list current))))
       (setq current r))
      ((and current (not (member (car (QS-TachKT r ";")) '("ROOT" "GROUP" "SOURCE" "MEMBER" "PARAM" "TAG" "ENVELOPE" "CUT_SOURCE"))))
       (setq current (strcat current r)))
      (T (if current (setq groups (append groups (list current)) current nil)))))
  (if current (setq groups (append groups (list current))))
  groups)

(defun QS-V3BodyPair (pts / a b best pair len)
  (setq a (car pts))
  (foreach b (cdr pts)
    (setq len (distance a b))
    (if (or (null best) (> len best)) (setq best len pair (list a b)))
    (setq a b))
  pair)

(defun QS-V3RefreshPlan (e rnd / audit root tag item hd data rec parts bars ids pts oldpts coords axis delta lens problem fresh row u v corners p text pos envelopeRows records recs meta oldBody newBody oldSeg newSeg oldP newP)
  (setq audit (QS-V3Audit e))
  (cond
    ((cadr audit) (list nil (cadr audit)))
    ((or (not (numberp rnd)) (< rnd 1)) (list nil '("Buoc lam tron phai >= 1.")))
    (T
      (setq root (car audit))
      (foreach item (nth 2 audit)
        (setq hd (QS-TachKT (car (QS-S23Read item)) ";"))
        (if (= (nth 2 hd) "SOLE") (setq tag item))
        (if (= (nth 2 hd) "BAR") (setq bars (cons item bars))))
      (setq data (QS-S23Read tag) records (QS-V3RecordParts (cdr data)) fresh (list (car data)))
      (foreach rec records
        (setq parts (QS-TachKT rec ";") item (if (nth 2 parts) (handent (nth 2 parts))))
        (if (or (null item) (not (member item bars)) (member item ids))
          (setq problem "BAR handle khong hop le/trung lap.")
          (progn
            (setq ids (cons item ids) pts (QS-DinhDuong item) oldpts nil)
            (foreach coords (cdddr parts)
              (setq oldpts (append oldpts (list (mapcar 'QS-Num (QS-TachKT coords ","))))))
            (if (or (< (length pts) 2) (/= (length pts) (length oldpts))
                    (not (= (cdr (assoc 70 (entget item))) 0))
                    (vl-some '(lambda (pair) (and (= (car pair) 42) (/= (cdr pair) 0.0))) (entget item))
                    (vl-some '(lambda (p) (member nil p)) oldpts))
              (setq problem "Khong doi so dinh/moc/cung cua thanh V3 trong lenh nay.")
              (progn
                (setq oldBody (QS-V3BodyPair oldpts) newBody (QS-V3BodyPair pts)
                      axis (if oldBody (QS-DVi (car oldBody) (cadr oldBody))))
                (if (null axis) (setq problem "Du lieu goc khong co phuong.")
                  (progn
                    (if (null u) (setq u axis v (list (- (cadr u)) (car u))))
                    (if (< (+ (* (car axis) (car u)) (* (cadr axis) (cadr u))) 0.999)
                      (setq problem "Huong thanh da thay doi."))
                    (if (or (null newBody)
                            (> (abs (- (QS-B2Dot (car newBody) v) (QS-B2Dot (car oldBody) v))) 0.02)
                            (> (abs (- (QS-B2Dot (cadr newBody) v) (QS-B2Dot (cadr oldBody) v))) 0.02))
                      (setq problem "Thanh da doi vi tri rai/huong; khong cap nhat tu dong."))
                    (setq oldP (car oldpts) newP (car pts))
                    (foreach p (cdr pts)
                      (setq newSeg (QS-DVi newP p))
                      (setq oldSeg (QS-DVi oldP (cadr oldpts)))
                      (if (or (null oldSeg) (null newSeg)
                              (< (+ (* (car oldSeg) (car newSeg))
                                    (* (cadr oldSeg) (cadr newSeg))) 0.99999)
                              (> (abs (- (QS-B2Dot newP v) (QS-B2Dot oldP v)))
                                 (+ 0.02 (if (> (abs (+ (* (car oldSeg) (car u))
                                                      (* (cadr oldSeg) (cadr u)))) 0.9) 0.0 1000.0))))
                        (setq problem "Huong doan thanh/moc/nhan da thay doi; khong cap nhat."))
                      (setq oldpts (cdr oldpts) oldP (car oldpts) newP p))
                    (setq lens (cons (QS-DaiPts pts) lens)
                          envelopeRows (cons (list (atoi (nth 1 parts)) pts) envelopeRows)
                          row (strcat "BAR;" (nth 1 parts) ";" (nth 2 parts)))
                    (foreach p pts (setq row (strcat row ";" (rtos (car p) 2 8) "," (rtos (cadr p) 2 8))))
                    (setq fresh (append fresh (QS-ChiaChuoi row 240))))))))))
      (if (/= (length ids) (length bars)) (setq problem "Danh sach BAR khong du thanh."))
      (if (or (QS-LayerBiKhoa root) (QS-LayerBiKhoa tag)) (setq problem "Bao/tag nam tren layer khoa."))
      (setq text (QS-LayTagBT tag) pos (if text (vl-string-search " (L=" text)))
      (if (null pos) (setq problem "Tag khong co truong chieu dai (L=...)."))
      (if problem (list nil (list problem))
        (progn
          (setq envelopeRows (vl-sort envelopeRows '(lambda (a b) (< (car a) (car b)))))
          (setq corners (append (mapcar '(lambda (r) (car (cadr r))) envelopeRows)
                                (reverse (mapcar '(lambda (r) (last (cadr r))) envelopeRows))))
          (setq fresh (append fresh (vl-remove-if '(lambda (x) (= (substr x 1 4) "BAR;"))
                                (vl-remove-if '(lambda (x) (and (> (strlen x) 0)
                                   (not (member (car (QS-TachKT x ";"))
                                     '("ROOT" "GROUP" "SOURCE" "MEMBER" "PARAM" "TAG" "ENVELOPE" "CUT_SOURCE")))))
                                  (cdr data)))))
          (list T root tag fresh corners
            (strcat (substr text 1 pos) " (L=" (QS-ChuoiChieuDai (apply 'min lens) (apply 'max lens) rnd) ")")))))))

(defun QS-V3RefreshApply (plan / root tag points ed pair output attrs att)
  (setq root (nth 1 plan) tag (nth 2 plan) points (nth 4 plan) ed (entget root))
  (setq output (vl-remove-if '(lambda (pair) (member (car pair) '(10 40 41 42 91))) ed))
  (setq output (subst (cons 90 (length points)) (assoc 90 output) output))
  (foreach pair points (setq output (append output (list (cons 10 (list (car pair) (cadr pair)))))))
  (if (null (entmod output)) (/ 1 0))
  (regapp "QS_BT_V3")
  (if (null (entmod (append (entget tag) (list (list -3 (cons "QS_BT_V3"
                   (mapcar '(lambda (x) (cons 1000 x)) (nth 3 plan)))))))) (/ 1 0))
  (foreach att (vlax-invoke (vlax-ename->vla-object tag) 'GetAttributes)
    (if (= (strcase (vla-get-TagString att)) "DKVAKC") (vla-put-TextString att (nth 5 plan))))
  (if (or (not (equal (QS-S23Read tag) (nth 3 plan)))
          (not (= (QS-LayTagBT tag) (nth 5 plan))) (cadr (QS-V3Audit root))) (/ 1 0))
  (entupd root) (entupd tag) T)

(defun QS-V3Refresh (e rnd / plan root tag savedRoot savedTag savedAtt a result)
  (setq plan (QS-V3RefreshPlan e rnd))
  (if (not (car plan)) plan
    (progn
      (setq root (nth 1 plan) tag (nth 2 plan) savedRoot (entget root '("*")) savedTag (entget tag '("*")))
      (foreach a (vlax-invoke (vlax-ename->vla-object tag) 'GetAttributes)
        (setq savedAtt (cons (entget (vlax-vla-object->ename a) '("*")) savedAtt)))
      (setq result (vl-catch-all-apply 'QS-V3RefreshApply (list plan)))
      (if (vl-catch-all-error-p result)
        (progn
          (entmod savedRoot) (entmod savedTag)
          (foreach a savedAtt (entmod a)) (entupd tag) (entupd root)
          (list nil (list (strcat "Da khoi phuc: " (vl-catch-all-error-message result)))))
        (list T (nth 5 plan))))))

(defun c:OS_CAPNHATBT3 (/ *error* doc pick rnd result msg)
  (defun *error* (msg)
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if msg (princ (strcat "\n[BT3] " msg))) (princ))
  (setq pick (entsel "\nChon nhom V3 de dong bo tag/bao theo thanh THAT da sua: "))
  (if pick
    (progn
      (initget 6) (setq rnd (getint "\nBuoc lam tron <1>: ")) (if (null rnd) (setq rnd 1))
      (setq doc (QS-Doc)) (vla-StartUndoMark doc)
      (setq result (QS-V3Refresh (car pick) rnd))
      (if (car result) (princ (strcat "\n[BT3] Da cap nhat: " (cadr result)))
        (foreach msg (cadr result) (princ (strcat "\n[BT3] " msg))))
      (vla-EndUndoMark doc) (setq doc nil)))
  (princ))
(princ "\n  OS_CAPNHATBT3 - Dong bo tag / bao theo thanh V3 da sua")
(princ)
(defun QS-V3Slab32Work (records chosen u v nx ny rep tag rai mck sh dia lap step rnd / r p e bars rows members mark idx root gid)
  (setq members (list rep tag rai) idx 0 gid (QS-TachFieldXData (QS-DocXDataTho rai) 2))
  (setq mark (entnext rai))
  (if (and mark (= (cdr (assoc 0 (entget mark))) "CIRCLE")) (setq members (cons mark members)))
  (foreach r records
    (if (equal r chosen) (setq e rep)
      (progn
        (setq e (QS-VeThanhThep u v (nth 1 r) (nth 2 r) (nth 3 r)
                   (nth 4 r) (nth 5 r) nx ny (nth 7 r)))
        (if (null e) (/ 1 0))
        (setq *QS-32Made* (cons e *QS-32Made*) members (cons e members))))
    (setq p (QS-DinhDuong e))
    (if (or (null p) (< (length p) 2)) (/ 1 0))
    (QS-GanXDThep e mck sh dia lap gid step)
    (QS-GanLinkRai e (cdr (assoc 5 (entget rai))))
    (setq bars (cons e bars) rows (cons (list idx p (QS-Pt u v (nth 1 r) 0.0)) rows) idx (1+ idx)))
  (setq root (QS-V3Attach32 (reverse rows) (reverse bars) rep tag rai members step 0.0 0.0 0))
  (if root
    (progn
      (QS-S22Write root (append (QS-S23Read root) (list "SOURCE;QS_THEPSAN")))
      (if (cadr (QS-V3Audit root)) (/ 1 0))))
  root)

(defun QS-V3Slab32 (records chosen u v nx ny rep tag rai mck sh dia lap step rnd / *QS-32Made* *QS-S24-GROUPS* *QS-S22-GROUP* saved result e g mark next)
  (if (not (and rep tag rai)) (QS-VT-Err "V3 thieu thanh/tag/rai."))
  (setq saved (list (entget rep '("*")) (entget tag '("*")) (entget rai '("*"))) mark (entlast))
  (setq e (entnext rai))
  (if (and e (= (cdr (assoc 0 (entget e))) "CIRCLE")) (setq saved (cons (entget e '("*")) saved)))
  (setq result (vl-catch-all-apply 'QS-V3Slab32Work (list records chosen u v nx ny rep tag rai mck sh dia lap step rnd)))
  (if (vl-catch-all-error-p result)
    (progn
      (foreach g *QS-S24-GROUPS* (vl-catch-all-apply 'vla-Delete (list g)))
      (setq e (entnext mark))
      (while e (setq next (entnext e)) (entdel e) (setq e next))
      (foreach e saved (entmod e))
      (QS-VT-Err (strcat "V3 da huy nhom loi: " (vl-catch-all-error-message result)))))
  result)

(defun QS-V3CutLengths (barLength stock lap minimum / count effective first remainder out pos finish k)
  (if (or (<= barLength 0.0) (<= stock 0.0) (< lap 0.0) (>= lap stock)
          (<= minimum lap) (> minimum stock))
    nil
    (if (<= barLength stock) (list (list 0.0 barLength))
      (progn
        (setq count (1+ (fix (/ (- barLength stock) (- stock lap)))))
        (if (> (- barLength (* (1- count) (- stock lap))) (+ stock 1e-7)) (setq count (1+ count)))
        (setq effective (+ barLength (* (1- count) lap)))
        (if (< effective (- (* count minimum) 1e-7)) nil
          (progn
            (setq pos 0.0 k 0)
            (repeat count
              (setq first (min stock (- effective (* (- count k 1) minimum))))
              (setq finish (+ pos first) out (cons (list pos finish) out)
                    effective (- effective first) pos (- finish lap) k (1+ k)))
            (reverse out)))))))

(defun QS-V3CutPlan (e stock lap minimum / audit members item head rows pts barLength ranges row data root)
  (setq audit (QS-V3Audit e))
  (if (cadr audit) (list nil (cadr audit))
    (progn
      (setq root (car audit))
      (foreach item (nth 2 audit)
        (setq data (QS-S23Read item) head (QS-TachKT (car data) ";"))
        (if (= (nth 2 head) "BAR")
          (progn
            (setq pts (QS-DinhDuong item))
            (if (or (< (length pts) 2)
                    (/= (cdr (assoc 70 (entget item))) 0)
                    (vl-some '(lambda (p) (and (= (car p) 42) (/= (cdr p) 0.0))) (entget item)))
              (setq ranges nil)
              (setq ranges (QS-V3CutLengths (QS-DaiPts pts) stock lap minimum)))
            (if (null ranges)
              (setq members (cons (strcat "Khong lap duoc phoi thanh " (cdr (assoc 5 (entget item)))
                    ": kiem tra moc/cung va gioi han cay/noi/doan toi thieu.") members))
              (setq rows (cons (list (atoi (nth 4 head)) item pts ranges) rows))))))
      (if members (list nil (reverse members))
        (list T root (vl-sort rows '(lambda (a b) (< (car a) (car b)))))))))

(defun QS-V3CutCheck (plan stock lap minimum / ok row intervals interval lastEnd total n barLength)
  (setq ok (car plan))
  (foreach row (nth 2 plan)
    (setq intervals (nth 3 row) total 0.0 lastEnd nil n 0
          barLength (QS-DaiPts (nth 2 row)))
    (foreach interval intervals
      (if (or (< (car interval) -1e-6) (> (cadr interval) (+ barLength 1e-6))
              (<= (- (cadr interval) (car interval)) 0.0)
              (> (- (cadr interval) (car interval)) (+ stock 1e-6))
              (and (> (length intervals) 1) (< (- (cadr interval) (car interval)) (- minimum 1e-6)))
              (and lastEnd (> (abs (- (- lastEnd (car interval)) lap)) 1e-6)))
        (setq ok nil))
      (setq lastEnd (cadr interval) total (+ total (- (cadr interval) (car interval))) n (1+ n)))
    (if (or (> (abs (caar intervals)) 1e-6) (> (abs (- lastEnd barLength)) 1e-6)
            (> (abs (- total (+ barLength (* (1- n) lap)))) 1e-6)) (setq ok nil)))
  ok)

(defun c:OS_PHUONGANCATBT3 (/ pick stock lap minimum plan row pieces total msg)
  (setq pick (entsel "\nChon mot nhom V3 de LAP PHUONG AN (khong sua ban ve): "))
  (if pick
    (progn
      (initget 6) (setq stock (getreal "\nChieu dai cay <11700>: ")) (if (null stock) (setq stock 11700.0))
      (initget 4) (setq lap (getreal "\nChieu dai NOI CHONG mm <500>: ")) (if (null lap) (setq lap 500.0))
      (initget 6) (setq minimum (getreal "\nChieu dai doan cat toi thieu <2000>: ")) (if (null minimum) (setq minimum 2000.0))
      (setq plan (QS-V3CutPlan (car pick) stock lap minimum))
      (if (not (car plan)) (foreach msg (cadr plan) (princ (strcat "\n[BT3] " msg)))
        (if (not (QS-V3CutCheck plan stock lap minimum)) (princ "\n[BT3] Phuong an khong dat kiem tra.")
          (progn
            (setq pieces 0 total 0.0)
            (foreach row (nth 2 plan)
              (princ (strcat "\nThanh " (itoa (car row)) ": " (vl-prin1-to-string (nth 3 row))))
              (setq pieces (+ pieces (length (nth 3 row))))
              (foreach msg (nth 3 row) (setq total (+ total (- (cadr msg) (car msg))))))
            (princ (strcat "\n[BT3] PASS: " (itoa (length (nth 2 plan))) " thanh -> " (itoa pieces)
                           " doan; tong chieu dai ke ca noi=" (rtos total 2 2) " mm. Chua ve/cat/xoa doi tuong.")))))))
  (princ))

(defun QS-V3CutDrawWork (plan shift / row interval pts u p q e index records strings par key dx dy)
  (regapp "QS_BT_V3_CUT")
  (foreach row (nth 2 plan)
    (setq pts (nth 2 row) index 0 u (QS-HuongPts pts)
          par (if (and *QS-V3CUT-SOLE* (assoc (nth 1 row) *QS-V3CUT-PAR*))
                (cdr (assoc (nth 1 row) *QS-V3CUT-PAR*)) 0))
    (foreach interval (nth 3 row)
      ;; v20.15: doan thu 2, 4 ... lech Y de 2 doan noi khong trung nhau
      (setq dx (car shift) dy (cadr shift))
      (if (and *QS-V3CUT-LECH* (= 1 (rem index 2)))
        (setq dx (+ dx (* *QS-V3CUT-LECH* (- (cadr u))))
              dy (+ dy (* *QS-V3CUT-LECH* (car u)))))
      (setq p (QS-PtsDoan pts (car interval) (cadr interval) dx dy)
            e (QS-VePts p "QS_ThepCatV3"))
      (if (null e) (/ 1 0))
      (setq *QS-C34Made* (cons e *QS-C34Made*) index (1+ index))
      (setq strings (list "CUT1;PREVIEW"
        (strcat "ROOT;" (cdr (assoc 5 (entget (nth 1 plan)))))
        (strcat "SOURCE;" (cdr (assoc 5 (entget (nth 1 row)))))
        (strcat "PIECE;" (itoa index) ";" (rtos (car interval) 2 8) ";" (rtos (cadr interval) 2 8))
        (strcat "SHIFT;" (rtos (car shift) 2 8) ";" (rtos (cadr shift) 2 8))))
      (if (null (entmod (append (entget e) (list (list -3 (cons "QS_BT_V3_CUT"
            (mapcar '(lambda (x) (cons 1000 x)) strings))))))) (/ 1 0))
      (if (> (abs (- (QS-DaiPts (QS-DinhDuong e)) (- (cadr interval) (car interval)))) 0.001) (/ 1 0))
      ;; v1.0.0: thanh <= 1 cay (khong cat) -> nhom rieng, khong gop voi doan dau cua thanh dai
      ;; v1.0.0: thanh khong cat KHONG tach chan / le khi cat so le -> 1 nhom, buoc rai goc
      (setq key (if (cdr (nth 3 row)) (if (= par 1) (+ 1000 index) index) 500))
      (setq records (cons (list e (car row) key interval) records))))
  (reverse records))

(defun QS-V3CutPreview (e stock lap minimum shift / plan result *QS-C34Made* item)
  (setq plan (QS-V3CutPlan e stock lap minimum))
  (cond
    ((not (car plan)) plan)
    ((not (QS-V3CutCheck plan stock lap minimum)) (list nil '("Phuong an cat khong dat kiem tra.")))
    ((not (and (listp shift) (= (length shift) 2) (vl-every 'numberp shift)))
     (list nil '("Vector dich chuyen phai la 2 so XY.")))
    (T
      (QS-V3MauLayer "QS_ThepCatV3" 1)
      (if (= 4 (logand 4 (cdr (assoc 70 (tblsearch "LAYER" "QS_ThepCatV3")))) )
        (list nil '("Layer QS_ThepCatV3 dang khoa."))
        (progn
          (setq result (vl-catch-all-apply 'QS-V3CutDrawWork (list plan shift)))
          (if (vl-catch-all-error-p result)
            (progn
              (foreach item *QS-C34Made* (if (entget item) (entdel item)))
              (list nil (list (strcat "Da huy ket qua loi: " (vl-catch-all-error-message result)))))
            (list T result)))))))

(defun c:OS_VEXEMCATBT3 (/ *error* doc pick stock lap minimum p q shift result msg)
  (defun *error* (msg)
    (foreach msg *QS-C34Made* (if (entget msg) (entdel msg)))
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc))) (princ))
  (setq pick (entsel "\nChon nhom V3: ve XEM phoi, KHONG thay the nguon: "))
  (if pick
    (progn
      (initget 6) (setq stock (getreal "\nChieu dai cay <11700>: ")) (if (null stock) (setq stock 11700.0))
      (initget 4) (setq lap (getreal "\nNoi chong mm <500>: ")) (if (null lap) (setq lap 500.0))
      (initget 6) (setq minimum (getreal "\nDoan toi thieu <2000>: ")) (if (null minimum) (setq minimum 2000.0))
      (setq p (getpoint "\nDiem goc dich chuyen <Enter huy>: "))
      (if p (setq q (getpoint p "\nDiem dat ket qua <Enter huy>: ")))
      (if (and p q)
        (progn
          (setq p (trans p 1 0) q (trans q 1 0) shift (list (- (car q) (car p)) (- (cadr q) (cadr p))))
          (setq doc (QS-Doc)) (vla-StartUndoMark doc)
          (setq result (QS-V3CutPreview (car pick) stock lap minimum shift))
          (if (car result)
            (princ (strcat "\n[BT3] Da ve " (itoa (length (cadr result))) " doan XEM tren QS_ThepCatV3; giu nguyen nguon."))
            (foreach msg (cadr result) (princ (strcat "\n[BT3] " msg))))
          (vla-EndUndoMark doc) (setq doc nil)))))
  (princ))
(princ "\n  OS_VEXEMCATBT3 - Ve xem phoi V3 rieng, khong xoa nguon")
(princ)

(defun QS-C35Plan (e stock lap minimum mode first1 first2 library / plan bars row old raw g item intervals converted seq)
  (setq plan (QS-V3CutPlan e stock lap minimum))
  (if (or (not (car plan)) (= mode "TuDo")) plan
    (if (not (member mode '("L1L2" "ThuVien")))
      (list nil '("Che do cat khong hop le."))
      (progn
        (setq seq 0)
        (foreach row (nth 2 plan)
          (setq bars (append bars (list (list seq 0.0 0.0
            (distance (car (nth 2 row)) (cadr (nth 2 row)))
            (distance (car (nth 2 row)) (cadr (nth 2 row))) 0.0 0.0))) seq (1+ seq)))
        (if (= mode "L1L2")
          (setq raw (QS-BTOneEndPlans bars first1 first2 stock lap minimum T))
          (progn
            (setq old (QS-BTCommonMidPlan bars stock lap minimum library nil nil))
            (foreach g old (setq raw (append raw (nth 2 g))))))
        (if (/= (length raw) (length bars))
          (list nil '("Khong co phuong an dung L1/L2/thu vien va doan toi thieu. Khong tu doi thong so."))
          (progn
            (setq seq 0)
            (foreach row (nth 2 plan)
              (setq item (assoc seq raw)
                    intervals (mapcar '(lambda (p) (list (car p) (+ (car p) (cadr p)))) (nth 2 item))
                    converted (append converted (list (list (car row) (nth 1 row) (nth 2 row) intervals)))
                    seq (1+ seq)))
            (setq plan (list T (nth 1 plan) converted))
            (if (QS-V3CutCheck plan stock lap minimum) plan
              (list nil '("Phuong an khong qua kiem tra doc lap.")))))))))

(defun QS-C35Draw (plan shift ty rnd / step0 source tag item hd ti sh dia mck lap step sourceRep output bins key pair rec rows bars members rep repRow mid text tg rai before after i pts tagList u v tt rowsFixed row sCoord ids)
  (setq source (QS-V3Audit (nth 1 plan)))
  (foreach item (nth 2 source)
    (setq hd (QS-TachKT (car (QS-S23Read item)) ";"))
    (if (= (nth 2 hd) "SOLE") (setq tag item)))
  (setq ti (QS-DocXDataTho tag) sh (QS-TachFieldXData ti 1) dia (QS-TachFieldXData ti 3)
        mck (QS-TachFieldXData ti 0) lap (QS-TachFieldXData ti 4)
        sourceRep (handent (QS-TachFieldXData ti 2))
        step (QS-DocKhoangCach (QS-LayTagBT tag)))
  (if (<= step 0.0) (/ 1 0))
  ;; v20.21: vi tri thanh dai dien CHUA CAT (+ vector dich chuyen) -> giu vi tri tag / rai sau khi cat
  (setq *QS-V3CUT-SRCP*
    (if (and sourceRep (entget sourceRep) (setq pts (QS-DinhDuong sourceRep)))
      (list (+ (car (car pts)) (car shift)) (+ (cadr (car pts)) (cadr shift)))))
  ;; v20.22: nhom (chan / le) chua thanh goc; huong lech nhom kia chon 1 lan cho ca nhom
  (setq *QS-V3CUT-PAR0* (if (and sourceRep (assoc sourceRep *QS-V3CUT-PAR*)) (cdr (assoc sourceRep *QS-V3CUT-PAR*)) 0)
        *QS-V3CUT-DIR* nil)
  (setq step0 step)
  (setq *QS-V3CUT-REPID* (QS-V3ChonThanhDD plan sourceRep))
  (setq output (QS-V3CutDrawWork plan shift))
  (foreach rec output
    (setq key (nth 2 rec) pair (assoc key bins))
    (if pair (setq bins (subst (append pair (list rec)) pair bins))
      (setq bins (append bins (list (list key rec))))))
  ;; v20.15: so hieu phu tuan tu SH.1, SH.2 ... theo thu tu nhom
  (setq *QS-V3CUT-SO* nil *QS-V3CUT-STREP* nil i 0)
  (foreach pair bins
    (setq i (1+ i) *QS-V3CUT-SO* (cons (cons (car pair) i) *QS-V3CUT-SO*)))
  (foreach pair bins
    (setq key (car pair) rows nil bars nil members nil i 0)
    ;; so le: nhom doan cat buoc 2a; nhom thanh khong cat (key 500) giu buoc a
    (setq step (if (and *QS-V3CUT-SOLE* (< (rem key 1000) 500)) (* 2.0 step0) step0))
    (setq ids nil)
    (foreach rec (cdr pair)
      (setq pts (QS-DinhDuong (car rec))
            rows (append rows (list (list i pts (QS-GiuaDoanDai pts))))
            bars (append bars (list (car rec))) ids (append ids (list (nth 1 rec))) i (1+ i)))
    ;; v20.24: thanh dai dien = DUNG thanh da chon cho nhom (theo so thu tu) -> doan noi cung 1 thanh
    (setq mid (if (and *QS-V3CUT-REPID* (< (rem key 1000) 500)
                       (setq i (vl-position (cdr (assoc (if (>= key 1000) 1 0) *QS-V3CUT-REPID*)) ids)))
                i
                (QS-V3ChonMid rows key))
          rep (nth mid bars) repRow (nth mid rows)
          text (strcat (itoa (length rows)) "%%c" dia "a" (rtos step 2 0) " (L="
            (QS-ChuoiChieuDai (apply 'min (mapcar '(lambda (r) (QS-DaiPts (cadr r))) rows))
                             (apply 'max (mapcar '(lambda (r) (QS-DaiPts (cadr r))) rows)) rnd) ")"))
    (setq u (QS-HuongPts (cadr repRow)) v (list (- (cadr u)) (car u))
          tt (QS-B2Dot (nth 2 repRow) u) rowsFixed nil)
    (foreach row rows
      (setq sCoord (QS-B2Dot (car (cadr row)) v))
      (setq rowsFixed (append rowsFixed (list (list (car row) (cadr row) (QS-Pt u v sCoord tt))))))
    (setq rows rowsFixed repRow (nth mid rows))
    (setq tg (vlax-vla-object->ename (QS-ChenTagThep (QS-Space (QS-Doc)) (nth 2 repRow) ty text
              (strcat sh "." (QS-V3TenC key)) "" (QS-GocDoc (QS-HuongPts (cadr repRow))))))
    (setq *QS-C34Made* (cons tg *QS-C34Made*) members (append bars (list tg)) rai nil)
    (if (> (length rows) 1)
      (progn
        (setq before (entlast))
        (setq rai (QS-VeDuongRai (QS-Space (QS-Doc))
          (nth 2 (car rows)) (nth 2 (last rows)) (nth 2 repRow) (* ty 2.5)))
        (if (null rai) (/ 1 0))
        (setq after (entnext before))
        (while after
          (if (member (cdr (assoc 0 (entget after))) '("DIMENSION" "CIRCLE"))
            (setq members (cons after members) *QS-C34Made* (cons after *QS-C34Made*)))
          (setq after (entnext after)))))
    (QS-GanBoLienKet rep tg rai mck (strcat sh "." (QS-V3TenC key)) (strcat sh "." (QS-V3TenC key)) dia lap step (length rows) "")
    (foreach item bars
      (QS-GanXDThep item mck (strcat sh "." (QS-V3TenC key)) dia lap
        (if rai (QS-TachFieldXData (QS-DocXDataTho rai) 2) "") step)
      (if rai (QS-GanLinkRai item (cdr (assoc 5 (entget rai))))))
    (setq before (entlast))
    (setq *QS-V3-BAOTHANG* T)
    (setq item (vl-catch-all-apply 'QS-V3Attach32 (list rows bars rep tg rai members step 0.0 0.0 0)))
    (setq *QS-V3-BAOTHANG* nil)
    (if (vl-catch-all-error-p item) (/ 1 0))
    (if item
      (progn
        (setq *QS-C34Made* (cons item *QS-C34Made*))
        (QS-S22Write item (append (QS-S23Read item)
          (list (strcat "CUT_SOURCE;" (cdr (assoc 5 (entget (nth 1 plan))))))))
        (if (cadr (QS-V3Audit item)) (/ 1 0))))
    (setq tagList (cons tg tagList)))
  (list output (reverse tagList)))

(defun QS-C35Run (e stock lap minimum mode first1 first2 library shift ty rnd / plan)
  (setq plan (QS-C35Plan e stock lap minimum mode first1 first2 library))
  (if (not (car plan)) plan (QS-C35RunPlan plan shift ty rnd)))

(defun QS-C35RunPlan (plan shift ty rnd / result *QS-C34Made* *QS-S24-GROUPS* *QS-S22-GROUP* item group olddim oldecho mark next)
  (cond
    ((not (and (> ty 0) (>= rnd 1) (= (length shift) 2) (vl-every 'numberp shift))) (list nil '("Ty le/vector/lam tron khong hop le.")))
    (T
      (setq olddim (getvar "DIMSTYLE") oldecho (getvar "CMDECHO") mark (entlast))
      (QS-V3MauLayer "QS_ThepCatV3" 1) (QS-DamBaoLayer "QS_Block" 7) (QS-DamBaoLayer "QS_Symbol" 8)
      (QS-TaoBlockTag) (QS-ChuanBiRaiStyle (* ty 2.5) "F")
      (setq result (vl-catch-all-apply 'QS-C35Draw (list plan shift ty rnd)))
      (if (vl-catch-all-error-p result)
        (progn
          (foreach group *QS-S24-GROUPS* (vl-catch-all-apply 'vla-Delete (list group)))
          (setq item (entnext mark))
          (while item
            (setq next (entnext item))
            (if (not (member (cdr (assoc 0 (entget item))) '("ATTRIB" "SEQEND"))) (entdel item))
            (setq item next))
          (setq result (list nil (list (vl-catch-all-error-message result)))))
        (setq result (list T result)))
      (command "_.-DIMSTYLE" "_R" olddim) (setvar "CMDECHO" oldecho)
      result)))

(defun c:OS_CATBT3 (/ *error* doc pick stock lap minimum mode first1 first2 library p q result msg ty rnd)
  (defun *error* (msg)
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if msg (princ (strcat "\n[BT3] " msg))) (princ))
  (setq pick (entsel "\nChon nhom V3 de cat, GIU NGUYEN nguon: "))
  (if pick
    (progn
      (initget "TuDo L1L2 ThuVien") (setq mode (getkword "\nChe do [TuDo/L1L2/ThuVien] <TuDo>: "))
      (if (null mode) (setq mode "TuDo"))
      (initget 6) (setq stock (getreal "\nCay thep <11700>: ")) (if (null stock) (setq stock 11700.0))
      (initget 4) (setq lap (getreal "\nNoi chong mm <500>: ")) (if (null lap) (setq lap 500.0))
      (initget 6) (setq minimum (getreal "\nDoan toi thieu <2000>: ")) (if (null minimum) (setq minimum 2000.0))
      (setq first1 stock first2 (/ stock 2.0))
      (if (= mode "L1L2")
        (progn
          (initget 6) (setq p (getreal "\nL1 <bang cay thep>: ")) (if p (setq first1 p))
          (initget 6) (setq p (getreal "\nL2 <nua cay>: ")) (if p (setq first2 p))))
      (if (= mode "ThuVien") (setq library (QS-TachSo (getstring T "\nThu vien doan giua, vd 10400,9000 <rong>: "))))
      (initget 6) (setq ty (getreal "\nTy le tag <50>: ")) (if (null ty) (setq ty 50.0))
      (setq p (getpoint "\nDiem goc dich chuyen <Enter huy>: "))
      (if p (setq q (getpoint p "\nDiem dat ket qua <Enter huy>: ")))
      (if (and p q)
        (progn
          (setq p (trans p 1 0) q (trans q 1 0) doc (QS-Doc)) (vla-StartUndoMark doc)
          (setq result (QS-C35Run (car pick) stock lap minimum mode first1 first2 library
            (list (- (car q) (car p)) (- (cadr q) (cadr p))) ty 1))
          (if (car result)
            (princ (strcat "\n[BT3] Da ve " (itoa (length (car (cadr result)))) " doan + "
              (itoa (length (cadr (cadr result)))) " tag. Nguon giu nguyen."))
            (foreach msg (cadr result) (princ (strcat "\n[BT3] " msg))))
          (vla-EndUndoMark doc) (setq doc nil)))))
  (princ))

;;; =====================================================================
;;;  OS_VUNGSAN  -  MAT BANG KET CAU: VUNG SAN (v1.0.0)
;;;  Moi vung san = 1 LWPOLYLINE kin mang XDATA app "QS_VUNGSAN":
;;;     "VS1"  Ten  Hs(mm)  Cote(m)  Goc(do | "" = theo lenh)  hLine  hNhan  hNen
;;;  Doi tuong phu (line huong, nhan, nen) mang XDATA "VSLINK" + handle vung.
;;;  OS_THEPSAN doc vung (khi tick "Dung VUNG SAN"):
;;;   - Hs / Cote lay theo diem giua tung doan thep (vung nho nhat chua diem).
;;;   - Cat doan thep tai ranh vung khi Hs / Cote hai ben khac nhau.
;;;   - Vung co goc rieng -> rai theo huong rieng, phan con lai theo huong lenh.
;;; =====================================================================

(setq *QSVS-APP* "QS_VUNGSAN")

(defun QSVS-Reg ()
  (if (not (tblsearch "APPID" *QSVS-APP*)) (regapp *QSVS-APP*))
  *QSVS-APP*
)

(defun QSVS-MacDinh ()
  (if (not *QSVS-TEN*)  (setq *QSVS-TEN* "S1"))
  (if (not *QSVS-HS*)   (setq *QSVS-HS* "150"))
  (if (not *QSVS-CT*)   (setq *QSVS-CT* "0.000"))
  (if (not *QSVS-MAU*)  (setq *QSVS-MAU* "4"))
  (if (not *QSVS-HR*)   (setq *QSVS-HR* "hr_md"))
  (if (not *QSVS-GOC*)  (setq *QSVS-GOC* "0"))
  (if (not *QSVS-TAO*)  (setq *QSVS-TAO* "tv_diem"))
  (if (not *QSVS-LAY*)  (setq *QSVS-LAY* "QS_VungSan"))
  (if (not *QSVS-LHR*)  (setq *QSVS-LHR* "Defpoints"))
  (if (not *QSVS-TYLE*) (setq *QSVS-TYLE* (if *QS4-TYL* *QS4-TYL* "50")))
  (if (not *QSVS-NHAN*) (setq *QSVS-NHAN* "1"))
  (if (not *QSVS-NEN*)  (setq *QSVS-NEN* "0"))
  (if (not *QSVS-TB*)   (setq *QSVS-TB* ""))
  (princ)
)

;; ---------------------------------------------------------------- dinh dang
(defun QSVS-Rtos (x p / dz r)
  (setq dz (getvar "DIMZIN"))
  (setvar "DIMZIN" 0)
  (setq r (rtos x 2 p))
  (setvar "DIMZIN" dz)
  r
)
(defun QSVS-FCote (c) (strcat (if (< c 0.0) "-" "+") (QSVS-Rtos (abs c) 3)))
(defun QSVS-FHs (h) (if (equal h (fix h) 1.0e-6) (itoa (fix h)) (QSVS-Rtos h 1)))
(defun QSVS-FGoc (g) (if g (strcat (QSVS-Rtos g 1) "d") "lenh"))
(defun QSVS-Pad (s n) (while (< (strlen s) n) (setq s (strcat s " "))) s)

;; ---------------------------------------------------------------- XDATA
(defun QSVS-XD (e / x)
  (if (and e (entget e))
    (progn
      (setq x (cdr (assoc -3 (entget e (list *QSVS-APP*)))))
      (if x (mapcar 'cdr (cdr (car x))) nil))
    nil)
)

(defun QSVS-GhiXD (e strs / ed)
  (QSVS-Reg)
  (setq ed (entget e))
  (setq ed (append ed
             (list (list -3 (cons *QSVS-APP*
                                  (mapcar (function (lambda (s) (cons 1000 s))) strs))))))
  (if (entmod ed) (progn (entupd e) T) nil)
)

(defun QSVS-BoXD (e / ed)
  (setq ed (append (entget e) (list (list -3 (list *QSVS-APP*)))))
  (if (entmod ed) (progn (entupd e) T) nil)
)

(defun QSVS-Handle (e) (cdr (assoc 5 (entget e))))

;; Doc vung -> (ten hs cote goc hLine hNhan hNen) hoac nil
(defun QSVS-Doc (e / x hs ct g)
  (setq x (QSVS-XD e))
  (if (and x (= (car x) "VS1"))
    (progn
      (setq hs (QS-Num (nth 2 x)) ct (QS-Num (nth 3 x)) g (QS-Num (nth 4 x)))
      (if (and hs ct)
        (list (if (nth 1 x) (nth 1 x) "") hs ct g
              (if (nth 5 x) (nth 5 x) "")
              (if (nth 6 x) (nth 6 x) "")
              (if (nth 7 x) (nth 7 x) ""))
        nil))
    nil)
)

(defun QSVS-Luu (e d)
  (QSVS-GhiXD e
    (list "VS1" (car d) (QSVS-Rtos (cadr d) 1) (QSVS-Rtos (caddr d) 4)
          (if (nth 3 d) (QSVS-Rtos (nth 3 d) 4) "")
          (nth 4 d) (nth 5 d) (nth 6 d)))
)

(defun QSVS-LaLink (e hv / x)
  (and e (entget e) (setq x (QSVS-XD e)) (= (car x) "VSLINK") (= (cadr x) hv))
)

;; Chi xoa doi tuong khi no tro nguoc dung vung hv (an toan voi vung copy)
(defun QSVS-XoaLink (h hv / e)
  (if (and h (/= h "") (setq e (handent h)) (QSVS-LaLink e hv))
    (progn (entdel e) T)
    nil)
)

;; ---------------------------------------------------------------- hinh hoc
(defun QSVS-Pts (e / ed bl n i k pts p)
  (setq ed (entget e) bl nil pts nil)
  (foreach x ed (if (= (car x) 42) (setq bl (cons (cdr x) bl))))
  (setq bl (reverse bl))
  (setq n (fix (+ 0.5 (vlax-curve-getEndParam e))) i 0)
  (while (< i n)
    (if (setq p (vlax-curve-getPointAtParam e i)) (setq pts (cons p pts)))
    (if (and (nth i bl) (> (abs (nth i bl)) 1.0e-9))
      (progn
        (setq k 1)
        (while (< k 8)
          (if (setq p (vlax-curve-getPointAtParam e (+ i (/ k 8.0))))
            (setq pts (cons p pts)))
          (setq k (1+ k)))))
    (setq i (1+ i))
  )
  (mapcar (function (lambda (q) (list (car q) (cadr q)))) (reverse pts))
)

(defun QSVS-DienTich (pts / s p)
  (setq s 0.0 p (last pts))
  (foreach q pts
    (setq s (+ s (- (* (car p) (cadr q)) (* (car q) (cadr p)))) p q))
  (/ s 2.0)
)

(defun QSVS-BB (pts / x1 y1 x2 y2)
  (foreach p pts
    (if (null x1)
      (setq x1 (car p) y1 (cadr p) x2 (car p) y2 (cadr p))
      (setq x1 (min x1 (car p)) y1 (min y1 (cadr p))
            x2 (max x2 (car p)) y2 (max y2 (cadr p)))))
  (list x1 y1 x2 y2)
)

(defun QSVS-BBGiao (a b)
  (and a b
       (<= (car a) (caddr b)) (>= (caddr a) (car b))
       (<= (cadr a) (cadddr b)) (>= (cadddr a) (cadr b)))
)

(defun QSVS-Trong (pt pts / x y in a)
  (setq x (car pt) y (cadr pt) in nil a (last pts))
  (foreach b pts
    (if (and (/= (> (cadr a) y) (> (cadr b) y))
             (< x (+ (car a) (/ (* (- y (cadr a)) (- (car b) (car a)))
                                (- (cadr b) (cadr a))))))
      (setq in (not in)))
    (setq a b))
  in
)

;; Diem dat nhan: trong tam; neu roi ra ngoai (vung chu L) -> giua day cung rong nhat.
(defun QSVS-DiemNhan (pts / A cx cy p cr y xs best bw i res bb)
  (setq A 0.0 cx 0.0 cy 0.0 p (last pts))
  (foreach q pts
    (setq cr (- (* (car p) (cadr q)) (* (car q) (cadr p))))
    (setq A (+ A cr)
          cx (+ cx (* (+ (car p) (car q)) cr))
          cy (+ cy (* (+ (cadr p) (cadr q)) cr)))
    (setq p q))
  (if (> (abs A) 1.0e-9)
    (setq res (list (/ cx (* 3.0 A)) (/ cy (* 3.0 A))))
    (setq res (QS-TamDinh pts)))
  (if (not (QSVS-Trong res pts))
    (progn
      (setq bb (QSVS-BB pts) best nil)
      (foreach y (list (cadr res) (/ (+ (cadr bb) (cadddr bb)) 2.0))
        (if (null best)
          (progn
            (setq xs nil p (last pts))
            (foreach q pts
              (if (/= (> (cadr p) y) (> (cadr q) y))
                (setq xs (cons (+ (car p) (/ (* (- y (cadr p)) (- (car q) (car p)))
                                             (- (cadr q) (cadr p)))) xs)))
              (setq p q))
            (setq xs (QS-Sap xs '<) bw 0.0 i 0)
            (while (< (1+ i) (length xs))
              (if (> (- (nth (1+ i) xs) (nth i xs)) bw)
                (setq bw (- (nth (1+ i) xs) (nth i xs))
                      best (list (/ (+ (nth i xs) (nth (1+ i) xs)) 2.0) y)))
              (setq i (+ i 2))))))
      (setq res (if best best (car pts)))))
  res
)

(defun QSVS-GocDo (p1 p2 / a)
  ;; tinh theo WCS (khong phu thuoc UCS hien hanh)
  (setq a (/ (* 180.0 (atan (- (cadr p2) (cadr p1)) (- (car p2) (car p1)))) pi))
  (while (>= a 180.0) (setq a (- a 180.0)))
  (while (< a 0.0) (setq a (+ a 180.0)))
  (/ (fix (+ 0.5 (* 100.0 a))) 100.0)
)

;; ---------------------------------------------------------------- layer
(defun QSVS-LayerKhongIn (ten mau / o)
  (QS-DamBaoLayer ten mau)
  (setq o (vl-catch-all-apply 'vla-Item (list (vla-get-Layers (QS-Doc)) ten)))
  (if (not (vl-catch-all-error-p o))
    (vl-catch-all-apply 'vla-put-Plottable (list o :vlax-false)))
  ten
)

;; Layer line huong: mac dinh Defpoints. Neu layer bi KHOA / DONG BANG thi KHONG
;; mo khoa layer cua ban ve mau, chuyen sang QS_VS_HuongRai (khong in).
(defun QSVS-LayerHR (ten / rec)
  (if (or (null ten) (= ten "")) (setq ten "Defpoints"))
  (setq rec (tblsearch "LAYER" ten))
  (cond
    ((null rec)
     (entmakex (list '(0 . "LAYER") '(100 . "AcDbSymbolTableRecord")
                     '(100 . "AcDbLayerTableRecord") (cons 2 ten) '(70 . 0)
                     '(62 . 8) '(6 . "Continuous") '(290 . 0)))
     ten)
    ((/= 0 (logand 5 (cdr (assoc 70 rec))))
     (princ (strcat "\n[Chu y] Layer \"" ten "\" dang khoa / dong bang -> ve line huong"
                    " tren layer QS_VS_HuongRai (khong in)."))
     (QSVS-LayerKhongIn "QS_VS_HuongRai" 8))
    (T ten))
)

;; ---------------------------------------------------------------- doi tuong phu
(defun QSVS-Elev (e / z) (setq z (cdr (assoc 38 (entget e)))) (if z z 0.0))

(defun QSVS-VeLine (p1 p2 hv mau z / e)
  (setq e (entmakex
            (list '(0 . "LINE") '(100 . "AcDbEntity") (cons 8 (QSVS-LayerHR *QSVS-LHR*))
                  (cons 62 mau) '(100 . "AcDbLine")
                  (list 10 (car p1) (cadr p1) z) (list 11 (car p2) (cadr p2) z))))
  (if e (progn (QSVS-GhiXD e (list "VSLINK" hv)) (QSVS-Handle e)) "")
)

(defun QSVS-CaoChu ( / t0)
  (setq t0 (QS-Num *QSVS-TYLE*))
  (* 2.5 (if (and t0 (> t0 0.0)) t0 50.0))
)

;; Line huong tu dong (che do nhap goc): nam giua vung, duoi nhan.
(defun QSVS-LineTuDong (e goc hv / pts bb p L a dx dy h)
  (setq pts (QSVS-Pts e) bb (QSVS-BB pts) p (QSVS-DiemNhan pts))
  (setq L (* 0.35 (min (- (caddr bb) (car bb)) (- (cadddr bb) (cadr bb)))))
  (setq h (QSVS-CaoChu))
  (if (= *QSVS-NHAN* "1") (setq p (list (car p) (- (cadr p) (* 2.4 h)))))
  (if (not (QSVS-Trong p pts)) (setq p (QSVS-DiemNhan pts)))
  (setq a (/ (* goc pi) 180.0) dx (* 0.5 L (cos a)) dy (* 0.5 L (sin a)))
  (QSVS-VeLine (list (- (car p) dx) (- (cadr p) dy)) (list (+ (car p) dx) (+ (cadr p) dy))
               hv (atoi *QSVS-MAU*) (QSVS-Elev e))
)

(defun QSVS-VeNhan (e d hv mau / pts p h txt en)
  (setq pts (QSVS-Pts e) p (QSVS-DiemNhan pts) h (QSVS-CaoChu))
  (setq txt (strcat (if (/= (car d) "") (strcat (car d) "\\P") "")
                    "Hs=" (QSVS-FHs (cadr d)) "\\P"
                    "Cote=" (QSVS-FCote (caddr d))))
  (QS-DamBaoLayer "QS_VungSan_Nhan" 7)
  (setq en (entmakex
             (list '(0 . "MTEXT") '(100 . "AcDbEntity") '(8 . "QS_VungSan_Nhan")
                   (cons 62 mau) '(100 . "AcDbMText")
                   (list 10 (car p) (cadr p) (QSVS-Elev e))
                   (cons 40 h) '(41 . 0.0) '(71 . 5) '(72 . 5)
                   (cons 7 (getvar "TEXTSTYLE")) (cons 1 txt))))
  (if en (progn (QSVS-GhiXD en (list "VSLINK" hv)) (QSVS-Handle en)) "")
)

(defun QSVS-VeNen (e mau hv / spc hat r sa)
  (QSVS-LayerKhongIn "QS_VungSan_Nen" 8)
  (setq spc (QS-Space (QS-Doc)))
  (setq hat (vl-catch-all-apply 'vla-AddHatch (list spc 1 "SOLID" :vlax-true)))
  (if (vl-catch-all-error-p hat)
    ""
    (progn
      (setq sa (vlax-make-safearray vlax-vbObject '(0 . 0)))
      (vlax-safearray-fill sa (list (vlax-ename->vla-object e)))
      (setq r (vl-catch-all-apply 'vla-AppendOuterLoop (list hat sa)))
      (if (vl-catch-all-error-p r)
        (progn (vl-catch-all-apply 'vla-Delete (list hat)) "")
        (progn
          (vl-catch-all-apply 'vla-Evaluate (list hat))
          (vl-catch-all-apply 'vla-put-Layer (list hat "QS_VungSan_Nen"))
          (vl-catch-all-apply 'vla-put-Color (list hat mau))
          (vl-catch-all-apply 'vla-put-EntityTransparency (list hat "80"))
          (QSVS-GhiXD (vlax-vla-object->ename hat) (list "VSLINK" hv))
          (vla-get-Handle hat)))))
)

;; Ve lai nhan + nen theo du lieu dang luu tren vung.
(defun QSVS-LamMoi (e / d hv ed mau hn hh)
  (if (setq d (QSVS-Doc e))
    (progn
      (setq hv (QSVS-Handle e))
      (QSVS-XoaLink (nth 5 d) hv)
      (QSVS-XoaLink (nth 6 d) hv)
      (setq ed (entget e) mau (if (assoc 62 ed) (cdr (assoc 62 ed)) 256) hn "" hh "")
      (if (= *QSVS-NHAN* "1") (setq hn (QSVS-VeNhan e d hv mau)))
      (if (= *QSVS-NEN* "1")  (setq hh (QSVS-VeNen e mau hv)))
      (QSVS-Luu e (list (car d) (cadr d) (caddr d) (nth 3 d) (nth 4 d) hn hh))))
)

;; Gan thong so cho 1 polyline vung (tao moi hoac ghi de).
(defun QSVS-Gan (e ten hs ct goc hLine / d hv ed mau)
  (setq hv (QSVS-Handle e) d (QSVS-Doc e) mau (atoi *QSVS-MAU*))
  (QS-DamBaoLayer *QSVS-LAY* 4)
  (setq ed (entget e))
  (setq ed (subst (cons 8 *QSVS-LAY*) (assoc 8 ed) ed))
  (setq ed (if (assoc 62 ed)
             (subst (cons 62 mau) (assoc 62 ed) ed)
             (append ed (list (cons 62 mau)))))
  (entmod ed)
  (if (and d (/= (nth 4 d) hLine)) (QSVS-XoaLink (nth 4 d) hv))
  (if (QSVS-Luu e (list ten hs ct goc hLine (if d (nth 5 d) "") (if d (nth 6 d) "")))
    (progn (QSVS-LamMoi e) T)
    nil)
)

;; ---------------------------------------------------------------- thu thap vung
(defun QSVS-DSVung ( / ss i e res)
  (setq ss (ssget "_X" (list '(0 . "LWPOLYLINE") (list -3 (list *QSVS-APP*)))) i 0)
  (while (and ss (< i (sslength ss)))
    (setq e (ssname ss i))
    (if (QSVS-Doc e) (setq res (cons e res)))
    (setq i (1+ i)))
  res
)

;; Ban ghi: (pts dientich hs cote goc vlaObj bbox ename)
;; bbS: hop bao san dang rai (nil = toan ban ve) - loai vung cua tang / mat bang khac.
(defun QSVS-ThuThap (bbS / e d pts bb res)
  (foreach e (QSVS-DSVung)
    (setq d (QSVS-Doc e) pts (QSVS-Pts e))
    (if (> (length pts) 2)
      (progn
        (setq bb (QSVS-BB pts))
        (if (or (null bbS) (QSVS-BBGiao bb bbS))
          (setq res (cons (list pts (abs (QSVS-DienTich pts)) (cadr d) (caddr d) (nth 3 d)
                                (vlax-ename->vla-object e) bb e) res))))))
  res
)

;; Vung NHO NHAT chua diem p (vung long trong vung lon duoc uu tien).
(defun QSVS-TimVung (ds p / best ba r bb)
  (foreach r ds
    (setq bb (nth 6 r))
    (if (and (>= (car p) (car bb)) (<= (car p) (caddr bb))
             (>= (cadr p) (cadr bb)) (<= (cadr p) (cadddr bb))
             (or (null ba) (< (cadr r) ba))
             (QSVS-Trong p (car r)))
      (setq best r ba (cadr r))))
  best
)

(defun QSVS-TraDiem (ds p / r)
  (if (setq r (QSVS-TimVung ds p)) (list (nth 2 r) (nth 3 r)) nil)
)

;; ---------------------------------------------------------------- cho OS_THEPSAN
;; Diem cat tai ranh vung: chi giu cho Hs/Cote hai ben KHAC nhau, cach dau doan >= 100.
(defun QSVS-Cat (ts kh ds u v s tsR / res ok a b)
  (foreach t0 (QS-Sap ts '<)
    (setq ok nil)
    (foreach iv kh
      (if (and (> t0 (+ (car iv) 100.0)) (< t0 (- (cadr iv) 100.0))) (setq ok T)))
    (if ok (foreach x tsR (if (< (abs (- x t0)) 1.0) (setq ok nil))))
    (if (and ok res (< (abs (- t0 (car res))) 100.0)) (setq ok nil))
    (if ok
      (progn
        (setq a (QSVS-TraDiem ds (QS-Pt u v s (- t0 60.0)))
              b (QSVS-TraDiem ds (QS-Pt u v s (+ t0 60.0))))
        (if (not (equal a b 1.0e-6)) (setq res (cons t0 res))))))
  (reverse res)
)

;; Nhom vung co goc rieng (goc gap 90 do lech khoi 0) -> (dsVung . dsTru) hoac nil
(defun QSVS-NhomHuong (ds gBase / g k pr grp tru)
  (foreach r ds
    (if (nth 4 r)
      (progn
        (setq g (QS-GocRai45 (* pi (/ (nth 4 r) 180.0))))
        (if (> (abs g) 1.0e-4)
          (progn
            (setq k (QS-R0 (* 10000.0 g)) pr (assoc k grp) tru (cons (nth 5 r) tru))
            (if pr
              (setq grp (subst (cons k (cons (nth 5 r) (cdr pr))) pr grp))
              (setq grp (cons (list k (nth 5 r)) grp))))))))
  (if grp
    (cons (cons (list gBase)
                (mapcar (function (lambda (x) (cons (+ gBase (/ (float (car x)) 10000.0)) (cdr x))))
                        (reverse grp)))
          tru)
    nil)
)

;; ---------------------------------------------------------------- DCL
(defun QSVS-TaoDCL ( / fn f q tmp)
  (setq q (chr 34))
  (setq tmp (getvar "TEMPPREFIX"))
  (setq fn (vl-filename-mktemp "qsvungsan" tmp ".dcl"))
  (if (not fn) (setq fn (strcat (if (and tmp (/= tmp "")) tmp "C:\\") "qsvungsan_tam.dcl")))
  (setq f (open fn "w"))
  (if (not f)
    (progn (princ (strcat "\n[Loi] Khong ghi duoc file tam: " fn)) nil)
    (progn
      (foreach L
        (list
          "qs_vungsan : dialog {"
          (strcat "  label = " q "Shop thep san  |  OS_VUNGSAN - Vung san: chieu day, cao do, huong rai     (v1.0.0)" q ";")
          (strcat "  initial_focus = " q "vshs" q ";")
          (QS-DCL-TX "Moi vung san = 1 polyline KIN mang thong so. OS_THEPSAN doc truc tiep tu polyline.   (*) = bat buoc")
          "  spacer;"
          "  : row {"
          "    : column { alignment = top; fixed_height = true;"
          (QS-DCL-BOX "  1. Thong so vung san  ")
          (QS-DCL-EB "vsten" "Ten vung (vd S1, S2, WC)" 10 "")
          (QS-DCL-EB "vshs"  "Chieu day san Hs (mm) *" 10 "")
          (QS-DCL-EB "vsct"  "Cao do mat san Cote (m) *" 10 "")
          "      : row {"
          (QS-DCL-EB "vsmau" "Mau vung (1 - 255)" 5 "")
          (strcat "      : image { key = " q "vsimg" q "; width = 8; height = 1.3; fixed_width = true; fixed_height = true; color = 4; }")
          "      }"
          (QS-DCL-TK "vsxem" "Mat BT / day BT" 46)
          "    }"
          (QS-DCL-BOX "  2. Huong rai thep (phuong luoi thep)  ")
          (strcat "      : radio_column { key = " q "vshr" q ";")
          (QS-DCL-RB "hr_md"  "Theo lenh OS_THEPSAN (luoi X - Y)" "")
          (QS-DCL-RB "hr_goc" "Nhap goc phuong chinh (tu ve line huong)" "")
          (QS-DCL-RB "hr_ve"  "Pick 2 diem ve line huong sau moi vung" "")
          "      }"
          (QS-DCL-EB "vsgoc"  "Goc so voi truc X (do)" 8 "")
          (QS-DCL-TX "Lop NGANG chay theo line, lop DUNG vuong goc line.")
          "    }"
          "    }"
          "    : column { alignment = top; fixed_height = true;"
          (strcat "    : boxed_radio_column { key = " q "vstao" q "; label = " q "  3. Cach tao vung  " q ";")
          (QS-DCL-RB "tv_diem" "Pick diem TRONG o san (tu do duong bien)" "")
          (QS-DCL-RB "tv_ve"   "Ve polyline moi (lenh PLINE)" "")
          (QS-DCL-RB "tv_chon" "Chon polyline KIN co san (gan moi hoac sua)" "")
          "    }"
          (QS-DCL-BOX "  4. The hien  ")
          (QS-DCL-EB "vslay"  "Layer vung san" 16 "")
          (QS-DCL-EB "vslhr"  "Layer line huong rai" 16 "")
          (QS-DCL-EB "vstyle" "Ty le ban ve 1 :" 8 "")
          (QS-DCL-TG "vsnhan" "Ghi nhan Ten / Hs / Cote tai tam vung")
          (QS-DCL-TG "vsnen"  "To nen mau trong suot (layer khong in)")
          (QS-DCL-TX "Vung nho nam trong vung lon: vung nho duoc uu tien.")
          "    }"
          "    }"
          "  }"
          (QS-DCL-BOX "  5. Cac loai vung da co trong ban ve (bam 1 dong de lay lai thong so)  ")
          (strcat "      : list_box { key = " q "vsds" q "; height = 8; width = 84; fixed_width_font = true; }")
          "      : row { alignment = centered;"
          (QS-DCL-BT "vsbmau"   "  Lay tu vung <  ")
          (QS-DCL-BT "vsbhuong" "  Gan huong tu line <  ")
          (QS-DCL-BT "vsbnhan"  "  Cap nhat nhan / nen  ")
          (QS-DCL-BT "vsbgo"    "  Go vung <  ")
          "      }"
          "  }"
          (QS-DCL-TK "vsloi" " " 84)
          "  : text { label = \"Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995\"; alignment = centered; }"
          "  : row { alignment = centered; fixed_width = true;"
          (strcat "    : button { key = " q "accept" q "; label = " q "   Tao / gan vung   " q "; is_default = true; fixed_width = true; }")
          (strcat "    : button { key = " q "cancel" q "; label = " q "   Dong   " q "; is_cancel = true; fixed_width = true; }")
          "  }"
          "}"
          "")
        (write-line L f))
      (close f)
      fn))
)

(defun QSVS-NapDCL ( / id)
  (if (not (and *QSVS-DCL-1914* (findfile *QSVS-DCL-1914*)))
    (setq *QSVS-DCL-1914* (QSVS-TaoDCL)))
  (if *QSVS-DCL-1914*
    (progn
      (setq id (load_dialog *QSVS-DCL-1914*))
      (if (and id (>= id 0)) id (progn (setq *QSVS-DCL-1914* nil) nil)))
    nil)
)

;; ---------------------------------------------------------------- tile
(defun QSVS-Swatch (m / w h c)
  (setq c (if (and (QS-Num m) (<= 1 (atoi m) 255)) (atoi m) 0))
  (setq w (dimx_tile "vsimg") h (dimy_tile "vsimg"))
  (start_image "vsimg")
  (fill_image 0 0 w h (if (> c 0) c -15))
  (end_image)
)

(defun QSVS-Xem ( / hs ct)
  (setq hs (QS-Num (get_tile "vshs")) ct (QS-Num (get_tile "vsct")))
  (set_tile "vsxem"
    (if (and hs ct (> hs 0))
      (strcat "Mat BT " (QSVS-FCote ct) "   |   Day BT "
              (QSVS-FCote (- ct (/ hs 1000.0))) "   |   Hs " (QSVS-FHs hs))
      "(nhap Hs > 0 va Cote la so)"))
  (QSVS-Swatch (get_tile "vsmau"))
)

(defun QSVS-ModeHR ( / )
  (mode_tile "vsgoc" (if (= (get_tile "vshr") "hr_goc") 0 1))
)

(defun QSVS-DocTile ( / )
  (setq *QSVS-TEN*  (vl-string-trim " " (get_tile "vsten"))
        *QSVS-HS*   (vl-string-trim " " (get_tile "vshs"))
        *QSVS-CT*   (vl-string-trim " " (get_tile "vsct"))
        *QSVS-MAU*  (vl-string-trim " " (get_tile "vsmau"))
        *QSVS-HR*   (get_tile "vshr")
        *QSVS-GOC*  (vl-string-trim " " (get_tile "vsgoc"))
        *QSVS-TAO*  (get_tile "vstao")
        *QSVS-LAY*  (vl-string-trim " " (get_tile "vslay"))
        *QSVS-LHR*  (vl-string-trim " " (get_tile "vslhr"))
        *QSVS-TYLE* (vl-string-trim " " (get_tile "vstyle"))
        *QSVS-NHAN* (get_tile "vsnhan")
        *QSVS-NEN*  (get_tile "vsnen"))
  (princ)
)

;; Danh sach loai vung: (dong-hien-thi ten hs cote goc mau so-vung)
(defun QSVS-LapDS ( / e d ed key pr res)
  (foreach e (QSVS-DSVung)
    (setq d (QSVS-Doc e) ed (entget e))
    (setq key (strcat (car d) "|" (QSVS-Rtos (cadr d) 1) "|" (QSVS-Rtos (caddr d) 4)
                      "|" (if (nth 3 d) (QSVS-Rtos (nth 3 d) 2) "")))
    (if (setq pr (assoc key res))
      (setq res (subst (append (reverse (cdr (reverse pr))) (list (1+ (last pr)))) pr res))
      (setq res (cons (list key (car d) (cadr d) (caddr d) (nth 3 d)
                            (if (assoc 62 ed) (cdr (assoc 62 ed)) 256) 1) res))))
  (setq res (vl-sort res (function (lambda (a b) (< (car a) (car b))))))
  (mapcar
    (function (lambda (r)
      (cons (strcat (QSVS-Pad (if (= (nth 1 r) "") "(khong ten)" (nth 1 r)) 12)
                    (QSVS-Pad (strcat "Hs=" (QSVS-FHs (nth 2 r))) 10)
                    (QSVS-Pad (strcat "Cote=" (QSVS-FCote (nth 3 r))) 15)
                    (QSVS-Pad (strcat "Day=" (QSVS-FCote (- (nth 3 r) (/ (nth 2 r) 1000.0)))) 15)
                    (QSVS-Pad (strcat "Huong=" (QSVS-FGoc (nth 4 r))) 14)
                    (QSVS-Pad (strcat "Mau " (itoa (nth 5 r))) 9)
                    "x" (itoa (nth 6 r)))
            (cdr r))))
    res)
)

(defun QSVS-ChonDS (v / r)
  (if (and v (/= v "") (setq r (nth (atoi v) *QSVS-LOAI*)))
    (progn
      (set_tile "vsten" (nth 1 r))
      (set_tile "vshs" (QSVS-FHs (nth 2 r)))
      (set_tile "vsct" (QSVS-Rtos (nth 3 r) 3))
      (if (< 0 (nth 5 r) 256) (set_tile "vsmau" (itoa (nth 5 r))))
      (if (nth 4 r)
        (progn (set_tile "vshr" "hr_goc") (set_tile "vsgoc" (QSVS-Rtos (nth 4 r) 2)))
        (set_tile "vshr" "hr_md"))
      (QSVS-ModeHR)
      (QSVS-Xem)
      (set_tile "vsloi" (strcat "Da lay thong so loai \"" (nth 1 r) "\". Bam \"Tao / gan vung\" de ve tiep."))))
  (princ)
)

(defun QSVS-Loi (msg key) (set_tile "vsloi" (strcat "[Loi] " msg)) (mode_tile key 2) nil)

(defun QSVS-Accept ( / m)
  (QSVS-DocTile)
  (setq m (QS-Num *QSVS-MAU*))
  (cond
    ((or (not (QS-Num *QSVS-HS*)) (<= (QS-Num *QSVS-HS*) 0))
     (QSVS-Loi "Chieu day Hs phai la so > 0 (mm)." "vshs"))
    ((not (QS-Num *QSVS-CT*))
     (QSVS-Loi "Cao do Cote phai la so (m), vd 3.600 hoac -0.050." "vsct"))
    ((or (not m) (< m 1) (> m 255) (/= m (fix m)))
     (QSVS-Loi "Mau vung phai la so nguyen tu 1 den 255." "vsmau"))
    ((and (= *QSVS-HR* "hr_goc") (not (QS-Num *QSVS-GOC*)))
     (QSVS-Loi "Goc huong rai phai la so (do)." "vsgoc"))
    ((or (not (QS-Num *QSVS-TYLE*)) (<= (QS-Num *QSVS-TYLE*) 0))
     (QSVS-Loi "Ty le ban ve phai la so > 0." "vstyle"))
    ((= *QSVS-LAY* "")
     (QSVS-Loi "Chua nhap layer vung san." "vslay"))
    ((wcmatch (strcase *QSVS-TEN*) "*|*")
     (QSVS-Loi "Ten vung khong duoc chua ky tu |." "vsten"))
    (T (done_dialog 1)))
  (princ)
)

;; ---------------------------------------------------------------- tao vung
(defun QSVS-MoiTu (mk / e res)
  (setq e (if mk (entnext mk) (entnext)))
  (while e (setq res (cons e res) e (entnext e)))
  res
)

;; -BOUNDARY tai diem p -> polyline kin lon nhat, xoa phan thua (dao)
(defun QSVS-TuBien (p / mk moi best ba a coRegion os)
  (setq mk (entlast) os (getvar "OSMODE"))
  (setvar "OSMODE" (logior os 16384))
  (command "_.-BOUNDARY" p "")
  (setvar "OSMODE" os)
  (setq moi (QSVS-MoiTu mk) best nil ba -1.0)
  (foreach e moi
    (cond
      ((= (cdr (assoc 0 (entget e))) "LWPOLYLINE")
       (setq a (vl-catch-all-apply 'vlax-curve-getArea (list e)))
       (if (and (not (vl-catch-all-error-p a)) (> a ba)) (setq ba a best e)))
      ((= (cdr (assoc 0 (entget e))) "REGION") (setq coRegion T))))
  (foreach e moi (if (and (entget e) (not (equal e best))) (entdel e)))
  (cond
    (best best)
    (coRegion
     (princ "\n[Loi] Lenh BOUNDARY dang tao REGION. Go -BOUNDARY > Advanced options > Object type = Polyline roi chay lai.")
     nil)
    (T (princ "\n[Loi] Khong tim thay duong bien kin quanh diem nay (kiem tra net dam co bi ho khong).") nil))
)

(defun QSVS-VePL ( / mk e ed ce)
  (setq mk (entlast) ce (getvar "CMDECHO"))
  (setvar "CMDECHO" 1)
  (command "_.PLINE")
  (while (> (getvar "CMDACTIVE") 0) (command pause))
  (setvar "CMDECHO" ce)
  (setq e (entlast))
  (if (and e (not (equal e mk)) (= (cdr (assoc 0 (setq ed (entget e)))) "LWPOLYLINE"))
    (if (< (cdr (assoc 90 ed)) 3)
      (progn (entdel e) (princ "\n[Chu y] Polyline < 3 dinh - bo qua.") nil)
      (progn (vla-put-Closed (vlax-ename->vla-object e) :vlax-true) e))
    nil)
)

(defun QSVS-XuLyMot (e / hv ten hs ct goc hl p1 p2)
  (setq hv (QSVS-Handle e) ten *QSVS-TEN*
        hs (QS-Num *QSVS-HS*) ct (QS-Num *QSVS-CT*) goc nil hl "")
  (cond
    ((= *QSVS-HR* "hr_goc")
     (setq goc (QS-Num *QSVS-GOC*))
     (while (>= goc 180.0) (setq goc (- goc 180.0)))
     (while (< goc 0.0) (setq goc (+ goc 180.0)))
     (setq hl (QSVS-LineTuDong e goc hv)))
    ((= *QSVS-HR* "hr_ve")
     (redraw e 3)
     (setq p1 (getpoint (strcat "\n  Vung " ten ": pick diem 1 HUONG RAI <Enter = theo lenh>: ")))
     (if p1 (setq p2 (getpoint p1 "\n  Pick diem 2 huong rai: ")))
     (redraw e 4)
     (if (and p1 p2 (> (distance p1 p2) 1.0e-6))
       (progn
         (setq p1 (trans p1 1 0) p2 (trans p2 1 0) goc (QSVS-GocDo p1 p2))
         (setq hl (QSVS-VeLine p1 p2 hv (atoi *QSVS-MAU*) (QSVS-Elev e)))))))
  (if (QSVS-Gan e ten hs ct goc hl)
    (progn
      (princ (strcat "\n  + " (if (= ten "") "Vung" ten) "  Hs=" (QSVS-FHs hs)
                     "  Cote=" (QSVS-FCote ct) "  Huong=" (QSVS-FGoc goc)))
      T)
    (progn (princ "\n  [Loi] Khong ghi duoc du lieu len polyline (layer khoa?).") nil))
)

(defun QSVS-CanhBaoLong (p / r ds)
  (setq ds (QSVS-ThuThap nil))
  (if (setq r (QSVS-TimVung ds p))
    (princ (strcat "\n  [Chu y] Diem nam trong vung da co (Hs=" (QSVS-FHs (nth 2 r))
                   " Cote=" (QSVS-FCote (nth 3 r)) "). Vung moi se long ben trong va duoc uu tien."))))

(defun QSVS-TaoVung ( / doc n e ss i ce lap p)
  (setq doc (QS-Doc) n 0 ce (getvar "CMDECHO"))
  (vla-StartUndoMark doc)
  (setvar "CMDECHO" 0)
  (QSVS-Reg)
  (cond
    ((= *QSVS-TAO* "tv_diem")
     (while (setq p (getpoint (strcat "\nPick diem TRONG o san cho vung \"" *QSVS-TEN*
                                      "\" <Enter = xong>: ")))
       (QSVS-CanhBaoLong (trans p 1 0))
       (if (setq e (QSVS-TuBien p))
         (if (QSVS-XuLyMot e) (setq n (1+ n))))))
    ((= *QSVS-TAO* "tv_ve")
     (setq lap T)
     (while lap
       (princ (strcat "\nVe polyline vung \"" *QSVS-TEN* "\" (Enter ngay diem dau = xong):"))
       (if (setq e (QSVS-VePL))
         (if (QSVS-XuLyMot e) (setq n (1+ n)))
         (setq lap nil))))
    (T
     (princ "\nChon cac polyline KIN de gan thong so vung: ")
     (setq ss (ssget '((0 . "LWPOLYLINE"))) i 0)
     (while (and ss (< i (sslength ss)))
       (setq e (ssname ss i))
       (cond
         ((QS-LayerBiKhoa e) (princ "\n  [Bo qua] polyline tren layer bi khoa."))
         ((not (QS-LaKin e (QS-DinhDuong e))) (princ "\n  [Bo qua] polyline HO (khong kin)."))
         ((QSVS-XuLyMot e) (setq n (1+ n))))
       (setq i (1+ i)))))
  (setvar "CMDECHO" ce)
  (vla-EndUndoMark doc)
  (setq *QSVS-TB* (strcat "Da tao / gan " (itoa n) " vung \"" *QSVS-TEN* "\"  (Hs="
                          *QSVS-HS* ", Cote=" *QSVS-CT* ")."))
  (princ)
)

;; ---------------------------------------------------------------- nut phu
(defun QSVS-LayMau ( / pe d ed)
  (setq pe (entsel "\nChon 1 VUNG SAN mau: "))
  (if (and pe (setq d (QSVS-Doc (car pe))))
    (progn
      (setq ed (entget (car pe)))
      (setq *QSVS-TEN* (car d) *QSVS-HS* (QSVS-FHs (cadr d)) *QSVS-CT* (QSVS-Rtos (caddr d) 3))
      (if (and (assoc 62 ed) (< 0 (cdr (assoc 62 ed)) 256))
        (setq *QSVS-MAU* (itoa (cdr (assoc 62 ed)))))
      (if (nth 3 d)
        (setq *QSVS-HR* "hr_goc" *QSVS-GOC* (QSVS-Rtos (nth 3 d) 2))
        (setq *QSVS-HR* "hr_md"))
      (setq *QSVS-TB* (strcat "Da lay thong so tu vung \"" (car d) "\".")))
    (setq *QSVS-TB* "Doi tuong chon khong phai VUNG SAN."))
  (princ)
)

;; Chon cac line huong da ve (vd tren Defpoints). Diem giua line -> vung chua no.
(defun QSVS-GanHuongLine ( / doc ss i e pts p q best bl ds r d ev hv n miss goc)
  (setq doc (QS-Doc) n 0 miss 0)
  (princ "\nChon cac LINE / PLINE huong rai (moi line dat GIUA vung can gan): ")
  (setq ss (ssget '((0 . "LINE,LWPOLYLINE"))))
  (if ss
    (progn
      (vla-StartUndoMark doc)
      (setq ds (QSVS-ThuThap nil) i 0)
      (while (< i (sslength ss))
        (setq e (ssname ss i))
        (if (and (not (QSVS-Doc e)) (setq pts (QS-DinhDuong e)) (>= (length pts) 2))
          (progn
            ;; doan dai nhat
            (setq best nil bl 0.0 p (car pts))
            (foreach q (cdr pts)
              (if (> (distance p q) bl) (setq bl (distance p q) best (list p q)))
              (setq p q))
            (setq p (list (/ (+ (car (car best)) (car (cadr best))) 2.0)
                          (/ (+ (cadr (car best)) (cadr (cadr best))) 2.0)))
            (if (setq r (QSVS-TimVung ds p))
              (progn
                (setq ev (nth 7 r) hv (QSVS-Handle ev) d (QSVS-Doc ev)
                      goc (QSVS-GocDo (car best) (cadr best)))
                (if (/= (nth 4 d) (QSVS-Handle e)) (QSVS-XoaLink (nth 4 d) hv))
                (QSVS-GhiXD e (list "VSLINK" hv))
                (QSVS-Luu ev (list (car d) (cadr d) (caddr d) goc (QSVS-Handle e) (nth 5 d) (nth 6 d)))
                (QSVS-LamMoi ev)
                (setq n (1+ n))
                (princ (strcat "\n  + Vung \"" (car d) "\"  huong " (QSVS-FGoc goc))))
              (setq miss (1+ miss)))))
        (setq i (1+ i)))
      (vla-EndUndoMark doc)))
  (setq *QSVS-TB* (strcat "Gan huong: " (itoa n) " line da ghi vao vung"
                          (if (> miss 0) (strcat ", " (itoa miss) " line KHONG nam trong vung nao") "")
                          "."))
  (princ)
)

;; Ve lai nhan / nen moi vung, xoa nhan / nen / line mo coi.
(defun QSVS-LamMoiTatCa ( / doc ds e ss i x rv rd n xo et)
  (setq doc (QS-Doc) n 0 xo 0)
  (vla-StartUndoMark doc)
  (setq ds (QSVS-DSVung))
  (foreach e ds (QSVS-LamMoi e) (setq n (1+ n)))
  (setq ss (ssget "_X" (list (list -3 (list *QSVS-APP*)))) i 0)
  (while (and ss (< i (sslength ss)))
    (setq e (ssname ss i) x (QSVS-XD e))
    (if (and x (= (car x) "VSLINK"))
      (progn
        (setq rv (handent (cadr x)) rd (if (and rv (entget rv)) (QSVS-Doc rv) nil)
              et (cdr (assoc 0 (entget e))))
        (if (or (null rd)
                (and (member et '("MTEXT" "HATCH"))
                     (not (member (QSVS-Handle e) (list (nth 5 rd) (nth 6 rd))))))
          (progn (entdel e) (setq xo (1+ xo))))))
    (setq i (1+ i)))
  (vla-EndUndoMark doc)
  (setq *QSVS-TB* (strcat "Da cap nhat " (itoa n) " vung"
                          (if (> xo 0) (strcat ", xoa " (itoa xo) " doi tuong mo coi") "") "."))
  (princ)
)

(defun QSVS-Go ( / doc ss i e d hv n)
  (setq doc (QS-Doc) n 0)
  (princ "\nChon VUNG SAN can go thong so (polyline duoc giu lai): ")
  (setq ss (ssget (list '(0 . "LWPOLYLINE") (list -3 (list *QSVS-APP*)))))
  (if ss
    (progn
      (vla-StartUndoMark doc)
      (setq i 0)
      (while (< i (sslength ss))
        (setq e (ssname ss i))
        (if (setq d (QSVS-Doc e))
          (progn
            (setq hv (QSVS-Handle e))
            (QSVS-XoaLink (nth 4 d) hv) (QSVS-XoaLink (nth 5 d) hv) (QSVS-XoaLink (nth 6 d) hv)
            (QSVS-BoXD e)
            (setq n (1+ n))))
        (setq i (1+ i)))
      (vla-EndUndoMark doc)))
  (setq *QSVS-TB* (strcat "Da go " (itoa n) " vung (xoa nhan, nen, line huong lien ket)."))
  (princ)
)

;; ---------------------------------------------------------------- LENH
(defun c:OS_VUNGSAN ( / *error* id lap rc ds)
  (defun *error* (msg)
    (if (and id (>= id 0)) (unload_dialog id))
    (if *QSVS-CE* (setvar "CMDECHO" *QSVS-CE*))
    (if *QSVS-OS* (setvar "OSMODE" *QSVS-OS*))
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[Loi] " msg)))
    (princ))
  (princ "\n[OS_ShopThepSan v1.0.0]  OS_VUNGSAN - VUNG SAN (CHIEU DAY / CAO DO / HUONG RAI)")
  (QSVS-MacDinh)
  (QSVS-Reg)
  (setq *QSVS-CE* (getvar "CMDECHO") *QSVS-OS* (getvar "OSMODE"))
  (setq id (QSVS-NapDCL))
  (if (not id)
    (princ "\n[Loi] Khong nap duoc giao dien DCL.")
    (progn
      (setq lap T)
      (while lap
        (if (not (new_dialog "qs_vungsan" id))
          (progn (princ "\n[Loi] Khong khoi tao duoc dialog qs_vungsan.") (setq lap nil))
          (progn
            (set_tile "vsten" *QSVS-TEN*)
            (set_tile "vshs" *QSVS-HS*)
            (set_tile "vsct" *QSVS-CT*)
            (set_tile "vsmau" *QSVS-MAU*)
            (set_tile "vshr" *QSVS-HR*)
            (set_tile "vsgoc" *QSVS-GOC*)
            (set_tile "vstao" *QSVS-TAO*)
            (set_tile "vslay" *QSVS-LAY*)
            (set_tile "vslhr" *QSVS-LHR*)
            (set_tile "vstyle" *QSVS-TYLE*)
            (set_tile "vsnhan" *QSVS-NHAN*)
            (set_tile "vsnen" *QSVS-NEN*)
            (setq *QSVS-LOAI* (QSVS-LapDS))
            (start_list "vsds")
            (if *QSVS-LOAI*
              (foreach r *QSVS-LOAI* (add_list (car r)))
              (add_list "(Chua co vung san nao - nhap thong so roi bam \"Tao / gan vung\")"))
            (end_list)
            (QSVS-ModeHR)
            (QSVS-Xem)
            (set_tile "vsloi" (if (/= *QSVS-TB* "") *QSVS-TB*
                                (strcat (itoa (length *QSVS-LOAI*)) " loai vung dang co trong ban ve.")))
            (action_tile "vshs" "(QSVS-Xem)")
            (action_tile "vsct" "(QSVS-Xem)")
            (action_tile "vsmau" "(QSVS-Xem)")
            (action_tile "vshr" "(QSVS-ModeHR)")
            (action_tile "vsds" "(QSVS-ChonDS $value)")
            (action_tile "vsbmau"   "(QSVS-DocTile)(done_dialog 2)")
            (action_tile "vsbhuong" "(QSVS-DocTile)(done_dialog 3)")
            (action_tile "vsbnhan"  "(QSVS-DocTile)(done_dialog 4)")
            (action_tile "vsbgo"    "(QSVS-DocTile)(done_dialog 5)")
            (action_tile "accept" "(QSVS-Accept)")
            (action_tile "cancel" "(done_dialog 0)")
            (setq rc (start_dialog))
            (setq *QSVS-TB* "")
            (cond
              ((= rc 1) (QSVS-TaoVung))
              ((= rc 2) (QSVS-LayMau))
              ((= rc 3) (QSVS-GanHuongLine))
              ((= rc 4) (QSVS-LamMoiTatCa))
              ((= rc 5) (QSVS-Go))
              (T (setq lap nil)))))
      )
      (unload_dialog id)
      (setq id nil)
      (setq ds (QSVS-DSVung))
      (princ (strcat "\nBan ve co " (itoa (length ds)) " vung san. Chay OS_THEPSAN (tick \"Dung VUNG SAN\") de rai thep."))))
  (princ)
)

(princ)

;;; =====================================================================
;;;  V3 TOI UU (v1.0.0) - GOP THEP THANH 1 THANH DAI DIEN (DEU + BIEN THIEN)
;;;  Bat bang "sbtopt" trong OS_THEPSAN (muc 10), chi tac dung khi QS_BT_V3.
;;;  1. Noi chuoi: moi hang (station) ghep cap hang truoc theo chi phi NHO NHAT
;;;     toan hang (khong phu thuoc thu tu duyet). Uu tien noi thanh BANG nhau.
;;;  2. Chia nhom: quy hoach dong 1 luot tren moi chuoi, 3 loai nhom:
;;;       E = DEU (cung chieu dai / ke / nhan, cho phep lech vi tri)  >= 2 thanh
;;;       B = BIEN THIEN (don dieu, doi deu / cong deu)               >= btMin
;;;       S = thanh le
;;;     Chi phi = 1 / tag  (+ 0.2..0.4 neu la B, uu tien DEU khi bang so tag)
;;;     -> so TAG it nhat, trong do uu tien nhom DEU, nhom B chenh L nho.
;;;  3. So hieu theo HINH DANG (L, ke, nhan) - khong theo toa do: thanh cung
;;;     hinh o vi tri khac nhau dung chung 1 SH.
;;;  4. Thanh dai dien: gan giua nhom, tranh chong tag da dat.
;;; =====================================================================

;; Ghep bien thien: nhu QS-BTCompatible nhung chap nhan khoa goi CHUA DU
;; (thanh dung o bien khong nhan dang) neu 2 dau thanh lien tuc.
;; Ly do 2 thanh ke nhau KHONG noi duoc (chan doan)
;; Chuoi: tra ve danh sach chuoi (moi chuoi = list hang theo thu tu station)
;; Loai doan: "S" / "E" / "B" / nil
;; Quy hoach dong tren 1 chuoi -> list (bars kind)
;; Thay QS-BTPlan + gom le trong che do V3. Cung dinh dang (groups infos).
;; So hieu theo HINH DANG (khong theo toa do)
(defun QS-V4KeyHinh (rr / st g tg)
  (setq st (if (and (boundp 'rnd) (numberp rnd) (>= rnd 1)) (fix rnd) 1) g 0.0)
  (foreach tg (nth 7 rr) (setq g (+ g (- (car tg) (nth 2 rr)) (* 7.0 (caddr tg)))))
  (strcat "H|" (itoa (QS-LamTron (- (nth 3 rr) (nth 2 rr)) st))
          "|" (itoa (QS-LamTron (nth 4 rr) st)) "|" (itoa (QS-LamTron (nth 5 rr) st))
          "|" (itoa (QS-LamTron (nth 6 rr) st))
          "|" (itoa (length (nth 7 rr))) "|" (itoa (QS-R0 g)))
)

(defun QS-V4Key (rr bt)
  (if (and bt (> (abs (- (cadr bt) (car bt))) 0.5))
    (QS-KeyBT rr bt)
    (QS-V4KeyHinh rr))
)

(princ)

;;; =====================================================================
;;;  v20.15  GOP THEP THEO O SAN (V5) + GOP SO LE XEN KE + LENH OS_GOPBT3
;;;  1. Moi thanh co cung GOI 2 dau (cung dam / bien) duoc gom 1 nhom, khong
;;;     xet khoang cach hay quy luat chieu dai (bien thien bat ky van gom).
;;;  2. Hai thanh ke nhau bi TACH neu giua chung co DAM (duong noi 2 thanh cat
;;;     qua dam / mep san / ranh vung san). Lo mo KHONG tach nhom.
;;;  3. Doan thanh DAI / NGAN XEN KE (so le) -> tach 2 nhom chan / le, buoc 2a.
;;;  4. OS_GOPBT3: gop lai cac nhom V3 / thanh le da ve thanh 1 nhom V3.
;;; =====================================================================

;; ---------------------------------------------------------- tach bang dam
;; Tra T neu 2 hang a, b KHONG duoc chung nhom (co dam / bien o giua).
(defun QS-V5CatDam (a b ln objs / lo hi f tm hit o r)
  (setq lo (max (nth 8 a) (nth 8 b)) hi (min (nth 9 a) (nth 9 b)))
  (cond
    ((< (abs (- (nth 1 b) (nth 1 a))) 1.0) T)
    ((< (- hi lo) 1.0) T)
    (T
     (foreach f '(0.25 0.5 0.75)
       (if (not hit)
         (progn
           (setq tm (+ lo (* f (- hi lo))))
           (vla-put-StartPoint ln (vlax-3d-point (QS-Pt u v (nth 1 a) tm)))
           (vla-put-EndPoint   ln (vlax-3d-point (QS-Pt u v (nth 1 b) tm)))
           (foreach o objs
             (if (not hit)
               (progn
                 (setq r (vl-catch-all-apply 'vlax-invoke (list ln 'IntersectWith o 0)))
                 (if (and (not (vl-catch-all-error-p r)) r) (setq hit T))))))))
     hit))
)

;; ---------------------------------------------------------- so le xen ke
;; Tach 1 day thanh (cung o san) thanh cac nhom: doan thuong + cap nhom chan/le.
(defun QS-V5SoLe (run minZ tolZ / n Ls d i j k ok wins res start w e seg odd even)
  (setq n (length run) Ls (mapcar 'QS-LThanh run))
  (if (< n minZ)
    (list run)
    (progn
      ;; d_i = L(i+1) - L(i)
      (setq i 0)
      (while (< i (1- n))
        (setq d (append d (list (- (nth (1+ i) Ls) (nth i Ls)))) i (1+ i)))
      ;; cua so zigzag toi da: moi |d| > tolZ va dau doi lien tiep
      (setq i 0)
      (while (< i (length d))
        (if (> (abs (nth i d)) tolZ)
          (progn
            (setq j i)
            (while (and (< (1+ j) (length d))
                        (> (abs (nth (1+ j) d)) tolZ)
                        (< (* (nth j d) (nth (1+ j) d)) 0.0))
              (setq j (1+ j)))
            ;; thanh tu i den j+1
            (if (>= (- (+ j 2) i) minZ)
              (setq wins (append wins (list (list i (1+ j))))
                    i (+ j 2))          ; bo qua canh ke tiep: thanh j+1 da thuoc cua so
              (setq i (1+ j))))
          (setq i (1+ i))))
      (if (null wins)
        (list run)
        (progn
          (setq start 0)
          (foreach w wins
            (if (> (car w) start)
              (setq res (append res (list (QS-LayDoan run start (car w))))))
            (setq seg (QS-LayDoan run (car w) (1+ (cadr w))) odd nil even nil k 0)
            (foreach e seg
              (if (= 0 (rem k 2)) (setq even (append even (list e))) (setq odd (append odd (list e))))
              (setq k (1+ k)))
            (setq res (append res (list even odd))
                  *QS-V5-SOLE* (1+ *QS-V5-SOLE*)
                  start (1+ (cadr w))))
          (if (< start n) (setq res (append res (list (QS-LayDoan run start n)))))
          res))))
)

;; v1.0.0: tach nhom thanh cac doan lien tiep: thanh <= 1 cay (khong can cat) / thanh > 1 cay
(defun QS-V5TachCay (g stock / res run f f0 r)
  (if (or (null (cdr g)) (null stock) (<= stock 0.0))
    (list g)
    (progn
      (foreach r g
        (setq f (<= (QS-LThanh r) (+ stock 0.5)))
        (if (and run (not (eq f f0)))
          (setq res (cons (reverse run) res) run nil
                *QS-V5-TACHCAY* (1+ (if *QS-V5-TACHCAY* *QS-V5-TACHCAY* 0))))
        (setq run (cons r run) f0 f))
      (if run (setq res (cons (reverse run) res)))
      (reverse res))))

;; Chia nhom qua dai thanh cac phan deu nhau <= maxN thanh
(defun QS-V5Chia (g maxN / n k sz i res)
  (setq n (length g))
  (if (or (<= maxN 1) (<= n maxN))
    (list g)
    (progn
      (setq k (fix (+ 0.999999 (/ (float n) maxN))) i 0)
      (while (< i n)
        (setq sz (fix (+ 0.5 (/ (float (- n i)) (- k (length res))))))
        (if (< sz 1) (setq sz 1))
        (setq res (append res (list (QS-LayDoan g i (min n (+ i sz))))) i (+ i sz)))
      res))
)

;; Thay QS-V4Plan: (groups infos), cung dinh dang cu.
(defun QS-V4Plan (grps aa dmin ds buoc / rows g r key pr buckets sorted run runs ln objs
                  minZ tolZ maxN res bts idx p1 nG nS g0 Lcay0)
  (setq minZ (max 3 dmin)
        tolZ (max 1.0 ds)
        maxN (if (QS-Num *QS4-BTMAXN*) (fix (QS-Num *QS4-BTMAXN*)) 0)
        *QS-V5-SOLE* 0 *QS-V5-DAM* 0)
  (if (null *QS-V5-TACHCAY*) (setq *QS-V5-TACHCAY* 0))
  (foreach g grps (setq rows (append rows g)))
  ;; 1. gom theo GOI 2 dau (+ co zone)
  (foreach r rows
    (setq key (vl-prin1-to-string (list (nth 11 r) (nth 10 r))))
    (if (setq pr (assoc key buckets))
      (setq buckets (subst (cons key (cons r (cdr pr))) pr buckets))
      (setq buckets (cons (list key r) buckets))))
  ;; 2. duong noi tam de do dam giua 2 thanh
  (setq objs (append (if dsDamSan dsDamSan nil) (if dsDamHo dsDamHo nil)
                     (if big (list big) nil) (if vgClip vgClip nil)
                     (if vgTru vgTru nil) (if vsObjs vsObjs nil)))
  (setq p1 (vlax-3d-point '(0.0 0.0 0.0)))
  (setq ln (vla-AddLine spc p1 (vlax-3d-point '(1.0 0.0 0.0))))
  (foreach pr buckets
    (setq sorted (vl-sort-i (cdr pr) '(lambda (a b) (< (nth 1 a) (nth 1 b))))
          sorted (mapcar '(lambda (i) (nth i (cdr pr))) sorted)
          run nil)
    (foreach r sorted
      (if (and run (QS-V5CatDam (last run) r ln objs))
        (progn (setq runs (cons run runs) run nil *QS-V5-DAM* (1+ *QS-V5-DAM*))))
      (setq run (append run (list r))))
    (if run (setq runs (cons run runs))))
  (vl-catch-all-apply 'vla-Delete (list ln))
  ;; 3. so le xen ke + gioi han so thanh
  (setq Lcay0 (if (QS-Num *QS5-CAY*) (QS-Num *QS5-CAY*) 11700.0))
  (foreach run runs
    (foreach g0 (QS-V5SoLe run minZ tolZ)
      ;; v1.0.0: nhom bien thien co ca thanh <= 1 cay va > 1 cay -> tach 2 nhom
      (foreach g (QS-V5TachCay g0 Lcay0)
        (foreach r (QS-V5Chia g maxN)
          (setq res (cons r res)
                bts (cons (if (> (length r) 1) (QS-TTinBT r) nil) bts))))))
  (setq nG 0 nS 0)
  (foreach r res (if (> (length r) 1) (setq nG (1+ nG)) (setq nS (1+ nS))))
  (if (null *QS-V4-STAT*) (setq *QS-V4-STAT* (list 0 0 0 0 0 0)))
  (setq *QS-V4-STAT* (list (+ (nth 0 *QS-V4-STAT*) nG) (+ (nth 1 *QS-V4-STAT*) *QS-V5-SOLE*)
                           (+ (nth 2 *QS-V4-STAT*) nS) (+ (nth 3 *QS-V4-STAT*) (length rows))
                           (+ (nth 4 *QS-V4-STAT*) (length grps))
                           (+ (nth 5 *QS-V4-STAT*) *QS-V5-DAM*)))
  ;; sap theo hang dau + station (QS-TronBT can thu tu nay)
  (setq idx (vl-sort-i res '(lambda (a b) (if (= (car (car a)) (car (car b)))
                                            (< (nth 1 (car a)) (nth 1 (car b)))
                                            (< (car (car a)) (car (car b)))))))
  (list (mapcar '(lambda (i) (nth i res)) idx)
        (mapcar '(lambda (i) (nth i bts)) idx))
)

(defun QS-V4InStat (nTruoc / s)
  (if (setq s *QS-V4-STAT*)
    (progn
      (princ (strcat "\n   [GOP V3] " (itoa (nth 3 s)) " thanh -> "
                     (itoa (+ (nth 0 s) (nth 2 s))) " tag  (truoc khi gop: " (itoa nTruoc) " nhom)"))
      (princ (strcat "\n            " (itoa (nth 0 s)) " nhom gop  |  "
                     (itoa (nth 2 s)) " thanh le  |  "
                     (itoa (nth 5 s)) " cho tach do DAM / bien  |  "
                     (itoa (nth 1 s)) " doan SO LE xen ke (tach 2 nhom)"))
      (if (and *QS-V5-TACHCAY* (> *QS-V5-TACHCAY* 0))
        (princ (strcat "\n            " (itoa *QS-V5-TACHCAY*)
                       " nhom bien thien tach: thanh <= 1 cay / thanh > 1 cay")))
      (setq *QS-V5-TACHCAY* 0))))

;;; =====================================================================
;;;  OS_GOPBT3 - gop lai cac nhom V3 / thanh le DA VE thanh 1 nhom V3
;;; =====================================================================
(defun QS-G3Field (e n) (QS-TachFieldXData (QS-DocXDataTho e) n))

;; Tag cua 1 thanh le (tag co truong (2) = handle thanh)
(defun QS-G3TagCuaThanh (bar / h ss i e r)
  (setq h (cdr (assoc 5 (entget bar))))
  (setq ss (ssget "_X" '((0 . "INSERT") (-3 ("DcePro")))) i 0)
  (while (and ss (not r) (< i (sslength ss)))
    (setq e (ssname ss i))
    (if (= (QS-G3Field e 2) h) (setq r e))
    (setq i (1+ i)))
  r)

;; Phan tich 1 nhom V3 -> (bars tag rai others) ; others = bao / vong tron / ... se xoa
(defun QS-G3DocNhom (root / audit data hd bars tag rai others)
  (setq audit (QS-V3Audit root))
  (if (cadr audit)
    nil
    (progn
      (foreach item (nth 2 audit)
        (setq hd (QS-TachKT (car (QS-S23Read item)) ";"))
        (cond
          ((= (nth 2 hd) "BAR")  (setq bars (cons item bars)))
          ((= (nth 2 hd) "SOLE") (setq tag item))
          ((= (nth 2 hd) "RAI")  (setq rai item))
          (T (setq others (cons item others)))))
      (setq data (QS-S23Read root))
      (foreach rec data
        (if (= (substr rec 1 6) "GROUP;") (setq others (cons (substr rec 7) others))))
      (list bars tag rai others))))

(defun QS-G3Diem (bar u / pts best p q d res)
  ;; trung diem doan dai nhat cua thanh
  (setq pts (QS-DinhDuong bar) best 0.0 p (car pts))
  (foreach q (cdr pts)
    (if (> (distance p q) best) (setq best (distance p q) res (list (/ (+ (car p) (car q)) 2.0) (/ (+ (cadr p) (cadr q)) 2.0))))
    (setq p q))
  res)

(defun QS-G3XoaXD (e)
  (if (and e (entget e))
    (vl-catch-all-apply 'entmod (list (append (entget e) (list (list -3 (list "QS_BT_V3"))))))))

(defun c:OS_GOPBT3 ( / *error* doc spc ss i e root seen nhom bars tags rais others r
                       u v uu best L rows s sorted rep tag keep mck sh dia lop step
                       gaps st h pt tt p1 p2 raiNew gid members cir text rnd origDim
                       oldecho n lens grp nm res)
  (defun *error* (msg)
    (if origDim (vl-catch-all-apply 'command (list "_.-DIMSTYLE" "_R" origDim)))
    (if oldecho (setvar "CMDECHO" oldecho))
    (if doc (vl-catch-all-apply 'vla-EndUndoMark (list doc)))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[GOPBT3] " msg "  (go U de hoan tac neu can)")))
    (princ))
  (princ "\n=== OS_GOPBT3 - GOP CAC NHOM THEP V3 / THANH LE THANH 1 NHOM ===")
  (princ "\nChon cac thanh / tag / duong rai cua nhung nhom can gop: ")
  (setq ss (ssget))
  (if (null ss)
    (princ "\nKhong chon duoc gi.")
    (progn
      ;; 1. thu thap nhom V3 va thanh le
      (setq i 0)
      (while (< i (sslength ss))
        (setq e (ssname ss i) root (QS-V3RootOf e))
        (cond
          (root
           (if (not (member root seen))
             (progn
               (setq seen (cons root seen) nhom (QS-G3DocNhom root))
               (if nhom
                 (setq bars (append bars (car nhom))
                       tags (cons (cadr nhom) tags)
                       rais (if (caddr nhom) (cons (caddr nhom) rais) rais)
                       others (append (cons root (cadddr nhom)) others))
                 (princ "\n  [Bo qua] 1 nhom V3 loi (chay OS_KIEMTRABT3 de xem).")))))
          ((and (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "LINE"))
                (/= (QS-G3Field e 1) "") (not (member e bars)))
           (setq bars (cons e bars))
           (if (setq r (QS-G3TagCuaThanh e)) (if (not (member r tags)) (setq tags (cons r tags))))
           (if (and (setq r (QS-DocLinkRai e)) (setq r (handent r)) (entget r))
             (if (not (member r rais)) (setq rais (cons r rais))))))
        (setq i (1+ i)))
      (setq tags (vl-remove nil tags))
      (cond
        ((< (length bars) 2) (princ "\n[GOPBT3] Can it nhat 2 thanh thep de gop."))
        ((null tags) (princ "\n[GOPBT3] Khong tim thay tag cua cac thanh da chon."))
        (T
         ;; 2. phuong thanh: theo thanh dai nhat
         (setq best 0.0)
         (foreach e bars
           (if (> (setq L (QS-DaiPts (QS-DinhDuong e))) best)
             (setq best L u (QS-HuongPts (QS-DinhDuong e)))))
         (setq v (list (- (cadr u)) (car u)))
         (foreach e bars
           (setq uu (QS-HuongPts (QS-DinhDuong e)))
           (if (< (abs (+ (* (car uu) (car u)) (* (cadr uu) (cadr u)))) 0.999)
             (setq r "KHONG_SONG_SONG")))
         (if r
           (princ "\n[GOPBT3] Cac thanh khong song song - khong gop.")
           (progn
             ;; 3. sap theo vi tri rai
             (foreach e bars
               (setq pt (QS-G3Diem e u))
               (setq rows (cons (list (+ (* (car pt) (car v)) (* (cadr pt) (cadr v))) e) rows)))
             (setq sorted (vl-sort rows '(lambda (a b) (< (car a) (car b)))))
             (setq st nil i 0)
             (while (< i (1- (length sorted)))
               (setq L (- (car (nth (1+ i) sorted)) (car (nth i sorted))))
               (if (or (null st) (< L st)) (setq st L))
               (setq i (1+ i)))
             (if (< st 1.0)
               (princ "\n[GOPBT3] Co 2 thanh trung vi tri rai - khong gop.")
               (progn
                 (setq doc (QS-Doc) spc (QS-Space doc))
                 (vla-StartUndoMark doc)
                 (setq oldecho (getvar "CMDECHO") origDim (getvar "DIMSTYLE"))
                 (setvar "CMDECHO" 0)
                 (setq n (length sorted) rep (cadr (nth (/ n 2) sorted)))
                 ;; tag giu lai: tag gan thanh dai dien nhat
                 (setq best nil)
                 (foreach e tags
                   (setq L (distance (cdr (assoc 10 (entget e))) (QS-G3Diem rep u)))
                   (if (or (null best) (< L best)) (setq best L tag e)))
                 ;; thong so tu tag / thanh
                 (setq mck (QS-G3Field tag 0) sh (QS-G3Field tag 1)
                       dia (QS-G3Field tag 3) lop (QS-G3Field tag 4))
                 (if (= sh "") (setq sh (QS-G3Field rep 1)))
                 (if (= dia "") (setq dia (QS-G3Field rep 3)))
                 (if (= lop "") (setq lop "1"))
                 ;; buoc rai = khoang cach nho nhat giua 2 thanh
                 (setq step (QS-LamTron st 5))
                 ;; 4. xoa tag / rai / bao / group cu (giu tag chon)
                 (foreach e tags (if (not (equal e tag)) (entdel e)))
                 (foreach e rais
                   (setq r (entnext e))
                   (if (and r (= (cdr (assoc 0 (entget r))) "CIRCLE")) (entdel r))
                   (entdel e))
                 (foreach e others
                   (cond
                     ((= (type e) 'STR)
                      (setq grp (vl-catch-all-apply 'vla-Item (list (vla-get-Groups doc) e)))
                      (if (not (vl-catch-all-error-p grp)) (vl-catch-all-apply 'vla-Delete (list grp))))
                     ((and e (entget e) (not (member e bars)) (not (equal e tag)))
                      (entdel e))))
                 (QS-G3XoaXD tag)
                 (foreach e bars
                   (QS-G3XoaXD e)
                   (vl-catch-all-apply 'vla-put-Visible (list (vlax-ename->vla-object e) :vlax-true)))
                 ;; 5. duong rai moi qua vi tri tag
                 (setq h (* 2.5 (vla-get-XScaleFactor (vlax-ename->vla-object tag))))
                 (QS-DamBaoLayer "QS_Symbol" 8)
                 (QS-ChuanBiRaiStyle h "F")
                 (setq pt (cdr (assoc 10 (entget tag)))
                       tt (+ (* (car pt) (car u)) (* (cadr pt) (cadr u))))
                 (setq p1 (QS-Pt u v (car (car sorted)) tt)
                       p2 (QS-Pt u v (car (last sorted)) tt))
                 (setq raiNew (QS-VeDuongRai spc p1 p2
                                (QS-Pt u v (car (nth (/ n 2) sorted)) tt) h))
                 (if (null raiNew) (/ 1 0))
                 ;; 6. lien ket + nhom V3
                 (QS-GanBoLienKet rep tag raiNew mck sh sh dia lop step n "")
                 (setq gid (QS-TachFieldXData (QS-DocXDataTho raiNew) 2))
                 (setq members (list rep tag raiNew) cir (entnext raiNew))
                 (if (and cir (= (cdr (assoc 0 (entget cir))) "CIRCLE")) (setq members (cons cir members)))
                 (setq rows nil i 0 bars nil)
                 (foreach r sorted
                   (setq e (cadr r))
                   (if (not (equal e rep)) (setq members (cons e members)))
                   (QS-GanXDThep e mck sh dia lop gid step)
                   (QS-GanLinkRai e (cdr (assoc 5 (entget raiNew))))
                   (setq bars (append bars (list e))
                         rows (append rows (list (list i (QS-DinhDuong e) (QS-Pt u v (car r) 0.0))))
                         i (1+ i)))
                 (setq root (QS-V3Attach32 rows bars rep tag raiNew members step 0.0 0.0 0))
                 (QS-S22Write root (append (QS-S23Read root) (list "SOURCE;QS_GOPBT3")))
                 ;; 7. tag: so thanh + L=Lmin~Lmax
                 (setq lens (mapcar '(lambda (e) (QS-DaiPts (QS-DinhDuong e))) bars)
                       rnd (if (and *QS4-RND* (QS-Num *QS4-RND*)) (fix (QS-Num *QS4-RND*)) 5))
                 (QS-DatDKVAKC tag (strcat (itoa n) "%%c" dia "a" (itoa (fix step))
                                           " (L=" (QS-ChuoiChieuDai (apply 'min lens) (apply 'max lens) rnd) ")"))
                 (setq res (QS-V3Audit root))
                 (command "_.-DIMSTYLE" "_R" origDim) (setq origDim nil)
                 (setvar "CMDECHO" oldecho) (setq oldecho nil)
                 (vla-EndUndoMark doc) (setq doc nil)
                 (if (cadr res)
                   (princ (strcat "\n[GOPBT3] Da gop nhung kiem tra bao loi: " (car (cadr res))
                                  " - go U de hoan tac."))
                   (princ (strcat "\n[GOPBT3] Da gop " (itoa n) " thanh thanh 1 nhom V3 (SH " sh
                                  ", a" (itoa (fix step)) ", L=" (QS-ChuoiChieuDai (apply 'min lens) (apply 'max lens) rnd)
                                  "). Go U neu muon hoan tac.")))))))))))
  (princ))

(princ)

;;; =====================================================================
;;;  v20.15  OS_CATTHEP CAT DUOC NHOM QS_BT_V3
;;;  Nhom V3 trong tap chon duoc tach rieng va cat bang bo cat V3 (nhu
;;;  OS_CATBT3) voi thong so cua hop thoai OS_CATTHEP:
;;;    cay thep, chieu dai noi (50d / mm), doan toi thieu, thu vien chieu dai,
;;;    ty le, buoc lam tron. Tick "Xoa thep, tag va dim goc" -> cat TAI CHO,
;;;    xoa nhom nguon; bo tick -> hoi diem dat ket qua, giu nguyen nguon.
;;;  Cac doi tuong con lai di tiep luong cat thuong.
;;; =====================================================================
(princ)

;;; =====================================================================
;;;  v20.15  OS_CATTHEP x QS_BT_V3 - CAT DAY DU NHU THEP THUONG
;;;   - Vung cat: chon tay (2 duong = 1 vung) hoac TU DONG theo net dam.
;;;   - So le: tick "CAT SO LE" -> 2 thanh ke nhau lech moi noi 1 khoang
;;;     "So le moi noi", tach 2 nhom (C1 / C1S ...) buoc 2a.
;;;   - Lech Y: doan chan (2, 4, ...) ve lech "Lech Y doan noi" -> khong trung.
;;;   - Dim: dim tung doan thanh dai dien (doan bien thien ghi Lmin~Lmax),
;;;     dim DOAN NOI tren thanh dai dien.
;;;   - Layer QS_ThepCatV3 mau DO.
;;;  Ham doc bien cua c:OS_CATTHEP qua pham vi dong (dynamic scope).
;;; =====================================================================

;; Chon thanh dai dien sau khi cat (v1.0.0):
;;  - Co vi tri thanh dai dien CHUA CAT (*QS-V3CUT-SRCP*):
;;      khong so le -> thanh trung vi tri do (doan le cong them Lech Y);
;;      so le       -> nhom chua thanh goc: dung vi tri do; nhom kia: lech
;;                     "Khoang cach 2 thanh mau" (*QS-V3CUT-KC*), HUONG LECH CO DINH
;;                     cho moi doan -> doan noi cua 1 thanh luon nam sat nhau.
;;  - Khong doc duoc thanh goc -> cach cu (giua nhom / cach nhom kia KC).
(defun QS-V3ChonMid (rows key / n m0 u v sts base kc best be i e vp sg lech k0 b1 b2)
  (setq n (length rows) m0 (fix (/ (1- n) 2.0))
        u (QS-HuongPts (cadr (nth m0 rows))) v (list (- (cadr u)) (car u)))
  (if (or (< (car v) -1e-9) (and (< (abs (car v)) 1e-9) (< (cadr v) 0.0)))
    (setq v (list (- (car v)) (- (cadr v)))))
  (setq sts (mapcar '(lambda (r) (QS-B2Dot (car (cadr r)) v)) rows))
  (cond
    ;; v1.0.0: nhom thanh khong cat -> thanh dai dien o giua nhom
    ((>= (rem key 1000) 500) m0)
    (*QS-V3CUT-SRCP*
     ;; lech Y cua doan le (index 1, 3 ...) theo huong v
     (setq vp (list (- (cadr u)) (car u))
           sg (if (> (QS-B2Dot vp v) 0.0) 1.0 -1.0)
           k0 (rem key 1000)
           lech (if (and *QS-V3CUT-LECH* (= 1 (rem k0 2))) (* sg *QS-V3CUT-LECH*) 0.0)
           base (+ (QS-B2Dot *QS-V3CUT-SRCP* v) lech))
     ;; v20.22: vi tri dich CO DINH cho ca nhom -> cac doan noi cua 1 thanh nam cung 1 hang
     (if (and *QS-V3CUT-SOLE* (/= (if (>= key 1000) 1 0) (if *QS-V3CUT-PAR0* *QS-V3CUT-PAR0* 0))
              *QS-V3CUT-KC* (> *QS-V3CUT-KC* 0.0))
       (progn
         (setq kc *QS-V3CUT-KC*)
         (if (null *QS-V3CUT-DIR*)
           (progn
             (setq b1 nil b2 nil)
             (foreach st sts
               (setq e (abs (- st (+ base kc)))) (if (or (null b1) (< e b1)) (setq b1 e))
               (setq e (abs (- st (- base kc)))) (if (or (null b2) (< e b2)) (setq b2 e)))
             (setq *QS-V3CUT-DIR* (if (<= b1 (+ b2 1.0)) 1.0 -1.0))))
         (setq base (+ base (* *QS-V3CUT-DIR* kc)))))
     (setq i 0 best m0 be nil)
     (foreach st sts (setq e (abs (- st base))) (if (or (null be) (< e be)) (setq be e best i)) (setq i (1+ i)))
     (setq *QS-V3CUT-STREP* (cons (cons key (nth best sts)) *QS-V3CUT-STREP*))
     best)
    ((< key 1000)
     (setq *QS-V3CUT-STREP* (cons (cons key (nth m0 sts)) *QS-V3CUT-STREP*))
     m0)
    ((and (setq base (cdr (assoc (- key 1000) *QS-V3CUT-STREP*)))
          *QS-V3CUT-KC* (> *QS-V3CUT-KC* 0.0))
     (setq kc *QS-V3CUT-KC* i 0 best m0 be nil)
     (foreach st sts
       (setq e (min (abs (- st (+ base kc))) (abs (- st (- base kc)))))
       (if (or (null be) (< e be)) (setq be e best i))
       (setq i (1+ i)))
     best)
    (T m0)))

;; v20.24: chon thanh dai dien sau cat THEO SO THU TU THANH (khong theo toa do doan ve):
;;  nhom chua thanh goc -> chinh thanh goc; nhom so le con lai -> thanh cung nhom
;;  gan vi tri goc +/- "Khoang cach 2 thanh mau" nhat (1 phia co dinh).
;;  Tra ve ((0 . soTT) (1 . soTT)); nil neu khong tim duoc thanh goc.
(defun QS-V3ChonThanhDD (plan src / rows r0 u v st0 par0 kc best be e res st par)
  (setq rows (nth 2 plan))
  (foreach r rows (if (and src (eq (nth 1 r) src)) (setq r0 r)))
  (if r0
    (progn
      (setq u (QS-HuongPts (nth 2 r0)) v (list (- (cadr u)) (car u))
            st0 (QS-B2Dot (car (nth 2 r0)) v)
            par0 (if (and *QS-V3CUT-SOLE* (assoc src *QS-V3CUT-PAR*)) (cdr (assoc src *QS-V3CUT-PAR*)) 0)
            res (list (cons par0 (car r0))))
      (if (and *QS-V3CUT-SOLE* *QS-V3CUT-KC* (> *QS-V3CUT-KC* 0.0))
        (progn
          (setq kc *QS-V3CUT-KC*)
          (foreach r rows
            (setq par (if (assoc (nth 1 r) *QS-V3CUT-PAR*) (cdr (assoc (nth 1 r) *QS-V3CUT-PAR*)) 0))
            (if (/= par par0)
              (progn
                (setq st (QS-B2Dot (car (nth 2 r)) v)
                      e (min (abs (- st (+ st0 kc))) (+ 0.5 (abs (- st (- st0 kc))))))
                (if (or (null be) (< e be)) (setq be e best (car r))))))
          (if best (setq res (cons (cons (- 1 par0) best) res)))))
      res)
    nil))

(defun QS-V3TenC (key / pr)
  (if (setq pr (assoc key *QS-V3CUT-SO*))
    (itoa (cdr pr))
    (itoa (rem (rem key 1000) 500))))

(defun QS-V3MauLayer (ten mau / o)
  (QS-DamBaoLayer ten mau)
  (setq o (vl-catch-all-apply 'vla-Item (list (vla-get-Layers (QS-Doc)) ten)))
  (if (not (vl-catch-all-error-p o)) (vl-catch-all-apply 'vla-put-Color (list o mau))))

;; Tach nhom V3 khoi tap chon -> (roots . rest)
(defun QS-V3TachNhom (ss / i e root roots rest)
  (setq i 0 rest (ssadd))
  (while (and ss (< i (sslength ss)))
    (setq e (ssname ss i) root (QS-V3RootOf e))
    (if root
      (if (not (member root roots)) (setq roots (cons root roots)))
      (ssadd e rest))
    (setq i (1+ i)))
  (cons (reverse roots) (if (> (sslength rest) 0) rest nil)))

;; Phuong an cat 1 nhom V3 theo cai dat OS_CATTHEP -> (T root rows) / (nil msgs)
;; rows: (idx item pts intervals) ; ghi *QS-V3CUT-PAR* = ((item . chan/le) ...)
;; Dau dau (diem 1) cua thanh co phai dau TRAI (thanh dung: dau DUOI) khong
(defun QS-V3DauTrai (pts / a b)
  (setq a (car pts) b (last pts))
  (if (>= (abs (- (car b) (car a))) (abs (- (cadr b) (cadr a))))
    (<= (car a) (car b))
    (<= (cadr a) (cadr b))))

;; Lat cac doan cat theo chieu nguoc lai tren thanh dai L
(defun QS-V3LatDoan (iv L)
  (reverse (mapcar '(lambda (p) (list (- L (cadr p)) (- L (car p)))) iv)))

;;; ---- v20.26: bang moi noi chung ca lan cat -> nhom khac nam ke ben khong trung moi noi
;; Huong chuan (x duong, hoac y duong neu thanh dung) de so sanh thanh nguoc chieu
(defun QS-V3HuongChuan (pts / u)
  (setq u (QS-HuongPts pts))
  (if (or (< (car u) -1.0e-9) (and (< (abs (car u)) 1.0e-9) (< (cadr u) 0.0)))
    (list (- (car u)) (- (cadr u))) u))

;; -> (s t1 t2 u0 (t moi noi ...)) toa do thanh theo huong chuan
(defun QS-V3BanGhiMN (pts iv / u u0 v0 p0 pe a b)
  (setq u (QS-HuongPts pts) u0 (QS-V3HuongChuan pts) v0 (list (- (cadr u0)) (car u0))
        p0 (car pts) pe (last pts)
        a (QS-B2Dot p0 u0) b (QS-B2Dot pe u0))
  (list (QS-B2Dot p0 v0) (min a b) (max a b) u0
        (mapcar '(lambda (q) (QS-B2Dot (list (+ (car p0) (* q (car u))) (+ (cadr p0) (* q (cadr u)))) u0))
                (QS-V3MoiNoi iv))))

(defun QS-V3GhiMN (root rows)
  (foreach row rows
    (setq *QS-V3-MN* (cons (cons root (QS-V3BanGhiMN (nth 2 row) (nth 3 row))) *QS-V3-MN*))))

;; Khoang cach 2 thanh lien tiep trong nhom (nguong xet "ke ben"): 1.05 x buoc nho nhat
(defun QS-V3KhoangNhom (bars / ss v0 d m)
  (foreach b bars
    (setq v0 (if v0 v0 (QS-V3HuongChuan (QS-DinhDuong (cadr b)))))
    (setq ss (cons (QS-B2Dot (car (QS-DinhDuong (cadr b))) (list (- (cadr v0)) (car v0))) ss)))
  (setq ss (QS-Sap ss '<))
  (while (cdr ss)
    (setq d (- (cadr ss) (car ss)))
    (if (and (> d 1.0) (or (null m) (< d m))) (setq m d))
    (setq ss (cdr ss)))
  (* 1.05 (if m m 1000.0)))

;;; ---- v20.28: bang moi noi cho THANH THUONG (khong phai nhom V3)
;; Pham vi vuong goc cua nhom thep: tu duong rai (rai = (e p1 p2 um)) hoac chinh thanh, noi rong aKC
(defun QS-LGDaiRai (pts rai aKC / u0 v0 st a b)
  (setq u0 (QS-V3HuongChuan pts) v0 (list (- (cadr u0)) (car u0))
        st (QS-B2Dot (car pts) v0) a st b st)
  (if (and rai (cadr rai) (caddr rai))
    (setq a (min a (QS-B2Dot (cadr rai) v0) (QS-B2Dot (caddr rai) v0))
          b (max b (QS-B2Dot (cadr rai) v0) (QS-B2Dot (caddr rai) v0))))
  (list (- a (* 0.55 (max aKC 0.0))) (+ b (* 0.55 (max aKC 0.0)))))

;; Moi noi cac thanh khac (ent khac) song song, chong theo chieu dai, pham vi rai chong nhau
(defun QS-LGKeBen (ent pts sr / me res)
  (setq me (QS-V3BanGhiMN pts nil))
  (foreach r *QS-LG-MN*
    (if (and (not (eq (car r) ent))
             (> (abs (QS-B2Dot (nth 5 r) (nth 3 me))) 0.9998)
             (< (nth 3 r) (caddr me)) (> (nth 4 r) (cadr me))
             (<= (nth 1 r) (cadr sr)) (>= (nth 2 r) (car sr)))
      (setq res (append (nth 6 r) res))))
  res)

(defun QS-LGGhi (ent pts plan sr / rec)
  (setq rec (QS-V3BanGhiMN pts plan))
  (setq *QS-LG-MN* (cons (list ent (car sr) (cadr sr) (cadr rec) (caddr rec) (nth 3 rec) (nth 4 rec)) *QS-LG-MN*)))

;; Doan (s e) -> (s e chan/le) cho ve lech Y
(defun QS-LGParity (iv / i)
  (setq i -1)
  (mapcar '(lambda (p) (setq i (1+ i)) (list (car p) (cadr p) (rem i 2))) iv))

;; v20.27: moi noi (toa do the gioi theo huong chuan) cua cac thanh KE BEN:
;;  nhom khac (bang moi noi chung) + thanh truoc cung nhom (prevRec, khi so le)
(defun QS-V3MNKeBen (pts root prevRec / me r res)
  (setq me (QS-V3BanGhiMN pts nil))
  (foreach r *QS-V3-MN*
    (if (and (not (eq (car r) root))
             (> (abs (QS-B2Dot (nth 4 r) (nth 3 me))) 0.9998)
             (<= (abs (- (nth 1 r) (car me))) *QS-V3-GAP*)
             (< (nth 2 r) (caddr me)) (> (nth 3 r) (cadr me)))
      (setq res (append (nth 5 r) res))))
  (if prevRec (setq res (append (nth 4 prevRec) res)))
  res)

;; Moi noi cua (pts iv) cach moi noi ke ben < soLe ?
(defun QS-V3TrungT (pts iv tn / hit)
  (if (and tn soLe (> soLe 0.0) (cdr iv))
    (foreach j (nth 4 (QS-V3BanGhiMN pts iv))
      (foreach k tn (if (< (abs (- j k)) (- soLe 1.0)) (setq hit T)))))
  hit)

;; Co vung cat: cam khoang +/- soLe quanh moi noi ke ben roi lap lai phoi trong phan vung con lai
;; (moi noi tu chuyen sang goi / vung ke tiep khi vung hien tai qua hep).
(defun QS-V3TranhVung (row pts L vungs tn stock lap minimum / u u0 sg t0 qs v2 z lo hi nua p iv2)
  (setq u (QS-HuongPts pts) u0 (QS-V3HuongChuan pts) sg (if (> (QS-B2Dot u u0) 0.0) 1.0 -1.0)
        t0 (QS-B2Dot (car pts) u0) nua (/ lap 2.0) v2 vungs)
  (setq qs (mapcar '(lambda (tk) (* sg (- tk t0))) tn))
  (foreach q qs
    (setq z v2 v2 nil)
    (foreach r z
      (setq lo (car r) hi (cadr r))
      (if (or (<= hi (- q soLe (- nua))) (>= lo (+ q soLe (- nua))))
        (setq v2 (cons r v2))
        (progn
          (if (> (- (+ (- q soLe) nua) lo) (* 2.0 nua)) (setq v2 (cons (list lo (+ (- q soLe) nua)) v2)))
          (if (> (- hi (- (+ q soLe) nua)) (* 2.0 nua)) (setq v2 (cons (list (- (+ q soLe) nua) hi) v2))))))
    (setq v2 (reverse v2)))
  (if v2
    (progn
      (setq p (vl-catch-all-apply 'QS-DoanCatVungUu (list L stock lap minimum v2 0 soLe)))
      (if (and p (not (vl-catch-all-error-p p)))
        (progn
          (setq iv2 (mapcar '(lambda (x) (list (car x) (cadr x))) p))
          (if (and (QS-PlanHopLe iv2 L stock minimum vungs lap)
                   (QS-V3CutCheck (list T nil (list (list (car row) (nth 1 row) pts iv2))) stock lap minimum)
                   (not (QS-V3TrungT pts iv2 tn)))
            iv2))))))

;; v1.0.0: dim cu (QS_Dim / DCE_Dim) nam tren cac thanh cua nhom V3 nguon: 2 diem dinh nghia deu
;; nam tren 1 thanh (sai so tol) -> danh sach de xoa sau khi cat xong.
(defun QS-V3DimCu (items tol / d bars pts p x0 y0 x1 y1 ss i e ed p1 p2 ok b res)
  (foreach it items
    (if (and it (entget it)
             (member (cdr (assoc 0 (entget it))) '("LWPOLYLINE" "LINE"))
             (setq d (QS-S23Read it)) (wcmatch (car d) "V3;1;BAR;*")
             (setq pts (QS-DinhDuong it)))
      (progn
        (setq bars (cons pts bars))
        (foreach p pts
          (if (or (null x0) (< (car p) x0)) (setq x0 (car p)))
          (if (or (null y0) (< (cadr p) y0)) (setq y0 (cadr p)))
          (if (or (null x1) (> (car p) x1)) (setq x1 (car p)))
          (if (or (null y1) (> (cadr p) y1)) (setq y1 (cadr p)))))))
  (if bars
    (progn
      (setq ss (ssget "_X" '((0 . "DIMENSION") (8 . "QS_Dim,DCE_Dim"))) i 0)
      (if ss
        (while (< i (sslength ss))
          (setq e (ssname ss i) ed (entget e) i (1+ i)
                p1 (cdr (assoc 13 ed)) p2 (cdr (assoc 14 ed)))
          (if (and p1 p2
                   (>= (car p1) (- x0 tol)) (<= (car p1) (+ x1 tol))
                   (>= (cadr p1) (- y0 tol)) (<= (cadr p1) (+ y1 tol)))
            (progn
              (setq ok nil)
              (foreach b bars
                (if (and (not ok) (< (QS-CachPts b p1) tol) (< (QS-CachPts b p2) tol)) (setq ok T)))
              (if ok (setq res (cons e res)))))))))
  res)

;; v1.0.0: nap moi noi cua thep V3 DA CAT o cac lan chay truoc (tren ban ve) vao bang moi noi,
;; de cat tung khung / tung nhom rieng van khong trung moi noi voi nhom ke ben da cat.
;; Doan cung nguon cat (CUT_SOURCE), cung tram (+/- lech Y), chong nhau -> 1 moi noi.
(defun QS-V3NapMNCu (roots / ss i e d r root h src pr cache pts u0 v0 a b bk bys tolS n p q j lst)
  (setq ss (ssget "_X" '((0 . "LWPOLYLINE,LINE") (-3 ("QS_BT_V3")))) i 0 n 0
        tolS (max 100.0 (+ (abs (if (numberp lechY) lechY 0.0)) 5.0)))
  (if ss
    (while (< i (sslength ss))
      (setq e (ssname ss i) i (1+ i) d (QS-S23Read e) root nil)
      (if (and d (wcmatch (car d) "V3;1;BAR;*"))
        (progn
          (foreach r d (if (= (substr r 1 5) "ROOT;") (setq root (substr r 6))))
          (if root
            (progn
              (setq pr (assoc root cache))
              (if (null pr)
                (progn
                  (setq src nil h (handent root))
                  (if (and h (entget h) (not (member h roots)))
                    (foreach r (QS-S23Read h)
                      (if (= (substr r 1 11) "CUT_SOURCE;") (setq src (substr r 12)))))
                  (setq pr (cons root src) cache (cons pr cache))))
              (if (and (cdr pr) (setq pts (QS-DinhDuong e)) (cdr pts))
                (progn
                  (setq u0 (QS-V3HuongChuan pts) v0 (list (- (cadr u0)) (car u0))
                        a (QS-B2Dot (car pts) u0) b (QS-B2Dot (last pts) u0)
                        p (list (QS-B2Dot (car pts) v0) (min a b) (max a b) u0)
                        bk (assoc (cdr pr) bys))
                  (if bk
                    (setq bys (subst (cons (car bk) (cons p (cdr bk))) bk bys))
                    (setq bys (cons (list (cdr pr) p) bys)))))))))))
  (foreach bk bys
    (setq lst (cdr bk))
    (foreach p lst
      (foreach q lst
        (if (and (not (eq p q))
                 (> (abs (QS-B2Dot (nth 3 p) (nth 3 q))) 0.9998)
                 (<= (abs (- (car p) (car q))) tolS)
                 (< (nth 1 p) (nth 1 q)) (> (nth 2 p) (nth 1 q)) (< (nth 2 p) (nth 2 q)))
          (setq j (/ (+ (nth 1 q) (nth 2 p)) 2.0) n (1+ n)
                *QS-V3-MN* (cons (list "DWG" (car p) (nth 1 p) (nth 2 q) (nth 3 p) (list j)) *QS-V3-MN*))))))
  n)

;; v1.0.0: lap lai phoi THAM LAM tu dau thanh: moi noi dat xa nhat (doan <= cay), lui 50 mm
;; toi khi cach moi noi ke ben >= soLe (va nam trong vung cat neu vungs). Tra ve iv hoac nil.
(defun QS-V3ThamLam (row pts L vungs tn stock lap minimum / u u0 sg t0 qs nua s j res ok iv k bad)
  (setq u (QS-HuongPts pts) u0 (QS-V3HuongChuan pts) sg (if (> (QS-B2Dot u u0) 0.0) 1.0 -1.0)
        t0 (QS-B2Dot (car pts) u0) nua (/ lap 2.0) s 0.0 ok T)
  (setq qs (mapcar '(lambda (tk) (* sg (- tk t0))) tn))
  (while (and ok (> (- L s) (+ stock 0.5)) (< (length iv) 200))
    (setq j (- (+ s stock) nua) res nil)
    (while (and (null res) (>= (- (+ j nua) s) minimum))
      (setq bad nil)
      (foreach k qs (if (< (abs (- j k)) soLe) (setq bad T)))
      (if (and (not bad)
               (>= (- L (- j nua)) minimum)
               (or (null vungs) (QS-TrongVung j vungs nua)))
        (setq res j)
        (setq j (- j 50.0))))
    (if res
      (setq iv (cons (list s (+ res nua)) iv) s (- res nua))
      (setq ok nil)))
  (if ok
    (progn
      (setq iv (reverse (cons (list s L) iv)))
      (if (and (cdr iv)
               (QS-PlanHopLe iv L stock minimum vungs lap)
               (QS-V3CutCheck (list T nil (list (list (car row) (nth 1 row) pts iv))) stock lap minimum)
               (not (QS-V3TrungT pts iv tn)))
        iv))))

;; v1.0.0: chuoi tranh trung moi noi (dung chung cho tung thanh / ca hang nhom deu) -> iv hoac nil
(defun QS-V3TranhTrung (row pts L vungs tn motDau mau stock lap minimum / ok)
  ;; muc 4 (cat 1 dau): thu dao chieu cat, doi L1/L2, roi moi dich
  (setq ok (if motDau (QS-V3NeTrung1Dau row pts L tn stock lap minimum mau)))
  (if (null ok) (setq ok (if vungs (QS-V3TranhVung row pts L vungs tn stock lap minimum))))
  (if (null ok) (setq ok (QS-V3NeTrung row vungs L stock lap minimum tn)))
  (if (null ok) (setq ok (QS-V3ThamLam row pts L vungs tn stock lap minimum)))
  ;; vung cat qua hep de so le -> uu tien KHONG TRUNG MOI NOI, cho moi noi ra ngoai vung
  (if (and (null ok) vungs)
    (progn
      (setq ok (QS-V3NeTrung row nil L stock lap minimum tn))
      (if (null ok) (setq ok (QS-V3ThamLam row pts L nil tn stock lap minimum)))
      (if ok (setq *QS-V3-NGVUNG* (1+ *QS-V3-NGVUNG*)))))
  ok)

;; v1.0.0: phuong an chung -> doan cuoi ket thuc dung chieu dai thanh nay (lech < 1 mm do sai so ve)
(defun QS-V3DatCuoi (iv L / r)
  (setq r (reverse iv))
  (reverse (cons (list (car (car r)) L) (cdr r))))

;; v1.0.0: nhom DEU = moi thanh cung chieu dai, cung diem dau (theo huong chung), cung chieu ve
(defun QS-V3NhomDeu (bars / b pts L u0 a z L0 a0 d0 ok)
  (setq ok T)
  (foreach b bars
    (if ok
      (progn
        (setq pts (QS-DinhDuong (cadr b)) L (QS-DaiPts pts) u0 (QS-V3HuongChuan pts)
              a (QS-B2Dot (car pts) u0) z (QS-B2Dot (last pts) u0))
        (if (null L0)
          (setq L0 L a0 a d0 (< a z))
          (if (or (> (abs (- L L0)) 1.0) (> (abs (- a a0)) 1.0) (not (eq d0 (< a z))))
            (setq ok nil))))))
  (and ok (cdr bars)))

;; v1.0.0: moi noi ke ben cua CA HANG m (chan / le) trong nhom deu; hang le them moi noi hang chan
(defun QS-V3TnLop (bars root sf m dongBo / k b res c0)
  (setq k 0)
  (foreach b bars
    (if (= (if sf (rem k 2) 0) m)
      (setq res (append (QS-V3MNKeBen (QS-DinhDuong (cadr b)) root nil) res)))
    (setq k (1+ k)))
  (if (and sf (= m 1) (setq c0 (assoc 0 dongBo)) (eq (cadr c0) 'OK))
    (setq res (append (nth 4 (QS-V3BanGhiMN (QS-DinhDuong (cadr (car bars))) (nth 3 c0))) res)))
  res)

;; v1.0.0: muc 4 bi trung moi noi -> thu: dao chieu cat; L1 <-> L2; ca hai. Tra ve iv hoac nil.
(defun QS-V3NeTrung1Dau (row pts L tn stock lap minimum mau / iv ds f res p)
  (setq iv (nth 3 row) ds (list (QS-V3LatDoan iv L)))
  (foreach f (list btL1 btL2)
    (if (and (numberp f) (> f 0.0) (<= f stock))
      (progn
        (setq p (vl-catch-all-apply 'QS-BTOneEndPlan (list L (min f stock) stock lap minimum)))
        (if (and p (not (vl-catch-all-error-p p)))
          (progn
            (setq p (mapcar '(lambda (x) (list (car x) (+ (car x) (cadr x)))) p))
            (setq ds (append ds (list p (QS-V3LatDoan p L)))))))))
  (foreach p ds
    (if (and (null res) p (cdr p)
             (QS-V3CutCheck (list T nil (list (list (car row) (nth 1 row) pts p))) stock lap minimum)
             (not (QS-V3TrungT pts p tn)))
      (setq res p)))
  res)

;; Khong co vung (hoac tranh vung khong duoc): dich ca chuoi moi noi it nhat (buoc 50 mm)
(defun QS-V3NeTrung (row vungs L stock lap minimum tn / iv d n cand res)
  (setq iv (nth 3 row) n 1)
  (while (and (null res) (<= (* n 50.0) (- stock lap)))
    (foreach d (list (* n 50.0) (* n -50.0))
      (if (null res)
        (progn
          (setq cand (mapcar '(lambda (p) (list (car p) (cadr p))) (QS-DichPlan iv d L)))
          (if (and (QS-PlanHopLe cand L stock minimum vungs lap)
                   (QS-V3CutCheck (list T nil (list (list (car row) (nth 1 row) (nth 2 row) cand))) stock lap minimum)
                   (not (QS-V3TrungT (nth 2 row) cand tn)))
            (setq res cand)))))
    (setq n (1+ n)))
  res)

;; v20.25: xep thu cac doan vao kho dau thua (best-fit) -> (soCayMoi dauVun khoMoi)
(defun QS-V3XepThu (lens pool stock minimum / best len vun)
  (foreach len (QS-Sap lens '>)
    (setq best nil)
    (foreach x pool
      (if (and (>= x (- len 0.5)) (or (null best) (< x best))) (setq best x)))
    (if best
      (setq pool (cons (- best len) (QS-BoMot best pool)))
      (setq pool (cons (- stock len) pool) vun (if vun (1+ vun) 1))))
  (list (if vun vun 0)
        (apply '+ (cons 0.0 (vl-remove-if '(lambda (x) (>= x minimum)) pool)))
        pool))

(defun QS-BoMot (x l / r xong)
  (foreach y l (if (and (not xong) (equal y x 1.0e-9)) (setq xong T) (setq r (cons y r))))
  (reverse r))

(defun QS-V3MoiNoi (iv / r)
  (while (cdr iv) (setq r (cons (/ (+ (cadr (car iv)) (car (cadr iv))) 2.0) r) iv (cdr iv)))
  (reverse r))

;; PHOI HOP cho nhom V3: moi thanh thu dich moi noi d trong [-dsai, +dsai] (buoc >= 50 mm),
;; giu dieu kien cay / doan toi thieu / vung cat / so le voi thanh ke truoc; chon d it cay moi
;; nhat, it dau vun nhat, |d| nho nhat. Kho dau thua dung chung cho ca lan quet.
;; So sanh voi cach cat thuong: phoi hop khong tot hon -> giu cach cat thuong.
(defun QS-V3PhoiHop (rows meta stock lap minimum / a b)
  (setq a (QS-V3PhoiLuot rows meta stock lap minimum nil *QS-V3-KHO*))
  (if (and coPhoi dsai (> dsai 0.0))
    (progn
      (setq b (QS-V3PhoiLuot rows meta stock lap minimum T *QS-V3-KHO*))
      (if (or (< (nth 2 b) (nth 2 a))
              (and (= (nth 2 b) (nth 2 a)) (< (nth 4 b) (- (nth 4 a) 0.5))))
        (setq a b))))
  (setq *QS-V3-KHO* (nth 1 a)
        *QS-V3-SOCAY* (+ (if *QS-V3-SOCAY* *QS-V3-SOCAY* 0) (nth 2 a))
        *QS-V3-DICH* (+ (if *QS-V3-DICH* *QS-V3-DICH* 0) (nth 3 a)))
  (car a))

;; 1 luot -> (rows khoMoi soCayMoi soThanhDich dauVun)
(defun QS-V3PhoiLuot (rows meta stock lap minimum dich kho / res m iv L d buoc best bk c cand ok prevRec tn socay nd)
  (setq socay 0 nd 0)
  (foreach row rows
    (setq m (car meta) meta (cdr meta) iv (nth 3 row) L (nth 3 m) best nil
          tn (QS-V3MNKeBen (nth 2 row) *QS-V3-ROOT* (if *QS-V3CUT-SOLE* prevRec)))
    (if (and dich (cdr iv) (not (nth 1 m)))
      (progn
        (setq buoc (max 50.0 (float rnd)) d (- dsai))
        (while (<= d (+ dsai 0.001))
          (setq cand (mapcar '(lambda (p) (list (car p) (cadr p))) (QS-DichPlan iv d L)))
          (setq ok (and (QS-PlanHopLe cand L stock minimum (car m) lap)
                        (not (QS-V3TrungT (nth 2 row) cand tn))))
          (if ok
            (progn
              (setq c (QS-V3XepThu (mapcar '(lambda (p) (- (cadr p) (car p))) cand) kho stock minimum))
              (if (or (null best)
                      (< (car c) (car bk))
                      (and (= (car c) (car bk)) (< (cadr c) (- (cadr bk) 0.5)))
                      (and (= (car c) (car bk)) (< (abs (- (cadr c) (cadr bk))) 0.5) (< (abs d) (abs (car best)))))
                (setq best (list d cand) bk c))))
          (setq d (+ d buoc)))))
    (if best
      (progn (setq iv (cadr best)) (if (/= (car best) 0.0) (setq nd (1+ nd))))
      (setq bk (QS-V3XepThu (mapcar '(lambda (p) (- (cadr p) (car p))) iv) kho stock minimum)))
    (setq kho (caddr bk) socay (+ socay (car bk))
          prevRec (QS-V3BanGhiMN (nth 2 row) iv)
          res (cons (list (car row) (nth 1 row) (nth 2 row) iv) res)))
  (list (reverse res) kho socay nd
        (apply '+ (cons 0.0 (vl-remove-if '(lambda (x) (>= x minimum)) kho)))))

;; v20.23: phoi thanh so le: moi noi lech so voi thanh chan >= soLe (nho nhat co the, uu tien
;; dung soLe). Moi noi thanh le = moi noi thanh chan dich d, them doan cuoi neu can.
;; Khong tim duoc -> cach cu.
(defun QS-V3DoanSoLe (L stock lap minimum tv soLe / p0 qs0 buoc d sg q qs p1 ok res dmax)
  (setq p0 (QS-DoanCat L stock lap minimum tv 0 soLe))
  (if (and p0 (cdr p0) soLe (> soLe 0.0))
    (progn
      (setq qs0 (mapcar '(lambda (p) (+ (car p) (/ lap 2.0))) (cdr p0))
            buoc (- stock lap) d soLe dmax (- buoc soLe))
      (while (and (null res) (<= d (max soLe dmax)))
        (foreach sg '(-1.0 1.0)
          (if (null res)
            (progn
              (setq q (+ (car qs0) (* sg d)) qs nil)
              (if (> q (/ lap 2.0))
                (progn
                  (setq qs (list q))
                  (while (and (> (- L (- q (/ lap 2.0))) stock) (< (length qs) 200))
                    (setq q (+ q buoc) qs (cons q qs)))
                  (setq p1 (QS-QsToDoan (reverse qs) L lap) ok T)
                  (foreach p p1
                    (if (or (> (- (cadr p) (car p)) (+ stock 1.0e-6))
                            (< (- (cadr p) (car p)) (- minimum 1.0e-6))
                            (< (car p) -1.0e-6) (> (cadr p) (+ L 1.0e-6)))
                      (setq ok nil)))
                  (if ok (setq res p1)))))))
        (setq d (+ d 50.0)))))
  (if res res (QS-DoanCat L stock lap minimum tv 1 soLe)))

(defun QS-V3PlanCat (root stock lap minimum / audit data head bars rows pts L u vungs mau
                      pieces iv k row out ok nFb motDau first meta prevRec tn uni dongBo c c0 sf)
  (setq audit (QS-V3Audit root) nFb 0)
  (if (cadr audit) (list nil (cadr audit))
    (progn
      (foreach item (nth 2 audit)
        (setq data (QS-S23Read item) head (QS-TachKT (car data) ";"))
        (if (= (nth 2 head) "BAR") (setq bars (cons (list (atoi (nth 4 head)) item) bars))))
      (setq bars (vl-sort bars '(lambda (a b) (< (car a) (car b)))) k 0)
      (setq *QS-V3-ROOT* root *QS-V3-GAP* (QS-V3KhoangNhom bars) prevRec nil
            uni (QS-V3NhomDeu bars) dongBo nil)
      (foreach b bars
        (setq pts (QS-DinhDuong (cadr b)) L (QS-DaiPts pts) u (QS-HuongPts pts))
        (setq vungs
          (cond
            ((and coVTD dsDamC) (QS-VungCatTD dsDamC pts u L vuot nchiaV minGV lopTren))
            ((and coVung ssV)   (QS-VungCat ssV pts u L vuot))
            (T nil)))
        ;; muc 4 "Cat thep bien thien 1 dau": ap dung khi KHONG co vung cat
        (setq motDau (and (= *QS5-BT_ENABLE* "1") (null vungs)))
        (setq sf (or soLeA
                     (and motDau btSole (/= *QS5-BT_NOFIRST* "1"))
                     (and motDau (= *QS5-BT_DAODAU* "1")))
              mau (if sf (rem k 2) 0))
        (setq pieces
          (cond
            ((<= L (+ stock 0.5)) (list (list 0.0 L)))
            (vungs (QS-DoanCatVungUu L stock lap minimum vungs mau soLe))
            ((and motDau (= *QS5-BT_NOFIRST* "1")) (QS-V3CutLengths L stock lap minimum))
            (motDau
             (setq first (if (and btSole (= mau 1)) btL2 btL1))
             (mapcar '(lambda (p) (list (car p) (+ (car p) (cadr p))))
                     (QS-BTOneEndPlan L (min first stock) stock lap minimum)))
            ;; v20.23: thanh so le (hang le) -> moi noi lech DUNG "So le moi noi 2 thanh"
            ((= mau 1) (QS-V3DoanSoLe L stock lap minimum tv soLe))
            (T (QS-DoanCat L stock lap minimum tv mau soLe))))
        (setq iv (mapcar '(lambda (p) (list (car p) (cadr p))) pieces))
        ;; muc 4: chon cat tu TRAI / PHAI (khong ap dung khi co vung cat)
        ;; DAO DAU: thanh L2 (hang le) cat tu dau nguoc lai
        (if (and iv (cdr iv) (null vungs)
                 (not (eq (QS-V3DauTrai pts)
                          (if (and motDau (= *QS5-BT_DAODAU* "1") (= mau 1))
                            (= *QS5-BT_HUONG* "bh_phai")
                            (/= *QS5-BT_HUONG* "bh_phai")))))
          (setq iv (QS-V3LatDoan iv L)))
        (setq row (list (car b) (cadr b) pts iv))
        ;; kiem tra doc lap; khong dat -> cat tu do
        (if (not (and iv (QS-V3CutCheck (list T root (list row)) stock lap minimum)))
          (progn
            (setq iv (QS-V3CutLengths L stock lap minimum) nFb (1+ nFb)
                  row (list (car b) (cadr b) pts iv))))
        ;; v20.26/27: khong trung moi noi voi thanh KE BEN (nhom khac + thanh so le cung nhom)
        ;; v1.0.0: NHOM DEU (cac thanh cung chieu dai / dau / huong) -> ca nhom (moi hang chan / le)
        ;; dung CHUNG 1 phuong an, tranh moi noi ke ben cua TAT CA thanh trong hang
        ;; -> khong tu sinh ra "bien thien" L=min~max khi thep goc deu.
        (setq c (if uni (assoc mau dongBo)))
        (if (and uni (null c) iv (cdr iv))
          (progn
            (setq c0 (assoc 0 dongBo))
            (if (and (= mau 1) (not (and c0 (eq (cadr c0) 'OK))))
              (setq c (list mau 'FAIL))
              (progn
                (setq tn (QS-V3TnLop bars root sf mau dongBo))
                (if tn (setq *QS-V3-KEBEN* (1+ *QS-V3-KEBEN*)))
                (setq c (cond
                          ((not (QS-V3TrungT pts iv tn)) (list mau 'OK vungs iv nil))
                          ((setq ok (QS-V3TranhTrung row pts L vungs tn motDau mau stock lap minimum))
                           (list mau 'OK vungs ok T))
                          (T (list mau 'FAIL))))))
            (setq dongBo (cons c dongBo))))
        (if (and c (eq (cadr c) 'OK) (equal (caddr c) vungs 1.0)
                 (setq ok (QS-V3DatCuoi (nth 3 c) L))
                 (QS-V3CutCheck (list T root (list (list (car b) (cadr b) pts ok))) stock lap minimum))
          (progn
            (setq iv ok row (list (car b) (cadr b) pts iv))
            (if (nth 4 c) (setq *QS-V3-NETR* (1+ *QS-V3-NETR*))))
          ;; v20.26/27: tung thanh - khong trung moi noi voi thanh KE BEN (nhom khac + thanh so le cung nhom)
          (if (and iv (cdr iv))
            (progn
              (setq tn (QS-V3MNKeBen pts root (if *QS-V3CUT-SOLE* prevRec)))
              (if tn (setq *QS-V3-KEBEN* (1+ *QS-V3-KEBEN*)))
              (if (QS-V3TrungT pts iv tn)
                (progn
                  (setq ok (QS-V3TranhTrung row pts L vungs tn motDau mau stock lap minimum))
                  (if ok
                    (setq iv ok row (list (car b) (cadr b) pts iv) *QS-V3-NETR* (1+ *QS-V3-NETR*))
                    (setq *QS-V3-KHTR* (1+ *QS-V3-KHTR*))))))))
        (setq prevRec (if iv (QS-V3BanGhiMN pts iv)))
        (if (null iv)
          (setq out (cons (strcat "Khong lap duoc phoi thanh " (cdr (assoc 5 (entget (cadr b))))) out))
          (setq rows (append rows (list row))
                meta (append meta (list (list vungs motDau mau L)))
                *QS-V3CUT-PAR* (cons (cons (cadr b) mau) *QS-V3CUT-PAR*)))
        (setq k (1+ k)))
      (if (> nFb 0)
        (princ (strcat "\n  [V3] " (itoa nFb) " thanh khong dat vung / so le -> cat tu do.")))
      ;; v20.25: PHOI HOP - dich moi noi trong dung sai de giam hao hut (chung ca lan quet)
      (if (and (null out) rows) (setq rows (QS-V3PhoiHop rows meta stock lap minimum)))
      (if (and (null out) rows) (QS-V3GhiMN root rows))
      (if out (list nil (reverse out)) (list T root rows)))))

;; Dim sau khi cat: output = records (e rowIdx key interval), tags theo thu tu nhom
(defun QS-V3DimSauCat (output tags / bins rec key pr lens rep mk e dims d best m mn mx
                        repRows row seq a b p1 p2 uu vv dsNoi tg tagsAll j par L)
  (setq tagsAll tags)
  (foreach rec output
    (setq key (nth 2 rec) pr (assoc key bins))
    (if pr (setq bins (subst (append pr (list rec)) pr bins))
      (setq bins (append bins (list (list key rec))))))
  ;; 1. dim tung doan thanh dai dien, doan bien thien ghi Lmin~Lmax
  (if coDim
    (foreach pr bins
      (setq tg (car tags) tags (cdr tags))
      (setq rep (if tg (handent (QS-TachFieldXData (QS-DocXDataTho tg) 2))))
      (if (and rep (entget rep))
        (progn
          (setq repRows (cons (list (car pr) rep) repRows))
          (setq lens (mapcar '(lambda (r) (- (cadr (nth 3 r)) (car (nth 3 r)))) (cdr pr)))
          (setq mk (entlast))
          (QS-GhiDimThep (list rep) cao rnd 0.0 dmin nil maMT T)
          (setq e (entnext mk) dims nil)
          (while e
            (if (= (cdr (assoc 0 (entget e))) "DIMENSION") (setq dims (cons e dims)))
            (setq e (entnext e)))
          (if (and dims (> (- (apply 'max lens) (apply 'min lens)) 0.5))
            (progn
              (setq best nil m -1.0)
              (foreach d dims
                (setq a (vl-catch-all-apply 'vla-get-Measurement (list (vlax-ename->vla-object d))))
                (if (and (numberp a) (> a m)) (setq m a best d)))
              (if best
                (progn
                  (setq L (QS-DaiPts (QS-DinhDuong rep))
                        mn (+ m (- (apply 'min lens) L)) mx (+ m (- (apply 'max lens) L)))
                  (vl-catch-all-apply 'vla-put-TextOverride
                    (list (vlax-ename->vla-object best) (QS-ChuoiChieuDai mn mx rnd))))))))))
    (setq repRows nil))
  ;; 2. dim DOAN NOI tren hang cua thanh dai dien nhom dau (moi nhom chan / le)
  (if coNoi
    (progn
      ;; v20.15: hang cua THANH DAI DIEN (thanh dang hien) - khong phai hang dau nhom
      (setq seq nil j 0)
      (foreach pr bins
        (setq par (if (> (car pr) 1000) 1 0) tg (nth j tagsAll) j (1+ j)
              rep (if tg (handent (QS-TachFieldXData (QS-DocXDataTho tg) 2))))
        (if (and (not (assoc par seq)) (< (rem (car pr) 1000) 500))
          (progn
            (setq rec (car (vl-remove-if-not '(lambda (r) (equal (car r) rep)) (cdr pr))))
            (if (null rec) (setq rec (car (cdr pr))))
            (setq seq (cons (cons par (nth 1 rec)) seq)))))
      (foreach s seq
        (setq row (vl-sort (vl-remove-if-not '(lambda (r) (= (nth 1 r) (cdr s))) output)
                           '(lambda (x y) (< (car (nth 3 x)) (car (nth 3 y))))))
        (while (cdr row)
          (setq a (car (car row)) b (car (cadr row)))
          (setq p1 (car (QS-DinhDuong b)) p2 (last (QS-DinhDuong a))
                uu (QS-HuongPts (QS-DinhDuong a)) vv (list (* sgn (- (cadr uu))) (* sgn (car uu))))
          (setq m (+ (* (- (car p2) (car p1)) (car uu)) (* (- (cadr p2) (cadr p1)) (cadr uu))))
          (setq p2 (list (+ (car p1) (* m (car uu))) (+ (cadr p1) (* m (cadr uu))) 0.0))
          (setq dsNoi (cons (list p1 p2 vv) dsNoi))
          (setq row (cdr row))))
      (if dsNoi
        (QS-GhiDimNoiCap dsNoi cao rnd (if (> kNoi 0.0) kNoi (* 2.5 cao)) maNeo)))))

;; Cat cac nhom V3 (goi trong c:OS_CATTHEP sau khi da co vung cat / net dam)
(defun QS-V3CatNhom (roots / nCu dimCu nDimCu root shift p q plan result nOk nLoi nDoan nTag lap dia tag
                     item data grpName grp e audit tg)
  (setq nOk 0 nLoi 0 nDoan 0 nTag 0 nDimCu 0 shift (list 0.0 0.0))
  (princ (strcat "\n\n[V3] " (itoa (length roots)) " nhom QS_BT_V3 -> cat theo cai dat OS_CATTHEP"
                 (if soLeA ", SO LE" "") (if (or coVTD coVung) ", co VUNG CAT" "") "."))
  (if (not xoaGoc)
    (progn
      (princ "\n[V3] Dang bo tick \"Xoa thep goc\": giu nguon, ve ket qua o cho khac.")
      (setq p (getpoint "\n[V3] Diem goc dich chuyen <Enter = bo qua cat V3>: "))
      (if p (setq q (getpoint p "\n[V3] Diem dat ket qua: ")))
      (setq shift (if (and p q)
                    (list (- (car (trans q 1 0)) (car (trans p 1 0)))
                          (- (cadr (trans q 1 0)) (cadr (trans p 1 0))))))))
  (if (null shift)
    (princ "\n[V3] Bo qua cat nhom V3.")
    (progn
      (QS-V3MauLayer "QS_ThepCatV3" 1)
      (setq *QS-V3CUT-KC* kcMau *QS-V3-KHO* nil *QS-V3-SOCAY* 0 *QS-V3-DICH* 0
            *QS-V3-MN* nil *QS-V3-NETR* 0 *QS-V3-KHTR* 0 *QS-V3-KEBEN* 0 *QS-V3-NGVUNG* 0)
      (setq nCu (vl-catch-all-apply 'QS-V3NapMNCu (list roots)))
      (if (vl-catch-all-error-p nCu) (setq nCu 0 *QS-V3-MN* nil))
      (if (> nCu 0)
        (princ (strcat "\n[V3] Da doc " (itoa nCu) " moi noi cua thep V3 da cat truoc tren ban ve -> tranh trung.")))
      (setq *QS-V3CUT-SOLE* (or soLeA
                                (and (= *QS5-BT_ENABLE* "1") (/= *QS5-BT_NOFIRST* "1") btSole)
                                (and (= *QS5-BT_ENABLE* "1") (= *QS5-BT_DAODAU* "1")))
            *QS-V3CUT-LECH* (* sgn lechY))
      (if (= *QS5-BT_ENABLE* "1")
        (princ (strcat "\n[V3] Muc 4: cat 1 dau"
                       (if (= *QS5-BT_NOFIRST* "1") " (khong dung L1/L2)"
                         (strcat ", thanh dau L1=" (rtos btL1 2 0)
                                 (if btSole (strcat " / L2=" (rtos btL2 2 0) " so le") "")))
                       (if (= *QS5-BT_HUONG* "bh_phai") ", cat tu PHAI qua" ", cat tu TRAI qua")
                       (if (= *QS5-BT_DAODAU* "1") " (DAO DAU: L2 cat tu dau nguoc lai)" "")
                       "; doan giua du cay, phan bien thien o dau cuoi.")))
      (foreach root roots
        (setq audit (QS-V3Audit root) tag nil *QS-V3CUT-PAR* nil)
        (foreach item (nth 2 audit)
          (if (= (nth 2 (QS-TachKT (car (QS-S23Read item)) ";")) "SOLE") (setq tag item)))
        (setq dia (if tag (atof (QS-TachFieldXData (QS-DocXDataTho tag) 3)) 0.0))
        (setq lap (if (vl-string-search "D" (strcase noiStr))
                    (* (atof (QS-SoDau noiStr)) dia) (atof (QS-SoDau noiStr))))
        (setq plan (QS-V3PlanCat root Lcay lap minCat))
        ;; v1.0.0: ghi nho dim cu cua thanh nguon (truoc khi ve dim moi) -> xoa khi cat xong
        (setq dimCu (if (and xoaGoc (car plan))
                      (vl-catch-all-apply 'QS-V3DimCu
                        (list (nth 2 audit) (max 1.0 (if (numberp cao) (* 0.02 cao) 1.0))))))
        (if (vl-catch-all-error-p dimCu) (setq dimCu nil))
        (setq result (if (car plan) (QS-C35RunPlan plan shift tyleV rnd) plan))
        (if (car result)
          (progn
            (setq nOk (1+ nOk)
                  nDoan (+ nDoan (length (car (cadr result))))
                  nTag (+ nTag (length (cadr (cadr result)))))
            (QS-V3DimSauCat (car (cadr result)) (cadr (cadr result)))
            ;; muc 4 "Hien tung thanh sau khi cat": bung nhom V3 moi (khong doi cau truc)
            (if btSingle
              (foreach tg (cadr (cadr result))
                (if (setq e (QS-V3RootOf tg)) (QS-V3Toggle e))))
            (if xoaGoc
              (progn
                (foreach e dimCu (if (entget e) (progn (entdel e) (setq nDimCu (1+ nDimCu)))))
                (setq data (QS-S23Read root) grpName nil)
                (foreach r data (if (= (substr r 1 6) "GROUP;") (setq grpName (substr r 7))))
                (if grpName
                  (progn
                    (setq grp (vl-catch-all-apply 'vla-Item (list (vla-get-Groups (QS-Doc)) grpName)))
                    (if (not (vl-catch-all-error-p grp)) (vl-catch-all-apply 'vla-Delete (list grp)))))
                (foreach item (nth 2 audit)
                  (if (and item (entget item))
                    (progn
                      (if (= (cdr (assoc 0 (entget item))) "DIMENSION")
                        (progn (setq e (entnext item))
                               (if (and e (= (cdr (assoc 0 (entget e))) "CIRCLE")) (entdel e))))
                      (entdel item)))))))
          (progn
            (setq nLoi (1+ nLoi))
            (foreach r (cadr result) (princ (strcat "\n  [V3] " r))))))
      (setq *QS-V3CUT-SOLE* nil *QS-V3CUT-LECH* nil *QS-V3CUT-PAR* nil *QS-V3CUT-KC* nil *QS-V3CUT-SRCP* nil *QS-V3CUT-PAR0* nil *QS-V3CUT-DIR* nil *QS-V3CUT-REPID* nil)
      (princ (strcat "\n[V3] Da cat " (itoa nOk) " nhom -> " (itoa nDoan) " doan, "
                     (itoa nTag) " tag (layer QS_ThepCatV3 mau do)"
                     (if (> nLoi 0) (strcat "; " (itoa nLoi) " nhom khong cat duoc (giu nguyen)") "")
                     (if xoaGoc (strcat ". Da xoa nhom nguon + " (itoa nDimCu) " dim cu cua thanh chua cat.") ". Nguon giu nguyen.")))
      (princ (strcat "\n[V3] Can " (itoa *QS-V3-SOCAY*) " cay " (rtos Lcay 2 0)
                     (if coPhoi (strcat " (PHOI HOP +/-" (rtos dsai 2 0) " mm: dich " (itoa *QS-V3-DICH*) " thanh)")
                                " (chua bat PHOI HOP)")
                     ", dau vun < doan toi thieu: "
                     (rtos (apply '+ (cons 0.0 (vl-remove-if '(lambda (x) (>= x minCat)) *QS-V3-KHO*))) 2 0) " mm."))
      (if (or (> (length roots) 1) (> nCu 0))
        (princ (strcat "\n[V3] Kiem tra so le giua nhom: " (itoa *QS-V3-KEBEN*) " thanh co nhom khac nam ke ben"
                       (if (= *QS-V3-KEBEN* 0) " (cac nhom khong xen ke / khong song song)" "") ".")))
      (if (> (+ *QS-V3-NETR* *QS-V3-KHTR*) 0)
        (princ (strcat "\n[V3] So le giua cac nhom ke ben: da dich " (itoa *QS-V3-NETR*)
                       " thanh de moi noi cach >= " (rtos soLe 2 0) " mm"
                       (if (> *QS-V3-NGVUNG* 0) (strcat " (" (itoa *QS-V3-NGVUNG*) " thanh vung cat qua hep -> moi noi ra ngoai vung)") "")
                       (if (> *QS-V3-KHTR* 0) (strcat "; " (itoa *QS-V3-KHTR*) " thanh khong dich duoc (kiem tra lai)") "")
                       "."))))))

;;; =====================================================================
;;;  v20.15  OS_MBTK - VE LAI MAT BANG KET CAU TU BAN VE THIET KE
;;;  1. Quet chon mat bang thiet ke (xuat tu Revit / CAD).
;;;  2. Gan layer thiet ke -> layer QS (mep san, dam, lo mo, cot, truc).
;;;  3. Quet bang GHI CHU: moi o hatch mau + dong chu ben phai
;;;     ("COTE SSL - 200mm, SLAB 250mm THK") -> Cote, Hs.
;;;  4. Hatch tren mat bang duoc so theo HINH MAU (khong phu thuoc ten
;;;     pattern, ty le, goc xoay) + MAU -> tu gan Hs / Cote. Dong chua
;;;     chac chan duoc danh dau de nguoi dung kiem tra / gan tay.
;;;  5. Ve ban sao sang cho khac: layer QS + polyline VUNG SAN (OS_VUNGSAN)
;;;     mang Hs / Cote -> OS_THEPSAN doc truc tiep.
;;; =====================================================================

(setq *QSMB-APP* "QS_MBTK")

;; (key  nhan  layer-QS  mau  linetype  che-do)  CURVE = chi lay net, ALL = chep nguyen
(setq *QSMB-CAT*
  '(("mbo"   "Mep san"    "QS_BaoBeTong" 4 "Continuous" CURVE)
    ("mdam"  "Dam"        "QS_NetKhuat"  8 "DASHED"     CURVE)
    ("mlo"   "Lo mo"      "QS_LoMo"      5 "Continuous" CURVE)
    ("mcot"  "Cot / vach" "QS_Cot"       7 "Continuous" ALL)
    ("mtruc" "Truc"       "QS_Truc"      8 "Continuous" ALL)))

;; goi y layer theo ten (chi dien khi o dang trong)
(setq *QSMB-GOIY*
  '(("mbo"   "*SLAB*EDGE*,*S-SLAB*,*MEP*SAN*,*BAO*SAN*,*BAOBETONG*")
    ("mdam"  "S-BEAM,S-BEAM-HDLN,*DAM*,S-BEAM-*LN*")
    ("mlo"   "*OPEN*,*LO*MO*,*LOMO*")
    ("mcot"  "S-COLS,S-COLS-HDLN,S-WALL*,*COT*")
    ("mtruc" "S-GRID,S-GRID-IDEN,*TRUC*,*GRID*")))

(defun QSMB-MacDinh ( / dwg)
  (setq dwg (strcat (getvar "DWGPREFIX") (getvar "DWGNAME")))
  (if (/= dwg *QSMB-DWG*)
    (setq *QSMB-LG* nil *QSMB-LGH* nil *QSMB-TY* nil *QSMB-HT* nil *QSMB-CLIP* nil *QSMB-DWG* dwg))
  (if (not *QSMB-GAP*) (setq *QSMB-GAP* "1000"))
  (if (not *QSMB-LOMAX*) (setq *QSMB-LOMAX* "30"))
  (if (not *QSMB-CLIPON*) (setq *QSMB-CLIPON* "0"))
  (if (not *QSMB-SRC*) (setq *QSMB-SRC* '()))
  (if (not *QSMB-HAT*) (setq *QSMB-HAT* ""))
  (if (not *QSMB-SSL*) (setq *QSMB-SSL* "0.000"))
  (if (not *QSMB-HS0*) (setq *QSMB-HS0* "200"))
  (if (not *QSMB-DT*)  (setq *QSMB-DT* "0.5"))
  (if (not *QSMB-NHAN*) (setq *QSMB-NHAN* "1"))
  (if (not *QSMB-NEN*) (setq *QSMB-NEN* "1"))
  (if (not *QSMB-XOA*) (setq *QSMB-XOA* "1"))
  (princ))

;; ------------------------------------------------------------ chuoi
(defun QSMB-Split (s / r i c cur)
  (setq r nil cur "" i 1 s (if s s ""))
  (while (<= i (strlen s))
    (setq c (substr s i 1))
    (if (member c '("," ";"))
      (progn (setq cur (vl-string-trim " \t" cur))
             (if (/= cur "") (setq r (cons (strcase cur) r))) (setq cur ""))
      (setq cur (strcat cur c)))
    (setq i (1+ i)))
  (setq cur (vl-string-trim " \t" cur))
  (if (/= cur "") (setq r (cons (strcase cur) r)))
  (reverse r))

(defun QSMB-Join (lst / s)
  (setq s "")
  (foreach x lst (setq s (if (= s "") x (strcat s "," x))))
  s)

(defun QSMB-Src (k / a) (if (setq a (assoc k *QSMB-SRC*)) (cdr a) ""))
(defun QSMB-SetSrc (k v)
  (setq *QSMB-SRC* (cons (cons k v) (vl-remove-if '(lambda (x) (= (car x) k)) *QSMB-SRC*))))

(defun QSMB-Cat (s n) (if (> (strlen s) n) (strcat (substr s 1 (- n 2)) "..") s))
(defun QSMB-R (x p) (QSVS-Rtos x p))

;; ------------------------------------------------------------ mau
(defun QSMB-LayMau (ed / c tb)
  (setq c (cdr (assoc 62 ed)))
  (if (or (null c) (= c 256) (= c 0))
    (if (setq tb (tblsearch "LAYER" (cdr (assoc 8 ed)))) (setq c (abs (cdr (assoc 62 tb)))) (setq c 7)))
  c)

;; hue (do) cua mau ACI, nil = mau xam / trang / den
(defun QSMB-Hue (c)
  (cond ((null c) nil)
        ((and (>= c 1) (<= c 6)) (nth (1- c) '(0.0 60.0 120.0 180.0 240.0 300.0)))
        ((and (>= c 10) (<= c 249)) (* 15.0 (- (/ c 10) 1)))
        (T nil)))

(defun QSMB-HueDiff (a b / d)
  (if (and a b)
    (progn (setq d (rem (abs (- a b)) 360.0)) (if (> d 180.0) (- 360.0 d) d))
    nil))

;; ------------------------------------------------------------ chu ghi chu
(defun QSMB-BoMaMText (s / r i c n k)
  (setq r "" i 1 n (strlen s))
  (while (<= i n)
    (setq c (substr s i 1))
    (cond
      ((and (= c "\\") (< i n))
       (setq k (substr s (1+ i) 1))
       (cond
         ((member k '("P" "p" "~" "N")) (setq r (strcat r " ") i (+ i 2)))
         ((member k '("L" "l" "O" "o" "K" "k")) (setq i (+ i 2)))
         ((member k '("\\" "{" "}")) (setq r (strcat r k) i (+ i 2)))
         ((member k '("f" "F" "H" "W" "Q" "T" "A" "C" "c" "p" "S"))
          (setq i (+ i 2))
          (while (and (<= i n) (/= (substr s i 1) ";")) (setq i (1+ i)))
          (setq i (1+ i)))
         (T (setq i (+ i 2)))))
      ((member c '("{" "}")) (setq i (1+ i)))
      (T (setq r (strcat r c) i (1+ i)))))
  r)

(defun QSMB-ChuDT (ed / s)
  (setq s "")
  (foreach x ed (if (= (car x) 3) (setq s (strcat s (cdr x)))))
  (setq s (strcat s (cdr (assoc 1 ed))))
  (if (= (cdr (assoc 0 ed)) "MTEXT") (QSMB-BoMaMText s) s))

;; Tach token: (loai . chuoi)  N = so, W = chu, S = ky hieu
(defun QSMB-Tok (s / i n c res cur ty a)
  (setq s (strcase s) i 1 n (strlen s) res nil cur "" ty nil)
  (while (<= i (1+ n))
    (setq c (if (<= i n) (substr s i 1) " ") a (ascii c))
    (cond
      ((or (and (>= a 48) (<= a 57))
           (and (= c ".") (= ty "N")))
       (if (and ty (/= ty "N")) (setq res (cons (cons ty cur) res) cur ""))
       (setq ty "N" cur (strcat cur c)))
      ((or (and (>= a 65) (<= a 90)) (> a 127))
       (if (and ty (/= ty "W")) (setq res (cons (cons ty cur) res) cur ""))
       (setq ty "W" cur (strcat cur c)))
      (T
       (if ty (setq res (cons (cons ty cur) res)))
       (setq cur "" ty nil)
       (if (member c '("-" "+" "(" ")" "=" ":")) (setq res (cons (cons "S" c) res)))))
    (setq i (1+ i)))
  (reverse res))

(defun QSMB-TkLa (tk i ty v / x)
  (and (setq x (nth i tk)) (= (car x) ty) (or (null v) (member (cdr x) v))))

;; Doc 1 dong ghi chu -> (hs rel(mm) abs(m) base(m))
(defun QSMB-DocGhiChu (s / tk n i hs rel ab base j sg v x dv)
  (setq tk (QSMB-Tok s) n (length tk) i 0)
  ;; ---- chieu day
  (while (and (< i n) (null hs))
    (if (QSMB-TkLa tk i "W" '("THK" "THICK" "DAY" "DÀY"))
      (progn (setq j (1- i))
             (while (and (>= j (max 0 (- i 3))) (null hs))
               (if (QSMB-TkLa tk j "N" nil) (setq hs (atof (cdr (nth j tk)))))
               (setq j (1- j)))
             (setq j (1+ i))
             (while (QSMB-TkLa tk j "S" '("=" ":")) (setq j (1+ j)))
             (if (and (null hs) (QSMB-TkLa tk j "N" nil) (not (vl-string-search "." (cdr (nth j tk)))))
               (setq hs (atof (cdr (nth j tk)))))))
    (setq i (1+ i)))
  (setq i 0)
  (while (and (< i n) (null hs))
    (if (QSMB-TkLa tk i "W" '("SLAB" "SAN" "SÀN" "HS" "H" "S" "T" "D"))
      (progn (setq j (1+ i))
             (while (QSMB-TkLa tk j "S" '("=" ":" "-")) (setq j (1+ j)))
             (if (and (QSMB-TkLa tk j "N" nil) (not (vl-string-search "." (cdr (nth j tk)))))
               (setq hs (atof (cdr (nth j tk)))))))
    (setq i (1+ i)))
  (if (and hs (or (< hs 40.0) (> hs 3000.0))) (setq hs nil))
  ;; ---- cao do
  (setq i 0)
  (while (< i n)
    (cond
      ((QSMB-TkLa tk i "W" '("SSL" "FFL" "TOS" "SFL"))
       (setq j (1+ i))
       (cond
         ((QSMB-TkLa tk j "S" '("("))
          (setq j (1+ j) sg 1.0)
          (if (QSMB-TkLa tk j "S" '("-" "+"))
            (setq sg (if (= (cdr (nth j tk)) "-") -1.0 1.0) j (1+ j)))
          (if (QSMB-TkLa tk j "N" nil)
            (progn (setq x (cdr (nth j tk)) v (atof x))
                   (if (and (not (vl-string-search "." x)) (>= v 20.0)) (setq v (/ v 1000.0)))
                   (setq base (* sg v)))))
         ((QSMB-TkLa tk j "S" '("-" "+"))
          (setq sg (if (= (cdr (nth j tk)) "-") -1.0 1.0) j (1+ j))
          (if (QSMB-TkLa tk j "N" nil)
            (progn (setq x (cdr (nth j tk)) v (atof x)
                         dv (if (QSMB-TkLa tk (1+ j) "W" '("M")) 1000.0
                              (if (and (vl-string-search "." x) (< v 20.0)
                                       (not (QSMB-TkLa tk (1+ j) "W" '("MM")))) 1000.0 1.0)))
                   (setq rel (* sg v dv)))))))
      ((and (null ab) (QSMB-TkLa tk i "S" '("-" "+")) (QSMB-TkLa tk (1+ i) "N" nil)
            (vl-string-search "." (cdr (nth (1+ i) tk)))
            (or (= i 0) (not (QSMB-TkLa tk (1- i) "W" '("SSL" "FFL" "TOS" "SFL")))))
       (setq v (atof (cdr (nth (1+ i) tk))))
       (if (< v 200.0) (setq ab (* (if (= (cdr (nth i tk)) "-") -1.0 1.0) v)))))
    (setq i (1+ i)))
  (list hs rel ab base))

;; ------------------------------------------------------------ hinh mau hatch
;; Chu ky HINH MAU: bat bien voi ten pattern, ty le, goc xoay.
;; ((gocTuongDoi  tyLeOffset  (tyLeNet...)) ...) hoac ("SOLID")
(defun QSMB-Sig (ed / L res a0 o0 a ox oy nd ds x lines)
  (if (= 1 (cdr (assoc 70 ed)))
    '("SOLID")
    (progn
      (setq L (cdr (member (assoc 78 ed) ed)) lines nil)
      (while (and L (= (caar L) 53))
        (setq a (cdar L) L (cdr L) ox 0.0 oy 0.0 nd 0 ds nil)
        (while (and L (member (caar L) '(43 44 45 46)))
          (if (= (caar L) 45) (setq ox (cdar L)))
          (if (= (caar L) 46) (setq oy (cdar L)))
          (setq L (cdr L)))
        (if (and L (= (caar L) 79)) (setq nd (cdar L) L (cdr L)))
        (while (and L (= (caar L) 49)) (setq ds (cons (abs (cdar L)) ds) L (cdr L)))
        (setq lines (cons (list a (sqrt (+ (* ox ox) (* oy oy))) (reverse ds)) lines)))
      (setq lines (reverse lines))
      (if (null lines)
        (list (strcase (cdr (assoc 2 ed))))
        (progn
          (setq a0 (car (car lines)) o0 (cadr (car lines)))
          (if (< o0 1.0e-9) (setq o0 1.0))
          (mapcar '(lambda (l)
                     (list (rem (+ 720.0 (- (car l) a0)) 360.0)
                           (/ (cadr l) o0)
                           (mapcar '(lambda (d) (/ d o0)) (caddr l))))
                  lines))))))

(defun QSMB-NumEq (a b) (<= (abs (- a b)) (* 0.03 (max 1.0 (abs a) (abs b)))))

(defun QSMB-SigEq1 (a b mir / ok da)
  (setq ok (= (length a) (length b)))
  (while (and ok a)
    (setq da (QSMB-HueDiff (caar a) (if mir (rem (- 360.0 (caar b)) 360.0) (caar b))))
    (if (or (> da 1.5)
            (not (QSMB-NumEq (cadar a) (cadar b)))
            (/= (length (caddar a)) (length (caddar b)))
            (vl-some '(lambda (p q) (not (QSMB-NumEq p q))) (caddar a) (caddar b)))
      (setq ok nil))
    (setq a (cdr a) b (cdr b)))
  ok)

(defun QSMB-SigEq (a b)
  (cond ((or (= (type (car a)) 'STR) (= (type (car b)) 'STR)) (equal a b))
        (T (or (QSMB-SigEq1 a b nil) (QSMB-SigEq1 a b T)))))

;; ------------------------------------------------------------ bien hatch
(defun QSMB-Kc (p q) (distance (list (car p) (cadr p)) (list (car q) (cadr q))))

;; Canh: (p1 p2 bulge)  ->  vong: ((x y b) ...)
(defun QSMB-NoiCanh (eds / out prv tol)
  (setq tol 1.0 out nil)
  (if (and (cadr eds)
           (> (min (QSMB-Kc (cadr (car eds)) (car (cadr eds))) (QSMB-Kc (cadr (car eds)) (cadr (cadr eds)))) tol)
           (<= (min (QSMB-Kc (car (car eds)) (car (cadr eds))) (QSMB-Kc (car (car eds)) (cadr (cadr eds)))) tol))
    (setq eds (cons (list (cadr (car eds)) (car (car eds)) (- (caddr (car eds)))) (cdr eds))))
  (foreach e eds
    (if (and prv (> (QSMB-Kc prv (car e)) tol) (<= (QSMB-Kc prv (cadr e)) tol))
      (setq e (list (cadr e) (car e) (- (caddr e)))))
    (if (or (> (QSMB-Kc (car e) (cadr e)) 0.01) (/= 0.0 (caddr e)))
      (setq out (cons (list (car (car e)) (cadr (car e)) (caddr e)) out)
            prv (cadr e))))
  (reverse out))

(defun QSMB-Arc (c r sa ea ccw / sw)
  (if (= ccw 1)
    (setq sw (rem (+ 720.0 (- ea sa)) 360.0))
    (setq sa (- 360.0 sa) ea (- 360.0 ea) sw (- (rem (+ 720.0 (- sa ea)) 360.0))))
  (if (equal sw 0.0 1.0e-9) (setq sw (if (= ccw 1) 360.0 -360.0)))
  (setq sa (* pi (/ sa 180.0)) sw (* pi (/ sw 180.0)))
  (list (polar c sa r) (polar c (+ sa sw) r) (/ (sin (/ sw 4.0)) (cos (/ sw 4.0)))))

;; Doc cac vong bien cua hatch -> list vong ((x y bulge) ...)
(defun QSMB-Vong (ed / L nl k fl eds pts nv hb ne ty p1 p2 c r sa ea ccw mj ra i n loops pt b jj)
  (setq L (cdr (member (assoc 91 ed) ed)) nl (cdr (assoc 91 ed)) k 0 loops nil)
  (while (and L (< k nl))
    (while (and L (/= (caar L) 92)) (setq L (cdr L)))
    (setq fl (cdar L) L (cdr L) eds nil)
    (if (= 2 (logand fl 2))
      (progn
        (setq hb 0 nv 0 pts nil)
        (while (and L (member (caar L) '(72 73)))
          (if (= (caar L) 72) (setq hb (cdar L))) (setq L (cdr L)))
        (if (= (caar L) 93) (setq nv (cdar L) L (cdr L)))
        (setq i 0)
        (while (and L (< i nv))
          (setq pt (cdar L) L (cdr L) b 0.0)
          (if (and L (= (caar L) 42)) (setq b (cdar L) L (cdr L)))
          (setq pts (cons (list (car pt) (cadr pt) b) pts) i (1+ i)))
        (setq loops (cons (reverse pts) loops)))
      (progn
        (setq ne (if (= (caar L) 93) (cdar L) 0) L (cdr L) i 0)
        (while (and L (< i ne))
          (while (and L (not (member (caar L) '(72 92 75)))) (setq L (cdr L)))
          (if (and L (= (caar L) 72)) (setq ty (cdar L) L (cdr L)) (setq ty 0))
          (cond
            ((= ty 1)
             (setq p1 (cdr (assoc 10 L)) p2 (cdr (assoc 11 L)))
             (setq L (cddr L))
             (setq eds (cons (list p1 p2 0.0) eds)))
            ((= ty 2)
             (setq c (cdar L) r (cdadr L) sa (cdr (nth 2 L)) ea (cdr (nth 3 L)) ccw (cdr (nth 4 L)))
             (setq L (cdr (cddddr L)))
             (setq eds (cons (QSMB-Arc c r sa ea ccw) eds)))
            ((= ty 3)
             (setq c (cdar L) mj (cdadr L) ra (cdr (nth 2 L)) sa (cdr (nth 3 L)) ea (cdr (nth 4 L)) ccw (cdr (nth 5 L)))
             (setq L (QSMB-Bo 6 L))
             (if (/= ccw 1) (setq sa (- 360.0 sa) ea (- 360.0 ea)))
             (setq sa (* pi (/ sa 180.0)) ea (* pi (/ ea 180.0)) n 8 p1 nil)
             (if (and (= ccw 1) (<= ea sa)) (setq ea (+ ea pi pi)))
             (if (and (/= ccw 1) (>= ea sa)) (setq ea (- ea pi pi)))
             (setq jj 0)
             (repeat (1+ n)
               (setq r (+ sa (* (- ea sa) (/ jj (float n))))
                     p2 (list (+ (car c) (* (car mj) (cos r)) (* ra -1.0 (cadr mj) (sin r)))
                              (+ (cadr c) (* (cadr mj) (cos r)) (* ra (car mj) (sin r)))))
               (if p1 (setq eds (cons (list p1 p2 0.0) eds)))
               (setq p1 p2 jj (1+ jj))))
            ((= ty 4)
             (setq pts nil)
             (while (and L (not (member (caar L) '(72 97 92))))
               (if (= (caar L) 10) (setq pts (cons (cdar L) pts)))
               (setq L (cdr L)))
             (setq pts (reverse pts))
             (while (cdr pts) (setq eds (cons (list (car pts) (cadr pts) 0.0) eds) pts (cdr pts))))
            (T (setq i ne)))
          (setq i (1+ i)))
        (if eds (setq loops (cons (QSMB-NoiCanh (reverse eds)) loops)))))
    (while (and L (not (member (caar L) '(92 75)))) (setq L (cdr L)))
    (setq k (1+ k)))
  (vl-remove-if '(lambda (x) (< (length x) 3)) (reverse loops)))

(defun QSMB-XY (lp) (mapcar '(lambda (v) (list (car v) (cadr v))) lp))
(defun QSMB-DTVong (lp) (abs (QSVS-DienTich (QSMB-XY lp))))
(defun QSMB-BBVong (lps / r) (foreach lp lps (setq r (append r (QSMB-XY lp)))) (QSVS-BB r))

;; ------------------------------------------------------------ bang ghi chu
(defun QSMB-BB (e / o a b r)
  (setq o (vlax-ename->vla-object e))
  (setq r (vl-catch-all-apply 'vla-GetBoundingBox (list o 'a 'b)))
  (if (vl-catch-all-error-p r) nil
    (progn (setq a (vlax-safearray->list a) b (vlax-safearray->list b))
           (list (car a) (cadr a) (car b) (cadr b)))))

(defun QSMB-BBTam (bb) (list (/ (+ (car bb) (caddr bb)) 2.0) (/ (+ (cadr bb) (cadddr bb)) 2.0)))

;; Quet ghi chu -> *QSMB-LG* : list (sigs mau hs rel ab chu)   + *QSMB-LGHANDLES*
(defun QSMB-QuetGhiChu (ss / i e ed ty bb hs tx sw s best sc gap dy ww hh r lst base chu k)
  (setq i 0 hs nil tx nil *QSMB-LGH* nil)
  (repeat (sslength ss)
    (setq e (ssname ss i) ed (entget e) ty (cdr (assoc 0 ed)) i (1+ i))
    (cond
      ((and (= ty "HATCH") (setq bb (QSMB-BB e)))
       (setq *QSMB-LGH* (cons (cdr (assoc 5 ed)) *QSMB-LGH*))
       (setq hs (cons (list bb (QSMB-Sig ed) (QSMB-LayMau ed) (cdr (assoc 2 ed))) hs)))
      ((and (member ty '("TEXT" "MTEXT")) (setq bb (QSMB-BB e)))
       (setq tx (cons (list bb (QSMB-ChuDT ed)) tx)))))
  ;; gom hatch chong nhau thanh 1 o mau
  (setq sw nil)
  (foreach h hs
    (setq k nil ww (- (caddr (car h)) (car (car h))) hh (- (cadddr (car h)) (cadr (car h))))
    (foreach s sw
      (if (and (null k)
               (< (apply 'max (mapcar '(lambda (u v) (abs (- u v))) (car s) (car h))) (* 0.15 (min ww hh))))
        (setq k s)))
    (if k
      (setq sw (subst (list (car k) (cons (cadr h) (cadr k)) (cons (caddr h) (caddr k)) nil (cons (cadddr h) (nth 4 k))) k sw))
      (setq sw (cons (list (car h) (list (cadr h)) (list (caddr h)) nil (list (cadddr h))) sw))))
  ;; gan chu vao o mau gan nhat ben TRAI
  (setq base nil)
  (foreach t0 tx
    (setq best nil)
    (foreach s sw
      (setq ww (- (caddr (car s)) (car (car s))) hh (- (cadddr (car s)) (cadr (car s)))
            gap (- (car (car t0)) (caddr (car s)))
            dy (abs (- (cadr (QSMB-BBTam (car t0))) (cadr (QSMB-BBTam (car s))))))
      (if (and (> gap (* -0.1 ww)) (< gap (* 8.0 (max ww hh))) (< dy (* 1.2 hh)))
        (progn (setq sc (+ gap (* 2.0 dy)))
               (if (or (null best) (< sc (car best))) (setq best (list sc s))))))
    (if best
      (setq sw (subst (list (car (cadr best)) (cadr (cadr best)) (caddr (cadr best))
                            (cons t0 (cadddr (cadr best))) (nth 4 (cadr best)))
                      (cadr best) sw))
      (if (setq r (QSMB-DocGhiChu (cadr t0)))
        (if (and (nth 3 r) (null base)) (setq base (nth 3 r))))))
  (setq lst nil)
  (foreach s sw
    (setq chu "")
    (foreach t0 (vl-sort (cadddr s) '(lambda (a b) (> (cadddr (car a)) (cadddr (car b)))))
      (setq chu (vl-string-trim " " (strcat chu " " (cadr t0)))))
    (setq r (QSMB-DocGhiChu chu))
    (if (and (nth 3 r) (null base) (null (cadr r))) (setq base (nth 3 r)))
    (if (/= chu "")
      (setq lst (cons (list (cadr s) (caddr s) (car r) (cadr r)
                            (if (nth 2 r) (nth 2 r) (if (and (nth 3 r) (null (cadr r))) (nth 3 r)))
                            chu (nth 4 s) (car s))
                      lst))))
  ;; sap theo cot roi hang (doc nhu nguoi doc bang)
  (setq lst (vl-sort lst '(lambda (a b)
                            (if (> (abs (- (car (nth 7 a)) (car (nth 7 b)))) (* 0.5 (- (caddr (nth 7 a)) (car (nth 7 a)))))
                              (< (car (nth 7 a)) (car (nth 7 b)))
                              (> (cadr (nth 7 a)) (cadr (nth 7 b)))))))
  (setq *QSMB-LG* lst)
  (if base (setq *QSMB-SSL* (QSMB-R base 3)))
  (length lst))

;; Cote (m) cua 1 dong ghi chu
(defun QSMB-LGCote (g / ssl)
  (setq ssl (QS-Num *QSMB-SSL*))
  (if (null ssl) (setq ssl 0.0))
  (cond ((nth 3 g) (+ ssl (/ (nth 3 g) 1000.0)))
        ((nth 4 g) (nth 4 g))
        (T ssl)))
(defun QSMB-LGHs (g / h0) (if (nth 2 g) (nth 2 g) (if (setq h0 (QS-Num *QSMB-HS0*)) h0 200.0)))

(defun QSMB-LGNhan (g)
  (strcat "Cote " (QSVS-FCote (QSMB-LGCote g)) "  Hs " (QSVS-FHs (QSMB-LGHs g))
          (if (nth 2 g) "" "*") "   " (QSMB-Cat (nth 5 g) 44)))

;; ------------------------------------------------------------ quet hatch mat bang
;; *QSMB-HT*  : kieu hatch don  (sig mau ten)
;; *QSMB-TY*  : loai vung       (ds-chi-so-kieu  ds-vung  dien-tich  gan  trang-thai  goiy)
;;   gan = nil | "BO" | (hs cote nguon mau)
(defun QSMB-KieuHT (sig mau ten / i k)
  (setq i 0 k nil)
  (foreach h *QSMB-HT*
    (if (and (null k) (= (cadr h) mau) (QSMB-SigEq (car h) sig)) (setq k i))
    (setq i (1+ i)))
  (if k k
    (progn (setq *QSMB-HT* (append *QSMB-HT* (list (list sig mau ten)))) (1- (length *QSMB-HT*)))))

(defun QSMB-TyKey (ty / s)
  (setq s "")
  (foreach k (car ty)
    (setq s (strcat s (caddr (nth k *QSMB-HT*)) "/" (itoa (cadr (nth k *QSMB-HT*))) "+")))
  s)

(defun QSMB-QuetHatch ( / lays i e ed vung bb dt key old found ty k dtmin r cu cbb)
  (setq lays (QSMB-Split *QSMB-HAT*) cu nil)
  (foreach ty *QSMB-TY* (if (nth 3 ty) (setq cu (cons (cons (QSMB-TyKey ty) (list (nth 3 ty) (nth 4 ty))) cu))))
  (QSMB-ClipSet)
  (setq cbb (if *QSMB-CLIPP* (QSVS-BB *QSMB-CLIPP*)))
  (setq *QSMB-HT* nil *QSMB-TY* nil vung nil i 0
        dtmin (* 1.0e6 (if (QS-Num *QSMB-DT*) (QS-Num *QSMB-DT*) 0.0)))
  (if (and *QSMB-SS* lays)
    (repeat (sslength *QSMB-SS*)
      (setq e (ssname *QSMB-SS* i) i (1+ i))
      (if (and (entget e) (= (cdr (assoc 0 (setq ed (entget e)))) "HATCH")
               (member (strcase (cdr (assoc 8 ed))) lays)
               (not (member (cdr (assoc 5 ed)) *QSMB-LGH*)))
        (progn
          (setq r (QSMB-Vong ed))
          (if (and r cbb (not (QSVS-BBGiao (QSMB-BBVong r) cbb))) (setq r nil))
          (if r
            (progn
              (setq dt 0.0)
              (foreach lp r (setq dt (+ dt (QSMB-DTVong lp))))
              (setq bb (QSMB-BBVong r) key (strcat (itoa (length r)) "|" (QSMB-R (/ dt 1.0e4) 0) "|"
                                                   (QSMB-R (/ (car bb) 10.0) 0) "|" (QSMB-R (/ (cadr bb) 10.0) 0)))
              (setq k (QSMB-KieuHT (QSMB-Sig ed) (QSMB-LayMau ed) (strcase (cdr (assoc 2 ed)))))
              (if (setq found (assoc key vung))
                (if (not (member k (cadr found)))
                  (setq vung (subst (list key (QS-Sap (cons k (cadr found)) '<) (caddr found) (cadddr found)
                                          (cons e (nth 4 found)) (nth 5 found))
                                    found vung)))
                (setq vung (cons (list key (list k) r dt (list e) bb) vung)))))))))
  ;; gom vung theo loai
  (foreach v vung
    (if (>= (cadddr v) dtmin)
      (if (setq found (vl-some '(lambda (t0) (if (equal (car t0) (cadr v)) t0)) *QSMB-TY*))
        (setq *QSMB-TY* (subst (list (car found) (cons v (cadr found)) (+ (caddr found) (cadddr v)) nil nil nil)
                               found *QSMB-TY*))
        (setq *QSMB-TY* (cons (list (cadr v) (list v) (cadddr v) nil nil nil) *QSMB-TY*)))))
  (setq *QSMB-TY* (vl-sort *QSMB-TY* '(lambda (a b) (> (caddr a) (caddr b)))))
  ;; giu lai phan gan tay cua lan truoc
  (setq *QSMB-TY*
    (mapcar '(lambda (ty / c)
               (if (setq c (assoc (QSMB-TyKey ty) cu))
                 (list (car ty) (cadr ty) (caddr ty) (cadr c) (caddr c) nil)
                 ty))
            *QSMB-TY*))
  (QSMB-TuKhop)
  (length *QSMB-TY*))

;; ------------------------------------------------------------ doi chieu
;; Ung vien ghi chu co cung tap HINH MAU voi tap kieu ks.
(defun QSMB-UngVien (ks / res)
  (foreach g *QSMB-LG*
    (if (and (= (length (car g)) (length ks))
             (vl-every '(lambda (k) (vl-some '(lambda (s) (QSMB-SigEq (car (nth k *QSMB-HT*)) s)) (car g))) ks)
             (vl-every '(lambda (s) (vl-some '(lambda (k) (QSMB-SigEq (car (nth k *QSMB-HT*)) s)) ks)) (car g)))
      (setq res (cons g res))))
  (reverse res))

;; Diem lech mau (0 = trung mau, 999 = khong so duoc)
(defun QSMB-DiemMau (ks g / tot m d s)
  (setq tot 0.0)
  (foreach k ks
    (setq m (cadr (nth k *QSMB-HT*)) d nil)
    (foreach s (car g)
      (if (QSMB-SigEq (car (nth k *QSMB-HT*)) s)
        (progn
          (setq s (nth (vl-position s (car g)) (cadr g)))
          (setq s (if (= s m) 0.0 (QSMB-HueDiff (QSMB-Hue m) (QSMB-Hue s))))
          (if (and s (or (null d) (< s d))) (setq d s)))))
    (setq tot (+ tot (if d d 999.0))))
  (/ tot (length ks)))

;; Chon ung vien: (g trang-thai) ; trang thai "OK" / "~" / "?"
(defun QSMB-Chon (ks / uv sc best b2 g)
  (setq uv (QSMB-UngVien ks))
  (cond
    ((null uv) nil)
    ((null (cdr uv)) (list (car uv) "OK"))
    (T
     (setq sc (vl-sort (mapcar '(lambda (g) (cons (QSMB-DiemMau ks g) g)) uv)
                       '(lambda (a b) (< (car a) (car b)))))
     (setq best (car sc) b2 (cadr sc))
     (cond
       ((and (= (car best) 0.0) (> (car b2) 0.0)) (list (cdr best) "OK"))
       ((and (<= (car best) 45.0) (>= (- (car b2) (car best)) 30.0)) (list (cdr best) "~"))
       (T (list nil "?" uv))))))

(defun QSMB-TuKhop ( / res ty ks r gs g1 hint)
  (setq res nil)
  (foreach ty *QSMB-TY*
    (setq ks (car ty) hint nil)
    (if (and (nth 3 ty) (member (nth 4 ty) '("TAY" "BO")))
      (setq res (cons ty res))
      (progn
        (setq r (QSMB-Chon ks))
        (cond
          ((and r (car r))
           (setq res (cons (list ks (cadr ty) (caddr ty) (car r) (cadr r) nil) res)))
          (T
           ;; to hop nhieu hatch chong nhau: xet tung thanh phan
           (setq gs nil)
           (if (cdr ks)
             (foreach k ks
               (setq g1 (QSMB-Chon (list k)))
               (setq gs (cons (if (and g1 (car g1)) (car g1)) gs))))
           (if (and gs (car gs) (vl-every '(lambda (x) (eq x (car gs))) gs))
             (setq res (cons (list ks (cadr ty) (caddr ty) (car gs) "~" nil) res))
             (progn
               (if (and r (caddr r)) (setq hint (caddr r)))
               (if (and (null hint) gs) (setq hint (vl-remove nil gs)))
               (setq res (cons (list ks (cadr ty) (caddr ty) nil "?" hint) res)))))))))
  (setq *QSMB-TY* (reverse res)))

;; Hs / Cote / ten nguon / mau cua 1 loai
(defun QSMB-TyGiaTri (ty / a)
  (setq a (nth 3 ty))
  (cond ((null a) nil)
        ((= a "BO") nil)
        ((and (listp a) (= (length a) 2) (numberp (car a))) (list (car a) (cadr a) "Gan tay"))
        ((listp a) (list (QSMB-LGHs a) (QSMB-LGCote a) (nth 5 a)))))

(defun QSMB-TyDong (i ty / ks s v st)
  (setq s "")
  (foreach k (car ty)
    (setq s (strcat s (if (= s "") "" "+") (caddr (nth k *QSMB-HT*)) "/" (itoa (cadr (nth k *QSMB-HT*))))))
  (setq v (QSMB-TyGiaTri ty) st (cond ((= (nth 3 ty) "BO") "BO") ((nth 4 ty)) (T "?")))
  (strcat (itoa (1+ i)) ".\t" (QSMB-Cat s 20) "\tx" (itoa (length (cadr ty)))
          "\t" (QSMB-R (/ (caddr ty) 1.0e6) 1) " m2\t" st "\t"
          (cond (v (strcat "Cote " (QSVS-FCote (cadr v)) "  Hs " (QSVS-FHs (car v)) "  " (QSMB-Cat (caddr v) 26)))
                ((= (nth 3 ty) "BO") "(khong tao vung)")
                ((nth 5 ty)
                 (strcat "goi y: " (QSMB-Cat (QSMB-Join (mapcar '(lambda (g) (QSVS-FCote (QSMB-LGCote g))) (nth 5 ty))) 36)))
                (T "chua gan"))))

;; ------------------------------------------------------------ hop thoai
(defun QSMB-DienDS ( / i)
  (start_list "mlist" 3) (setq i 0)
  (foreach ty *QSMB-TY* (add_list (QSMB-TyDong i ty)) (setq i (1+ i)))
  (end_list)
  (start_list "mpop" 3)
  (add_list "(chon dong ghi chu de gan cho dong dang chon)")
  (foreach g *QSMB-LG* (add_list (QSMB-LGNhan g)))
  (end_list)
  (set_tile "mgcinfo"
    (if *QSMB-LG*
      (strcat "Da doc " (itoa (length *QSMB-LG*)) " dong ghi chu.  SSL = " *QSMB-SSL* " m")
      "Chua doc ghi chu."))
  (set_tile "mtong" (strcat (itoa (length *QSMB-TY*)) " loai hatch  |  OK: "
                            (itoa (length (vl-remove-if-not '(lambda (t0) (= (nth 4 t0) "OK")) *QSMB-TY*)))
                            "  ~: " (itoa (length (vl-remove-if-not '(lambda (t0) (= (nth 4 t0) "~")) *QSMB-TY*)))
                            "  ?: " (itoa (length (vl-remove-if-not '(lambda (t0) (= (nth 4 t0) "?")) *QSMB-TY*)))))
  (princ))

(defun QSMB-Chon-DS ( / s)
  (setq s (get_tile "mlist"))
  (if (and s (/= s "")) (read (strcat "(" s ")")) nil))

(defun QSMB-GanDS (gan st / sel i)
  (setq sel (QSMB-Chon-DS) i 0)
  (if (null sel)
    (set_tile "mghichu" "Chon 1 hoac nhieu dong trong bang truoc.")
    (progn
      (setq *QSMB-TY*
        (mapcar '(lambda (ty / r)
                   (setq r (if (member i sel) (list (car ty) (cadr ty) (caddr ty) gan st (nth 5 ty)) ty) i (1+ i))
                   r)
                *QSMB-TY*))
      (QSMB-DienDS)
      (set_tile "mlist" (vl-string-trim "()" (vl-prin1-to-string sel)))
      (set_tile "mghichu" (strcat "Da gan " (itoa (length sel)) " dong."))))
  (princ))

(defun QSMB-OnPop (v / k)
  (setq k (atoi v))
  (if (> k 0) (QSMB-GanDS (nth (1- k) *QSMB-LG*) "TAY"))
  (set_tile "mpop" "0"))

(defun QSMB-OnTay ( / hs ct)
  (setq hs (QS-Num (get_tile "mhs")) ct (QS-Num (get_tile "mct")))
  (if (and hs ct (> hs 0.0))
    (QSMB-GanDS (list hs ct) "TAY")
    (set_tile "mghichu" "Nhap Hs (mm) va Cote (m) hop le truoc khi bam Gan tay.")))

(defun QSMB-OnList ( / sel ty v)
  (if (and (setq sel (QSMB-Chon-DS)) (setq ty (nth (car sel) *QSMB-TY*)) (setq v (QSMB-TyGiaTri ty)))
    (progn (set_tile "mhs" (QSVS-FHs (car v))) (set_tile "mct" (QSMB-R (cadr v) 3)))))

(defun QSMB-DocTile ( / )
  (foreach c *QSMB-CAT* (QSMB-SetSrc (car c) (vl-string-trim " " (get_tile (car c)))))
  (setq *QSMB-HAT* (vl-string-trim " " (get_tile "mhat"))
        *QSMB-SSL* (get_tile "mssl") *QSMB-HS0* (get_tile "mhs0") *QSMB-DT* (get_tile "mdt")
        *QSMB-NHAN* (get_tile "mnhan") *QSMB-NEN* (get_tile "mnen") *QSMB-XOA* (get_tile "mxoa")
        *QSMB-GAP* (get_tile "mgap") *QSMB-LOMAX* (get_tile "mlomax") *QSMB-CLIPON* (get_tile "mclip"))
  (princ))

(defun QSMB-OnSo ( / ) (QSMB-DocTile) (QSMB-DienDS))
(defun QSMB-OnHat ( / ) (QSMB-DocTile) (QSMB-QuetAnToan) (QSMB-DienDS))

;; Tu nhan layer hatch: layer co hatch trung HINH MAU voi ghi chu
(defun QSMB-TuLayerHat ( / i e ed lays s dtmin r dt)
  (setq i 0 lays nil dtmin (* 1.0e6 (if (QS-Num *QSMB-DT*) (QS-Num *QSMB-DT*) 0.0)))
  (if (and *QSMB-SS* *QSMB-LG*)
    (repeat (sslength *QSMB-SS*)
      (setq e (ssname *QSMB-SS* i) i (1+ i) ed (entget e))
      (if (and ed (= (cdr (assoc 0 ed)) "HATCH") (not (member (cdr (assoc 5 ed)) *QSMB-LGH*))
               (setq s (QSMB-Sig ed))
               (vl-some '(lambda (g) (vl-some '(lambda (x) (QSMB-SigEq s x)) (car g))) *QSMB-LG*))
        (progn
          (setq dt 0.0)
          (foreach lp (QSMB-Vong ed) (setq dt (+ dt (QSMB-DTVong lp))))
          (if (>= dt dtmin)
            (if (setq r (assoc (strcase (cdr (assoc 8 ed))) lays))
              (setq lays (subst (cons (car r) (1+ (cdr r))) r lays))
              (setq lays (cons (cons (strcase (cdr (assoc 8 ed))) 1) lays))))))))
  (setq lays (vl-sort lays '(lambda (a b) (> (cdr a) (cdr b)))))
  (if lays (setq *QSMB-HAT* (QSMB-Join (mapcar 'car lays))))
  lays)

(defun QSMB-GoiYLayer ( / i e lay ds r)
  (setq i 0 ds nil)
  (if *QSMB-SS*
    (repeat (sslength *QSMB-SS*)
      (setq e (ssname *QSMB-SS* i) i (1+ i) lay (strcase (cdr (assoc 8 (entget e)))))
      (if (not (member lay ds)) (setq ds (cons lay ds)))))
  (foreach g *QSMB-GOIY*
    (if (= (QSMB-Src (car g)) "")
      (progn
        (setq r nil)
        (foreach lay ds (if (wcmatch lay (cadr g)) (setq r (cons lay r))))
        (if r (QSMB-SetSrc (car g) (QSMB-Join (QS-Sap r '<)))))))
  (princ))

(defun QSMB-QuetAnToan ( / r)
  (setq r (vl-catch-all-apply 'QSMB-QuetHatch nil))
  (if (vl-catch-all-error-p r)
    (progn
      (princ (strcat "\n[OS_MBTK] Loi khi quet hatch: " (vl-catch-all-error-message r)
                     "\n           Da tat polyline gioi han, quet lai..."))
      (setq *QSMB-CLIPON* "0" *QSMB-TY* nil *QSMB-HT* nil)
      (setq r (vl-catch-all-apply 'QSMB-QuetHatch nil))
      (if (vl-catch-all-error-p r)
        (progn (princ (strcat "\n[OS_MBTK] Van loi: " (vl-catch-all-error-message r))) (setq *QSMB-TY* nil)))))
  (princ))

;; Chi nhan polyline gioi han hop le (>= 3 diem so)
(defun QSMB-ClipHopLe (c)
  (and c (listp c) (> (length c) 2)
       (vl-every '(lambda (p) (and (listp p) (numberp (car p)) (numberp (cadr p)))) c)))

(defun QSMB-ClipSet ()
  (if (not (QSMB-ClipHopLe *QSMB-CLIP*)) (setq *QSMB-CLIP* nil))
  (setq *QSMB-CLIPP* (if (and (= *QSMB-CLIPON* "1") *QSMB-CLIP*) *QSMB-CLIP* nil)
        *QSMB-CLIPM* nil))

;; Chia polyline gioi han thanh manh loi - chi goi luc VE (ngoai hop thoai)
(defun QSMB-ClipManh ( / n)
  (setq *QSMB-CLIPM* nil)
  (if *QSMB-CLIPP*
    (progn
      (setq n (length *QSMB-CLIPP*))
      (cond
        ((QSMB-Loi *QSMB-CLIPP*) (setq *QSMB-CLIPM* (list *QSMB-CLIPP*)))
        ((> n 150)
         (princ (strcat "\n  [Gioi han] Polyline lom qua nhieu dinh (" (itoa n)
                        ") - vung san cat ngang bien se giu nguyen ca vung.")))
        (T (princ "\n  Dang chia polyline gioi han...")
           (setq *QSMB-CLIPM* (QSMB-ManhLoi *QSMB-CLIPP*)))))))

(defun QSMB-ClipInfo ()
  (if *QSMB-CLIP*
    (strcat "Da chon: " (itoa (length *QSMB-CLIP*)) " dinh, "
            (QSMB-R (/ (abs (QSVS-DienTich *QSMB-CLIP*)) 1.0e6) 1) " m2"
            (if (QSMB-Loi *QSMB-CLIP*) "" " (lom: vung san giu nguyen)"))
    "Chua chon polyline gioi han."))

(defun QSMB-ChonClip ( / pe e ty pts c r i)
  (setq pe (entsel "\nChon POLYLINE kin (hoac CIRCLE) gioi han vung can lay: "))
  (if pe
    (progn
      (setq e (car pe) ty (cdr (assoc 0 (entget e))))
      (cond
        ((member ty '("LWPOLYLINE" "POLYLINE")) (setq pts (QSVS-Pts e)))
        ((= ty "CIRCLE")
         (setq c (cdr (assoc 10 (entget e))) r (cdr (assoc 40 (entget e))) i 0)
         (repeat 48 (setq pts (cons (polar c (* i (/ pi 24.0)) r) pts) i (1+ i)))))
      (if (and pts (> (length pts) 2))
        (setq *QSMB-CLIP* (QSMB-DonGian (mapcar '(lambda (p) (list (car p) (cadr p))) pts)) *QSMB-CLIPON* "1")
        (princ "\n[Loi] Can POLYLINE (it nhat 3 dinh) hoac CIRCLE.")))))

(defun QSMB-Pick (k / pe e ed lay cu)
  (setq pe (nentsel (strcat "\nChon 1 doi tuong thuoc layer can them vao [" k "]: ")))
  (if pe
    (progn
      (setq e (car pe) ed (entget e) lay (cdr (assoc 8 ed)))
      (if (and (cadddr pe) (= lay "0")) (setq lay (cdr (assoc 8 (entget (car (last pe)))))))
      (setq lay (strcase lay) cu (if (= k "mhat") (QSMB-Split *QSMB-HAT*) (QSMB-Split (QSMB-Src k))))
      (if (not (member lay cu)) (setq cu (append cu (list lay))))
      (if (= k "mhat") (setq *QSMB-HAT* (QSMB-Join cu)) (QSMB-SetSrc k (QSMB-Join cu)))
      (princ (strcat "\n  + layer " lay)))))

(defun QSMB-ZoomXem (bb hs / m)
  (if bb
    (progn
      (setq m (* 0.05 (max (- (caddr bb) (car bb)) (- (cadddr bb) (cadr bb)))))
      (vl-cmdf "_.ZOOM" "_W" (list (- (car bb) m) (- (cadr bb) m)) (list (+ (caddr bb) m) (+ (cadddr bb) m)))
      (foreach e hs (redraw e 3))
      (getstring "\nCac vung dang sang la loai da chon. Enter de quay lai hop thoai...")
      (foreach e hs (redraw e 4)))))

;; Moi thao tac trong hop thoai chay qua day: loi LISP chi bao len dong ghi chu,
;; khong lam dung hop thoai (ZWCAD).
(defun QSMB-Chay (k / r)
  (setq r (vl-catch-all-apply 'QSMB-XuLy (list k)))
  (if (vl-catch-all-error-p r)
    (set_tile "mghichu" (strcat "[Loi " k "] " (vl-catch-all-error-message r))))
  (princ))

(defun QSMB-XuLy (k / c n)
  (cond
    ((= k "accept") (vl-catch-all-apply 'QSMB-DocTile nil) (setq *QSMB-OK* T) (done_dialog 1))
    ((wcmatch k "pk_m*")
     (QSMB-DocTile)
     (setq n (if (= k "pk_mhat") 19
               (+ 11 (vl-position (substr k 4) (mapcar 'car *QSMB-CAT*)))))
     (done_dialog n))
    ((= k "pk_clip") (QSMB-DocTile) (done_dialog 22))
    ((= k "bt_gc") (QSMB-DocTile) (done_dialog 20))
    ((= k "bt_zoom") (QSMB-DocTile) (setq *QSMB-SEL* (QSMB-Chon-DS)) (done_dialog 21))
    ((= k "mclip")
     (if (and (= *QSMB-V* "1") (null *QSMB-CLIP*))
       (progn (set_tile "mclip" "0") (set_tile "mghichu" "Bam \"Chon polyline gioi han <\" truoc."))
       (QSMB-OnHat)))
    ((= k "bt_auto")
     (QSMB-DocTile)
     (if (QSMB-TuLayerHat)
       (progn (set_tile "mhat" *QSMB-HAT*) (QSMB-QuetAnToan) (QSMB-DienDS))
       (set_tile "mghichu" "Chua doc ghi chu hoac khong co hatch nao trung hinh mau.")))
    ((= k "bt_khop")
     (QSMB-DocTile)
     (setq *QSMB-TY* (mapcar '(lambda (t0) (list (car t0) (cadr t0) (caddr t0) nil nil nil)) *QSMB-TY*))
     (QSMB-TuKhop) (QSMB-DienDS))
    ((member k '("mhat" "mdt")) (if (= *QSMB-R* 2) (QSMB-OnHat)))
    ((member k '("mssl" "mhs0")) (if (= *QSMB-R* 2) (QSMB-OnSo)))
    ((= k "mlist") (QSMB-OnList))
    ((= k "mpop") (QSMB-OnPop *QSMB-V*))
    ((= k "bt_tay") (QSMB-OnTay))
    ((= k "bt_bo") (QSMB-GanDS "BO" "BO")))
  (princ))

(defun QSMB-DienHT ( / )
  (foreach c *QSMB-CAT* (set_tile (car c) (QSMB-Src (car c))))
  (set_tile "mhat" *QSMB-HAT*)
  (set_tile "mssl" *QSMB-SSL*) (set_tile "mhs0" *QSMB-HS0*) (set_tile "mdt" *QSMB-DT*)
  (set_tile "mnhan" *QSMB-NHAN*) (set_tile "mnen" *QSMB-NEN*) (set_tile "mxoa" *QSMB-XOA*)
  (set_tile "mgap" *QSMB-GAP*) (set_tile "mlomax" *QSMB-LOMAX*)
  (set_tile "mclip" (if *QSMB-CLIP* *QSMB-CLIPON* "0")) (set_tile "mclipinfo" (QSMB-ClipInfo))
  (set_tile "mghichu" "B1: Chon bang ghi chu.  B2: kiem tra cot trang thai (~ / ?), gan lai neu can.  OK -> pick diem dat.")
  (QSMB-DienDS))

(defun QSMB-HopThoai ( / id lap rc bb hs ss r)
  (setq lap T *QSMB-OK* nil)
  (while lap
    (setq id (QS-NapDCL))
    (if (or (null id) (not (new_dialog "qs_mbtk" id)))
      (progn (princ "\n[Loi] Khong mo duoc hop thoai qs_mbtk.") (setq lap nil))
      (progn
        ;; gan nut TRUOC (khong the loi) de luon thoat duoc hop thoai
        (action_tile "cancel" "(done_dialog 0)")
        (foreach k (append (mapcar '(lambda (c) (strcat "pk_" (car c))) *QSMB-CAT*)
                           '("pk_mhat" "pk_clip" "bt_gc" "bt_zoom" "mclip" "bt_auto" "bt_khop"
                             "mhat" "mdt" "mssl" "mhs0" "mlist" "mpop" "bt_tay" "bt_bo" "accept"))
          (action_tile k (strcat "(setq *QSMB-V* $value *QSMB-R* $reason)(QSMB-Chay \"" k "\")")))
        (setq r (vl-catch-all-apply 'QSMB-DienHT nil))
        (if (vl-catch-all-error-p r)
          (set_tile "mghichu" (strcat "[Loi khi nap du lieu] " (vl-catch-all-error-message r)
                                      "  - bam Cancel, gui anh chup cho nguoi viet lenh.")))
        (setq rc (start_dialog))
        (QS-DongDCL)
        (setq r (vl-catch-all-apply 'QSMB-SauHT (list rc)))
        (cond
          ((vl-catch-all-error-p r)
           (princ (strcat "\n[OS_MBTK] Loi: " (vl-catch-all-error-message r))))
          ((null r) (setq lap nil))))))
  *QSMB-OK*)

;; Xu ly sau khi dong hop thoai; tra ve T = mo lai hop thoai
(defun QSMB-SauHT (rc / ss hs bb)
  (cond
    ((and (>= rc 11) (<= rc 15)) (QSMB-Pick (car (nth (- rc 11) *QSMB-CAT*))) T)
    ((= rc 19) (QSMB-Pick "mhat") (QSMB-QuetAnToan) T)
    ((= rc 22) (QSMB-ChonClip) (QSMB-QuetAnToan) T)
    ((= rc 20)
     (princ "\nQuet chon BANG GHI CHU (o hatch mau + dong chu ben phai): ")
     (if (setq ss (ssget))
       (progn
         (princ (strcat "\n  Doc duoc " (itoa (QSMB-QuetGhiChu ss)) " dong ghi chu co o mau."))
         (if (= *QSMB-HAT* "") (QSMB-TuLayerHat))
         (QSMB-QuetAnToan)))
     T)
    ((= rc 21)
     (foreach i (if *QSMB-SEL* *QSMB-SEL* '(0))
       (if (nth i *QSMB-TY*)
         (foreach v (cadr (nth i *QSMB-TY*))
           (setq bb (if bb (list (min (car bb) (car (nth 5 v))) (min (cadr bb) (cadr (nth 5 v)))
                                 (max (caddr bb) (caddr (nth 5 v))) (max (cadddr bb) (cadddr (nth 5 v))))
                      (nth 5 v))
                 hs (append hs (nth 4 v))))))
     (QSMB-ZoomXem bb hs)
     T)
    (T nil)))

;; ------------------------------------------------------------ ve
(defun QSMB-Tag (e key / ed)
  (if (not (tblsearch "APPID" *QSMB-APP*)) (regapp *QSMB-APP*))
  (setq ed (append (entget e) (list (list -3 (list *QSMB-APP* (cons 1000 key))))))
  (entmod ed))

(defun QSMB-Curve-p (o)
  (member (vla-get-ObjectName o)
          '("AcDbLine" "AcDbArc" "AcDbCircle" "AcDbPolyline" "AcDb2dPolyline" "AcDbEllipse" "AcDbSpline")))

(defun QSMB-Giu (o lay key p0 p1 / r)
  (setq r (vl-catch-all-apply
            '(lambda ()
               (vla-Move o p0 p1)
               (vla-put-Layer o lay)
               (vla-put-Color o 256)
               (if (vlax-property-available-p o 'Linetype T) (vla-put-Linetype o "ByLayer"))
               (QSMB-Tag (vlax-vla-object->ename o) key))))
  (if (vl-catch-all-error-p r) (progn (vl-catch-all-apply 'vla-Delete (list o)) nil) T))

;; Gom LINE (theo nhom) de gop / cat sau; net khac: trim theo polyline gioi han.
(defun QSMB-GomLine (ck p q / a)
  (if (setq a (assoc ck gom))
    (setq gom (subst (cons ck (cons (list p q) (cdr a))) a gom))
    (setq gom (cons (list ck (list p q)) gom))))

(defun QSMB-XLoMo (o key off / pts c r)
  (cond
    ((= (vla-get-ObjectName o) "AcDbCircle")
     (setq c (vlax-safearray->list (vlax-variant-value (vla-get-Center o))) r (vla-get-Radius o))
     (foreach d (list (list (polar c (* 0.25 pi) r) (polar c (* 1.25 pi) r))
                      (list (polar c (* 0.75 pi) r) (polar c (* 1.75 pi) r)))
       (QSMB-VeLine (car d) (cadr d) "QS_LoMo" key '(0.0 0.0 0.0))))
    ((and (= (vla-get-ObjectName o) "AcDbPolyline") (= :vlax-true (vla-get-Closed o)))
     (setq pts (QSVS-Pts (vlax-vla-object->ename o)))
     (foreach d (QSMB-ChuX pts) (QSMB-VeLine (car d) (cadr d) "QS_LoMo" key '(0.0 0.0 0.0))))))

(defun QSMB-No (o ck lay key p0 p1 sau / arr n r)
  (setq n 0)
  (setq arr (vl-catch-all-apply 'vla-Explode (list o)))
  (if (not (vl-catch-all-error-p arr))
    (foreach c (vlax-safearray->list (vlax-variant-value arr))
      (cond
        ((= (vla-get-ObjectName c) "AcDbLine")
         (QSMB-GomLine ck (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint c)))
                          (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint c))))
         (vl-catch-all-apply 'vla-Delete (list c)))
        ((QSMB-Curve-p c)
         (setq r (QSMB-CatCurve c))
         (cond
           ((eq r 'IN)
            (if (QSMB-Giu c lay key p0 p1)
              (progn (setq n (1+ n)) (if (= ck "mlo") (QSMB-XLoMo c key nil)))))
           (T
            (foreach pl (if (listp r) r) (if (QSMB-PlineMo pl lay key (vlax-safearray->list (vlax-variant-value p1))) (setq n (1+ n))))
            (vl-catch-all-apply 'vla-Delete (list c)))))
        ((and (= (vla-get-ObjectName c) "AcDbBlockReference") (< sau 6))
         (setq n (+ n (QSMB-No c ck lay key p0 p1 (1+ sau))))
         (vl-catch-all-apply 'vla-Delete (list c)))
        (T (vl-catch-all-apply 'vla-Delete (list c))))))
  n)

(defun QSMB-VeLine (p q lay key off / e)
  (if (setq e (entmakex (list '(0 . "LINE") '(100 . "AcDbEntity") (cons 8 lay) '(100 . "AcDbLine")
                              (list 10 (+ (car p) (car off)) (+ (cadr p) (cadr off)) 0.0)
                              (list 11 (+ (car q) (car off)) (+ (cadr q) (cadr off)) 0.0))))
    (QSMB-Tag e key))
  e)

(defun QSMB-XoaCu (key / ss i e d hv)
  (setq ss (ssget "_X" (list (list -3 (list *QSMB-APP*)))) i 0)
  (if ss
    (repeat (sslength ss)
      (setq e (ssname ss i) i (1+ i))
      (if (and (entget e)
               (= key (cdr (assoc 1000 (cdadr (assoc -3 (entget e (list *QSMB-APP*))))))))
        (progn
          (if (setq d (QSVS-Doc e))
            (progn (setq hv (QSVS-Handle e))
                   (QSVS-XoaLink (nth 4 d) hv) (QSVS-XoaLink (nth 5 d) hv) (QSVS-XoaLink (nth 6 d) hv)))
          (entdel e))))))

(defun QSMB-Pline (lp dx dy lay / ed)
  (setq ed (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay) '(100 . "AcDbPolyline")
                 (cons 90 (length lp)) '(70 . 1)))
  (foreach v lp
    (setq ed (append ed (list (list 10 (+ (car v) dx) (+ (cadr v) dy)) (cons 42 (caddr v))))))
  (entmakex ed))

;; Vong nam trong vong khac cua cung vung -> lo (so lan long le)
(defun QSMB-LaLo (lp lps / p d)
  (setq p (QSMB-DiemTrong lp) d 0)
  (foreach q lps (if (and (not (eq q lp)) (QSVS-Trong p (QSMB-XY q))) (setq d (1+ d))))
  (= 1 (rem d 2)))

(defun QSMB-DiemTrong (lp / a b)
  (setq a (car lp) b (cadr lp))
  (list (/ (+ (car a) (car b)) 2.0) (/ (+ (cadr a) (cadr b)) 2.0)))

(defun QSMB-Dem (dem k n)
  (if (assoc k dem) (subst (cons k (+ n (cdr (assoc k dem)))) (assoc k dem) dem) (cons (cons k n) dem)))

(defun QSMB-Ve (off / *QSVS-NHAN* *QSVS-NEN* *QSVS-MAU* p0 p1 key i e ed lay c n nv nl hs0 ssl
                      dtmin v e2 khoa cu dem mode mau ds ngoai lo a lp r gom segs lomo gap lomax bb pts nlo)
  (QSVS-MacDinh)
  (setq *QSVS-NHAN* *QSMB-NHAN* *QSVS-NEN* "0")
  (setq p0 (vlax-3d-point '(0.0 0.0 0.0)) p1 (vlax-3d-point off)
        key (strcat (QSMB-R (car off) 0) "," (QSMB-R (cadr off) 0))
        hs0 (if (QS-Num *QSMB-HS0*) (QS-Num *QSMB-HS0*) 200.0)
        ssl (if (QS-Num *QSMB-SSL*) (QS-Num *QSMB-SSL*) 0.0)
        dtmin (* 1.0e6 (if (QS-Num *QSMB-DT*) (QS-Num *QSMB-DT*) 0.0))
        gap (if (QS-Num *QSMB-GAP*) (QS-Num *QSMB-GAP*) 0.0)
        lomax (if (QS-Num *QSMB-LOMAX*) (QS-Num *QSMB-LOMAX*) 30.0))
  (QSMB-ClipSet)
  (QSMB-ClipManh)
  (vla-StartUndoMark (QS-Doc))
  (foreach c *QSMB-CAT* (QS-TaoLayer (nth 2 c) (nth 3 c) (nth 4 c)))
  (QS-DamBaoLayer "QS_VungSan" 4)
  (if (= *QSMB-XOA* "1") (QSMB-XoaCu key))
  ;; mo khoa tam layer nguon
  (setq khoa nil)
  (vlax-for L (vla-get-Layers (QS-Doc))
    (if (= :vlax-true (vla-get-Lock L)) (progn (setq khoa (cons L khoa)) (vla-put-Lock L :vlax-false))))
  ;; --- net / doi tuong theo layer
  (setq i 0 dem nil gom nil)
  (repeat (sslength *QSMB-SS*)
    (setq e (ssname *QSMB-SS* i) i (1+ i))
    (if (setq ed (entget e))
      (progn
        (setq lay (strcase (cdr (assoc 8 ed))) c nil)
        (foreach x *QSMB-CAT* (if (and (null c) (member lay (QSMB-Split (QSMB-Src (car x))))) (setq c x)))
        (if (and c (not (member (cdr (assoc 5 ed)) *QSMB-LGH*)))
          (progn
            (setq v (vlax-ename->vla-object e) mode (nth 5 c) n 0)
            (cond
              ((and (= mode 'CURVE) (= (cdr (assoc 0 ed)) "LINE"))
               (QSMB-GomLine (car c) (cdr (assoc 10 ed)) (cdr (assoc 11 ed))))
              ((= (cdr (assoc 0 ed)) "LINE")
               (foreach d (QSMB-ClipSeg (cdr (assoc 10 ed)) (cdr (assoc 11 ed)))
                 (if (QSMB-VeLine (car d) (cadr d) (nth 2 c) key off) (setq n (1+ n)))))
              ((QSMB-Curve-p v)
               (setq r (QSMB-CatCurve v))
               (cond
                 ((eq r 'IN)
                  (if (QSMB-Giu (setq v (vla-Copy v)) (nth 2 c) key p0 p1)
                    (progn (setq n 1) (if (= (car c) "mlo") (QSMB-XLoMo v key nil)))))
                 ((listp r)
                  (foreach pl r (if (QSMB-PlineMo pl (nth 2 c) key off) (setq n (1+ n)))))))
              ((= mode 'ALL)
               (if (and (/= (cdr (assoc 0 ed)) "DIMENSION")
                        (or (null *QSMB-CLIPP*) (and (setq bb (QSMB-BB e)) (QSMB-ClipOK (QSMB-BBTam bb))))
                        (QSMB-Giu (vla-Copy v) (nth 2 c) key p0 p1))
                 (setq n 1)))
              ((= (vla-get-ObjectName v) "AcDbBlockReference")
               (setq n (QSMB-No v (car c) (nth 2 c) key p0 p1 0))))
            (if (> n 0) (setq dem (QSMB-Dem dem (nth 2 c) n))))))))
  ;; --- LINE da gom: gop net dam / mep san, tim lo mo, cat theo gioi han
  (setq lomo nil)
  (foreach g gom
    (setq c (assoc (car g) *QSMB-CAT*) segs (cdr g))
    (cond
      ((= (car g) "mdam") (setq segs (QSMB-GopLine segs (max 1.0 gap))))
      ((= (car g) "mbo") (setq segs (QSMB-GopLine segs 5.0)))
      ((= (car g) "mlo")
       (setq r (QSMB-TimVong segs 3.0 lomax) segs nil)
       (foreach lp0 (car r)
         (setq pts (QSMB-CatVung lp0))
         (if (equal pts '(NGUYEN)) (setq pts (list lp0)))
         (foreach lp pts
           (setq lomo (cons (list lp (abs (QSVS-DienTich lp))) lomo))
           (if (setq e2 (QSMB-Pline (mapcar '(lambda (p) (list (car p) (cadr p) 0.0)) lp) (car off) (cadr off) "QS_LoMo"))
             (QSMB-Tag e2 key))
           (foreach d (QSMB-ChuX lp) (QSMB-VeLine (car d) (cadr d) "QS_LoMo" key off))))
       (setq dem (QSMB-Dem dem "QS_LoMo (lo)" (length lomo)))
       (if (cadr r) (princ (strcat "\n  [Lo mo] Bo qua " (itoa (length (cadr r)))
                                  " net le khong khep kin (khong phai lo mo).")))))
    (setq n 0)
    (foreach sg segs
      (foreach d (QSMB-ClipSeg (car sg) (cadr sg))
        (if (QSMB-VeLine (car d) (cadr d) (nth 2 c) key off) (setq n (1+ n)))))
    (if (> n 0) (setq dem (QSMB-Dem dem (nth 2 c) n))))
  (foreach L khoa (vla-put-Lock L :vlax-true))
  ;; --- vung san: phan loai vong ngoai / lo truoc
  (setq nv 0 nl 0 nlo 0 ds nil ngoai nil)
  (foreach ty *QSMB-TY*
    (if (setq v (QSMB-TyGiaTri ty))
      (progn
        (setq mau (itoa (max 1 (min 255 (if (and (listp (nth 3 ty)) (cadr (nth 3 ty)) (listp (cadr (nth 3 ty))))
                                            (car (cadr (nth 3 ty)))
                                            (cadr (nth (car (car ty)) *QSMB-HT*)))))))
        (foreach vg (cadr ty)
          (foreach lp (nth 2 vg)
            (if (>= (setq a (QSMB-DTVong lp)) dtmin)
              (progn
                (setq lo (QSMB-LaLo lp (nth 2 vg)))
                ;; trim theo polyline gioi han (vung lom: chia manh loi)
                (setq pts (QSMB-CatVung (QSMB-VongPts lp)))
                (if (equal pts '(NGUYEN))
                  (setq pts (list lp))
                  (setq pts (vl-remove-if '(lambda (q) (< (abs (QSVS-DienTich q)) (max 1.0e4 (* 0.2 dtmin)))) pts)
                        pts (mapcar '(lambda (q) (mapcar '(lambda (p) (list (car p) (cadr p) 0.0)) q)) pts)))
                (foreach lp pts
                  (setq a (QSMB-DTVong lp) ds (cons (list lp lo v mau a) ds))
                  (if (not lo) (setq ngoai (cons (list (QSMB-XY lp) a) ngoai)))))))))))
  (foreach o lomo (setq ngoai (cons o ngoai)))
  (foreach r (reverse ds)
    (setq lp (car r) v (caddr r))
    (if (cadr r)
      ;; lo trong hatch khong co vung / lo mo nao lap kin:
      ;;   mnen = 1 -> LO MO (polyline + chu X),  mnen = 0 -> vung nen (SSL, Hs thuong)
      (if (not (vl-some '(lambda (o)
                           (and (>= (cadr o) (* 0.8 (nth 4 r))) (<= (cadr o) (* 1.25 (nth 4 r)))
                                (QSVS-Trong (QSVS-DiemNhan (car o)) (QSMB-XY lp))))
                        ngoai))
        (if (= *QSMB-NEN* "1")
          (progn
            (setq pts (QSMB-VongPts lp))
            (if (setq e2 (QSMB-Pline lp (car off) (cadr off) "QS_LoMo"))
              (progn (QSMB-Tag e2 key) (setq nlo (1+ nlo))
                     (foreach d (QSMB-ChuX pts) (QSMB-VeLine (car d) (cadr d) "QS_LoMo" key off)))))
          (if (setq e2 (QSMB-Pline lp (car off) (cadr off) "QS_VungSan"))
            (progn (setq *QSVS-MAU* "8")
                   (QSVS-Gan e2 (strcat "S" (QSVS-FHs hs0)) hs0 ssl nil "")
                   (QSMB-Tag e2 key) (setq nl (1+ nl))))))
      (if (setq e2 (QSMB-Pline lp (car off) (cadr off) "QS_VungSan"))
        (progn (setq *QSVS-MAU* (cadddr r))
               (QSVS-Gan e2 (strcat "S" (QSVS-FHs (car v))) (car v) (cadr v) nil "")
               (QSMB-Tag e2 key) (setq nv (1+ nv))))))
  ;; giu lai polyline gioi han
  (if *QSMB-CLIPP*
    (progn
      (QS-DamBaoLayer "QS_GioiHan" 2)
      (if (setq e2 (QSMB-Pline (mapcar '(lambda (p) (list (car p) (cadr p) 0.0)) *QSMB-CLIP*) (car off) (cadr off) "QS_GioiHan"))
        (QSMB-Tag e2 key))))
  (vla-EndUndoMark (QS-Doc))
  (princ "\n----------------------------------------------------------")
  (foreach d (reverse dem) (princ (strcat "\n  " (QSVS-Pad (car d) 14) ": " (itoa (cdr d)) " doi tuong")))
  (princ (strcat "\n  QS_VungSan    : " (itoa nv) " vung san"
                 (if (> nl 0) (strcat " + " (itoa nl) " vung nen (lo trong hatch)") "")
                 (if (> nlo 0) (strcat "\n  QS_LoMo       : them " (itoa nlo) " lo mo tu lo trong hatch san") "")))
  (princ "\n----------------------------------------------------------")
  (princ))

(defun c:OS_MBTK ( / *error* base dest off)
  (defun *error* (msg)
    (vl-catch-all-apply 'vla-EndUndoMark (list (QS-Doc)))
    (QS-DongDCL)
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[OS_MBTK] " msg (if *QSMB-BUOC* (strcat "   (buoc: " *QSMB-BUOC* ")") ""))))
    (princ))
  (setq *QSMB-BUOC* "khoi tao")
  (QSMB-MacDinh)
  (princ "\n=== OS_MBTK - VE LAI MAT BANG KET CAU TU BAN VE THIET KE ===")
  (princ "\nQuet chon TOAN BO mat bang thiet ke (khong can chon bang ghi chu): ")
  (if (setq *QSMB-SS* (ssget))
    (progn
      (princ (strcat "\n  Da chon " (itoa (sslength *QSMB-SS*)) " doi tuong."))
      (setq *QSMB-BUOC* "goi y layer") (QSMB-GoiYLayer)
      (setq *QSMB-BUOC* "quet hatch")
      (if (/= *QSMB-HAT* "") (QSMB-QuetAnToan) (setq *QSMB-TY* nil))
      (setq *QSMB-BUOC* "hop thoai")
      (if (QSMB-HopThoai)
        (if (and (setq base (getpoint "\nDiem goc tren ban thiet ke: "))
                 (setq dest (getpoint base "\nDiem dat ban ve QS: ")))
          (progn
            (setq off (mapcar '- (trans dest 1 0) (trans base 1 0)))
            (setq *QSMB-BUOC* "ve")
            (QSMB-Ve off)
            (princ "\nXong. Chay OS_THEPSAN tren ban ve QS (tick dung VUNG SAN)."))
          (princ "\nDa huy: chua chon diem dat."))
        (princ "\nDa huy."))))
  (princ))

(princ "\n  OS_MBTK         - VE LAI mat bang ket cau tu ban THIET KE (layer QS + vung san Hs / Cote)")

;;; ------------------------------------------------------------ v20.16 hinh hoc phu
;; Goc duong thang [0, pi)
(defun QSMB-GocDT (p q / a)
  (setq a (atan (- (cadr q) (cadr p)) (- (car q) (car p))))
  (if (< a 0.0) (setq a (+ a pi)))
  (if (>= a (- pi 3.0e-4)) (setq a (- a pi)))
  a)

;; Gop cac doan thang trung phuong + trung duong, noi khe <= gap.  segs: ((p q) ...)
(defun QSMB-GopLine (segs gap / rs grp gs a0 ux uy nx ny tt off res cur s e lst o0 sub)
  (foreach sg segs
    (if (> (distance (car sg) (cadr sg)) 0.5)
      (setq rs (cons (cons (QSMB-GocDT (car sg) (cadr sg)) sg) rs))))
  (setq rs (vl-sort rs '(lambda (a b) (< (car a) (car b)))) grp nil gs nil)
  ;; nhom theo goc (chuoi lien tiep)
  (foreach r rs
    (if (and gs (> (- (car r) (car (car gs))) 3.0e-4))
      (setq grp (cons gs grp) gs nil))
    (setq gs (cons r gs)))
  (if gs (setq grp (cons gs grp)))
  (foreach gs grp
    (setq a0 (/ (apply '+ (mapcar 'car gs)) (float (length gs)))
          ux (cos a0) uy (sin a0) nx (- uy) ny ux lst nil)
    (foreach r gs
      (setq s (+ (* (car (cadr r)) ux) (* (cadr (cadr r)) uy))
            e (+ (* (car (caddr r)) ux) (* (cadr (caddr r)) uy))
            off (/ (+ (* (car (cadr r)) nx) (* (cadr (cadr r)) ny)
                      (* (car (caddr r)) nx) (* (cadr (caddr r)) ny)) 2.0))
      (setq lst (cons (list off (min s e) (max s e)) lst)))
    (setq lst (vl-sort lst '(lambda (a b) (< (car a) (car b)))) sub nil o0 nil)
    (foreach r (append lst (list nil))
      (if (or (null r) (and sub (> (- (car r) (car (car sub))) 2.0)))
        (progn
          ;; xu ly 1 duong thang
          (setq off (/ (apply '+ (mapcar 'car sub)) (float (length sub)))
                sub (vl-sort sub '(lambda (a b) (< (cadr a) (cadr b)))) cur nil)
          (foreach t0 sub
            (if (and cur (<= (cadr t0) (+ (cadr cur) gap)))
              (setq cur (list (car cur) (max (cadr cur) (caddr t0))))
              (progn
                (if cur (setq res (cons (list cur off ux uy nx ny) res)))
                (setq cur (list (cadr t0) (caddr t0))))))
          (if cur (setq res (cons (list cur off ux uy nx ny) res)))
          (setq sub nil)))
      (if r (setq sub (cons r sub)))))
  (mapcar '(lambda (x / s e o)
             (setq s (car (car x)) e (cadr (car x)) o (cadr x))
             (list (list (+ (* s (nth 2 x)) (* o (nth 4 x))) (+ (* s (nth 3 x)) (* o (nth 5 x))))
                   (list (+ (* e (nth 2 x)) (* o (nth 4 x))) (+ (* e (nth 3 x)) (* o (nth 5 x))))))
          res))

;; Tim vong kin tu cac doan thang (moi nut dung 2 doan).  -> (dsVong dsDoanConLai)
(defun QSMB-TimVong (segs tol dtmax / eps act nid nxy rec i j sn adj cur k nodes used loops rest
                       a b pth ok n dem nb x dt)
  (setq i 0 eps nil)
  (foreach sg segs
    (setq eps (cons (list (car (car sg)) (cadr (car sg)) i 0) eps)
          eps (cons (list (car (cadr sg)) (cadr (cadr sg)) i 1) eps) i (1+ i)))
  (setq eps (vl-sort eps '(lambda (a b) (< (car a) (car b)))) act nil nid 0 nxy nil rec nil)
  (foreach ep eps
    (setq act (vl-remove-if '(lambda (x) (< (car x) (- (car ep) tol))) act) k nil)
    (foreach x act
      (if (and (null k) (<= (abs (- (cadr x) (cadr ep))) tol)) (setq k (caddr x))))
    (if (null k)
      (setq k nid nid (1+ nid) nxy (cons (list (car ep) (cadr ep)) nxy)
            act (cons (list (car ep) (cadr ep) k) act)))
    (setq rec (cons (list (caddr ep) (cadddr ep) k) rec)))
  (setq nxy (reverse nxy))
  ;; nut 2 dau moi doan
  (setq rec (vl-sort rec '(lambda (a b) (if (= (car a) (car b)) (< (cadr a) (cadr b)) (< (car a) (car b))))))
  (setq sn nil)
  (while rec (setq sn (cons (list (caddr (car rec)) (caddr (cadr rec))) sn) rec (cddr rec)))
  (setq sn (reverse sn))
  ;; ke: (nut seg nutKia) sap theo nut -> list chi so theo nut
  (setq i 0 x nil)
  (foreach p sn
    (if (/= (car p) (cadr p))
      (setq x (cons (list (car p) i (cadr p)) (cons (list (cadr p) i (car p)) x))))
    (setq i (1+ i)))
  (setq x (vl-sort x '(lambda (a b) (< (car a) (car b)))) adj nil k 0 cur nil)
  (while (< k nid)
    (setq cur nil)
    (while (and x (= (car (car x)) k)) (setq cur (cons (cdr (car x)) cur) x (cdr x)))
    (setq adj (cons cur adj) k (1+ k)))
  (setq adj (reverse adj))
  ;; di vong
  (setq i 0 used nil loops nil)
  (foreach p sn
    (if (and (not (member i used)) (/= (car p) (cadr p)))
      (progn
        (setq a (car p) b (cadr p) pth (list b a) ok nil n (list i) cur b dem 0)
        (while (and (not ok) cur (< dem 400))
          (setq nb (vl-remove-if '(lambda (e) (member (car e) n)) (nth cur adj)))
          (if (and (= (length (nth cur adj)) 2) (= (length nb) 1))
            (progn
              (setq n (cons (car (car nb)) n))
              (if (= (cadr (car nb)) a)
                (setq ok T)
                (setq cur (cadr (car nb)) pth (cons cur pth))))
            (setq cur nil))
          (setq dem (1+ dem)))
        (if ok
          (progn
            (setq pth (mapcar '(lambda (k) (nth k nxy)) (reverse pth))
                  dt (abs (QSVS-DienTich pth)))
            (if (and (> (length pth) 2) (>= dt 1.0e4) (<= dt (* dtmax 1.0e6)))
              (setq loops (cons pth loops) used (append n used))
              (setq used (append n used) rest (append (mapcar '(lambda (k) (nth k segs)) n) rest))))
          nil)))
    (setq i (1+ i)))
  (setq i 0)
  (foreach sg segs
    (if (not (member i used)) (setq rest (cons sg rest)))
    (setq i (1+ i)))
  (list (reverse loops) rest))

;; 2 duong cheo chu X cho da giac
(defun QSMB-ChuX (pts / a b c d best dd s smax smin)
  (if (= (length pts) 4)
    (list (list (nth 0 pts) (nth 2 pts)) (list (nth 1 pts) (nth 3 pts)))
    (progn
      (setq best 0.0)
      (foreach p pts (foreach q pts (if (> (setq dd (distance p q)) best) (setq best dd a p b q))))
      (setq smax 0.0 smin 0.0 c nil d nil)
      (foreach p pts
        (setq s (- (* (- (car b) (car a)) (- (cadr p) (cadr a))) (* (- (cadr b) (cadr a)) (- (car p) (car a)))))
        (if (> s smax) (setq smax s c p))
        (if (< s smin) (setq smin s d p)))
      (if (and c d) (list (list a b) (list c d)) (list (list a b))))))

;; ---- cat theo polyline gioi han
(defun QSMB-ClipOK (p) (or (null *QSMB-CLIPP*) (QSVS-Trong p *QSMB-CLIPP*)))

(defun QSMB-ClipSeg (p q / ts L e1 ip res s0 i t1 t2 m)
  (if (null *QSMB-CLIPP*)
    (list (list p q))
    (progn
      (setq L (distance p q) ts (list 0.0 1.0) e1 (last *QSMB-CLIPP*))
      (foreach e2 *QSMB-CLIPP*
        (if (and (> L 1.0e-9) (setq ip (inters p q e1 e2 T)))
          (setq ts (cons (/ (distance p ip) L) ts)))
        (setq e1 e2))
      (setq ts (QS-Sap ts '<) i 0 s0 nil)
      (while (< (1+ i) (length ts))
        (setq t1 (nth i ts) t2 (nth (1+ i) ts))
        (if (> (- t2 t1) 1.0e-9)
          (progn
            (setq m (* 0.5 (+ t1 t2)))
            (if (QSVS-Trong (list (+ (car p) (* m (- (car q) (car p)))) (+ (cadr p) (* m (- (cadr q) (cadr p)))))
                            *QSMB-CLIPP*)
              (if (and s0 (equal (cadr s0) t1 1.0e-9)) (setq s0 (list (car s0) t2))
                (progn (if s0 (setq res (cons s0 res))) (setq s0 (list t1 t2))))
              (progn (if s0 (setq res (cons s0 res))) (setq s0 nil)))))
        (setq i (1+ i)))
      (if s0 (setq res (cons s0 res)))
      (mapcar '(lambda (tt)
                 (list (list (+ (car p) (* (car tt) (- (car q) (car p)))) (+ (cadr p) (* (car tt) (- (cadr q) (cadr p)))))
                       (list (+ (car p) (* (cadr tt) (- (car q) (car p)))) (+ (cadr p) (* (cadr tt) (- (cadr q) (cadr p)))))))
              (reverse res)))))

(defun QSMB-Loi (pts / a b c s sg ok)
  (setq ok T sg 0 a (nth (- (length pts) 2) pts) b (last pts))
  (foreach c pts
    (setq s (- (* (- (car b) (car a)) (- (cadr c) (cadr b))) (* (- (cadr b) (cadr a)) (- (car c) (car b)))))
    (cond ((< (abs s) 1.0e-6))
          ((= sg 0) (setq sg (if (> s 0) 1 -1)))
          ((/= sg (if (> s 0) 1 -1)) (setq ok nil)))
    (setq a b b c))
  ok)

;; Diem vong co bulge -> da giac (cung chia 8)
(defun QSMB-VongPts (lp / res n i v w b th r a0 c sa k)
  (setq n (length lp) i 0)
  (while (< i n)
    (setq v (nth i lp) w (nth (rem (1+ i) n) lp) b (caddr v))
    (setq res (cons (list (car v) (cadr v)) res))
    (if (> (abs b) 1.0e-9)
      (progn
        (setq th (* 4.0 (atan b))
              r (/ (distance (list (car v) (cadr v)) (list (car w) (cadr w))) (* 2.0 (sin (/ th 2.0))))
              a0 (+ (angle (list (car v) (cadr v)) (list (car w) (cadr w))) (- (/ pi 2.0) (/ th 2.0)))
              c (polar (list (car v) (cadr v)) a0 r)
              sa (angle c (list (car v) (cadr v))) k 1)
        (while (< k 8)
          (setq res (cons (polar c (+ sa (* th (/ k 8.0))) (abs r)) res) k (1+ k)))))
    (setq i (1+ i)))
  (reverse res))

;; Sutherland-Hodgman: cat da giac pts theo da giac loi *QSMB-CLIPP*
(defun QSMB-SHin (p a b sg)
  (>= (* sg (- (* (- (car b) (car a)) (- (cadr p) (cadr a))) (* (- (cadr b) (cadr a)) (- (car p) (car a))))) -1.0e-9))

(defun QSMB-SH (pts / cl sg a out s ip)
  (setq cl *QSMB-CLIPP* sg (if (> (QSVS-DienTich cl) 0) 1.0 -1.0) a (last cl))
  (foreach b cl
    (setq out nil)
    (if pts
      (progn
        (setq s (last pts))
        (foreach p pts
          (if (QSMB-SHin p a b sg)
            (progn
              (if (not (QSMB-SHin s a b sg)) (if (setq ip (inters s p a b nil)) (setq out (cons ip out))))
              (setq out (cons p out)))
            (if (QSMB-SHin s a b sg) (if (setq ip (inters s p a b nil)) (setq out (cons ip out)))))
          (setq s p))))
    (setq pts (reverse out) a b))
  pts)

;;; ------------------------------------------------------------ v20.17 trim theo polyline gioi han
(defun QSMB-SHp (pts cl / *QSMB-CLIPP*) (setq *QSMB-CLIPP* cl) (QSMB-SH pts))

;; Canh da giac pts co cat bien gioi han?
(defun QSMB-CatNhau (pts / a b c d hit)
  (setq a (last pts))
  (foreach b pts
    (if (not hit)
      (progn
        (setq c (last *QSMB-CLIPP*))
        (foreach d *QSMB-CLIPP*
          (if (and (not hit) (inters a b c d T)) (setq hit T))
          (setq c d))))
    (setq a b))
  hit)

(defun QSMB-TrongHet (pts)
  (and (vl-every 'QSMB-ClipOK pts) (not (QSMB-CatNhau pts))))

;; Chia da giac (lom) thanh tam giac - cat tai (ear clipping), da giac CCW
(defun QSMB-TamGiac (poly / res n i a b c ok cr dem)
  (if (< (QSVS-DienTich poly) 0.0) (setq poly (reverse poly)))
  (setq dem 0)
  (while (and (> (length poly) 3) (< dem 5000))
    (setq n (length poly) i 0 ok nil)
    (while (and (< i n) (not ok))
      (setq a (nth (rem (+ i n -1) n) poly) b (nth i poly) c (nth (rem (1+ i) n) poly)
            cr (- (* (- (car b) (car a)) (- (cadr c) (cadr a))) (* (- (cadr b) (cadr a)) (- (car c) (car a)))))
      (if (and (> cr 1.0e-9)
               (not (vl-some '(lambda (p) (and (not (equal p a 1.0e-9)) (not (equal p b 1.0e-9)) (not (equal p c 1.0e-9))
                                               (QSVS-Trong p (list a b c))))
                             poly)))
        (setq ok T res (cons (list a b c) res) poly (vl-remove b poly))
        (setq i (1+ i))))
    (if (not ok) (setq res (cons poly res) poly nil))
    (setq dem (1+ dem)))
  (if (= (length poly) 3) (setq res (cons poly res)))
  res)

;; Gop tam giac ke nhau khi ket qua van loi -> manh loi
(defun QSMB-ManhLoi (poly / ps doi p q m i j a b k n pa qa)
  (if (QSMB-Loi poly)
    (list poly)
    (progn
      (setq ps (QSMB-TamGiac poly) doi T)
      (while doi
        (setq doi nil)
        (foreach p ps
          (if (not doi)
            (foreach q ps
              (if (and (not doi) (not (eq p q)))
                (progn
                  (setq n (length p) i 0)
                  (while (and (< i n) (not doi))
                    (setq a (nth i p) b (nth (rem (1+ i) n) p))
                    (if (and (setq k (vl-position b q)) (equal (nth (rem (1+ k) (length q)) q) a 1.0e-9))
                      (progn
                        ;; p quay ve b..a, q quay ve a..b
                        (setq pa (QSMB-Xoay p (rem (1+ i) n)))
                        (setq qa (QSMB-Xoay q (rem (1+ k) (length q))))
                        (setq m (append pa (cdr (reverse (cdr (reverse qa))))))
                        (if (QSMB-Loi m)
                          (setq ps (cons m (vl-remove-if '(lambda (x) (or (eq x p) (eq x q))) ps)) doi T))))
                    (setq i (1+ i)))))))))
      ps)))

;; Bo n phan tu dau danh sach (dung chung cho AutoCAD va ZWCAD)
(defun QSMB-Bo (n l) (repeat n (setq l (cdr l))) l)

;; Xoay danh sach de bat dau tu chi so k
(defun QSMB-Xoay (l k) (append (QSMB-Bo k l) (reverse (QSMB-Bo (- (length l) k) (reverse l)))))

;; Bo diem trung / thang hang (sai lech < 1mm) cua da giac kin
(defun QSMB-DonGian (pts / doi out n i a b c h)
  (setq doi T)
  (while (and doi (> (length pts) 3))
    (setq doi nil n (length pts) i 0 out nil)
    (while (< i n)
      (setq a (nth (rem (+ i n -1) n) pts) b (nth i pts) c (nth (rem (1+ i) n) pts))
      (setq h (if (> (distance a c) 1.0e-6)
                (/ (abs (- (* (- (car c) (car a)) (- (cadr b) (cadr a))) (* (- (cadr c) (cadr a)) (- (car b) (car a)))))
                   (distance a c))
                0.0))
      (if (and (not doi) (or (< (distance a b) 1.0) (< h 1.0)))
        (setq doi T)
        (setq out (cons b out)))
      (setq i (1+ i)))
    (setq pts (reverse out)))
  pts)

;; Cat da giac theo gioi han -> nil (ngoai), (list 'NGUYEN) hoac list cac manh
(defun QSMB-CatVung (pts / res r)
  (cond
    ((null *QSMB-CLIPP*) (list 'NGUYEN))
    ((QSMB-TrongHet pts) (list 'NGUYEN))
    ((null *QSMB-CLIPM*)
     (if (QSMB-ClipOK (QSVS-DiemNhan pts)) (list 'NGUYEN) nil))
    (T
     (foreach m *QSMB-CLIPM*
       (setq r (QSMB-SHp pts m))
       (if (and (> (length r) 2) (> (abs (QSVS-DienTich r)) 1.0e3)) (setq res (cons r res))))
     (QSMB-GopManh res))))

;; Gop lai cac manh cua cung 1 vung dung chung canh (duong chia manh loi)
(defun QSMB-GopManh (ps / doi n i a b k m pa qa)
  (setq ps (mapcar '(lambda (p) (if (< (QSVS-DienTich p) 0.0) (reverse p) p)) ps) doi T)
  (while doi
    (setq doi nil)
    (foreach p ps
      (if (not doi)
        (foreach q ps
          (if (and (not doi) (not (eq p q)))
            (progn
              (setq n (length p) i 0)
              (while (and (< i n) (not doi))
                (setq a (nth i p) b (nth (rem (1+ i) n) p) k 0)
                (while (and (< k (length q)) (not doi))
                  (if (and (< (distance (nth k q) b) 0.5)
                           (< (distance (nth (rem (1+ k) (length q)) q) a) 0.5))
                    (progn
                      (setq pa (QSMB-Xoay p (rem (1+ i) n))
                            qa (QSMB-Xoay q (rem (1+ k) (length q)))
                            m (append pa (cdr (reverse (cdr (reverse qa))))))
                      (setq ps (cons m (vl-remove-if '(lambda (x) (or (eq x p) (eq x q))) ps)) doi T)))
                  (setq k (1+ k)))
                (setq i (1+ i)))))))))
  ps)

;; Lay mau diem tren curve
(defun QSMB-MauCurve (o / n e i k res d L st)
  (setq e (vlax-curve-getEndParam o))
  (if (member (vla-get-ObjectName o) '("AcDbPolyline" "AcDb2dPolyline"))
    (progn
      (setq i 0 n (fix (+ 0.5 e)))
      (while (< i n)
        (setq k 0)
        (while (< k 8)
          (setq res (cons (vlax-curve-getPointAtParam o (+ i (/ k 8.0))) res) k (1+ k)))
        (setq i (1+ i)))
      (setq res (cons (vlax-curve-getPointAtParam o e) res)))
    (progn
      (setq L (vlax-curve-getDistAtParam o e) n 64 i 0)
      (repeat (1+ n)
        (setq res (cons (vlax-curve-getPointAtDist o (* L (/ i (float n)))) res) i (1+ i)))))
  (mapcar '(lambda (p) (list (car p) (cadr p))) (vl-remove nil (reverse res))))

;; 'IN / 'OUT / list cac doan polyline (list diem) nam trong gioi han
(defun QSMB-CatCurve (o / pts in out a res cur d)
  (if (null *QSMB-CLIPP*)
    'IN
    (progn
      (setq pts (vl-catch-all-apply 'QSMB-MauCurve (list o)))
      (if (or (vl-catch-all-error-p pts) (< (length pts) 2))
        'IN
        (progn
          (setq in (vl-every 'QSMB-ClipOK pts) out (not (vl-some 'QSMB-ClipOK pts)))
          (cond
            ((and in (not (QSMB-CatNhauMo pts))) 'IN)
            ((and out (not (QSMB-CatNhauMo pts))) 'OUT)
            (T
             (setq a (car pts) cur nil)
             (foreach b (cdr pts)
               (foreach d (QSMB-ClipSeg a b)
                 (if (and cur (< (distance (last cur) (car d)) 1.0e-6))
                   (setq cur (append cur (list (cadr d))))
                   (progn (if cur (setq res (cons cur res))) (setq cur d))))
               (if (and cur (> (distance (last cur) b) 1.0e-6)) (setq res (cons cur res) cur nil))
               (setq a b))
             (if cur (setq res (cons cur res)))
             (reverse res))))))))

(defun QSMB-CatNhauMo (pts / a hit c)
  (setq a (car pts))
  (foreach b (cdr pts)
    (if (not hit)
      (progn (setq c (last *QSMB-CLIPP*))
             (foreach d *QSMB-CLIPP* (if (and (not hit) (inters a b c d T)) (setq hit T)) (setq c d))))
    (setq a b))
  hit)

(defun QSMB-PlineMo (pts lay key off / ed e)
  (setq ed (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay) '(100 . "AcDbPolyline")
                 (cons 90 (length pts)) '(70 . 0)))
  (foreach p pts (setq ed (append ed (list (list 10 (+ (car p) (car off)) (+ (cadr p) (cadr off)))))))
  (if (setq e (entmakex ed)) (QSMB-Tag e key))
  e)

;;; =====================================================================
;;;  v20.7  SHOPTHEP - BANG DIEU KHIEN TONG CAC LENH CHINH
;;;  Go SHOPTHEP -> chon lenh theo quy trinh: chuan bi -> ve -> gop -> cat
;;;  -> cap nhat / ghi chu. Tick "Mo lai bang" de quay lai sau moi lenh.
;;; =====================================================================

;; (nhom (ma-lenh mo-ta) ...)
(setq *QSH-MENU*
  '(("  1. CHUAN BI BAN VE  "
     ("OS_LAYER"        "Tao bo layer chuan cho cac lenh QS")
     ("OS_CAIDAT"       "Cai dat du an: ty le, neo, bao ve, layer")
     ("OS_VUNGSAN"      "Vung san: chieu day, cao do, huong rai")
     ("OS_MBTK"         "Ve lai MB ket cau tu ban thiet ke"))
    ("  2. VE THEP  "
     ("OS_THEPSAN"      "Tu dong rai thep san, gop V3")
     ("OS_VETHEP"       "Ve thanh thep + tag + duong rai")
     ("OS_VETHEPMAU"    "Ve dong loat theo bo thep mau")
     ("OS_THEPTK"       "Ve theo block thep thiet ke")
     ("OS_GIACUONGLOMO" "Thep gia cuong quanh lo mo san"))
    ("  3. NHOM THEP V3  "
     ("OS_GOPBT3"       "Gop nhieu nhom / thanh le thanh 1 nhom")
     ("OS_KIEMTRABT3"   "Kiem tra lien ket nhom V3")
     ("OS_BUNGBT3"      "Bung / thu cac thanh trong nhom")
     ("OS_CAPNHATBT3"   "Dong bo tag theo thanh da sua"))
    ("  4. CAT THEP  "
     ("OS_CATTHEP"      "Cat / noi thep theo cay (ca nhom V3)")
     ("OS_VUNGCAT"      "Ve ranh vung duoc phep noi thep")
     ("OS_PHUONGANCATBT3" "Xem phuong an cat nhom V3 (khong ve)")
     ("OS_VEXEMCATBT3"  "Ve xem phoi cat V3 o cho khac")
     ("OS_CATBT3"       "Cat nhom V3 bang dong lenh"))
    ("  5. CAP NHAT - GHI CHU  "
     ("OS_CAPNHATTHEP"  "Cap nhat chieu dai / thong so thep")
     ("OS_DIMTHEP"      "Ghi kich thuoc tung doan thep")
     ("OS_CAPNHATRAI"   "Cap nhat so thanh theo duong rai")
     ("OS_RAILIVE"      "Bat / tat tu cap nhat khi keo rai")
     ("OS_NOILAIRAI"    "Noi lai lien ket duong rai - tag")
     ("OS_CANGIUASH"    "Can giua so hieu trong tag"))))

(if (not *QSH-LAP*) (setq *QSH-LAP* "0"))

(defun QSH-DSLenh ( / res g) (foreach g *QSH-MENU* (setq res (append res (cdr g)))) res)

(defun QSH-TaoDCL ( / fn f q tmp g it cot k)
  (setq q (chr 34) tmp (getvar "TEMPPREFIX"))
  (setq fn (vl-filename-mktemp "qsshop" tmp ".dcl"))
  (if (not fn) (setq fn (strcat (if (and tmp (/= tmp "")) tmp "C:\\") "qsshop_tam.dcl")))
  (setq f (open fn "w"))
  (if (not f)
    (progn (princ (strcat "\n[Loi] Khong ghi duoc file tam: " fn)) nil)
    (progn
      (write-line "shopthep : dialog {" f)
      (write-line (strcat "  label = " q "Shop thep san  |  SHOPTHEP - Bang dieu khien thep     (v1.0.0)" q ";") f)
      (write-line (QS-DCL-TX "Bam 1 nut de chay lenh. Thu tu nhom = thu tu lam viec: chuan bi -> ve -> gop -> cat -> cap nhat.") f)
      (write-line "  spacer;" f)
      (write-line "  : row {" f)
      ;; cot trai: nhom 1-3, cot phai: nhom 4-5
      (setq k 0)
      (foreach cot (list (list (nth 0 *QSH-MENU*) (nth 1 *QSH-MENU*) (nth 2 *QSH-MENU*))
                         (list (nth 3 *QSH-MENU*) (nth 4 *QSH-MENU*)))
        (write-line "    : column { alignment = top; fixed_height = true;" f)
        (foreach g cot
          (write-line (QS-DCL-BOX (car g)) f)
          (foreach it (cdr g)
            (write-line "      : row { fixed_width = true;" f)
            (write-line (strcat "        : button { key = " q "b_" (car it) q "; label = " q (car it) q
                                "; width = 22; fixed_width = true; }") f)
            (write-line (strcat "        : text { label = " q (cadr it) q "; width = 40; }") f)
            (write-line "      }" f))
          (write-line "    }" f))
        (write-line "    }" f))
      (write-line "  }" f)
      (write-line "  spacer;" f)
      (write-line "  : row {" f)
      (write-line (strcat "    : toggle { key = " q "lap" q "; label = " q "Mo lai bang nay sau khi chay xong lenh" q "; }") f)
      (write-line (strcat "    : button { key = " q "cancel" q "; label = " q "  Dong  " q "; is_cancel = true; fixed_width = true; }") f)
      (write-line "  }" f)
      (write-line (strcat "  : text { key = " q "shinfo" q "; label = " q " " q "; width = 90; }") f)
      (write-line (strcat "  : text { label = " q "Tac gia: Nguyen Xuan Phat   |   Email: banhbaonxp@gmail.com   |   SDT: 0898010995" q "; alignment = centered; }") f)
      (write-line "}" f)
      (close f)
      fn)))

(defun c:SHOPTHEP ( / *error* fn id lap rc ds it lenh)
  (defun *error* (msg)
    (if (and id (>= id 0)) (unload_dialog id))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[SHOPTHEP] " msg)))
    (princ))
  (setq ds (QSH-DSLenh) lap T)
  (while lap
    (setq lenh nil)
    (if (not (and *QSH-DCL* (findfile *QSH-DCL*))) (setq *QSH-DCL* (QSH-TaoDCL)))
    (setq id (if *QSH-DCL* (load_dialog *QSH-DCL*) -1))
    (if (or (null id) (< id 0) (not (new_dialog "shopthep" id)))
      (progn
        (princ "\n[SHOPTHEP] Khong mo duoc hop thoai. Go truc tiep ten lenh, vd OS_THEPSAN.")
        (setq *QSH-DCL* nil lap nil))
      (progn
        (set_tile "lap" *QSH-LAP*)
        (set_tile "shinfo" (strcat "OS_ShopThepSan v1.0.0  -  " (itoa (length ds)) " lenh."))
        (setq rc 100)
        (foreach it ds
          (setq rc (1+ rc))
          (action_tile (strcat "b_" (car it))
            (strcat "(setq *QSH-LAP* (get_tile \"lap\"))(done_dialog " (itoa rc) ")")))
        (action_tile "cancel" "(setq *QSH-LAP* (get_tile \"lap\"))(done_dialog 0)")
        (setq rc (start_dialog))
        (unload_dialog id) (setq id nil)
        (if (> rc 100) (setq lenh (car (nth (- rc 101) ds))))
        (if lenh
          (progn
            (princ (strcat "\n[SHOPTHEP] -> " lenh))
            (eval (list (read (strcat "c:" lenh))))
            (if (/= *QSH-LAP* "1") (setq lap nil)))
          (setq lap nil)))))
  (princ))

;; Lenh tat ST = SHOPTHEP (lenh LISP uu tien hon alias ST = STYLE trong file PGP)
(defun c:ST () (c:SHOPTHEP))

(princ "\n  SHOPTHEP / ST   - BANG DIEU KHIEN tong cac lenh chinh")

(princ)

;;; =====================================================================
;;;  v1.0.0 - LENH TAT: go ten lenh khong can tien to OS_ (vd THEPSAN = OS_THEPSAN)
;;;  (OS_LAYER khong co lenh tat vi trung lenh LAYER cua AutoCAD / ZWCAD)
;;; =====================================================================
(defun c:BUNGBT3 () (c:OS_BUNGBT3))
(defun c:CAIDAT () (c:OS_CAIDAT))
(defun c:CANGIUASH () (c:OS_CANGIUASH))
(defun c:CAPNHATBT3 () (c:OS_CAPNHATBT3))
(defun c:CAPNHATRAI () (c:OS_CAPNHATRAI))
(defun c:CAPNHATTHEP () (c:OS_CAPNHATTHEP))
(defun c:CATBT3 () (c:OS_CATBT3))
(defun c:CATTHEP () (c:OS_CATTHEP))
(defun c:DIMTHEP () (c:OS_DIMTHEP))
(defun c:GIACUONGLOMO () (c:OS_GIACUONGLOMO))
(defun c:GOPBT3 () (c:OS_GOPBT3))
(defun c:KIEMTRABT3 () (c:OS_KIEMTRABT3))
(defun c:MBTK () (c:OS_MBTK))
(defun c:NOILAIRAI () (c:OS_NOILAIRAI))
(defun c:PHUONGANCATBT3 () (c:OS_PHUONGANCATBT3))
(defun c:RAILIVE () (c:OS_RAILIVE))
(defun c:THEPSAN () (c:OS_THEPSAN))
(defun c:THEPTK () (c:OS_THEPTK))
(defun c:VETHEP () (c:OS_VETHEP))
(defun c:VETHEPDCE () (c:OS_VETHEPDCE))
(defun c:VETHEPMAU () (c:OS_VETHEPMAU))
(defun c:VEXEMCATBT3 () (c:OS_VEXEMCATBT3))
(defun c:VUNGCAT () (c:OS_VUNGCAT))
(defun c:VUNGSAN () (c:OS_VUNGSAN))
(princ "\n  Lenh tat: go ten lenh KHONG can OS_ (vd THEPSAN, CATTHEP, VETHEP, VUNGSAN, MBTK ...). Rieng OS_LAYER giu nguyen.")
(princ)
