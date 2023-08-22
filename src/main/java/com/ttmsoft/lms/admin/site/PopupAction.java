package com.ttmsoft.lms.admin.site;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileUtil;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping(value="/admin")
public class PopupAction extends BaseAct{

	@Autowired
	private PopupService popupService;
	
	@Autowired
	private SeqService	seqService;	
	
	@Value ("${siteid}")
	private String			siteid;
	
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 25
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 팝업 페이지 이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/popup.do")
	public ModelAndView doMovePopup(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("/lms/admin/site/popup/adminPopup.admin");
		paraMap.put("siteid", siteid);
		mav.addObject("paraMap", paraMap);
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 25
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 팝업 리스트 조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listPopup.do")
	public ModelAndView doListPopup(@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav =new ModelAndView("jsonView");	
		
		paraMap.put("siteid", siteid);
	
		try {
			//총 데이터 갯수
			int totalCount= popupService.doCountPopup(paraMap);
			
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
			mav.addObject("rows",    popupService.doListPopup(paraMap));
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	/**
	 *
	 * @Author : ijpark
	 * @Date : 2020. 5. 
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 등록폼
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/insertPopupForm.do")
	public ModelAndView doInsertPopupForm(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/admin/site/popup/insertPopupForm.adminPopup");
		mav.addObject("paraMap", paraMap);
		paraMap.put("siteid", siteid);
		
		try {					
			paraMap.put("commcd_gcd", "POPUP_PCD");
			mav.addObject("popupPcd" , popupService.doListPopupCode(paraMap));
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : ijpark
	 * @Date : 2020. 5. 
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 등록
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/insertPopup.do")
	public ModelAndView doInsertPopup(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		paraMap.put("siteid", siteid);
		
		
		try {
			paraMap.put("seq_tblnm", "TA_POPUP"); 
			int popupSeq = this.seqService.doAddAndGetSeq(paraMap);
			paraMap.put("popup_seq", popupSeq);	 		
		    paraMap.put("popup_img", FileUtil.viewUpload(paraMap, request, "view/popup/" + popupSeq));
			if(paraMap.get("popup_left").equals("")) {
				paraMap.put("popup_left", 0);
			}
			if(paraMap.get("popup_top").equals("")) {
				paraMap.put("popup_top", 0);
			}
			if(paraMap.get("popup_width").equals("")) {
				paraMap.put("popup_width", 0);
			}
			if(paraMap.get("popup_height").equals("")) {
				paraMap.put("popup_height", 0);
			}
			
			popupService.doInsertPopup(paraMap);
		}catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 수정 팝업
	 * @Explain :
	 */
	@RequestMapping(value="/updatePopupForm.do") 
	public ModelAndView doUpdatePopupForm(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("/lms/admin/site/popup/updatePopupForm.adminPopup");
		mav.addObject("paraMap",paraMap);
		try { 
			
			DataMap popup = popupService.doGetPopup(paraMap);
			mav.addObject("popup", popup);
			mav.addObject("popup_seq",paraMap.get("popup_seq"));
			
			paraMap.put("commcd_gcd", "POPUP_PCD");
			mav.addObject("popupPcd" , popupService.doListPopupCode(paraMap));
			
			String name = FileUtil.getFileName(request, (String)popup.get("popup_img"));
			mav.addObject("viewName", name);
			
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
		
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 26
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 수정
	 * @Explain :
	 */
	@RequestMapping(value="/updatePopup.do") 
	public ModelAndView doUpdatePopup(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		
		try {
			
			paraMap.put("popup_img", FileUtil.viewUpload(paraMap, request, "view/popup/" + paraMap.get("popup_seq")));
			popupService.doUpdatePopup(paraMap);			
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	/**
	 *
	 * @Author : ijpark
	 * @Date : 2020. 5. 
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 삭제
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/deletePopup.do")
	public ModelAndView doDeletePopup(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("popup_seq", paraMap.get("popup_seq"));
		
		try {
			popupService.doDeletePopup(paraMap);
		}catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 * @Author : ijpark
	 * @Date : 2020. 6.5 
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 미리보기 
	 * @Explain :
	 */
	@RequestMapping(value="/previewPopupForm.do") 
	public ModelAndView dopreviewPopupForm(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("/lms/admin/site/popup/previewPopupForm.adminPopup");
		mav.addObject("paraMap",paraMap);
		try { 
			mav.addObject("popup", popupService.doGetPopup(paraMap));
			mav.addObject("popup_seq",paraMap.get("popup_seq"));
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
	/**
	 * @Author : ijpark
	 * @Date : 2020. 6. 5
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 팝업 이미지 삭제
	 * @Explain :
	 */
	@RequestMapping(value="/deletePopupView.do") 
	public ModelAndView doDeletePopupView(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {			
			popupService.doDeletePopupView(paraMap);	
			FileUtil.removeFile(request, (String)paraMap.get("popup_img"));
			
		} catch(Exception e) { 
			e.printStackTrace();
		}
		
		return mav;
	}		
	
}