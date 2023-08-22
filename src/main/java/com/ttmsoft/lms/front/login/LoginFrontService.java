package com.ttmsoft.lms.front.login;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class LoginFrontService extends BaseSvc<DataMap>{
	/* 로그인 -> 사용자 있는지 체크 - 추정완 2021/04/26 */	
	public int doCountUserInfo(DataMap paraMap) {
		return this.dao.countQuery("Login_v_SQL.doCountUserInfo", paraMap);
	}
	/* 로그인 -> 아이디 틀린지 파악 - 추정완 2021/04/26 */	
	public int doCountId(DataMap paraMap) {
		return this.dao.countQuery("Login_v_SQL.doCountId", paraMap);
	}
	/* 로그인 -> 로그인 성공 시 해당 사용자 정보 가져오기 - 추정완 2021/04/26 */
	public DataMap doGetOneUserInfo(DataMap paraMap) {
		return this.dao.selectQuery("Login_v_SQL.doGetOneUserInfo", paraMap);
	}
	/* 로그인 -> 로그인 성공 시 비밀번호 오류 횟수 초기화 - 추정완 2021/04/26 */
	public void doUpdateInvalidCountReset(DataMap paraMap) {
		this.dao.updateQuery("Login_v_SQL.doUpdateInvalidCountReset", paraMap);
	}
	/* 로그인 -> 아이디 찾기 - 추정완 2021/04/26 */
	public DataMap doFindId(DataMap paraMap) {
		return this.dao.selectQuery("Login_v_SQL.doFindId", paraMap);
	}
	/* 로그인 -> 비밀번호 찾기 - 추정완 2021/04/26 */
	public DataMap doFindPw(DataMap paraMap) {
		return this.dao.selectQuery("Login_v_SQL.doFindPw", paraMap);
	}
	/* 로그인 -> 비밀번호 찾기 성공하면 해당 아이디에 임시비밀번호 저장 - 추정완 2021/04/26 */
	public void doUpdateTempPw(DataMap paraMap) {
		this.dao.updateQuery("Login_v_SQL.doUpdateTempPw", paraMap);
	}
	/* 로그인 -> 비밀번호 오류 시 비밀번호 오류 횟수 +1 증가 - 추정완 2021/04/26 */
	public void doUpdatePwInvalid(DataMap paraMap) {
		this.dao.updateQuery("Login_v_SQL.doUpdatePwInvalid", paraMap);
	}
	/* 로그인 -> 비밀번호 오류 횟수 정보 가져오기 - 추정완 2021/04/26 */
	public int doGetPwInvalid(DataMap paraMap) {
		return this.dao.countQuery("Login_v_SQL.doGetPwInvalid", paraMap);
	}
}
