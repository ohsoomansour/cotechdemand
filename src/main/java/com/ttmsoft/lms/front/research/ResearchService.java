package com.ttmsoft.lms.front.research;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ResearchService extends BaseSvc<DataMap>{

	//연구자 검색 기술분류 코드(대분류)
	public List<DataMap> doGetStdMainCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	//연구자 검색 기술분류 코드(중분류)
	public List<DataMap> doGetStdMiddleCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	//연구자 검색 기술분류 카운트
	public int doResearchCountSubCode(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doResearchCountSubCode", paraMap);
	}
	
	//키워드검색 리스트 조회
	public List<DataMap> doGetKeywordList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetKeywordList", paraMap);
		return result;
	}
	
	//키워드검색 카운트
	public int doGetKeywordCount(DataMap paraMap) {
		return this.dao.countQuery("SubjectFrontSQL.doGetKeywordCount", paraMap);
	}
	
	//연구자 상세보기
	public DataMap doViewResearchDetail (DataMap paraMap) {
		return this.dao.selectQuery("SubjectFrontSQL.doViewResearchDetail", paraMap);
	}
	
	//연구자 국가과제 수행 이력
	public List<DataMap> doViewResearchProject(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doViewResearchProject", paraMap);
		return result;
	}
	
	//유사분야 연구자
	public List<DataMap> doSimilarResearchList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doSimilarResearchList", paraMap);
		return result;
	}
	
	//특허리스트
	public List<DataMap> doPatentList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doPatentList", paraMap);
		return result;
	}
}
