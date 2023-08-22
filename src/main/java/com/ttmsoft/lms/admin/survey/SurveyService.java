package com.ttmsoft.lms.admin.survey;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class SurveyService extends BaseSvc<DataMap> {
	//설문 문항(TE_EVAL_QUE)
	//설문문항 갯수 (2020.05 조예찬)
	public int doCountSurveyQue (DataMap paraMap) {
		return this.dao.countQuery("SurveySQL.doCountSurveyQue", paraMap);
	}
	
	//설문문항 단일조회 (2020.05 조예찬)
	public DataMap doGetSurveyQue (DataMap paraMap) {
		return this.dao.selectQuery("SurveySQL.doGetSurveyQue", paraMap);
	}
	
	//설문문항 갯수 (2020.05 조예찬)
	public List<DataMap> dolistSurveyQue (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListSurveyQue", paraMap);
	}
	
	//설문항목 추가 (2020.05 조예찬)
	public int doAddSurveyQue (DataMap paraMap) {
		return this.dao.insertQuery("SurveySQL.addSurveyQue", paraMap);
	}
	
	//설문항목 수정 (2020.05 조예찬)
	public int doUpdateSurveyQue (DataMap paraMap) {
		return this.dao.updateQuery("SurveySQL.doUpdateSurveyQue", paraMap);
	}
	
	//설문항목 삭제 (2020.05 조예찬)
	public int doDeleteSurveyQue (DataMap paraMap) {
		return this.dao.deleteQuery("SurveySQL.doDeleteSurveyQue", paraMap);
	}
	
	//설문문항 항목(TE_EVAL_QUEITEM)
	//출제된 문제의 주관식 항목 목록 조회 (2020.05 조예찬)
	public List<DataMap> doListSubjective (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListSubjective", paraMap);
	}
	
	//출제된 문제의 객관식 항목 목록 조회 (2020.05 조예찬)
	public List<DataMap> doListMultipleChoice (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListMultipleChoice", paraMap);
	}
	
	//설문 항목 첫번째 idx 조회 (2020.05 조예찬)
	public DataMap doGetMaxQueItemIdx (DataMap paraMap) {
		return this.dao.selectQuery("SurveySQL.doGetMaxQueItemIdx", paraMap);
	}
	
	//설문문항 항목 단일조회 (2020.05 조예찬)
	public DataMap doGetSurveyQueItem (DataMap paraMap) {
		return this.dao.selectQuery("SurveySQL.doGetOneSurveyQueitem", paraMap);
	}	
	
	//설문문항 항목 목록조회 (2020.05 조예찬)	
	public List<DataMap> doListSurveyQueItem (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListSurveyQueitem", paraMap);
	}
	
	//설문문항 항목 갯수 (2020.05 조예찬)
	public int doCountSurveyQueItem (DataMap paraMap) {
		return this.dao.countQuery("SurveySQL.doCountSurveyQueitem", paraMap);
	}
	
	//설문문항 항목 추가 (2020.05 조예찬)
	public int doAddSurveyQueItem (DataMap paraMap) {
		return this.dao.insertQuery("SurveySQL.doAddSurveyQueitem", paraMap);
	}
	
	//설문문항 항목 수정 (2020.05 조예찬)
	public int doUpdateSurveyQueItem (DataMap paraMap) {
		return this.dao.updateQuery("SurveySQL.doUpdateSurveyQueitem", paraMap);
	}
	
	//설문문항 항목 삭제 (2020.05 조예찬)
	public int doDeleteSurveyQueItem (DataMap paraMap) {
		return this.dao.deleteQuery("SurveySQL.deleteSurveyQueitem", paraMap);
	}
	
	//설문지 (TE_EVAL_PAPER)
	//설문지 단일조회 (2020.05 조예찬)
	public DataMap doGetSurveyPaper (DataMap paraMap) {
		return this.dao.selectQuery("SurveySQL.doGetSurveyPaper", paraMap);
	}
	
	//설문지 갯수 (2020.05 조예찬)	
	public int doCountSurveyPaper (DataMap paraMap) {
		return this.dao.countQuery("SurveySQL.doCountSurveyPaper", paraMap);
	}
	
	//설문지 목록조회 (2020.05 조예찬)
	public List<DataMap> doListSurveyPaper (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListSurveyPaper", paraMap);
	}
	//설문지 등록 (2020.05 조예찬)
	public int doAddSurveyPaper (DataMap paraMap) {
		return this.dao.insertQuery("SurveySQL.doAddSurveyPaper", paraMap);
	}
	
	//설문지 수정 (2020.05 조예찬)
	public int doUpdateSurveyPaper (DataMap paraMap) {
		return this.dao.updateQuery("SurveySQL.doUpdateSurveyPaper", paraMap);
	}
	
	//설문지 삭제 (2020.05 조예찬)
	public int doDeleteSurveyPaper (DataMap paraMap) {
		return this.dao.deleteQuery("SurveySQL.doDeleteSurveyPaper", paraMap);
	}
	
	//설문지 문제 출제 (TE_EVAL_SET)	
	//특정 시험지에 출제되어있는 문제 번호 목록 조회 (2020.06 조예찬)
	public List<DataMap> doListSurveySetQueSeq (DataMap paraMap) {
		return this.dao.dolistQuery("SurveySQL.doListSurveySetQueSeq", paraMap);
	}
	//설문지 문제 출제 등록 (2020.06 조예찬)
	public int doAddSurveySet (DataMap paraMap) {
		return this.dao.insertQuery("SurveySQL.doAddSurveySet", paraMap);
	}
	
	//설문지 문제 출제 수정 (2020.06 조예찬)
	public int doUpdateSurveySet (DataMap paraMap) {
		return this.dao.updateQuery("SurveySQL.doUpdateSurveySet", paraMap);
	}
	
	//설문지 문제 출제 삭제 (2020.06 조예찬)
	public int doDeleteSurveySet (DataMap paraMap) {
		return this.dao.deleteQuery("SurveySQL.doDeleteSurveySet", paraMap);
	}
	
	//특정 설문지 문제 출제 조회 (2020.06 조예찬)
	public List<DataMap> doGetSurveySet (DataMap paraMap) {
		return this.dao.dolistQuery("SurveySQL.doGetSurveySet", paraMap);
	}
	
	//설문지 문제출제 목록 조회(주관식) (2020.06 조예찬)
	public List<DataMap> doListSurveySetQueS (DataMap paraMap) {
		return this.dao.dolistQuery("SurveySQL.doListSurveySetQueS", paraMap);
	}
	
	//설문지 문제출제 목록 조회(객관식) (2020.06 조예찬)
	public List<DataMap> doListSurveySetQueO (DataMap paraMap) {
		return this.dao.dolistQuery("SurveySQL.doListSurveySetQueO", paraMap);
	}
	
	//설문지 구분별 문제 목록 조회 (2020.06 조예찬)
	public List<DataMap> dolistSetSurveyQue (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.dolistSetSurveyQue", paraMap);
	}
	
	//설문지 구분별 문제 갯수 (2020.06 조예찬)
	public int doCountSetSurveyQue (DataMap paraMap) {
		return this.dao.countQuery("SurveySQL.doCountSetSurveyQue", paraMap);
	}
	
	//설문조사평가 계획 (TE_EVAL_MNG)
	//평가 계획 갯수 (2020.06 조예찬)
	public int doCountSurveyMng (DataMap paraMap) {
		return this.dao.countQuery("SurveySQL.doCountSurveyMng", paraMap);
	}
	
	//평가 계획 단일 조회 (2020.06 조예찬)
	public DataMap doGetSurveyMng (DataMap paraMap) {
		return this.dao.selectQuery("SurveySQL.doGetSurveyMng", paraMap);
	}
	
	//평가 계획 목록 조회 (2020.06 조예찬)
	public List<DataMap> dolistSurveyMng (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListSurveyMng", paraMap);
	}
	
	//평가 계획 등록 (2020.06 조예찬)	
	public int doAddSurveyMng (DataMap paraMap) {
		return this.dao.insertQuery("SurveySQL.doAddSurveyMng", paraMap);
	}
	
	//평가 계획 수정 (2020.06 조예찬)
	public int doUpdateSurveyMng (DataMap paraMap) {
		return this.dao.updateQuery("SurveySQL.doUpdateSurveyMng", paraMap);
	}
	
	//평가 계획 삭제 (2020.06 조예찬)
	public int doDeleteSurveyMng (DataMap paraMap) {
		return this.dao.deleteQuery("SurveySQL.doDeleteSurveyMng", paraMap);
	}
	
	//설문조사내역 (TE_EVAL_APPLOG)
	//설문조사 목록 조회 (2020.06 조예찬)
	public List<DataMap> doListApplog (DataMap paraMap){
		return this.dao.dolistQuery("SurveySQL.doListApplog", paraMap);
	}
	
	//설문조사 참여 내역 (TE_EVAL_APPLY)
	//설문조사 참여 내역 갯수 (2021.04 조예찬)
	public DataMap doGetSurveyApplyCnt (DataMap paraMap){
		return this.dao.selectQuery("SurveySQL.doGetSurveyApplyCnt", paraMap);
	}			
}
