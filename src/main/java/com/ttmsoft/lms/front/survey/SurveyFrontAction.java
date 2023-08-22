package com.ttmsoft.lms.front.survey;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

/**
 * 
 * @Package	 : com.ttmsoft.lms.front.survey
 * @File	 : SurveyFrontAction.java
 * 
 * @Author   : ycjo
 * @Date	 : 2020. 5. 28.
 * @Explain  : 설문조사
 *
 */
@Controller
@RequestMapping ("/front")
public class SurveyFrontAction extends BaseAct {

	@Autowired
	private SurveyFrontService surveyFrontService;

	@Value ("${siteid}")
	private String			siteid;	
	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 2.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문계획에 포함되어 있는 설문지 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listFrontSurveyPaper.do", method = RequestMethod.GET)
	public ModelAndView doListFrontSurveyPaper (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("/lms/front/survey/listFrontSurveyPaper.front");
		paraMap.put("userno", request.getSession().getAttribute("userno"));
		
		try {
			mav.addObject("paraMap", paraMap);	
			mav.addObject("data", surveyFrontService.doListFrontSurveyPaper(paraMap));
			mav.addObject("applydate", this.surveyFrontService.doListApplyDate(paraMap)); //설문 기간
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 2.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listTakeSurvey.do", method = RequestMethod.GET)
	public ModelAndView doTakeSurveyListForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("/lms/front/survey/surveyDetail.front");
		mav.addObject("paraMap", paraMap);			
	 
	 	try { 		
	 		mav.addObject("que", surveyFrontService.doListSurveySet(paraMap)); //출제된 문제 데이터
		 	mav.addObject("queitem", surveyFrontService.doListMultipleChoice(paraMap)); //객관식 항목
		 	
		 	Calendar cal = Calendar.getInstance();  
	
			String yStr = ""+cal.get(Calendar.YEAR); //년도
			String mStr = ""+(cal.get(Calendar.MONTH) + 1); //월(+1일)
			String dStr = ""+cal.get(Calendar.DATE); //일	
			String hStr = ""+cal.get(Calendar.HOUR); //시간 
			String mnStr = ""+cal.get(Calendar.MINUTE); //분
			String sStr = ""+cal.get(Calendar.SECOND); //초	
			
			if((cal.get(Calendar.MONTH)+1) < 10 ) {
				mStr = "0"+mStr;  
			}  	  
			
			if((cal.get(Calendar.DATE)+1) < 10 ) {
				dStr = "0"+dStr;  
			}  	
			
			if((cal.get(Calendar.HOUR)+1) < 10 ) {
				hStr = "0"+hStr;  
			}  	
			
			if((cal.get(Calendar.MINUTE)+1) < 10 ) {
				mnStr = "0"+mnStr;  
			}  	
			
			if((cal.get(Calendar.SECOND)+1) < 10 ) {
				sStr = "0"+sStr;  
			} 	
			
			String nowDate = yStr+mStr+dStr+hStr+mnStr+sStr; //현재 날짜
			DataMap navi = new DataMap();
			navi.put("one", "사업수행");
			navi.put("two", "설문조사 상세");
			mav.addObject("navi",navi);
			mav.addObject("aplSdtm", nowDate);
	 	} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 2.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listTakeSurvey.do", method = RequestMethod.POST)
	public ModelAndView doTakeSurveyList (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();	
		mav.addObject("paraMap", paraMap);	
		
		paraMap.put("siteid", siteid);
		paraMap.put("userno", session.getAttribute("userno"));
		paraMap.put("userid", session.getAttribute("userid"));
		System.out.println("para@@@Map: "+paraMap);
		try {
			ArrayList<DataMap> list = new ArrayList<DataMap>();
					
			String[] que_seq = request.getParameterValues("que_seq");
			String[] que_pcd = request.getParameterValues("que_pcd");
							
			int length = que_seq.length;
						
			List<String> apl_ans = new ArrayList<String>();
	
			for(int j = 0; j < length; j++) {
				
				apl_ans.add(paraMap.getstr("apl_ans_" + j));
			}
							
			for(int i = 0; i < length; ++i) {				
				
				DataMap data = new DataMap();
				data.put("que_seq", que_seq[i]);
				data.put("que_pcd", que_pcd[i]);
				data.put("apl_ans", apl_ans.get(i));

				list.add(data);
			}
			paraMap.put("list", list);
			
			/*
			 * this.surveyFrontService.doAddSurveyApply(paraMap); //설문조사 등록
			 * this.surveyFrontService.doAddSurveyApplog(paraMap); //설문조사 참여 내역 등록
			 */
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
}


