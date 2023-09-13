package com.ttmsoft.lms.front.match;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MatchSearchService extends BaseSvc<DataMap> {
	
	
	//매칭된 기업수요 목록
	public List<DataMap> doGetMatchRList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetMatchRList", paraMap);
		return result;
	}
	
	//매칭된 연구자 목록
	public List<DataMap> doGetMatchBList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetMatchBList", paraMap);
		return result;
	}
	
	//매칭된 연구자-기업수요 목록
	public List<DataMap> doGetMatchTLOList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetMatchTLOList", paraMap);
		return result;
	}
	
	//매칭 이력보기
	public List<DataMap> doGetHistoryList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetHistoryList", paraMap);
		return result;
	}
}

