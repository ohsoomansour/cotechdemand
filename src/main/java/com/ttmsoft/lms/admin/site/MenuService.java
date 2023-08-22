package com.ttmsoft.lms.admin.site;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MenuService extends BaseSvc<DataMap>{
	/* 메뉴조회-> 메뉴리스트 - 2020/05/07 추정완*/
	public List<DataMap> doListMenuTree(DataMap paraMap) {
		return this.dao.dolistQuery("MenuSQL.doListMenuTree", paraMap);
	}
	/* 메뉴조회 -> 메뉴구분 리스트 조회 - 2020/05/08 추정완*/
	public List<DataMap> doListMenuPCD(DataMap paraMap) {
		return this.dao.dolistQuery("MenuSQL.doListMenuPCD", paraMap);
	}
	/* 메뉴등록 -> 권한메뉴 테이블 시퀀스 최댓값 가져오기 - 2020/05/09 추정완*/
	public int doGetMaxMenuAuthSeq(DataMap paraMap) {
		return this.dao.countQuery("MenuSQL.doGetMaxMenuAuthSeq", paraMap);
	}
	/* 메뉴등록 -> 권한종류 가져오기 - 2020/05/09 추정완*/
	public List<DataMap> doListAuth(DataMap paraMap) {
		return this.dao.dolistQuery("MenuSQL.doListAuth", paraMap);
	}
	/* 메뉴등록 -> 메인메뉴등록 - 2020/05/07 추정완*/
	public void doInsertMainMenu(DataMap paraMap) {
		this.dao.insertQuery("MenuSQL.doInsertMainMenu", paraMap);
		this.dao.insertQuery("MenuSQL.doInsertMainMenuAuth", paraMap);
	}
	/* 메뉴등록 -> 서브메뉴등록 - 2020/05/07 추정완*/
	public void doInsertSubMenu(DataMap paraMap) {
		this.dao.insertQuery("MenuSQL.doInsertSubMenu", paraMap);
		this.dao.insertQuery("MenuSQL.doInsertSubMenuAuth", paraMap);
		this.dao.insertQuery("MenuSQL.doUpdateMenuState", paraMap);	
	}
	/* 메뉴수정 -> 메뉴정보가져오기 - 2020/05/08 추정완*/
	public DataMap doGetMenuInfo(DataMap paraMap) {
		return this.dao.selectQuery("MenuSQL.doGetMenuInfo", paraMap);
	}
	/* 메뉴수정 -> 메뉴수정 - 2020/05/08 추정완*/
	public void doUpdateMenu(DataMap paraMap) {
		this.dao.updateQuery("MenuSQL.doUpdateMenu", paraMap);
		if(!paraMap.get("menucdList").equals("")) {
			this.dao.updateQuery("MenuSQL.doUpdateChildMenu", paraMap);
		}
	}
	/* 메뉴수정 -> 메뉴삭제 - 2020/05/08 추정완*/
	public void doDeleteMenu(DataMap paraMap) {
		this.dao.deleteQuery("MenuSQL.doDeleteMenu", paraMap);
		this.dao.deleteQuery("MenuSQL.doDeletemenuAuth", paraMap);
	}
	
	public void doUpdateMoveMenu(DataMap paraMap) {
		
		this.dao.updateQuery("MenuSQL.doUpdateMenuLevel", paraMap);
		
		if(("2").equals(paraMap.get("currentLvl"))){
			this.dao.updateQuery("MenuSQL.doUpdateChildMenuLevel", paraMap);
		}
		
		this.dao.updateQuery("MenuSQL.doUpdateMenuIdx", paraMap);
	}
	
}
