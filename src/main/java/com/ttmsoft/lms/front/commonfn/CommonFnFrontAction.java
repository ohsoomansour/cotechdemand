package com.ttmsoft.lms.front.commonfn;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.front.projectapply.FileService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping ("/front")

public class CommonFnFrontAction extends BaseAct{
	
	@Autowired
	private CommonFnFrontService commonfnService; 
	
	@Autowired
	private FileService fileService;
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2020. 7. 22.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이용약관 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/terms.do")
	public ModelAndView doTerms (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/lms/front/commonfn/TermsOfServices.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "이용약관");
		mav.addObject("navi",navi);
		return mav;
	}
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2020. 7. 22.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 개인정보 처리방침
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/policy.do")
	public ModelAndView doPolicy (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/lms/front/commonfn/PrivacyPolicy.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "개인정보처리방침");
		mav.addObject("navi",navi);
		return mav;
	}
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2020. 8. 06.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 가계부
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/accountBookList.do")
	public ModelAndView doAccountBookList (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		String member_seqno = request.getSession().getAttribute("member_seqno").toString();
		paraMap.put("insert_user", member_seqno);
		paraMap.put("member_seqno", member_seqno);
		ModelAndView mav = new ModelAndView("/lms/front/commonfn/accountBookList.front");
		
		try {
		// 게시글 개수
		int totalCount = this.commonfnService.countAccountBookList(paraMap);
		
		paraMap.put("count",totalCount);
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
		
		mav.addObject("sPageInfo",  
				new PageInfo().makeIndex(Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList"));
		mav.addObject("result", this.commonfnService.doListAccountBook(paraMap));
		mav.addObject("paraMap", paraMap);
		DataMap navi = new DataMap();
		navi.put("one", "사업공통");
		navi.put("two", "사업비 집행내역");
		mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	

	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 03.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 상세보기 페이지
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/accountBookDetail.do", method = RequestMethod.POST)
	public ModelAndView accountBookDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/commonfn/accountBookDetail.front");

		mav.addObject("paraMap", paraMap);
		String member_seqno = request.getSession().getAttribute("member_seqno").toString();
		paraMap.put("insert_user", member_seqno);
		paraMap.put("member_seqno", member_seqno);
		System.out.println("초기데이터확인용 : "+paraMap);

		try {
			// 카테고리
			DataMap result = this.commonfnService.doDetailAccountBook(paraMap);
			mav.addObject("paraMap", result);
			System.out.println("최종데이터일거야 "+result);
			String fmst_seqno = result.getstr("fmst_seqno");
			if(!("").equals(fmst_seqno)) {
				paraMap.put("fmst_seq", fmst_seqno);
				List<DataMap> fileList = fileService.getFileListToZip(paraMap);
				mav.addObject("fileList", fileList);
				paraMap.remove("fmst_seq");
				//System.out.println("fileList에요 " + fileList);
			}
			DataMap navi = new DataMap();
			navi.put("one", "사업공통");
			navi.put("two", "사업비 집행내역 상세정보");
			mav.addObject("navi",navi);
		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 03.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 가계부 히스토리 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/doAccountBookHist.do", method = RequestMethod.POST)
	public ModelAndView doAccountBookHist(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		String member_seqno = request.getSession().getAttribute("member_seqno").toString();
		paraMap.put("insert_user", member_seqno);
		paraMap.put("member_seqno", member_seqno);
		System.out.println("초반데이터 확인용 :" + paraMap);
		try {
			List<DataMap> result = commonfnService.doAccountBookHist(paraMap);
			 mav.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 03.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 가계부 히스토리 추가
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/accountBookSubmit.do", method = RequestMethod.POST)
	public ModelAndView accountBookSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		String member_seqno = request.getSession().getAttribute("member_seqno").toString();
		paraMap.put("insert_user", member_seqno);
		paraMap.put("insert_ip", request.getRemoteAddr());
		paraMap.put("member_seqno", member_seqno);
		System.out.println("초반데이터 확인용 :" + paraMap);
		try {
			int result = commonfnService.accountBookSubmit(paraMap);
			 mav.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
}
