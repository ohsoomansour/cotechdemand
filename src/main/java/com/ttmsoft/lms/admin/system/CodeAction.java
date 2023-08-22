package com.ttmsoft.lms.admin.system;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping(value="/admin")
public class CodeAction extends BaseAct{
	@Autowired
	private CodeService codeService;
	
	@Value ("${siteid}")
	private String siteid;
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 28
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드관리이동페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="code.do")
	public ModelAndView doCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/admin/system/code/adminCode.admin");
		paraMap.put("siteid", siteid);

		try {
			mav.addObject("commcd_pcd", codeService.doListCodePCD(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 28
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메인코드리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="listMainCode.do")
	public ModelAndView doListMainCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);

		try {
			paraMap.put("locale", RequestContextUtils.getLocale(request).toString());
			//검색 조건
			logger.info("검색조건 데이터:" + paraMap.toString());			
			// 총 데이터 갯수
			int totalCount = codeService.doCountMainCode(paraMap);
			// 총 페이지 갯수
			int totalPage  = (totalCount -1)/Integer.parseInt((String)paraMap.get("rows")) + 1;
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",   totalPage);
			// 현재 페이지
			mav.addObject("page",    paraMap.get("page"));
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",    codeService.doListMainCode(paraMap));
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 28
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 서브코드리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="listSubCode.do")
	public ModelAndView doListSubCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);

		try {
			paraMap.put("locale", RequestContextUtils.getLocale(request).toString());
			// 총 데이터 갯수
			int totalCount = codeService.doCountSubCode(paraMap);			
			// 총 페이지 갯수
			int totalPage  = (totalCount -1)/Integer.parseInt((String)paraMap.get("rows")) + 1;
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",   totalPage);
			// 현재 페이지
			mav.addObject("page",    paraMap.get("page"));
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",    codeService.doListSubCode(paraMap));
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();  
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 28
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드폼생성
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "formCode.do")
	public ModelAndView doFormMainCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/admin/system/code/adminCodeForm.adminPopup");
		paraMap.put("siteid", siteid);

		try {
			if(paraMap.get("mode").equals("MU")) {
				mav.addObject("codeInfo", codeService.doGetMainCodeInfo(paraMap));
			}else if(paraMap.get("mode").equals("SU")) {
				mav.addObject("codeInfo", codeService.doGetSubCodeInfo(paraMap));
			}
			
			mav.addObject("commcd_pcd", codeService.doListCodePCD(paraMap));
			mav.addObject("paraMap", paraMap);
			
		} catch (Exception e) {
			e.printStackTrace(); 
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 30
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드 중복검사
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "checkCodeOverlap.do")
	public ModelAndView doCheckCodeOverlap(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		try {
			int codeOverlap = codeService.doCheckCodeOverlap(paraMap);
			mav.addObject("codeOverlap", codeOverlap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 29
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "insertCode.do")
	public ModelAndView doInsertCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));

		try {
			//코드 등록정보
			logger.info("코드 등록정보 : " + paraMap.toString()); 
			
			if(("MI").equals(paraMap.get("mode"))) {
				codeService.doInsertMainCode(paraMap);
			}else if(("SI").equals(paraMap.get("mode"))) {
				DataMap mainCodeInfo = codeService.doGetMainCodeInfo(paraMap);							
				 paraMap.put("commcd_gcd", mainCodeInfo.get("commcd")); 
				 paraMap.put("commcd_tcd", mainCodeInfo.get("commcd_tcd"));
				 paraMap.put("commcd_pcd", mainCodeInfo.get("commcd_pcd"));
				 paraMap.put("commcd_idx", codeService.doMaxCodeIdx(paraMap) + 1); // maincode commcd_gcd정보가 필요함..
				 codeService.doInsertSubCode(paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 29
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "updateCode.do")
	public ModelAndView doUpdateCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {
			logger.info("코드 정보 : " + paraMap.toString());
			
			if(("MU").equals(paraMap.get("mode"))) {
				String mainCommcd = (String)paraMap.get("c_commcd");
				String mainCommcdGcd = (String)paraMap.get("c_commcd_gcd");
				codeService.doUpdateMainCode(paraMap);
				paraMap.put("c_commcd", paraMap.get("commcd"));
				paraMap.put("c_commcd_gcd", paraMap.get("commcd"));
				DataMap mainCodeInfo = codeService.doGetMainCodeInfo(paraMap);
				paraMap.put("c_commcd_gcd", mainCommcdGcd);
				List<DataMap> list = codeService.doListMainCodeOfSubCode(paraMap);
				if(list.size() != 0) {
					paraMap.put("list", list);
					paraMap.put("commcd_tcd", mainCodeInfo.get("commcd_tcd"));
					paraMap.put("commcd",  mainCodeInfo.get("commcd"));
					codeService.doUpdateMainCodeOfSubCode(paraMap);
				}
			}else if(("SU").equals(paraMap.get("mode"))) {
				//메인코드 정보 가져오기
				paraMap.put("commcd_pcd", codeService.doGetMainCodeInfoOfCG(paraMap).get("commcd_pcd"));
				codeService.doUpdateSubCode(paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace(); 
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 1
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "deleteCode.do")
	public ModelAndView doDeleteCode(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		
		try {
			logger.info("삭제될 코드 정보 : " + paraMap.toString());
			
			if(("mainCode").equals(paraMap.get("type"))) {
				DataMap mainCodeInfo = codeService.doGetMainCodeInfo(paraMap);
				paraMap.put("commcd_gcd", mainCodeInfo.get("commcd_gcd"));
				codeService.doDeleteMainCode(paraMap);
			}else if(("subCode").equals(paraMap.get("type"))) {
				codeService.doDeleteSubCode(paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
}
