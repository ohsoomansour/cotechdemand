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

	//기업수요 검색 기술분류 코드(대분류)
	public List<DataMap> doGetStdMainCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	//기업수요 검색 기술분류 코드(중분류)
	public List<DataMap> doGetStdMiddleCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	//기업수요 검색 기술분류 카운트
	public int doResearchCountSubCode(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doResearchCountSubCode", paraMap);
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
