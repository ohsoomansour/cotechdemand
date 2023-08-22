package com.ttmsoft.lms.admin.site;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class BoardItemService extends BaseSvc<DataMap> {
	//게시판 (TB_BOARD_MNG)
	//게시판 목록 조회 (2020.03 조예찬)
	public List<DataMap> dolistBoard (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.dolistBoard", paraMap);
	}
	
	//게시판 단일조회 (2020.03 조예찬)
	public DataMap doGetMngBoard (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetMngBoard", paraMap);
	}
	
	//카테고리 (TB_BOARD_CTGR)
	//게시판 카테고리 추가 (2020.03 조예찬)
	public void doAddBoardCtgr (DataMap paraMap) {
		this.dao.insertQuery("BoardSQL.doAddBoardCtgr", paraMap);
	}
	
	//게시판 카테고리 목록 조회 (2020.03 조예찬)
	public List<DataMap> doListBoardCtgr (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.doListBoardCtgr", paraMap);
	}
	public List<DataMap> dolistBoardCtgr (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.dolistBoardCtgr", paraMap);
	}	
	
	//게시물 (TB_BOARD_ITEM)
	//게시물 갯수 (2020.03 조예찬)
	public int doCountBoardItem (DataMap paraMap) {
		return this.dao.countQuery("BoardSQL.doCountBoardItem", paraMap);
	}
	
	//게시물 목록 조회 (2020.03 조예찬)
	public List<DataMap> doListBoardItem (DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListBoardItem", paraMap);
	}
	
	//게시물 추가 (2020.03 조예찬)
	public void doAddBoardItem (DataMap paraMap) {		
		this.dao.insertQuery("BoardSQL.doAddBoardItem", paraMap);
		
		if(!("").equals(paraMap.get("files"))) { //files가 존재하면 파일 업로드
			this.dao.insertQuery("BoardSQL.doAddBoardAttach", paraMap);
		}
	}
	
	//게시물 단일 조회 (2020.03 조예찬)
	public DataMap doGetBoardItem (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBoardItem", paraMap);
	}
	
	//게시물 수정 (2020.03 조예찬)
	public void doUpdateBoardItem (DataMap paraMap) {		
		this.dao.updateQuery("BoardSQL.doUpdateBoardItem", paraMap);
		
		if(!("").equals(paraMap.get("files"))) { //files가 존재하면 파일 업로드
			this.dao.insertQuery("BoardSQL.doAddBoardAttach", paraMap);
		}
	}
	
	//게시물 삭제 (2020.03 조예찬)
	public void doDeleteBoardItem (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doDeleteBoardItem", paraMap);
	}			
	
	//파일목록 조회 (2020.03 조예찬)
	public List<DataMap> doListBoardAttach(DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListBoardAttach", paraMap);
	}
	
	//파일 단일 조회 (2020.03 조예찬)
	public DataMap doGetBoardAttach(DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBoardAttach", paraMap);
	}
	
	//파일 삭제 (2020.03 조예찬)
	public void doDeleteBoardAttach(DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoardAttach", paraMap);
	}
	
	//[통합게시물]
	//게시물 관리 게시판 게시물 갯수 (2020.03 조예찬)
	public int doCountBoardItemMng (DataMap paraMap) {
		return this.dao.countQuery("BoardSQL.doCountBoardItemMng", paraMap);
	}
	
	//게시물 관리 게시판 게시물 목록 조회 (2020.03 조예찬)
	public List<DataMap> doListBoardItemMng (DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListBoardItemMng", paraMap);
	}
	
	//게시물 상태 다중 수정 (2020.03 조예찬)
	public void doUpdateBoardItemState (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doUpdateBoardItemState", paraMap);
	}
}
