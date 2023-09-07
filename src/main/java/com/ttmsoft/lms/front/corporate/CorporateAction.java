package com.ttmsoft.lms.front.corporate;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.member.MemberFrontService;
import com.ttmsoft.lms.front.research.ResearchService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping("/techtalk")
public class CorporateAction extends BaseAct{

	@Autowired
	private CorporateService corporateService;
	
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
	 * @Function : 기업수요 기술분야 리스트
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value="/coTechList.do", method = RequestMethod.GET)
	public ModelAndView researchTechList (@ModelAttribute ("paraMap") DataMap paraMap) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/corporateTechList.front");
		DataMap navi = new DataMap();
		navi.put("one", "기업수요 검색");
		navi.put("two", "기술분야 검색");
		mav.addObject("navi",navi);
		try {
			paraMap.put("parent_depth", '1');
			paraMap.put("next_depth", '2');
			List<DataMap> stdCode = corporateService.doCorprateCountSubCode(paraMap);
			mav.addObject("stdMainCode", stdCode);
			mav.addObject("data", this.corporateService.doGetCorporateList(paraMap));
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
		System.out.println("paraMap : " + paraMap);
		try {
			String name_path = (String) paraMap.get("name_path");
			String[] name_path_split = name_path.split("\\^");
			
			if(paraMap.get("parent_depth").equals("3")) {
				System.out.println("소분류");
		        int size = 2;
		        String code_key_change = StringUtils.leftPad(String.valueOf(paraMap.get("code_key")), size, '0');
				paraMap.put("parent_code_key", code_key_change);
				paraMap.put("tech_code2", code_key_change);
				paraMap.put("tech_nm1", name_path_split[0]);
				paraMap.put("tech_nm2", name_path_split[1]);
			}else if(paraMap.get("parent_depth").equals("2"))  {
				System.out.println("중분류");
				paraMap.put("parent_code_key", paraMap.get("code_key"));
				paraMap.put("tech_nm1", name_path_split[0]);
			}else if(paraMap.get("parent_depth").equals("4"))  {
				paraMap.put("parent_depth", "3");
				paraMap.put("code_end", "end");
				paraMap.put("tech_nm1", name_path_split[0]);
				paraMap.put("tech_nm2", name_path_split[1]);
				paraMap.put("tech_nm3", name_path_split[2]);
			}
			System.out.println("paraMap2 : " + paraMap);
			List<DataMap> stdCode = researchService.doResearchCountSubCode(paraMap);
			mav.addObject("stdMainCode", stdCode);
			mav.addObject("data", this.corporateService.doGetCorporateList(paraMap));
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
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 1. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구자 상세 페이지
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/viewCorprateDetail.do", method = RequestMethod.POST)
	public ModelAndView doViewResearchDetail(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporate/viewCoDetail.front");						
		mav.addObject("paraMap", paraMap);	
		
		try {						
			System.out.println("paraMap:"+paraMap);
			// 기업수요 정보	
			DataMap data = this.corporateService.doViewCorporateDetail(paraMap);
			mav.addObject("data", data);
			DataMap navi = new DataMap();
			navi.put("one", "기업수요 검색");
			navi.put("two", "키워드 정보");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		

		return mav;
	}
	
}
