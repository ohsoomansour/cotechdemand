package com.ttmsoft.lms.admin.member;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class AuthService extends BaseSvc<DataMap>{
	/* 권한카운트 - 2020/03/23 추정완*/
	public int doCountAuth(DataMap paraMap) {
		return this.dao.countQuery("AuthSQL.doCountAuth", paraMap);
	}
	/* 권한리스트 - 2020/03/23 추정완*/
	public List<DataMap> doListAuth(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListAuth", paraMap);
	}
	/* 권한조회리스트 - 2020/03/26 추정완*/
	public List<DataMap> doListLookUpAuth(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListLookUpAuth", paraMap);
	}
	/* 코드명 중복체크 - 2020/04/21 추정완*/
	public int doCheckCodeOverlap(DataMap paraMap) {
		return this.dao.countQuery("AuthSQL.doCheckCodeOverlap", paraMap);
	}
	/* 권한등록하기 - 2020/04/21 추정완*/
	public void doInsertAuth(DataMap paraMap) {
		this.dao.insertQuery("AuthSQL.doInsertAuth", paraMap);
		this.dao.insertQuery("AuthSQL.doInsertAuthMenuList", paraMap);
	}
	/* 권한등록하기 -> 메뉴전체데이터 가져오기 - 2020/04/24 추정완*/
	public List<DataMap> doListMenuAllData(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListMenuAllData", paraMap);
	}
	/* 권한삭제하기 -> 삭제할 권한 사용자 존재유무 - 2020/04/28 추정완*/
	public int doCountAuthOfMemberAuth(DataMap paraMap) {
		return this.dao.countQuery("AuthSQL.doCountAuthOfMemberAuth", paraMap);
	}
	/* 권한삭제하기 -> 권한삭제하기 - 2020/04/21 추정완*/
	public void doDeleteAuth(DataMap paraMap) {
		this.dao.deleteQuery("AuthSQL.doDeleteAuth", paraMap);
		this.dao.deleteQuery("AuthSQL.doDeleteAuthMenu", paraMap);
	}
	/* 권한정보가져오기 - 2020/04/21 추정완*/
	public DataMap doGetAuthInfo(DataMap paraMap) {
		return this.dao.selectQuery("AuthSQL.doGetAuthInfo", paraMap);
	}
	/* 권한정보수정하기 - 2020/04/21 추정완*/
	public void doUpdateAuth(DataMap paraMap) {
		this.dao.updateQuery("AuthSQL.doUpdateAuth", paraMap);
		this.dao.updateQuery("AuthSQL.doUpdateMenuAuth", paraMap);
	}
	/* 권한메뉴 -> 메뉴리스트 - 2020/03/25 추정완*/
	public List<DataMap> doListAuthTree(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListAuthTree", paraMap);
	}
	/* 권한메뉴 -> 권한에 따른 메뉴 정보 리스트 가져오기 - 2020/04/22 추정완*/
	public List<DataMap> doListMenuAuth(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListMenuAuth", paraMap);
	}
	/* 권한메뉴 -> 메뉴 시퀀스 최댓값 찾기 - 2020/04/22 추정완*/
	public int doGetMaxMenuSeq(DataMap paraMap) {
		return this.dao.countQuery("AuthSQL.doGetMaxMenuSeq", paraMap);
	}
	/* 권한메뉴 -> 메뉴 체크/미체크 저장 - 2020/04/22 추정완*/
	public void doUpdateMenu(DataMap paraMap) {
		this.dao.updateQuery("AuthSQL.doResetMenuAll", paraMap);
	
		if(!("").equals(paraMap.get("list"))) {
			this.dao.updateQuery("AuthSQL.doUpdateMenu", paraMap);
		}
	}
	/* 권한메뉴 -> 메뉴 체크 제외 값들 - 2020/04/25 추정완*/
	public List<DataMap> doMenuCheckExp(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doMenuCheckExp", paraMap);
	}
	/* 권한메뉴 -> 메뉴 미체크 저장 - 2020/04/22 추정완*/
	public void doUpdateMenuN(DataMap paraMap) {
		this.dao.updateQuery("AuthSQL.doUpdateMenuN", paraMap);
	}
	/* 권한메뉴 -> 메뉴 체크 값 없을 시 저장 - 2020/04/26 추정완*/
	public void doUpdateMenuNAll(DataMap paraMap) {
		this.dao.updateQuery("AuthSQL.doUpdateMenuNAll", paraMap);
	}
	/* 권한메뉴 -> 자식노드로 부모노드 데이터 가져오기 - 2020/04/24 추정완*/
	public List<DataMap> doListNodeParent(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListNodeParent", paraMap);
	}
	/* 권한메뉴 -> 각 노드 데이터 가져오기 - 2020/05/07 추정완*/
	public DataMap doGetMenu(DataMap paraMap) {
		return this.dao.selectQuery("AuthSQL.doGetMenu", paraMap);
	}
	/* 권한메뉴 -> 부모노드로 자식노드 데이터 가져오기 - 2020/04/24 추정완*/
	public List<DataMap> doListNodeChild(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListNodeChild", paraMap);
	}
	/* 권한메뉴 -> 모든 노드 데이터 가져오기 - 2020/04/25 추정완*/
	public List<DataMap> doListNodeAll(DataMap paraMap) {
		return this.dao.dolistQuery("AuthSQL.doListNodeAll", paraMap);
	}
}
