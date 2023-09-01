package com.ttmsoft.lms.front.corporate;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CosearchService extends BaseSvc<DataMap>{

	public List<DataMap> doGetStdMainCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	public List<DataMap> doGetCosearchKeywordList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.doGetCosearchKeywordList", paraMap);
		return result;
	}
	
	public int doGetKeywordCount(DataMap paraMap) {
		return this.dao.countQuery("SubjectFrontSQL.doGetKeywordCount", paraMap);
	}
}
