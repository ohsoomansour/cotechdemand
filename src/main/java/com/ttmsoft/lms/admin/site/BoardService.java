package com.ttmsoft.lms.admin.site;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class BoardService extends BaseSvc<DataMap> {
	//게시판 (TB_BOARD_MNG)
	//게시판 목록 (2020.03 조예찬)
	public List<DataMap> dolistBoard (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.dolistBoard", paraMap);
	}
	
	//게시판 단일 조회 (2020.03 조예찬)
	public DataMap doGetMngBoard (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetMngBoard", paraMap);
	}
	
	//게시판 갯수 (2020.03 조예찬)
	public int doCountBoard (DataMap paraMap) {
		return this.dao.countQuery("BoardSQL.doCountBoard", paraMap);
	}
	
	//게시판 추가 (2020.03 조예찬)
	public void doAddBoard (DataMap paraMap) {
		this.dao.insertQuery("BoardSQL.doAddBoard", paraMap);	
	}
	
	//게시판 수정 (2020.03 조예찬)
	public void doUpdateBoard (DataMap paraMap) {
		System.out.println(paraMap.get("board_opt"));
		this.dao.updateQuery("BoardSQL.doUpdateBoard", paraMap);
	}	
	
	//게시판 삭제 (2020.03 조예찬)
	public void doDeleteBoard (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoard", paraMap);
	}
	
	//게시판 관련 하위 게시물 삭제 (2020.03 조예찬)
	public void doDeleteBoarddownBoardItem (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoarddownBoardItem", paraMap);
	}
	
	//게시판 관련 하위 카테고리 삭제 (2020.03 조예찬)
	public void doDeleteBoarddownCtgr (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoarddownCtgr", paraMap);
	}
	
	//카테고리 (TB_BOARD_CTGR)
	//게시판 카테고리 추가 (2020.03 조예찬)
	public void doAddBoardCtgr (DataMap paraMap) {
		this.dao.insertQuery("BoardSQL.doAddBoardCtgr", paraMap);
	}
	
	//게시판 카테고리 목록 (2020.03 조예찬)
	public List<DataMap> doListBoardCtgr (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.doListBoardCtgr", paraMap);
	}
	public List<DataMap> dolistBoardCtgr (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.dolistBoardCtgr", paraMap);
	}	
	
	//게시판 카테고리 삭제 (2020.03 조예찬)
	public void doDeleteBoardCtgr (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoardCtgr", paraMap);
	}
	
	//게시판 카테고리 수정 (2020.03 조예찬)
	public void doUpdateBoardCtgr (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doUpdateBoardCtgr", paraMap);
	}	
}
