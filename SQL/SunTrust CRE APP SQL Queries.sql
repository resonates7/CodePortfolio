--Need to adjust the where clause �
 
select distinct
-- borrower and colat owner names
aip.invlv_prty_id AS borrower_ip,
aip.invlv_prty_nm AS borrower_name,
/*
FRED - these two columns show up as NULL when I run this report  I suspect this is due to the data not being
populated in this QA instance
*/
cip.invlv_prty_id AS col_owner_ip,
cip.invlv_prty_nm AS col_owner_name,
 
-- identifiers and account nums
b.ultm_par_arnge_id as CRE_LnNbr, c.src_sys_unique_key_txt as Compass_OBG_NO_ITM_NO,
C.COLAT_OWN_SHRT_NM as Comps_Colat_OwNm,
b.src_sys_unique_key_txt as Compass_OBG_NO_OBL_NO, B.FACLT_OBLGR_NM as OBLG_Nm,  c.COLAT_TY_DESC,
/*linkage of obligation to collateral
a.arnge_id = true key for underlying loans
b.core_arnge_dim_id = also a key for loans but mainly to facilitate versioning
RSRC_ITM_ID = true key for collateral
c.colat_dim_id = also a key for collateral but used mostly to facilitate versioning*/
--Collat columns from CDM
B.AMORT_PERD_CD, B.RCRSE_FLG, C.APPRS_VAL_BASIS_TY_CD, C.PSTCD_AREA_CD, C.ORIG_APPRS_AMT,
C.LIEN_POSN_1_NBR, C.LRG_TNNT_TY_DESC, C.SCND_LRG_TNNT_TY_DESC, C.THRD_LRG_TNNT_TY_DESC, CT.GRP_NM,
C.ORIG_OPER_INCM_AMT, C.OPER_STMT_DT, CCA.CURR_NET_OPER_INCM_AMT, C.COLAT_TY_CD, D.COLAT_VAL_AMT,
D.COLAT_VAL_AMT, D.CURR_APPRS_DT, D.CURR_OCCPY_RATIO_TXT, D.NET_OPER_INCM_AMT, E.INT_RSRV_AMT,
--Binding Info
B.HGH_BND_FLG, PT.CRED_FACLT_TY_CD, PT.PROCES_TY_CD,
PT.PROCES_TY_NM, PT.FUTR_TY_CD,
-- metrics
F.bnd_and_reg_expos_amt, D.colat_val_amt
 
 
from CCA_5.FT_COMRCL_REAL_ESTAT_subm_fact as CCA
left join cdm_pd.DT_CORE_ARNGE_DIM AS B
  on b.ultm_par_arnge_id = trim(CCA.LN_NBR)
inner join cdm_pd.FT_ARNGE_TO_COLAT_FACT AS A
  on a.core_arnge_dim_id= b.core_arnge_dim_id
inner join cdm_pd.T_ARNGE_EXPOS_OBLIG_FACT AS F
  on b.core_arnge_dim_id= f.core_arnge_dim_id and B.ARNGE_ID = f.ARNGE_ID
inner join cdm_pd.dt_core_invlv_prty_dim AS AIP
  on f.core_invlv_prty_dim_id = aip.core_invlv_prty_dim_id
left join cdm_pd.dt_core_invlv_prty_dim AS CIP
  on a.colat_core_invlv_prty_dim_id = cip.core_invlv_prty_dim_id
  --AND A.COLAT_INVLV_PRTY_ID = CIP.CORE_INVLV_PRTY_DIM_ID
 
  
inner join cdm_pd.T_ARNGE_EXPOS_FACLT_FACT AS E
  on b.core_arnge_dim_id= e.core_arnge_dim_id and B.ARNGE_ID = e.ARNGE_ID
inner join CDM_PD.DT_AS_WAS_COLAT_TY_HIER_DIM as CT
  on CT.AS_WAS_COLAT_TY_DIM_ID = F.PRI_COLAT_TY_DIM_ID
inner join cdm_pd.DT_PROCES_TY_DIM as PT
  on f.PROCES_TY_DIM_ID = PT.PROCES_TY_DIM_ID
inner join cdm_pd.DT_COLAT_DIM AS C
  on a.colat_dim_id= c.colat_dim_id and a.RSRC_ITM_ID = c.RSRC_ITM_ID
inner join cdm_pd.FT_COLAT_FACT AS D
  on c.colat_dim_id= d.colat_dim_id
 
where f.MTH_RPT_PERD_DIM_ID = 303  and a.MTH_RPT_PERD_DIM_ID = 303
/*and B.ULTM_PAR_ARNGE_ID in (10026966, 10029607, 10034488, 10036254,)*/
and CCA.SUBM_CNTL_DIM_ID = '20150611015956'
--where b.as_was_eff_dt<= '2014-09-01' and b.as_was_end_dt>='2014-09-30'
 
--fetch first 50 rows only
with ur;
 
 
/*exceptions: this query returns collateral records that are different
actual 3Q dimid 20141111013839, 3Q dim id using compass data 20141118034843
You can change the dimid to compare different versions of the data set
*/
 
 
(select
F.LN_NBR,
F.OBLGR_NM,
f.AMORT_TRM,
f.RCRSE_CD,
f.INT_RSRV_AMT,
f.CURR_VAL_AMT,
f.ANCHR_TNNT_NM,
f.VAL_BASIS_CD,
f.CURR_OCCPY_PCT,
f.CURR_NET_OPER_INCM_AMT,
f.NET_OPER_INCM_AMT,
f.LST_NET_OPER_INCM_DT,
f.LOC_CD,
f.VAL_AT_ORIG_AMT,
f.CROSS_COLAT_LN_NBR,
f.PRPTY_SIZ_VAL,
f.LST_VAL_DT,
f.ADD_COLAT_VAL,
f.LIEN_POSN_CD
from CCA_5.FT_COMRCL_REAL_ESTAT_SUBM_FACT as F
where F.SUBM_CNTL_DIM_ID = '20141111013839')
 
except
 
(select
C.LN_NBR,
C.OBLGR_NM,
c.AMORT_TRM,
c.RCRSE_CD,
c.INT_RSRV_AMT,
c.CURR_VAL_AMT,
c.ANCHR_TNNT_NM,
c.VAL_BASIS_CD,
c.CURR_OCCPY_PCT,
c.CURR_NET_OPER_INCM_AMT,
c.NET_OPER_INCM_AMT,
c.LST_NET_OPER_INCM_DT,
c.LOC_CD,
c.VAL_AT_ORIG_AMT,
c.CROSS_COLAT_LN_NBR,
c.PRPTY_SIZ_VAL,
c.LST_VAL_DT,
c.ADD_COLAT_VAL,
c.LIEN_POSN_CD
from CCA_5.FT_COMRCL_REAL_ESTAT_SUBM_FACT as C
where c.SUBM_CNTL_DIM_ID = '20141118034843')
;