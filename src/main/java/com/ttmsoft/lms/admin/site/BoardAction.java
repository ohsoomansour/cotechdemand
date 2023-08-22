package com.ttmsoft.lms.admin.site;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

/**
 * 
 * @Package	 : com.ttmsoft.lms.cmm.site
 * @File	 : BoardAction.java
 *
 * @Author   : ycjo
 * @Date	 : 2020. 3. 19.
 * @Explain  : 게시판 관리
 *
 */
@Controller
@RequestMapping ("/admin")
public class BoardAction extends BaseAct {

	@Autowired
	private BoardService	boardService;
	
	@Autowired
	private SeqService	seqService;

	@Value ("${siteid}")
	private String			siteid;	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 관리 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/board.do", method = RequestMethod.GET)
	public ModelAndView dolistBoard (@ModelAttribute ("paraMap") DataMap paraMap) {	
		
		ModelAndView mav = new ModelAndView("/lms/admin/site/board/listBoard.admin");
		mav.addObject("paraMap", paraMap);			
	 	
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 관리 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/board.do", method = RequestMethod.POST)
	public ModelAndView dolistBoard (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");		
		mav.addObject("siteid", siteid);
		mav.addObject("paraMap", paraMap);		
		
		try {
	
		 	int totalCount = this.boardService.doCountBoard(paraMap);
			int totalPage  = (totalCount -1)/(10) + 1;	
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",  totalPage);
			// 현재 페이지
			mav.addObject("page",   1);
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",   this.boardService.dolistBoard(paraMap));
			// --------------------------------------------------------------------------		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 19. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 등록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addBoard.do", method = RequestMethod.GET)
	public ModelAndView doAddBoardForm(@ModelAttribute ("paraMap") DataMap paraMap) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/site/board/addBoard.adminPopup");	
		paraMap.put("seq_tblnm", "TB_BOARD_MNG");
		mav.addObject("paraMap", paraMap);
		
		return mav;
	}	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 20. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addBoard.do", method = RequestMethod.POST)
	public ModelAndView doAddBoard(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		String board_seq =  String.valueOf(seqService.doAddAndGetSeq(paraMap));
		ModelAndView mav = new ModelAndView("jsonView");	
		paraMap.put("userid", request.getSession().getAttribute("userid"));		
		paraMap.put("siteid", siteid);
		paraMap.put("board_seq", board_seq);

		System.out.println(paraMap.toString());
		
		//INT NULL CHECK
		if(paraMap.get("board_opt") == "") {
			paraMap.put("board_opt", 0);
		}
		
		if(paraMap.get("attf_maxcnt") == "") {
			paraMap.put("attf_maxcnt", 0);
		}
		
		if(paraMap.get("attf_maxsize") == ""){
			paraMap.put("attf_maxsize", 0);
		}
		
		try {
			this.boardService.doAddBoard(paraMap);	
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 20. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 수정 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateBoard.do", method = RequestMethod.GET)
	public ModelAndView doUpdateBoardForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/site/board/updateBoard.adminPopup");
		mav.addObject("paraMap", paraMap);
		
		try {
			DataMap Map = this.boardService.doGetMngBoard(paraMap);						
			mav.addObject("data", Map);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	

		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 20. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateBoard.do", method = RequestMethod.POST)
	public ModelAndView doUpdateBoard(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		System.out.println("paraMap : " + paraMap.toString());
		
		ModelAndView mav = new ModelAndView("jsonView");	
		paraMap.put("userid", request.getSession().getAttribute("userid"));	
		
		try {
			this.boardService.doUpdateBoard(paraMap);	
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 5. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping (path = "/deleteBoard.do", method = RequestMethod.GET)
	public ModelAndView doDeleteBoard(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");	
		paraMap.put("userid", request.getSession().getAttribute("userid"));			
		
		try {
			this.boardService.doDeleteBoarddownBoardItem(paraMap); //게시판 관련 하위 게시물 삭제
			this.boardService.doDeleteBoarddownCtgr(paraMap); //게시판 관련 하위 카테고리 삭제
			this.boardService.doDeleteBoard(paraMap); //게시판 삭제
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 23. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 카테고리 등록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addBoardCtgr.do", method = RequestMethod.GET)
	public ModelAndView doAddBoardCtgrForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/site/board/addBoardCategory.adminPopup");			
		mav.addObject("paraMap", paraMap);
		
		try {
			mav.addObject("category", this.boardService.doListBoardCtgr(paraMap));		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 23. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 카테고리 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addBoardCtgr.do", method = RequestMethod.POST)
	public ModelAndView doAddBoardCtgr(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		String userId = (String) request.getSession().getAttribute("userid");
		paraMap.put("siteid", siteid);
		paraMap.put("userId", userId);		
		
		try {		
			if(request.getParameterValues("ctgrnm") != null) { //등록
			paraMap.put("seq_tblnm", "TB_BOARD_CTGR");
			ArrayList<DataMap> list = new ArrayList<DataMap>();
			
			String[] ctgrnm = request.getParameterValues("ctgrnm");

			String boardSeq = paraMap.getstr("board_seq");
		
			int length = ctgrnm.length;
			
			for(int i = 0; i < length; ++i) {				
				
				DataMap data = new DataMap();

				data.put("ctgr_seq", seqService.doAddAndGetSeq(paraMap));
				data.put("ctgrnm", ctgrnm[i]);
				data.put("board_seq", boardSeq);				
				
				list.add(data);			
			}
			paraMap.put("list", list);
			
			this.boardService.doAddBoardCtgr(paraMap);	
			}
			
			if(request.getParameterValues("ctgr_seqs") != null) { //수정
				ArrayList<DataMap> lists = new ArrayList<DataMap>();
				
				String[] ctgr_seqs = request.getParameterValues("ctgr_seqs");
				String[] ctgrnms = request.getParameterValues("ctgrnms");		
				int lengths = ctgr_seqs.length;
				
				for(int i = 0; i < lengths; ++i) {				
					
					DataMap datas = new DataMap();
					datas.put("ctgr_seqs", ctgr_seqs[i]);
					datas.put("ctgrnms", ctgrnms[i]);				
					
					lists.add(datas);
					
				}
				paraMap.put("lists", lists);

				this.boardService.doUpdateBoardCtgr(paraMap);			
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}
	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 25. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시판 카테고리 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping (path = "/deleteBoardCtgr.do", method = RequestMethod.GET)
	public ModelAndView doDeleteBoardCtgr(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");	
		try {
			this.boardService.doDeleteBoardCtgr(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}		
}


