package com.ttmsoft.lms.front.match;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

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
		
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "매칭 목록 페이지");
		mav.addObject("navi",navi);
		return mav;
	}
}
