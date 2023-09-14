package com.ttmsoft.lms.front.mypage;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.ExcelUtil;

@Controller
@RequestMapping("/techtalk")
public class MyPageAction extends BaseAct {
	
	private final ExcelUtil excelUtil = new ExcelUtil();
	
	@Autowired
	private MyPageService myPageService;


	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 05.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자)
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/researchMyPage.do")
	public ModelAndView deGetResearcherMyPage(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,
			HttpServletResponse response) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/mypage/researchMyPage.front");
		
		try {
			DataMap navi = new DataMap();
			navi.put("one", "마이페이지");
			navi.put("two", "연구자 목록");
			mav.addObject("navi", navi);
			
			//기술분류 리스트
			paraMap.put("depth", '1');
			mav.addObject("codeList1", this.myPageService.doGetCodeListInfo(paraMap));
			paraMap.put("depth", '2');
			mav.addObject("codeList2", this.myPageService.doGetCodeListInfo(paraMap));
			paraMap.put("depth", '3');
			mav.addObject("codeList3", this.myPageService.doGetCodeListInfo(paraMap));

			paraMap.put("id", request.getSession().getAttribute("id"));

			//연구원 정보
			mav.addObject("data", this.myPageService.doGetResearcherInfo(paraMap));

			if(mav.getModel().get("data") != null) {
				//유사연구자
				String keyword = this.myPageService.doGetResearcherInfo(paraMap).getstr("keyword");
				String researcher_seqno = this.myPageService.doGetResearcherInfo(paraMap).getstr("researcher_seqno");
				String[] keyword_split = keyword.split(",");
				paraMap.put("researcher_seqno", researcher_seqno);
				
				for(int i=0; i < keyword_split.length; i++) {
					paraMap.put("keyword_split"+(i+1), keyword_split[i]);
				}
	
				mav.addObject("similData", this.myPageService.doGetSimilar(paraMap));
				
				//국가 과제 수행 이력
				mav.addObject("proData", this.myPageService.doGetProject(paraMap));
				
				//연구히스토리
				mav.addObject("dataHis", this.myPageService.doGetHistory(paraMap));
				
				//특허리스트
				mav.addObject("invent", this.myPageService.doGetInvent(paraMap));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 07.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/deGetResearcherDetail.do")
	public ModelAndView deGetResearcherDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");

		try {
			//담당자 정보
			mav.addObject("manager", this.myPageService.doGetManager(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 07.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 상세보기 기술분류목록
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/deGetCodeList.do")
	public ModelAndView deGetCodeList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			} else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}
			
			List<DataMap> code = myPageService.doGetCodeListInfo(paraMap);
			if(paraMap.get("gubun").equals("mid")) {
				mav.addObject("codeList", code);
			} else if(paraMap.get("gubun").equals("sub")) {
				mav.addObject("codeList", code);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 13.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 수정
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/doUpdateResearcher.do")
	public ModelAndView deUpdateResearcher(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
			System.out.println("수정 여기 : " + paraMap);
			
		try {
			//연구자 정보
			this.myPageService.doUpdateResearcher(paraMap);
			
			//특허리스트
			this.myPageService.doUpdateInvent(paraMap);
			
			//담당자 정보
			this.myPageService.doUpdateManager(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 13.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 엑셀입력
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/doUpdateExcel.do")
	public ModelAndView deUpdateExcel(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,
			HttpServletResponse response, @RequestParam("file") MultipartFile multipartFile) {
		ModelAndView mav = new ModelAndView("jsonView");

		Map<String, Object> result = this.excelUtil.convertExcelToMap(multipartFile);
		
		mav.addObject("result", result);
		
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
}
