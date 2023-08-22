package com.ttmsoft.lms.admin.member;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

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
	private SeqService	seqService;
	
	/* 사용자카운트 - 2020/03/19 추정완*/
	public int doCountMember(DataMap paraMap) {
		return this.dao.countQuery("MemberSQL.doCountMember", paraMap);
	}
	/* 사용자리스트 - 2020/03/19 추정완 */
	public List<DataMap> doListMember(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListMember", paraMap);
	}
	/* 권한조회리스트 - 2020/03/26 추정완*/
	public List<DataMap> doListAuthLookUp(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListAuthLookUp", paraMap);
	}
	/* 권한종류리스트 - 2020/03/26 추정완*/
	public List<DataMap> doListAuthKinds(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListAuthKinds", paraMap);
	}
	/* 멤버권한들가져오기 - 2020/03/27 추정완*/
	public List<DataMap> doListMemberAuth(DataMap paraMap) {
		return this.dao.dolistQuery("MemberSQL.doListMemberAuth", paraMap);
	}
	/* 멤버수정 -> 사용자정보 가져오기 - 2020/04/16 추정완*/
	public DataMap doGetMemberInfo(DataMap paraMap) { 
		return this.dao.selectQuery("MemberSQL.doGetMemberInfo", paraMap);
	}	
	/* 멤버수정 -> 멤버권한선택삽입 - 2020/04/16 추정완*/
	public void doInsertAuthAll(DataMap paraMap) {
		this.dao.insertQuery("MemberSQL.doInsertAuthAll",paraMap);
	}	
	/* 멤버수정 -> 멤버권한변경 - 2020/04/16 추정완*/
	public void doUpdateMemberAuth(DataMap paraMap) throws Exception{
		paraMap.put("seq_tblnm", "TU_USER_ROLE");
		this.dao.updateQuery("MemberSQL.doUpdateAllMemberAuth", paraMap);								//사용자 권한의 사용여부 N으로 초기화
		DataMap memberInfo = doGetMemberInfo(paraMap);													//사용자 정보
		List<DataMap> checkAuthList = this.dao.dolistQuery("MemberSQL.doListCodeInfo", paraMap);		//사용자가 선택한 권한 리스트 정보들
		List<DataMap> getAuthList = this.dao.dolistQuery("MemberSQL.doGetMemberAuthInfo", paraMap);		//사용자가 가지고 있는 권한 리스트 정보들
		List<DataMap> list = new ArrayList<DataMap>();

		//권한을 가지고 있는데 체크를 함
		List<DataMap> checkList = new ArrayList<DataMap>();
		for(int i = 0; i < getAuthList.size(); i++) {
			for(int j = 0; j < checkAuthList.size(); j++) {
				if(getAuthList.get(i).get("role_pcd").equals(checkAuthList.get(j).get("commcd"))) {
					System.out.println("test : " + getAuthList.get(i));
					DataMap data = new DataMap();
					data.put("userrole_seq", getAuthList.get(i).get("userrole_seq"));
					System.out.println(data);
					checkList.add(data);
				}
			}
		}
		if(checkList.size() > 0) {
			paraMap.put("list", checkList);
			this.dao.updateQuery("MemberSQL.doUpdateCheckAuth", paraMap);
		}
		
		//체크한 권한을 가지고 있지 않는 상태
		for(int i = 0; i < getAuthList.size(); i++) {
			for(int j = 0; j < checkAuthList.size(); j++) {
				if(checkAuthList.get(j).get("commcd").equals(getAuthList.get(i).get("role_pcd"))) {
					checkAuthList.remove(j);
				}
			}
		}
		System.out.println(checkAuthList);
		if(checkAuthList.size() > 0) {
			for(int i = 0; i < checkAuthList.size(); i++) {
				DataMap data = new DataMap();
				data.put("userrole_seq", seqService.doAddAndGetSeq(paraMap));
				data.put("roleuid", memberInfo.get("userid"));
				data.put("role_pcd", checkAuthList.get(i).get("commcd"));
				list.add(data);
			}
			paraMap.put("list", list);
			doInsertAuthAll(paraMap);
		}
	}
	/* 멤버 포인트 조회 가운트 - 2020/04/22 박인정*/
	public int doCountPointLookUp(DataMap paraMap) {
		return this.dao.countQuery("MemberSQL.doCountPointLookUp",paraMap);
	}
	/* 멤버 포인트 조회 리스트 - 2020/04/21 박인정 */
	public List<DataMap> doListPointLookUp(DataMap paraMap){
		return this.dao.dolistQuery("MemberSQL.doListPointLookUp", paraMap);
	}	
	/* 멤버 포인트 내역 추가- 2020/04/29 박인정 */
	public void doInsertPointLog(DataMap paraMap) {
		this.dao.insertQuery("MemberSQL.doInsertPointLog",paraMap);
	}
	/* 멤버 포인트 변경- 2020/04/29 박인정 */
	public void doAddMemberPoint(DataMap paraMap) {
		this.dao.insertQuery("MemberSQL.doAddMemberPoint",paraMap);
	}
	/* 멤버 포인트 변경- 2020/04/29 박인정 */
	public void doSubtractMemberPoint(DataMap paraMap) {
		this.dao.insertQuery("MemberSQL.doSubtractMemberPoint",paraMap);
	}
	/* 멤버 포인트 지급- 2020/04/29 박인정 */
	public void doInsertAndUpdateMemberPoint(DataMap paraMap) throws Exception{
		
		String userNo = (String)paraMap.get("userno");
		String[] userNoList = userNo.split(",");
		
		ArrayList<DataMap> list = new ArrayList<DataMap>();
		
		for(int i=0; i < userNoList.length; i++) {
			
			DataMap data= new DataMap();	
			data.put("pointlog_seq", seqService.doAddAndGetSeq(paraMap));
			data.put("userno", userNoList[i]);
			list.add(data);
		}
		paraMap.put("list", list);
		
		String pointPcd = paraMap.getstr("point_pcd");
		
		if(("POINT_P001").equals(pointPcd)){
			doAddMemberPoint(paraMap);
		}else if(("POINT_P002").equals(pointPcd) || ("POINT_P003").equals(pointPcd)){
			doSubtractMemberPoint(paraMap);
		}
		doInsertPointLog(paraMap);
		
	}	
}
