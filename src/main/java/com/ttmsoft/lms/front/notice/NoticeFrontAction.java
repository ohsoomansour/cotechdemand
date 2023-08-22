package com.ttmsoft.lms.front.notice;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.projectapply.FileService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping ("/front")
public class NoticeFrontAction extends BaseAct{

	@Autowired
	private NoticeFrontService noticeService;
	
	@Autowired
	private SeqService seqService;
	
	@Autowired
	private FileService fileService;
	
	@Value ("${siteid}")
	private String siteid;	
	
	@RequestMapping (value="/noticeList.do", method = RequestMethod.GET)
	public ModelAndView doListView(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/lms/front/notice/noticeList.front");
		paraMap.put("member_seqno", session.getAttribute("member_seqno").toString());
		try {
			int totalCount = this.noticeService.doCountNotice(paraMap);
			
			//현재페이지
			String page = StringUtil.nchk((String)(paraMap.get("page")),"1");
			//페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String)(paraMap.get("rows")),"10");
			//게시물 정렬 위치
			String sidx = StringUtil.nchk((String)(paraMap.get("sidx")),"1");
			//게시물 정렬차순
			//String sord = StringUtil.nchk((String)(paraMap.get("sord")),"asc");
			//페이지 그룹 수
			int pageGroups = 5;
			
			paraMap.put("count",totalCount);
			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			//paraMap.put("sord", sord);
			
			mav.addObject("sPageInfo",  new PageInfo().makeIndex(
					Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList"
			));
			
			// 데이터
			mav.addObject("data", this.noticeService.doListNotice(paraMap));
			// 세션 아이디
			mav.addObject("userid", request.getSession().getAttribute("userid"));
						
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			navi.put("two", "통지");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}
	
	@RequestMapping (value="viewNotice.do", method = RequestMethod.POST)
	public ModelAndView doviewNotice(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/front/notice/viewNotice.front");						
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		paraMap.put("siteid", siteid);	
		mav.addObject("paraMap", paraMap);
		
		try {
			// 게시판
			DataMap result = this.noticeService.doGetNotice(paraMap);
			mav.addObject("paraMap", result);
			String fmst_seqno = result.getstr("fmst_seqno");
			if(!("").equals(fmst_seqno)) {
				paraMap.put("fmst_seq", fmst_seqno);
				List<DataMap> fileList = fileService.getFileListToZip(paraMap);
				mav.addObject("fileList", fileList);
				paraMap.remove("fmst_seq");
				//System.out.println("fileList에요 " + fileList);
			}
			// 첨부파일
			//mav.addObject("file", this.noticeService.doListNoticeAttach(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			navi.put("two", "통지");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		System.out.println("데이터확이느"+paraMap);
		return mav;
	}
	
	@RequestMapping (value="/noticePopupList.do", method = RequestMethod.GET)
	public ModelAndView noticePopupList(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("member_seqno", session.getAttribute("member_seqno").toString());
		mav.addObject("paraMap", paraMap);
		
		try {
			// 세션 아이디
			mav.addObject("userid", request.getSession().getAttribute("userid"));
			
			List<DataMap> list = this.noticeService.doPopupListNotice(paraMap);
			for (int i =0; i<list.size(); i++) {
				String fmst_seqno = list.get(i).getstr("fmst_seqno");
				System.out.println("fmst_seqno: "+fmst_seqno);
				if(!("").equals(fmst_seqno)) {
					paraMap.put("fmst_seq", fmst_seqno);
					List<DataMap> fileList = fileService.getFileListToZip(paraMap);
					list.get(i).put("data", fileList);
					paraMap.remove("fmst_seq");
				}
			}
			// 데이터
			mav.addObject("data",list );
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}
	
	@RequestMapping (value="noticeConfirm.do", method = RequestMethod.POST)
	public ModelAndView noticeConfirm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");						
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		mav.addObject("paraMap", paraMap);
		
		try {
			// 게시판
			int result = this.noticeService.doConfirmNotice(paraMap);
			mav.addObject("paraMap", result);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		System.out.println("데이터확이느"+paraMap);
		return mav;
	}
}
