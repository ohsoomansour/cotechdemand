package com.ttmsoft.lms.admin.site;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileUtil;

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
public class BoarditemAction extends BaseAct {

	@Autowired
	private BoardItemService boardItemService;
	
	@Autowired
	private SeqService	seqService;

	@Value ("${siteid}")
	private String			siteid;	
	
	/**
	 *
	 * @throws Exception 
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 에디터 이미지 업로드
	 * @Explain  : 
	 *
	 */	
	@ResponseBody	
	@RequestMapping(value = "/uploadEditorImg", method = RequestMethod.POST)
	public ResponseEntity doUploadImg(HttpServletRequest req, HttpServletResponse resp, MultipartHttpServletRequest multiFile) throws Exception {
		ResponseEntity result = null;
		
		try {
			FileUtil.uploadEditorImg(req, resp, multiFile);	
			
			
			result = ResponseEntity.ok().body("");
		} catch (Exception e) {
			//e.printStackTrace();
			
			result = ResponseEntity.badRequest().body(e.getMessage());
		}
		
		return result;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 24.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 관리 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/boardItem.do", method = RequestMethod.GET)
	public ModelAndView doBoardItemMngForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/site/boarditem/listBoardItem.admin");
		mav.addObject("paraMap", paraMap);
	
		try {
			mav.addObject("data", this.boardItemService.dolistBoard(paraMap));
		} catch (Exception e) {
			e.printStackTrace(); 
			return new ModelAndView("error");
		}		
	 	
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 27.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 관리 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/boardItem.do", method = RequestMethod.POST)
	public ModelAndView doBoardItemMng (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
	
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("paraMap", paraMap);		
		mav.addObject("siteid", siteid);		
		
		System.out.println("FINAL : " + paraMap.toString());
		
		try {		
		 	int totalCount = this.boardItemService.doCountBoardItemMng(paraMap);
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
			mav.addObject("rows",   this.boardItemService.doListBoardItemMng(paraMap));		
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
	 * @Date	 : 2020. 4. 27. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 상태 변경(Y -> N)
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateBoardItemState.do", method = RequestMethod.POST)
	public ModelAndView doUpdateBoardItemState(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();		
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {			
			ArrayList<DataMap> list = new ArrayList<DataMap>();
			
			String[] bitem_seq = (String[]) paraMap.get("bitem_seq");
			String useYn = (String)paraMap.get("useyn");		
			int length = bitem_seq.length;
			
			for(int i = 0; i < length; ++i) {								
				DataMap data = new DataMap();
				data.put("bitem_seq", bitem_seq[i]);
				data.put("useyn", useYn);							
				list.add(data);			
			}
			
			paraMap.put("list", list);		
			this.boardItemService.doUpdateBoardItemState(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 등록폼(게시물 관리 게시판)
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addBoardItem.do", method = RequestMethod.GET)
	public ModelAndView doaddBoardItemForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("/lms/admin/site/boarditem/addBoardItem.adminPopup");
		mav.addObject("paraMap", paraMap);			
		try {
			mav.addObject("data", this.boardItemService.dolistBoard(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	 	
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 등록폼(ajax 데이터 사용)
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/getBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doGetBoardItem (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("paraMap", paraMap);			
		try {
			//카테고리
			mav.addObject("ctgr", this.boardItemService.doListBoardCtgr(paraMap));
			//게시판
			mav.addObject("board", this.boardItemService.doGetMngBoard(paraMap));		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	 	
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 26. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 등록(게시물 관리 게시판)
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/addBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doaddBoardItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("jsonView");			
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		paraMap.put("seq_tblnm", "TB_BOARD_ITEM");	
		paraMap.put("siteid", siteid);
				
		try {		
			
			paraMap.put("bitem_seq", this.seqService.doAddAndGetSeq(paraMap));	
			
			DataMap map = this.boardItemService.doGetMngBoard(paraMap);
			String attach_yn = (String) map.get("attach_yn");

			if(("Y").equals(attach_yn)) {
				paraMap.put("seq_tblnm", "TB_BOARD_ATTACH");
				
				if(!("").equals(paraMap.get("attachments")) && null != paraMap.get("attachments")) {
					
					List<MultipartFile> multipartFiles = (List<MultipartFile>)paraMap.get("attachments"); //첨부 된 파일
					List<DataMap> files = new ArrayList<DataMap>();

					int attfSeq = 0;
					int fileCnt = multipartFiles.size();			
					String somePath = "view/board/" + paraMap.get("board_seq");
					
					for(int i = 0; i < fileCnt; i++) {
						attfSeq = seqService.doAddAndGetSeq(paraMap);
						DataMap file = FileUtil.fileUpload(multipartFiles.get(i), request, somePath);
						file.put("attf_seq", attfSeq);
						files.add(file);
					}
					
					if(files.size() > 0) {
						paraMap.put("files", files);
					}
				}				
			}
			this.boardItemService.doAddBoardItem(paraMap); //게시물 등록
			
		} catch (Exception e) {
			e.printStackTrace();  
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 28. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 수정 폼(게시물 관리 게시판)
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateBoardItem.do", method = RequestMethod.GET)
	public ModelAndView doupdateBoardItemForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("/lms/admin/site/boarditem/updateBoardItem.adminPopup");	
		paraMap.put("siteid", siteid);
		mav.addObject("paraMap", paraMap);	
		
		try {
			// 데이터
			mav.addObject("data", this.boardItemService.doGetBoardItem(paraMap));
			// 게시판
			mav.addObject("board", this.boardItemService.doGetMngBoard(paraMap));
			// 카테고리
			mav.addObject("ctgr", this.boardItemService.doListBoardCtgr(paraMap));	
			// 첨부파일
			mav.addObject("file", this.boardItemService.doListBoardAttach(paraMap));	
		} catch (Exception e) {
			e.printStackTrace();  
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 28. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 수정(게시물 관리 게시판)
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doupdateBoardItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		paraMap.put("siteid", siteid);

		try {

			DataMap map = this.boardItemService.doGetMngBoard(paraMap);
			String attach_yn = (String) map.get("attach_yn");
			
			if(("Y").equals(attach_yn)) {		
				paraMap.put("seq_tblnm", "TB_BOARD_ATTACH");
				
				if(!("").equals(paraMap.get("attachments")) && null != paraMap.get("attachments")) {
					
					List<MultipartFile> multipartFiles = (List<MultipartFile>)paraMap.get("attachments"); //첨부 된 파일
					List<DataMap> files = new ArrayList<DataMap>();

					int attfSeq = 0;
					int fileCnt = multipartFiles.size();			
					String somePath = "board/" + paraMap.get("board_seq");
					
					for(int i = 0; i < fileCnt; i++) {
						attfSeq = seqService.doAddAndGetSeq(paraMap);
						DataMap file = FileUtil.fileUpload(multipartFiles.get(i), request, somePath);
						file.put("attf_seq", attfSeq);
						files.add(file);
					}
					
					if(files.size() > 0) {
						paraMap.put("files", files);
					}
				}		
			}

			this.boardItemService.doUpdateBoardItem(paraMap);
		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		

		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 파일 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping (path = "/deleteBoardAttach.do", method = RequestMethod.POST)
	public ModelAndView deleteBoardAttach(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");
		//mav.setViewName("redirect:/admin/updateBoardItem.do?bitem_seq=" + paraMap.get("bitem_seq") + "&board_seq=" + paraMap.get("board_seq"));
		paraMap.put("siteid", siteid);		
		
		try {		
			DataMap fileInfo = this.boardItemService.doGetBoardAttach(paraMap);
			String real_name = (String) fileInfo.get("real_name"); //파일 저장 이름
			String file_path = (String) fileInfo.get("file_path"); //파일 저장 경로		

			this.boardItemService.doDeleteBoardAttach(paraMap);
			FileUtil.removeFile(request, file_path+"/"+real_name);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
}


