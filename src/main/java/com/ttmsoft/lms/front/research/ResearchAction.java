package com.ttmsoft.lms.front.research;

import java.text.DecimalFormat;
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
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.CommonUtil;

@Controller
@RequestMapping("/techtalk")
public class ResearchAction extends BaseAct{

	@Autowired
	private ResearchService researchService;
	
	@Autowired
	private SeqService	seqService;
	
	@Autowired
	private CommonUtil CommonUtil;
	
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
		paraMap.get("parent_code_key");
		try {
			paraMap.put("parent_depth", '1');
			paraMap.put("next_depth", '2');
			List<DataMap> stdCode = researchService.doResearchCountSubCode(paraMap);
			mav.addObject("stdMainCode", stdCode);
			mav.addObject("data", this.researchService.doGetResearchList(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 9. 3. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기술 분류값 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doClickCodeResult.do")
	public ModelAndView doClickCodeResult(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
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
			mav.addObject("data", this.researchService.doGetResearchList(paraMap));
			
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
	
	/**
	 *
	 * @Author   : jmyoo
	 * @Date	 : 2023. 8. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구자 상세 페이지
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/viewResearchDetail.do", method = RequestMethod.POST)
	public ModelAndView doViewResearchDetail(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/techtalk/front/research/viewReDetail.front");						
		mav.addObject("paraMap", paraMap);	
		
		try {						
			System.out.println("paraMap:"+paraMap);
			// 연구자 정보	
			DataMap data = this.researchService.doViewResearchDetail(paraMap);
			mav.addObject("data", data);
			// 국가 과제 수행 이력
			mav.addObject("proData", this.researchService.doViewResearchProject(paraMap));
			if(paraMap.get("keyword") != null && paraMap.get("keyword") != "" && paraMap.get("keyword") != "") {
				System.out.println("????????????");
				String keyword = (String) paraMap.get("keyword");
				String[] keyword_split = keyword.split(",");
				paraMap.put("keyword_split1", keyword_split[0]);
				paraMap.put("keyword_split2", keyword_split[1]);
				paraMap.put("keyword_split3", keyword_split[2]);
				
			}
			//연구히스토리
			mav.addObject("dataHis", this.researchService.doViewResearchHistory(paraMap));
			// 유사분야 연구자
			mav.addObject("similData", this.researchService.doSimilarResearchList(paraMap));
			// 특허리스트
			mav.addObject("patentData", this.researchService.doPatentList(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "연구자 검색");
			navi.put("two", "연구자 정보");
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
	 * @Date	 : 2023. 8. 31. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기술이전 문의 메일
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/sendTechInquiry.do", method = RequestMethod.POST)
	public ModelAndView doSendTechInquiry(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");						
		mav.addObject("paraMap", paraMap);	
		
		try {						
			CommonUtil.doTloMailSender(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		

		return mav;
	}
}
