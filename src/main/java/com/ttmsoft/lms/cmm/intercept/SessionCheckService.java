package com.ttmsoft.lms.cmm.intercept;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class SessionCheckService extends BaseSvc<DataMap> {

	/**
	 * 세션 정보 조회
	 *
	 * @param dataMap
	 * @return
	 */
	public DataMap getoneSessionInfo (DataMap dataMap) {
		return this.dao.selectQuery("SessionCheckSql.getoneSessionInfo", dataMap);
	}

	public DataMap getoneSessionByKey (DataMap dataMap) {
		return this.dao.selectQuery("SessionCheckSql.getoneSessionByKey", dataMap);
	}

	/**
	 * 세션 정보 삭제
	 *
	 * @param dataMap
	 */
	public void removeSessionInfo (DataMap dataMap) {
		this.dao.updateQuery("SessionCheckSql.removeSessionInfo", dataMap);
		this.dao.deleteQuery("SessionCheckSql.removeInvalidSession", dataMap);
	}

	/**
	 * 1. 현재세션 시간 갱신
	 * 2. 하루 이상 남아있는 데이터 삭제
	 *
	 * @param dataMap
	 */
	public void modifySessionTime (DataMap dataMap) {
		this.dao.updateQuery("SessionCheckSql.modifySessionTime", dataMap);
		this.dao.deleteQuery("SessionCheckSql.removeInvalidSession", dataMap);
	}


	/**
	 * 1. 같은 유저의 다른 세션 아이디 레코드가 있을 경우 비활성화
	 * 2. 로그인 한 사람의 세션 정보를 세션 테이블에 인서트
	 *
	 * @param dataMap
	 */
	public void appendUserSession (DataMap dataMap) {
		this.dao.updateQuery("SessionCheckSql.modifyUserSessionDisabled", dataMap);
		this.dao.insertQuery("SessionCheckSql.appendUserSession", dataMap);
	}

}
