package com.ttmsoft.lms.front.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MemberFrontService extends BaseSvc<DataMap>{
	
	/* ----[회원가입 SQL]----*/
	/* 회원가입 -> 아이디 중복검사 - 2023/10/03 박성민 */
	public int doCountMemberId(DataMap paraMap) {
		return this.dao.countQuery("Member_v_SQL.doCountMemberId", paraMap);
	}
	/* 회원가입 -> 사업자등록번호 중복검사 - 2023/10/03 박성민 */
	public int doCountBizRegno(DataMap paraMap) {
		return this.dao.countQuery("Member_v_SQL.doCountBizRegno", paraMap);
	}
	/* 회원가입 -> 회원가입 - 2023/10/03 박성민*/
	public void doInsertMember(DataMap paraMap) {
		String userEmail = paraMap.get("user_email1").toString() 
				+ "@" + paraMap.get("user_email2").toString() ;
		String bizEmail = paraMap.getstr("biz_email1").toString()
				+ "@ " + paraMap.getstr("biz_email2").toString();
		
		paraMap.put("user_email", userEmail);
		paraMap.put("biz_email", bizEmail);
		
		System.out.println(paraMap);
		
		this.dao.insertQuery("Member_v_SQL.doInsertMember", paraMap);
	}
	
	/* ----[회원정보관리 SQL]----*/
	/* 회원정보관리 -> 회원 정보 조회 - 2023/09/08 박성민*/
	public DataMap doGetMemberInfo(DataMap paraMap) {
		DataMap result =this.dao.selectQuery("Member_v_SQL.doGetMemberInfo", paraMap);
		if(result.getstr("member_type").equals("R")) {
			result.put("member_type","연구자");
		}else if(result.getstr("member_type").equals("B")) {
			result.put("member_type","기업");
		}
		return  result;
	}
	/* 회원정보관리 -> 비밀번호변경 - 2021/04/22 추정완*/
	public void doUpdatePw(DataMap paraMap) {
		this.dao.updateQuery("Member_v_SQL.doUpdatePw", paraMap);
	}
	/* 회원정보관리 -> 회원정보변경/사업자정보 - 20201/04/22 추정완*/
	public int doUpdateMember(DataMap paraMap) {
		return this.dao.updateQuery("Member_v_SQL.doUpdateMember", paraMap);
	}
	
	public List<DataMap> doGetStdMainCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	public List<DataMap> doGetStdMiddleCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdCodeInfo", paraMap);
		return result;
	}
	
	public List<DataMap> doGetStdSubCodeInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("CodeSQL.doGetStdSubCodeInfo", paraMap);
		return result;
	}
	public int doGetRndBizno(DataMap paraMap) {
		int result = 0;
		result = this.dao.countQuery("RndSQL.countRndBizno", paraMap);
		return result;
	}
	
	public DataMap doMemberBiz(DataMap paraMap) {
		return this.dao.selectQuery("Member_v_SQL.doMemberBiz", paraMap);
	}
	
	public List<DataMap> doAutoSearchBusiness(DataMap paraMap) {
		
		return this.dao.dolistQuery("Member_v_SQL.doAutoSearchBusiness", paraMap);
	}
	/* 아이디찾기 -> 아이디찾기카운트 2023/09/21/박성민 */
	public int doCountFindMemberId(DataMap paraMap) {
		return this.dao.countQuery("Member_v_SQL.doCountFindId", paraMap);
	}
	
	/* 아이디찾기 -> 아이디찾기 2023/09/21/박성민 */
	public DataMap doFindMemberId(DataMap paraMap) {
		return this.dao.selectQuery("Member_v_SQL.doFindId", paraMap);
	}
	/* 비밀번호찾기 -> 비밀번호찾기카운트 2023/09/21/박성민 */
	public int doCountFindMemberPwd(DataMap paraMap) {
		return this.dao.countQuery("Member_v_SQL.doCountFindPwd", paraMap);
	}
	/* 비밀번호찾기 -> 비밀번호찾기 2023/09/21/박성민 */
	public DataMap doFindMemberPwd(DataMap paraMap) {
		return this.dao.selectQuery("Member_v_SQL.doFindPwd", paraMap);
	}
	/* 비밀번호변경 -> 비밀번호변경 2023/09/22/박성민 */
	public int doChangePwd(DataMap paraMap) {
		return this.dao.updateQuery("Member_v_SQL.doUpdatePw", paraMap);
	}
	/* 비밀번호변경 -> 비밀번호변경 2023/09/22/박성민 */
	public int doChangePwdFind(DataMap paraMap) {
		return this.dao.updateQuery("Member_v_SQL.doUpdatePwFind", paraMap);
	}
	/* 인증번호생성 -> 비밀번호변경 2023/09/22/박성민 */
	public int doSetCertification(DataMap paraMap) {
		return this.dao.updateQuery("Member_v_SQL.doUpdateCertification", paraMap);
	}
	public DataMap doGetCertification(DataMap paraMap) {
		return this.dao.selectQuery("Member_v_SQL.doCheckCertification", paraMap);
	}
}
