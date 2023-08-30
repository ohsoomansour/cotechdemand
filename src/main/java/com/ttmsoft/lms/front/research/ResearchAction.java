package com.ttmsoft.lms.front.research;

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
public class ResearchAction extends BaseAct{

	@Autowired
	private ResearchService researchService;
	
	@Autowired
	private SeqService	seqService;
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구자 기술분야 리스트
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value="/reTechList.do", method = RequestMethod.GET)
	public ModelAndView researchTechList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/research/researchTechList.front");
		DataMap navi = new DataMap();
		navi.put("one", "연구자 검색");
		navi.put("two", "기술분야 검색");
		mav.addObject("navi",navi);
		try {
			paraMap.put("depth", '1');
			List<DataMap> stdCode = researchService.doGetStdMainCodeInfo(paraMap);
			mav.addObject("stdMainCode", stdCode);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
				
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구자 키워드 리스트
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value="/reKeyList.do", method = RequestMethod.GET)
	public ModelAndView researchKeyList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/research/researchKeyList.front");
		DataMap navi = new DataMap();
		navi.put("one", "연구자 검색");
		navi.put("two", "키워드 검색");
		mav.addObject("navi",navi);
		try {
			//List<DataMap> keywordList = researchService.doGetKeywordList(paraMap);
			mav.addObject("data", this.researchService.doGetKeywordList(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		
		return mav;
		
				
	}
	
	/*@RequestMapping ("/researchListCheck.do")
	public ModelAndView testInput(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response ) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<DataMap> result = researchService.doListCheck(paraMap);
		
		mav.addObject(result);
		return mav;
	}*/
	
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
	@RequestMapping (value = "/doGetStdCodeInfoTest.do")
	public ModelAndView doGetStdCodeInfo(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap.toString());
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			}else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}
			List<DataMap> code = researchService.doGetStdMiddleCodeInfo(paraMap);
			// 총 데이터 갯수
			int totalCount = researchService.doResearchCountSubCode(paraMap);	
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
	@RequestMapping (value = "/doKeywordResult.do")
	public ModelAndView doGetKeyword(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			System.out.println("paraMap:" + paraMap);
			
			List<DataMap> data = researchService.doGetKeywordList(paraMap);
			mav.addObject("data", data);
			//mav.addObject("data", this.researchService.doGetKeywordList(paraMap));
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
}
