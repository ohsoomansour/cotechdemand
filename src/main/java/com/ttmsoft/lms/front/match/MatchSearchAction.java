package com.ttmsoft.lms.front.match;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.lms.front.research.ResearchService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.CommonUtil;

/**
 * 
 * 파일명	: MainAction.java
 * 패키지	: com.ttmsoft.lms.svc.main
 * 설  명	: 사용자 메인 페이지
 *
 * 2020.03.03	[sgchoi] - 최초작성
 * 
 */
@Controller
@RequestMapping("/techtalk")
public class MatchSearchAction extends BaseAct {

	@Value ("${siteid}")
	private String			siteid;
	
	@Autowired
	private MatchSearchService matchSearchService;
	
	@Autowired
	private ResearchService researchService;
	
	@Autowired
	private CommonUtil CommonUtil;
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 6.
	 * @Parm	 : DataMap
0	 * @Return   : ModelAndView
	 * @Function : 매칭된 목록 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/matchList.do")
	public ModelAndView doMatchBusinessList (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/match/matchList.front");
		String biz_name = session.getAttribute("biz_name").toString();
		String member_seqno = session.getAttribute("member_seqno").toString();
		String member_type = session.getAttribute("member_type").toString();
		paraMap.put("biz_name", biz_name);
		paraMap.put("member_type", member_type);
		paraMap.put("member_seqno", member_seqno);
		System.out.println("member_type:"+member_type);
		System.out.println("paraMap:"+paraMap);
		if(paraMap.getstr("member_type").equals("R")) {
			mav.addObject("dataR", this.matchSearchService.doGetMatchRList(paraMap));
		}else if(paraMap.getstr("member_type").equals("B")) {
			mav.addObject("dataB", this.matchSearchService.doGetMatchBList(paraMap));
		}else if(paraMap.getstr("member_type").equals("TLO")) {
			mav.addObject("dataTLO", this.matchSearchService.doGetMatchTLOList(paraMap));
		}
		System.out.println("paraMap:"+paraMap);
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "매칭 목록 페이지");
		mav.addObject("navi",navi);
		return mav;
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 13. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 매칭 이력보기
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doMatchHistoryListX.do")
	public ModelAndView doGetKeyword(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			System.out.println("paraMap:" + paraMap);
			mav.addObject("data", this.matchSearchService.doGetHistoryList(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "메인");
			navi.put("two", "매칭 목록 페이지");
			mav.addObject("navi",navi);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 문의 메일
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/sendInquiryMatchX.do", method = RequestMethod.POST)
	public ModelAndView dosendInquiryResearcher(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, Model model, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");		
		String member_seqno = session.getAttribute("member_seqno").toString();
		paraMap.put("member_seqno", member_seqno);
		mav.addObject("paraMap", paraMap);	
		
		try {						
			for(int i = 0; i < 2; i ++) {
				DataMap data = null;
				if( i == 0) {
					paraMap.put("user_email", "tbiz@tbizip.com");
					paraMap.put("subject", "매칭 문의합니다");
					paraMap.put("text", "매칭 문의해요");
					System.out.println("TLO 담당자 이메일 없음");
					System.out.println("티비즈" + paraMap);
					CommonUtil.doMailSender(paraMap);
				}else if( i == 1) {
					DataMap userData = researchService.doUserGetName(paraMap);
					data = researchService.doViewResearchEmail(paraMap);
					paraMap.put("user_email", data.get("user_email"));
					paraMap.put("subject", userData.get("user_name")+"님이 매칭 문의합니다");
					paraMap.put("text", "매칭 문의해요");
					System.out.println("TLO" + paraMap);
					if(data == null) {
						ModelAndView errorModelAndView = new ModelAndView("errorView");
		                errorModelAndView.addObject("errorMessage", "Data not found");
		                return errorModelAndView;
					}
				}
			}
			
			System.out.println(paraMap);
		} catch (Exception e) {
			/*e.printStackTrace();
			return new ModelAndView("error");*/
			ModelAndView errorModelAndView = new ModelAndView("errorView");
            errorModelAndView.addObject("errorMessage", "An error occurred: " + e.getMessage());
            return errorModelAndView;
		}		

		return mav;
	}
}
