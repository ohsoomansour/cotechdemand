package com.ttmsoft.lms.front.member;

import java.util.ArrayList;
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
public class MemberService extends BaseSvc<DataMap>{
	
	@Autowired
	
	/* 사용자카운트 - 2023/08/31 수정중*/
	public int doCountVMember(DataMap paraMap) {
		return this.dao.countQuery("Member_v_SQL.doCountVMember", paraMap);
	}
	
	/* 사용자리스트 - 2023/08/30  osm*/
	public List<DataMap> doListMember(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListMember", paraMap);
	}
	
	/* 가입승인 - 2023/09/03 osm*/
	public int doUpdateAgreement(DataMap paraMap) {
		return this.dao.updateQuery("Member_v_SQL.doUpdateAgreement", paraMap);
	}
	/* 가입승인 확인 - 2023/09/04 osm */
	public DataMap getJoinApprovedFlag(DataMap seqno) {
		return this.dao.selectQuery("Member_v_SQL.getJoinApprovedFlag", seqno);
	}
	
	// -------------------  회원관리 로직: 2023/08/31 수정 -------------------------- 

	public List<DataMap> doGetMemberInfoData(DataMap paraMap) { 
		return this.dao.dolistQuery("Member_v_SQL.GetMembersInfoData", paraMap );
	}
	//--------------------------------------------------------------------------------  
	/* 권한종류리스트 - 2020/03/26 추정완*/
	public List<DataMap> doListAuthKinds(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListAuthKinds", paraMap);
	}
	
		
}
