package com.ttmsoft.lms.front.corporate;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.member.MemberFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping("/techtalk")
public class CosearchAction extends BaseAct{

	@Autowired
	private CosearchService cosearchService;
	
	@Autowired
	private SeqService	seqService;
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. .
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업수요 기술분야 리스트
	 * @Explain  : 
	 *
	 */
	/*@RequestMapping (value="/reTechList.do", method = RequestMethod.GET)
	public ModelAndView researchTechList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/researchTechList.front");
		DataMap navi = new DataMap();
		navi.put("one", "기업수요 검색 검색");
		navi.put("two", "기술분야 검색");
		mav.addObject("navi",navi);
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
				
	}*/
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 1.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업수요 키워드 리스트
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value="/coKeyList.do", method = RequestMethod.GET)
	public ModelAndView researchKeyList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/corporateKeyList.front");
		DataMap navi = new DataMap();
		navi.put("one", "기업수요 검색");
		navi.put("two", "키워드 검색");
		mav.addObject("navi",navi);
		try {
			mav.addObject("data", this.cosearchService.doGetCosearchKeywordList(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
				
	}
	
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 1. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 키워드값 가져오기
	 * @Explain  : 
	 *
	 */
	/*@RequestMapping (value = "/doKeywordResult.do")
	public ModelAndView doGetKeyword(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			System.out.println("paraMap:" + paraMap);
			
			List<DataMap> data = cosearchService.doGetKeywordList(paraMap);
			mav.addObject("data", data);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}*/
	
}
