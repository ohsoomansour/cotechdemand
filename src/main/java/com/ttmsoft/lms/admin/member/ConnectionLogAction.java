package com.ttmsoft.lms.admin.member;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping(value="/admin")
public class ConnectionLogAction extends BaseAct{

	@Autowired
	private ConnectionLogService connectionLogService;
	
	@Value ("${siteid}")
	private String			siteid;
	
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 11
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이용로그 페이지 이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/connLog.do")
	public ModelAndView doMoveConnectionLog(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("/lms/admin/member/conLog/adminConnectionLog.admin");
		paraMap.put("siteid", siteid);
		try {
			// 상태종류	
			mav.addObject("connLogCode",connectionLogService.doListConnectionLogCode(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 11
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이용로그 리스트 조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listConnLog.do")
	public ModelAndView doListConnectionLog(@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav =new ModelAndView("jsonView");
		
		paraMap.put("siteid", siteid);
		
		//가입날짜 조건
		String strDate = (String) paraMap.get("startdate");
		String endDate = (String) paraMap.get("enddate");
	
		if(strDate != null && !("").equals(strDate)) {		
			paraMap.put("strDate", strDate.substring(0, 4) + strDate.substring(5, 7) + strDate.substring(8, 10));					
		}
		
		if(endDate != null && !("").equals(endDate)) {
			paraMap.put("endDate", endDate.substring(0, 4) + endDate.substring(5, 7) + endDate.substring(8, 10));
		}
		paraMap.put("connectionstate", paraMap.get("connectionstate"));
	
		try {
			//총 데이터 갯수
			int totalCount=this.connectionLogService.doCountConnectionLog(paraMap);
			
			// 총 페이지 갯수
			int totalPage  = (totalCount -1)/ Integer.parseInt((String) paraMap.get("rows")) + 1;
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",   totalPage);
			// 현재 페이지
			mav.addObject("page",    paraMap.get("page"));
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",    this.connectionLogService.doListConnectionLog(paraMap));
			// --------------------------------------------------------------------------
			

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
		
}
