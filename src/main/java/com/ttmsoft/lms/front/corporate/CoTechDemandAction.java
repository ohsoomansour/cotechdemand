package com.ttmsoft.lms.front.corporate;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping("/techtalk")
public class CoTechDemandAction {
	@Autowired
	CoTechDemandService coTechDemandService;
	/**
	 *
	 * @Author   : osm
	 * @Date	 : 2023.9. 14
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업 기술수요 등록  
	 * @Explain  : 
	 *
	 */
	 
	//임시 페이지
	@RequestMapping (value = "/newui.do")
	public ModelAndView donewui(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/researchMyPage.front");

		return mav;
	}
	
	@RequestMapping(value = "/registerCoTechDemand")
	public ModelAndView doRegisterCoTechDemand(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session ) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/registCoTechDemandForm.front");
		/* **secure, 기업 회원만 입장*** 
		String member_type = (String) session.getAttribute("member_type");
		String  id = (String) session.getAttribute("id");
		
		//'비로그인'의 경우 
		if(Objects.isNull(id)){
			mav.setViewName("redirect:/techtalk/login.do");
			return mav;
		}
		//'로그인'의 경우
		else if(!Objects.isNull(id)){
			if(member_type.equals("B")) {
				return mav;
			} else {
				//팝업창에 기업 아이디가 아닙니다!
				mav.setViewName("redirect:/");
				return mav;
			 }
		}
		*/
		
		
		return mav;
	}
	
	//삽입 
	@RequestMapping(value = "/insertCoTechDemand.do")
	public ModelAndView doInsertCTD(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session ) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			// ------ 2023.09.15 수정 컨펌 필요 --------------------------------------
//{category_medi=1, category_small=11, keyword=battery, erro=erro, rndInfra=infra, investWilling=investWillings, bizName=osooman, userDepart=dev, userRank=bo, bizEmail1=osmansour, bizEmail2=daum.net, bizEmail3=daum.net, user_mobile_no=01036383330}
			System.out.println(paraMap);
			String biz_email = paraMap.getstr("bizEmail1")+"@"+paraMap.getstr("bizEmail2");
			paraMap.put("biz_email", biz_email);
			coTechDemandService.doInsertCoTechDemand(paraMap);	
			
			LocalDate now = LocalDate.now();
			int month = now.getMonthValue();
			int day = now.getDayOfMonth();
			String biz_id = (String)session.getAttribute("id");
			
			/*등록 완료 메세지 >> '팝업창'
			String text = "귀하께서는 "+month+"월"+day+"일 </br>TECHTALK 기업수요 정보를 등록하였습니다. <br/><br/><br/> ";
					text +="아이디 : "+ biz_id;
			mav.addObject("text", text);
			 */

			return mav;

		} catch (Exception e) {	
			
		}
		// 로직
		return mav;
	}
	
	@RequestMapping (value = "/autoSearchKeyword.do")
	public ModelAndView doAutoSearchBusiness(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("keyword checking:" + paraMap);
		List<DataMap> result = coTechDemandService.doAutoSearchKeyword(paraMap);
		mav.addObject("result", result);
		return mav;
	}
	
	//기업 기술수요 목록 리스트
	@RequestMapping(value = "/moveCoTechDemandList.do")
	public ModelAndView moveCorporateDemandList(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response ) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/coTechDemandList.front");
		//***기업 회원만 입장*** 
		return mav;
	}
	
}
