package com.ttmsoft.lms.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.object.DataMap;

@Controller
public class MainAction {
	@RequestMapping ("/")
	public ModelAndView doMain (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
		
		try {
			String member_seqno = request.getSession().getAttribute("member_seqno").toString();
			ModelAndView mv = new ModelAndView("redirect:/front/mainView.do");
			return mv;
		}catch(Exception e) {
			ModelAndView mv = new ModelAndView("redirect:/front/login.do");
			return mv;
		}
		
	}
}
