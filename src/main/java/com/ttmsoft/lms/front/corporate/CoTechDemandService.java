package com.ttmsoft.lms.front.corporate;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CoTechDemandService extends BaseSvc<DataMap>{
	public int doInsertCoTechDemand(DataMap dataMap) {
		return this.dao.insertQuery("CoTechDemandSQL.registTechDemandCo", dataMap);
	}
	
	
	public List<DataMap> doAutoSearchKeyword(DataMap paraMap) {
		return this.dao.dolistQuery("CoTechDemandSQL.doAutoSearchKeyword", paraMap);
	}
}
