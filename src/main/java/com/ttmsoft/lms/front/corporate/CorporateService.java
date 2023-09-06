package com.ttmsoft.lms.front.corporate;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CorporateService extends BaseSvc<DataMap>{

	//기업수요 검색 기술분류 코드
	public List<DataMap> doCorprateCountSubCode(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doResearchCountSubCode", paraMap);
		return result;
	}
	
	//기술분야 검색 기업수요 목록
	public List<DataMap> doGetCorporateList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doCorprateCountSubCode", paraMap);
		return result;
	}
	
	//키워드검색 리스트 조회
	public List<DataMap> doGetCorporateKeywordList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetCorporateKeywordList", paraMap);
		return result;
	}
	
	//키워드검색 카운트
	public int doGetKeywordCount(DataMap paraMap) {
		return this.dao.countQuery("SubjectFrontSQL.doGetKeywordCount", paraMap);
	}
	
	//기업수요 상세보기
	public DataMap doViewCorporateDetail (DataMap paraMap) {
		return this.dao.selectQuery("SubjectFrontSQL.doViewCorporateDetail", paraMap);
	}
	
}
