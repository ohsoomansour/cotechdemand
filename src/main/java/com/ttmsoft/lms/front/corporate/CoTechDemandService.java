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
	public DataMap doGetTLOSeqno(DataMap dataMap) {
		return this.dao.selectQuery("CoTechDemandSQL.getTLOSeqNo", dataMap);
	}
	/* 마이페이지 기업 카운트 - 2023/09/24*/
	public int doCountCorporates(DataMap paraMap) {
		int result = this.dao.countQuery("CoTechDemandSQL.doCountCorporates", paraMap);
		return result;
	}
	/* 기업수요 등록 - 2023/09/26 */
	public int doInsertCoTechDemand(DataMap dataMap) {
		System.out.println("등록 파라미터:" + dataMap);
		return this.dao.insertQuery("CoTechDemandSQL.registTechDemandCo", dataMap);
	}
	
	/* 마이페이지 기업 기술분류 목록 - 2023/09/22 */
	public List<DataMap> doGetCodeListInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CoTechDemandSQL.doGetCodeListInfo", paraMap);
		return result;
	}
	
	/* 마이페이지 기업입장, 기술수요 목록 - 2023/09/26 */
	public List<DataMap> doGetCoTechDemandInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CoTechDemandSQL.doGetCoTechDemandInfo", paraMap);
		return result;
	}
	
	public List<DataMap> doAutoSearchKeyword(DataMap paraMap) {
		return this.dao.dolistQuery("CoTechDemandSQL.doAutoSearchKeyword", paraMap);
	}
}
