package com.ttmsoft.lms.admin.member;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class ConnectionLogService extends BaseSvc<DataMap>{
	/* 이용로그 카운트 - 2020/03/26 박인정 */
	public int doCountConnectionLog(DataMap paraMap) {
		return this.dao.countQuery("ConnectionLogSQL.doCountConnectionLog",paraMap);
	}	
	/* 이용로그 리스트 - 2020/03/24 박인정 */
	public List<DataMap> doListConnectionLog(DataMap paraMap){
		return this.dao.dolistQuery("ConnectionLogSQL.doListConnectionLog", paraMap);
	}
	/* 이용로그 코드 - 2020/05/11 박인정 */
	public List<DataMap> doListConnectionLogCode(DataMap paraMap){
		return this.dao.dolistQuery("ConnectionLogSQL.doListConnectionLogCode", paraMap);
	}

}
