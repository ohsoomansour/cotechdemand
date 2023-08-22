package com.ttmsoft.lms.front.boarditem;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class BoardItemFrontService extends BaseSvc<DataMap> {
	//통합게시판
	//게시판 (TB_BOARD_MNG)	
	//게시판 목록조회 (2020.03 조예찬)
	public List<DataMap> dolistBoard (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.dolistBoard", paraMap);
	}
	
	//게시판 목록 단일조회 (2020.03 조예찬)	
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
		this.dao.updateQuery("BoardSQL.doUpdateBoard", paraMap);
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
	
//	//게시판 카테고리 추가 (2020.03 조예찬) - BackUp
//	public List<DataMap> dolistBoardCtgr (DataMap paraMap) {
//		return this.dao.dolistQuery("BoardSQL.dolistBoardCtgr", paraMap);
//	}	
	
	//게시판 카테고리 삭제 (2020.03 조예찬)
	public void doDeleteBoardCtgr (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.deleteBoardCtgr", paraMap);
	}
	
	//게시판 카테고리 수정 (2020.03 조예찬)	
	public void doUpdateBoardCtgr (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doUpdateBoardCtgr", paraMap);
	}	
	
	//게시물 (TB_BOARD_ITEM)
	//게시물 갯수 (2020.04 조예찬)
	public int doCountBoardItem (DataMap paraMap) {
		return this.dao.countQuery("BoardSQL.doCountBoardItem", paraMap);
	}
	
	//공지사항 목록 (2021.07 조예찬)	
	public List<DataMap> doListNotice (DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListNotice", paraMap);
	}	
	
	//게시물 목록 (2020.04 조예찬)	
	public List<DataMap> doListBoardItem (DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListBoardItem", paraMap);
	}
	
	//게시물 다음글 조회 (2020.04 조예찬)
	public DataMap doGetNextBoardItem (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetNextBoardItem", paraMap);
	}
	
	//게시물 이전글 조회 (2020.04 조예찬)
	public DataMap doGetBeforeBoardItem (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBeforeBoardItem", paraMap);
	}
	
	//게시물 등록 (2020.04 조예찬)
	public int doAddBoardItem (DataMap paraMap) {		
		int result = this.dao.insertQuery("BoardSQL.doAddBoardItem", paraMap);
		return result;
		
		/*if(!("").equals(paraMap.get("files"))) {
			//첨부파일 등록 (2020.04 조예찬)
			this.dao.insertQuery("BoardSQL.doAddBoardAttach", paraMap);
		}*/
	}
	
	//게시물 상세보기 (2020.04 조예찬)
	public DataMap doViewBoardItem (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doViewBoardItem", paraMap);
	}
	
	//게시물 단일조회 (2020.04 조예찬)
	public DataMap doGetBoardItem (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBoardItem", paraMap);
	}
	
	//게시물 조회수 증가(2020.04 조예찬)
	public void doAddBoardViewCnt (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doAddBoardViewCnt", paraMap);
	}
	
	//게시물 수정 (2020.04 조예찬)
	public int doUpdateBoardItem (DataMap paraMap) {	
		int result = this.dao.updateQuery("BoardSQL.doUpdateBoardItem", paraMap);
		
		if(!("").equals(paraMap.get("files"))) {
			//첨부파일 등록 (2020.04 조예찬)
			this.dao.insertQuery("BoardSQL.doAddBoardAttach", paraMap);
		}	
		return result;
	}
	
	//게시물 삭제 (2020.04 조예찬)
	public int doDeleteBoardItem (DataMap paraMap) {
		int result = this.dao.updateQuery("BoardSQL.doDeleteBoardItem", paraMap);
		return result;
	}
		
	//댓글 (TB_BOARD_CMMT)
	//댓글 목록 (2020.04 조예찬)
	public DataMap doListBoardCmmt (DataMap paraMap){
		return this.dao.selectQuery("BoardSQL.doListBoardCmmt", paraMap);
	}
	
	//댓글 등록 (2020.04 조예찬)	
	public void doAddBoardCmmt (DataMap paraMap) {
		this.dao.insertQuery("BoardSQL.doAddBoardCmmt", paraMap);
	}
	
	//댓글 수정 (2020.04 조예찬)
	public void doUpdateBoardCmmt (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doUpdateBoardCmmt", paraMap);
	}
	
	//댓글 삭제 (2020.04 조예찬)
	public void doDeleteBoardCmmt (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoardCmmt", paraMap);
	}
	
	//댓글 전체 삭제 (2020.04 조예찬)
	public void doDeleteBoardCmmtAll (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoardCmmtAll", paraMap);
	}	
	
	//첨부파일 (TB_BOARD_ATTACH)
	//첨부파일 목록 조회 (2020.04 조예찬)
	public List<DataMap> doListBoardAttach(DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.doListBoardAttach", paraMap);
	}
	
	//첨부파일 단일 조회 (2020.04 조예찬)	
	public DataMap doGetBoardAttach(DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBoardAttach", paraMap);
	}
	
	//첨부파일 삭제 (2020.04 조예찬)
	public void doDeleteBoardAttach(DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doDeleteBoardAttach", paraMap);
	}
	
	//추천 (TB_BOARD_RECOM)
	//게시물 추천 단일조회 (2020.04 조예찬)
	public DataMap doGetBoardRecom (DataMap paraMap) {
		return this.dao.selectQuery("BoardSQL.doGetBoardRecom", paraMap);
	}
	
	//게시물 추천 (2020.04 조예찬)	
	public void doAddBoardRecom (DataMap paraMap) {
		this.dao.insertQuery("BoardSQL.doAddBoardRecom", paraMap);
	}
	
	//게시물 추천 취소(2020.04 조예찬)
	public void doCancleBoardRecom (DataMap paraMap) {
		this.dao.deleteQuery("BoardSQL.doCancleBoardRecom", paraMap);
	}
	
	//[통합게시물]
	public List<DataMap> dolistBoardItem (DataMap paraMap){
		return this.dao.dolistQuery("BoardSQL.dolistBoardItem", paraMap);
	}
	
	public void doUpdateBoardItemState (DataMap paraMap) {
		this.dao.updateQuery("BoardSQL.doUpdateBoardItemState", paraMap);
	}
	
	public List<DataMap> doListMainNotice (DataMap paraMap) {
		return this.dao.dolistQuery("BoardSQL.doListMainNotice", paraMap);
	}
}
