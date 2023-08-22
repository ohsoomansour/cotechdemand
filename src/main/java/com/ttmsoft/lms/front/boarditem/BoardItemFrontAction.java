package com.ttmsoft.lms.front.boarditem;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.projectapply.FileService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileUtil;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

/**
 * 
 * @Package	 : com.ttmsoft.lms.cmm.site
 * @File	 : BoardAction.java
 * 
 * @Author   : ycjo
 * @Date	 : 2020. 3. 19.
 * @Explain  : 사용자 게시판
 *
 */
@Controller
@RequestMapping ("/front")
public class BoardItemFrontAction extends BaseAct {

	@Autowired
	private BoardItemFrontService boardService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private SeqService seqService;

	@Value ("${siteid}")
	private String siteid;			
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 25. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listBoardItem.do",  method = RequestMethod.POST)
	public ModelAndView doListView(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/front/boarditem/listBoardItem.front");
		
		try {
			
			int totalCount = this.boardService.doCountBoardItem(paraMap);
			
			// --------------------------------------------------------------------------
			
			//현재페이지
			String page = StringUtil.nchk((String)(paraMap.get("page")),"1");
			//페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String)(paraMap.get("rows")),"10");
			//게시물 정렬 위치
			String sidx = StringUtil.nchk((String)(paraMap.get("sidx")),"1");
			//게시물 정렬차순
			String sord = StringUtil.nchk((String)(paraMap.get("sord")),"asc");
			//페이지 그룹 수
		
			int pageGroups = 5;
			
			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);
			
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			if(paraMap.get("board_seq").equals("100")) {
				navi.put("two", "공지사항");
			}else if(paraMap.get("board_seq").equals("101")) {
				navi.put("two", "문의게시판");
			}
			mav.addObject("navi",navi);
			mav.addObject("sPageInfo",  new PageInfo().makeIndex(
					Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList"
			));
			
			// 데이터
			mav.addObject("data", this.boardService.doListBoardItem(paraMap));
			// 게시판
			mav.addObject("board", this.boardService.doGetMngBoard(paraMap));
			// 세션 아이디
			mav.addObject("userid", request.getSession().getAttribute("id"));
			
			mav.addObject("paraMap", paraMap);
			System.out.println("뭐나와요"+paraMap);
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
	 * @Date	 : 2020. 3. 26. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 등록 폼
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/addBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doAddBoardItemForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/front/boarditem/addBoardItem.front");	
		mav.addObject("paraMap", paraMap);
		
		try {				
			
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			navi.put("two", "문의게시판");
			mav.addObject("navi",navi);
			// 카테고리
			mav.addObject("ctgr", this.boardService.doListBoardCtgr(paraMap));
			// 게시판
			mav.addObject("board", this.boardService.doGetMngBoard(paraMap));				
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
	 * @Function : 게시물 등록
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/doAddBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doAddBoardItem(@ModelAttribute ("paraMap") DataMap paraMap,HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");
		String userid = "";
		try {
		userid = request.getSession().getAttribute("id").toString();
		}catch(Exception e) {
			if(userid.equals("")) {
				userid="guest";
			}
		}
		
		paraMap.put("userid", userid);
		paraMap.put("seq_tblnm", "TB_BOARD_ITEM");
		paraMap.put("siteid", siteid);
		System.out.println("paraMap : "+ paraMap);
		try {				
			paraMap.put("bitem_seq", this.seqService.doAddAndGetSeq(paraMap));
			int result = this.boardService.doAddBoardItem(paraMap); //게시물 등록
			mav.addObject("result", result);
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
	 * @Function : 게시물 수정 폼
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doUpdateBoardItemForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/front/boarditem/updateBoardItem.front");
		paraMap.put("seq_tblnm", "TB_BOARD_ITEM");		
		paraMap.put("siteid", siteid);
		mav.addObject("paraMap", paraMap);
		
		try {				
			
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			navi.put("two", "문의게시판");
			mav.addObject("navi",navi);
			
			// 데이터
			mav.addObject("data", this.boardService.doGetBoardItem(paraMap));
			// 게시판
			mav.addObject("board", this.boardService.doGetMngBoard(paraMap));
			// 카테고리
			mav.addObject("ctgr", this.boardService.doListBoardCtgr(paraMap));	
			// 첨부파일
			mav.addObject("file", this.boardService.doListBoardAttach(paraMap));
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
	 * @Function : 게시물 수정
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/doUpdateBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doUpdateBoardItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("seq_tblnm", "TB_BOARD_ITEM");
		paraMap.put("siteid", siteid);
		
		try {				
			//paraMap.put("bitem_seq", this.seqService.doAddAndGetSeq(paraMap));
			int result = this.boardService.doUpdateBoardItem(paraMap); //게시물 수정
			mav.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 3. 27. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 게시물 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteBoardItem.do", method = RequestMethod.GET)
	public ModelAndView doDeleteBoardItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		//mav.setViewName("redirect:/front/listBoardItem.do?board_seq=" + paraMap.get("board_seq"));
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("siteid", siteid);

		try {
			int result = this.boardService.doDeleteBoardItem(paraMap);
			mav.addObject("result", result);
			//this.boardService.doDeleteBoardCmmtAll(paraMap); //게시물에 달린 댓글 전부삭제
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
	 * @Function : 게시물 상세 페이지
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/viewBoardItem.do", method = RequestMethod.POST)
	public ModelAndView doViewBoardItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/boarditem/viewBoardItem.front");						
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("siteid", siteid);	
		mav.addObject("paraMap", paraMap);	
		
		try {						
			// 데이터		
			DataMap data = this.boardService.doViewBoardItem(paraMap);
			mav.addObject("data", data);
			String fmst_seqno = data.getstr("fmst_seqno");
			if(!("").equals(fmst_seqno)) {
				paraMap.put("fmst_seq", fmst_seqno);
				List<DataMap> fileList = fileService.getFileListToZip(paraMap);
				mav.addObject("fileList", fileList);
			}
			
			// 게시판
			mav.addObject("board", this.boardService.doGetMngBoard(paraMap));
			// 첨부파일
			//mav.addObject("file", this.boardService.doListBoardAttach(paraMap));
			// 다음글
			//mav.addObject("next", this.boardService.doGetNextBoardItem(paraMap));
			// 이전글
			//mav.addObject("before", this.boardService.doGetBeforeBoardItem(paraMap));
			// 댓글 데이터
			DataMap cmmt = this.boardService.doListBoardCmmt(paraMap);
			mav.addObject("cmmt", cmmt);
			if(cmmt != null) {
				if(!cmmt.getstr("fmst_seqno").equals("")) {
					paraMap.put("fmst_seq", cmmt.getstr("fmst_seqno"));
					List<DataMap> fileList = fileService.getFileListToZip(paraMap);
					mav.addObject("cmmtfileList", fileList);
				}
			}
			
			// 추천
			//mav.addObject("recom", this.boardService.doGetBoardRecom(paraMap));	
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			if(paraMap.get("board_seq").equals("100")) {
				navi.put("two", "공지사항");
			}else if(paraMap.get("board_seq").equals("101")) {
				navi.put("two", "문의게시판");
			}
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		

		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 7. 1. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 조회수 증가
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateViewCnt.do", method = RequestMethod.POST)
	public ModelAndView doUpdateViewCnt(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("userid", request.getSession().getAttribute("id"));
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("siteid", siteid);

		try {
			// 조회수 증가
			this.boardService.doAddBoardViewCnt(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4.20
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 댓글 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listBoardCmmt.do",  method = RequestMethod.GET)
	public ModelAndView doBoardCmmt(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");	
		mav.addObject("cmmt", this.boardService.doListBoardCmmt(paraMap));
		
		try {
		// 데이터
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 20. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 댓글 등록
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/addBoardCmmt.do", method = RequestMethod.POST)
	public ModelAndView doAddBoardCmmt(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");	
		paraMap.put("seq_tblnm", "TB_BOARD_CMMT");
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("siteid", siteid);
			
		try {		
			String cmmt_seq =  String.valueOf(seqService.doAddAndGetSeq(paraMap));
			paraMap.put("cmmt_seq", cmmt_seq);
			this.boardService.doAddBoardCmmt(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 21. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 댓글 수정
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/updateBoardCmmt.do", method = RequestMethod.POST)
	public ModelAndView doUpdateBoardCmmt(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("id"));
		paraMap.put("siteid", siteid);
		
		try {
			this.boardService.doUpdateBoardCmmt(paraMap);
		} catch (Exception e) {
			e.printStackTrace(); 
			return new ModelAndView("error");
		}			
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 21. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 댓글 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping (path = "/deleteBoardCmmt.do", method = RequestMethod.POST)
	public ModelAndView doDeleteBoardCmmt(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);		
		
		try {
			this.boardService.doDeleteBoardCmmt(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}		
	
	/**
	 *
	 * @throws IOException 
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 파일 다운로드
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/downloadBoardAttach.do",  method = RequestMethod.GET)
	public ModelAndView doDownloadBoardAttach(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletResponse response, HttpServletRequest request) throws IOException {
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);	
		
		BufferedInputStream innputStream = null;
		BufferedOutputStream outputStream = null;
		
		try {
			DataMap file = this.boardService.doGetBoardAttach(paraMap);
			
			String file_name = (String) file.get("file_name"); //파일 실제 이름 
			String real_name = (String) file.get("real_name"); //파일 저장 이름
			String file_path = (String) file.get("file_path"); //파일 저장 경로	
			
			response.setContentType("application/octet-stream");
			response.addHeader(
				"Content-Disposition", 
				String.format("Attachment;Filename=\"%s\"", URLEncoder.encode(file_name, "utf-8"))); //한글 깨짐			
			
			ServletContext application = request.getServletContext();
			String file2 = application.getRealPath(file_path+"/"+real_name);
			innputStream = new BufferedInputStream(new FileInputStream(file2));
			outputStream = new BufferedOutputStream(response.getOutputStream());
			
			while (true) {
				int data = innputStream.read();
				
				if (data != -1) { 
					outputStream.write(data);
				} else {
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		} finally {
			
			if(outputStream != null) {
				innputStream.close();
			}
			
			if(outputStream != null) {
				outputStream.close();
			}	
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
	@RequestMapping (path = "/deleteBoardAttach.do", method = RequestMethod.GET)
	public ModelAndView deleteBoardAttach(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);		
		
		try {		
			DataMap fileInfo = this.boardService.doGetBoardAttach(paraMap);
			String real_name = (String) fileInfo.get("real_name"); //파일 저장 이름
			String file_path = (String) fileInfo.get("file_path"); //파일 저장 경로			
			
			this.boardService.doDeleteBoardAttach(paraMap);			
			FileUtil.removeFile(request, file_path+"/"+real_name);
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
	 * @Function : 추천하기
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/addBoardRecom.do", method = RequestMethod.POST)
	public ModelAndView doAddBoardRecom(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		
		ModelAndView mav = new ModelAndView("jsonView");
		String userid = (String) request.getSession().getAttribute("userid");
		String bitem_seq = (String) paraMap.get("bitem_seq");	
		String recom_userkey = userid + "_" + bitem_seq;		
		
		paraMap.put("userid", userid);
		paraMap.put("siteid", siteid);
		paraMap.put("recom_userkey", recom_userkey);
		
		try {
			this.boardService.doAddBoardRecom(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 4. 23. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 추천 취소
	 * @Explain  : 
	 *
	 */
	@RequestMapping (path = "/cancleBoardRecom.do", method = RequestMethod.POST)
	public ModelAndView doCancleBoardRecom(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			this.boardService.doCancleBoardRecom(paraMap);
		} catch (Exception e) {
			e.printStackTrace(); 
			return new ModelAndView("error");
		}	
		
		return mav;
	}		
}


