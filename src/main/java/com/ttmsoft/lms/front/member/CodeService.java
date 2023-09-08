package com.ttmsoft.lms.front.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CodeService extends BaseSvc<DataMap>{	
	/* ----[기타 SQL]----*/
	/* 기타 -> 구분코드리스트 - 2020/04/28 추정완*/
	public List<DataMap> doListCodePCD(DataMap paraMap) {
		return this.dao.dolistQuery("CodeSQL.doListCodePCD", paraMap);
	}
	/* 기타 -> 코드중복검사 - 2020/04/30 추정완*/
	public int doCheckCodeOverlap(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doCheckCodeOverlap", paraMap);
	}
	
	/* ----[메인코드 SQL]----*/
	/* 메인코드리스트 -> 메인코드카운트 - 2020/04/28 추정완*/
	public int doCountMainCode(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doCountMainCode", paraMap);
	}
	/* 메인코드리스트 -> 메인코드리스트 - 2020/04/28 추정완*/
	public List<DataMap> doListMainCode(DataMap paraMap) {
		return this.dao.dolistQuery("CodeSQL.doListMainCode", paraMap);
	}
	/* 메인코드리스트 -> 메인코드등록 - 2020/04/28 추정완*/
	public int doInsertMainCode(DataMap paraMap) {
		return this.dao.insertQuery("CodeSQL.doInsertMainCode", paraMap);
	}
	/* 메인코드수정 -> 메인코드 정보가져오기 - 2020/04/28 추정완*/
	public DataMap doGetMainCodeInfo(DataMap paraMap) {
		return this.dao.selectQuery("CodeSQL.doGetMainCodeInfo", paraMap);
	}
	/* 메인코드수정 -> 메인코드수정 - 2020/04/28 추정완*/
	public int doUpdateMainCode(DataMap paraMap) {
		return this.dao.updateQuery("CodeSQL.doUpdateMainCode", paraMap);
	}
	/* 메인코드수정 -> 메인코드에 관련된 서브코드 리스트 - 2020/04/28 추정완*/
	public List<DataMap> doListMainCodeOfSubCode(DataMap paraMap) {
		return this.dao.dolistQuery("CodeSQL.doListMainCodeOfSubCode", paraMap);
	}
	/* 메인코드수정 -> 메인코드에 관련된 서브코드 수정 - 2020/04/28 추정완*/
	public int doUpdateMainCodeOfSubCode(DataMap paraMap) {
		return this.dao.updateQuery("CodeSQL.doUpdateMainCodeOfSubCode", paraMap);
	}
	/* 메인코드삭제 -> 메인코드 삭제 - 2020/05/01 추정완*/
	public void doDeleteMainCode(DataMap paraMap) {
		this.dao.deleteQuery("CodeSQL.doDeleteMainCode", paraMap);
	}
	
	/* ----[서브코드 SQL]----*/
	/* 서브코드리스트 -> 서브코드카운트 - 2020/04/28 추정완*/
	public int doCountSubCode(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doCountSubCode", paraMap);
	}
	/* 서브코드리스트 -> 서브코드리스트 - 2020/04/28 추정완*/
	public List<DataMap> doListSubCode(DataMap paraMap) {
		return this.dao.dolistQuery("CodeSQL.doListSubCode", paraMap);
	}
	
	/* -------  이버드 가이드 신청 여부 확인 - 2023/09/01 오수만  ------------ */
	public List<DataMap> doListGuideRegistInfo(DataMap paraMap) {
		return this.dao.dolistQuery("CodeSQL.doListGuideRegistInfo", paraMap);
	}
	

	/* 서브코드리스트 -> 코드 인덱스 최댓값 가져오기 - 2020/04/29 추정완*/
	public int doMaxCodeIdx(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doMaxCodeIdx", paraMap);
	}
	/* 서브코드리스트 -> 서브코드 등록 - 2020/04/29 추정완*/
	public int doInsertSubCode(DataMap paraMap) {
		return this.dao.insertQuery("CodeSQL.doInsertSubCode", paraMap);
	}
	/* 서브코드수정 -> 서브코드 정보 가져오기 - 2020/04/30 추정완*/
	public DataMap doGetSubCodeInfo(DataMap paraMap) {
		return this.dao.selectQuery("CodeSQL.doGetSubCodeInfo", paraMap);
	}
	/* 서브코드수정 -> commcd_gcd로 메인코드 가져오기 - 2020/07/10 추정완*/
	public DataMap doGetMainCodeInfoOfCG(DataMap paraMap) {
		return this.dao.selectQuery("CodeSQL.doGetMainCodeInfoOfCG", paraMap);
	}
	/* 서브코드수정 -> 서브코드 수정 - 2020/04/29 추정완*/
	public int doUpdateSubCode(DataMap paraMap) {
		return this.dao.updateQuery("CodeSQL.doUpdateSubCode", paraMap);
	}
	/* 서브코드삭제 -> 서브코드 삭제 - 2020/05/01 추정완*/
	public void doDeleteSubCode(DataMap paraMap) {
		DataMap subCodeInfo = doGetSubCodeInfo(paraMap);
		paraMap.put("commcd_idx", subCodeInfo.get("commcd_idx"));
		this.dao.updateQuery("CodeSQL.doUpdateSubCodeIdx", paraMap);
		this.dao.deleteQuery("CodeSQL.doDeleteSubCode", paraMap);
	}
}
