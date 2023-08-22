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
public class BannerAction extends BaseAct{

	@Autowired
	private BannerService bannerService;

	@Autowired
	private SeqService	seqService;	
	
	@Value ("${siteid}")
	private String			siteid;
	
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 12
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 배너 페이지 이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/banner.do")
	public ModelAndView doMoveBanner(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("/lms/admin/site/banner/adminBanner.admin");
		paraMap.put("siteid", siteid);
		mav.addObject("paraMap", paraMap);

		return mav;
	}
	
	/**
	 *
	 * @Author   : ijpark
	 * @Date	 : 2020. 5. 12
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 배너 리스트 조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listBanner.do")
	public ModelAndView doListBanner(@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav =new ModelAndView("jsonView");	
		
		paraMap.put("siteid", siteid);
		
		try {
			//총 데이터 갯수
			int totalCount= bannerService.doCountBanner(paraMap);
			
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
			mav.addObject("rows",    bannerService.doListBanner(paraMap));
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 18
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 배너순번체크
	 * @Explain :
	 */
	@RequestMapping(value="/checkBanner.do") 
	public ModelAndView doCheckBanner(@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("jsonView");
		
		try { 
			mav.addObject("check",bannerService.doCheckBanner(paraMap)); 
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
		
	
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 13
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 
	 * @Explain :
	 */
	@RequestMapping(value="/updateBannerIdx.do") 
	public ModelAndView doUpdateBannerIdx(@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("jsonView");
		
		try { 
			bannerService.doUpdateBannerIdx(paraMap); 
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 12
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 배너 수정 팝업
	 * @Explain :
	 */
	@RequestMapping(value="/updateBannerForm.do") 
	public ModelAndView doUpdateBannerForm(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("/lms/admin/site/banner/updateBannerForm.adminPopup");
		mav.addObject("paraMap",paraMap);
		
		try { 
			DataMap banner = bannerService.doGetBanner(paraMap);
			mav.addObject("banner", banner);
			mav.addObject("bannerPcd", bannerService.doListBannerPcd(paraMap));
			mav.addObject("bannerTcd", bannerService.doListBannerTcd(paraMap));
			
			String name = FileUtil.getFileName(request, (String)banner.get("banner_img"));
			mav.addObject("viewName", name);
			
		} catch(Exception e) { 
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
		
	/**
	 * @Author : ijpark
	 * @Date : 2020. 5. 12
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 배너 수정
	 * @Explain :
	 */
	@RequestMapping(value="/updateBanner.do") 
	public ModelAndView doUpdateBanner(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav= new ModelAndView("jsonView");
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		
		try {	
			System.out.println("paraMap : " + paraMap.toString());
			paraMap.put("banner_img", FileUtil.viewUpload(paraMap, request, "view/banner/" + paraMap.get("banner_seq")));
			bannerService.doUpdateBanner(paraMap);			
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
	 * @Function : 배너 게시판 등록 팝업
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/insertBannerForm.do")
	public ModelAndView doInsertBannerForm(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/admin/site/banner/insertBannerForm.adminPopup");	
		mav.addObject("paraMap", paraMap);
		paraMap.put("siteid", siteid);
		
		try {						
			mav.addObject("bannerPcd", bannerService.doListBannerPcd(paraMap));
			mav.addObject("bannerTcd", bannerService.doListBannerTcd(paraMap));
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
	 * @Function : 배너 게시판 등록
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/insertBanner.do")
	public ModelAndView doInsertBanner(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		logger.info("paraMap : " + paraMap.toString());
		paraMap.put("userid", request.getSession().getAttribute("userid"));
		paraMap.put("siteid", siteid);
		
		try {
			paraMap.put("seq_tblnm", "TA_BANNER");
			int bannerSeq = this.seqService.doAddAndGetSeq(paraMap);
			paraMap.put("banner_seq", bannerSeq);	 
		    paraMap.put("banner_img", FileUtil.viewUpload(paraMap, request, "view/banner/" + bannerSeq));	
			bannerService.doInsertBanner(paraMap);
		}catch (Exception e) {
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
	 * @Function : 배너 게시판 삭제
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/deleteBanner.do")
	public ModelAndView doDeleteBanner(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("banner_seq", paraMap.get("banner_seq"));
		
		try {
			String bannerImg = paraMap.getstr("banner_img");
			bannerService.doDeleteBanner(paraMap);
			FileUtil.removeFile(request, bannerImg);
			FileUtil.removeDir(request, StringUtil.substring(bannerImg, 0, bannerImg.lastIndexOf("/")));
		}catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 * @Author : sgchoi
	 * @Date : 2020. 5. 22
	 * @param : dataMap
	 * @Return : ModelAndView
	 * @Function : 배너 이미지 삭제
	 * @Explain :
	 */
	@RequestMapping(value="/deleteBannerView.do") 
	public ModelAndView doDeleteBannerView(@ModelAttribute("paraMap")DataMap paraMap, HttpServletRequest request, HttpServletResponse response) { 
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {			
			bannerService.doDeleteBannerView(paraMap);	
			FileUtil.removeFile(request, (String)paraMap.get("banner_img"));
			
		} catch(Exception e) { 
			e.printStackTrace();
		}
		
		return mav;
	}		
}
