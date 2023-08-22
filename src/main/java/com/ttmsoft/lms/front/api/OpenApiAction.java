package com.ttmsoft.lms.front.api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.front.projectapply.ProjectFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

import okhttp3.Response;

@Controller
public class OpenApiAction extends BaseAct{

	@Autowired
	private OpenApiService openApiService;
	
	/**
	 * API 새로고침
	 * @param paraMap
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping (value = "/apiCheckList.do", method = RequestMethod.POST)
	public ModelAndView doTaxCertificationList(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("jsonView");	
		try {
			paraMap.put("id", request.getSession().getAttribute("id"));
			List<DataMap> result = this.openApiService.doFrontBusiness(paraMap);
			String biz_regno = result.get(0).getstr("biz_regno");
			int total = 0;
			int ser1 = openApiService.bizApiCheck(biz_regno);
			int ser2 = openApiService.bizBusibbCnt(biz_regno);
			org.json.JSONArray ser3 = openApiService.taxCertificationList(biz_regno);
			int ser4 = openApiService.taxCertificationList2(biz_regno); // 표준재무제표증명
			int ser5 = openApiService.taxCertificationList3(biz_regno); // 납세증명
			int ser6 = openApiService.taxCertificationList4(biz_regno); // 지방세 납세증명
			mav.addObject("result1", result);
			mav.addObject("ser1", ser1);
			System.out.println("ser1:"+ser1);
			mav.addObject("ser2", ser2);
			mav.addObject("ser3", ser3);
			mav.addObject("ser4", ser4);
			mav.addObject("ser5", ser5);
			mav.addObject("ser6", ser6);
			mav.addObject("total", total);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 * 전자서명 시 사업자번호 비교
	 * @param paraMap
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/doBizeCheck.do", method = RequestMethod.POST)
	public ModelAndView doBizeCheck(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			paraMap.put("member_seqno", paraMap.get("user_id"));
			List<DataMap> result = this.openApiService.doFrontBusiness2(paraMap);
			mav.addObject("result", result);
		}catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	@RequestMapping(value = "/doSignOk.do", method = RequestMethod.POST)
	public ModelAndView doSignOk(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("jsonView");

		try {
			//String signToken = openApiService.getToken();
			//mav.addObject("signToken", signToken);
			
			//String signCreate = openApiService.createDocument();
			//Map<String,Object> signGet = openApiService.getDocument();
			String signTemplateGet = openApiService.getTemplate();//템플릿 목록 조회
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
 
}
