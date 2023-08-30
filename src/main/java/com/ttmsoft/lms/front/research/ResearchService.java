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

	/*public List<DataMap> doListCheck(DataMap paraMap) {
		System.out.print("paraMap:"+paraMap);
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.testttttt", paraMap);
		
		return result;
	}*/
	
	public List<DataMap> doGetStdMainCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	public List<DataMap> doGetStdMiddleCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	public int doResearchCountSubCode(DataMap paraMap) {
		return this.dao.countQuery("CodeSQL.doResearchCountSubCode", paraMap);
	}
	
	public List<DataMap> doGetKeywordList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetKeywordList", paraMap);
		return result;
	}
	
	public int doGetKeywordCount(DataMap paraMap) {
		return this.dao.countQuery("SubjectFrontSQL.doGetKeywordCount", paraMap);
	}
}
