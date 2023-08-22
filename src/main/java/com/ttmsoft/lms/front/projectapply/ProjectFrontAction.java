package com.ttmsoft.lms.front.projectapply;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.login.LoginFrontService;
import com.ttmsoft.lms.front.member.MemberFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileUtil;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;


/**
 * 
 * @Package	 : com.ttmsoft.lms.cmm.site
 * @File	 : BoardAction.java
 * 
 * @Author   : psm
 * @Date	 : 2021. 4. 05.
 * @Explain  : 사업공고 
 *
 */
@Controller
@RequestMapping ("/project")
public class ProjectFrontAction extends BaseAct{
	@Autowired
	private ProjectFrontService applyFrontService;
	
	@Autowired
	private FileService fileService;

	@Value ("${siteid}")
	private String siteid;	
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2021. 4. 05. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사업공고 리스트
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/list.do", method = RequestMethod.GET)
	public ModelAndView doList(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String member_seqno = session.getAttribute("member_seqno").toString();
		paraMap.put("member_seqno", member_seqno);
		
		
		System.out.println(">>>>>>>>>>>>>>"+session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>"+session);
		ModelAndView mav = new ModelAndView("/lms/front/project/projectList.front");	
		if(paraMap.getstr("project_year").equals("")) {
			paraMap.put("project_year", 2021);
		}
		mav.addObject("paraMap", paraMap);
		
		try {
			// 게시글 개수
			int totalCount = this.applyFrontService.countList(paraMap);
			
			paraMap.put("count",totalCount);
			// --------------------------------------------------------------------------
			//현재페이지
			String page = StringUtil.nchk((String)(paraMap.get("page")),"1");
			//페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String)(paraMap.get("rows")),"10");
			//게시물 정렬 위치
			String sidx = StringUtil.nchk((String)(paraMap.get("sidx")),"1");
			//게시물 정렬차순
			String sord = StringUtil.nchk((String)(paraMap.get("sord")),"asc");
			//페이지 그룹 수
		
			int pageGroups = 5;
			
			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);
		
			mav.addObject("sPageInfo",new PageInfo().makeIndex(Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.applyFrontService.doListBoard(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "공고");
			navi.put("two", "공고 현황");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오"+paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}	
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2021. 4. 05. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사업공고 상세보기
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/detail.do", method = RequestMethod.POST)
	public ModelAndView doDetail(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("/lms/front/project/projectDetail.front");	
	
		try {
			System.out.println("초반에데이터가들어와?"+paraMap);
			DataMap result = applyFrontService.getDetailData(request, paraMap);
			String fmst_seq = result.getstr("fmst_seq").toString();
			if(!("").equals(fmst_seq)) {
				List<DataMap> fileList = fileService.getFileListToZip(result);
				mav.addObject("fileList", fileList);
			}
			mav.addObject("fmst_seq",fmst_seq);
			mav.addObject("paraMap", result);
			DataMap navi = new DataMap();
			navi.put("one", "공고");
			navi.put("two", "공고 상세");
			mav.addObject("navi",navi);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 4. 15.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 파일업로드
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/uploadFile.do", method = RequestMethod.POST)
	public ModelAndView fileUpload(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("jsonView");

		try {

			List<MultipartFile> multipartFiles = (List<MultipartFile>) paraMap.get("upload"); // 첨부 된 파일
			List<DataMap> files = new ArrayList<DataMap>();

			int attfSeq = 0;
			int fileCnt = multipartFiles.size();
			String somePath = "apply/file/" ;

			for (int i = 0; i < fileCnt; i++) {
				DataMap file = FileUtil.fileUpload(multipartFiles.get(i), request, somePath);
				file.put("attf_seq", attfSeq);
				files.add(file);
			}

			if (files.size() > 0) {
				paraMap.put("files", files);
			}

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	

	
	
		
}
