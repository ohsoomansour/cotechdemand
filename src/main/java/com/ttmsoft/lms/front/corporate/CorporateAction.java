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
public class CorporateAction extends BaseAct{

	@Autowired
	private CorporateService corporateService;
	
	@Autowired
	private SeqService	seqService;
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업수요 기술분야 리스트
	 * @Explain  : 
	 *
	 */
	/*@RequestMapping (value="/CoTechList.do", method = RequestMethod.GET)
	public ModelAndView researchTechList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/corporateTechList.front");
		DataMap navi = new DataMap();
		navi.put("one", "기업수요 검색");
		navi.put("two", "기술분야 검색");
		mav.addObject("navi",navi);
		try {
			paraMap.put("depth", '1');
			List<DataMap> stdCode = corporateService.doGetStdMainCodeInfo(paraMap);
			mav.addObject("stdMainCode", stdCode);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
				
	}*/
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업수요 키워드 리스트
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value="/coKeyList.do", method = RequestMethod.GET)
	public ModelAndView corporateKeyList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/corporateKeyList.front");
		DataMap navi = new DataMap();
		navi.put("one", "기업수요 검색");
		navi.put("two", "키워드 검색");
		mav.addObject("navi",navi);
		try {
			mav.addObject("data", this.corporateService.doGetCorporateKeywordList(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 29. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기술 분류값 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doGetCoStdCodeInfoTest.do")
	public ModelAndView doGetCoStdCodeInfo(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap.toString());
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			}else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}
			List<DataMap> code = corporateService.doGetStdMiddleCodeInfo(paraMap);
			// 총 데이터 갯수
			int totalCount = corporateService.doResearchCountSubCode(paraMap);	
			if(paraMap.get("gubun").equals("mid")) {
				mav.addObject("stdCode", code);
				mav.addObject("totalCount", totalCount);
			}else if(paraMap.get("gubun").equals("sub")) {
				mav.addObject("stdCode", totalCount);
				mav.addObject("totalCount", totalCount);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 29. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 키워드값 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doCorporateKeywordResult.do")
	public ModelAndView doGetCorporateKeyword(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			System.out.println("paraMap:" + paraMap);
			
			List<DataMap> data = corporateService.doGetCorporateKeywordList(paraMap);
			mav.addObject("data", data);
			//mav.addObject("data", this.researchService.doGetKeywordList(paraMap));
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
}
