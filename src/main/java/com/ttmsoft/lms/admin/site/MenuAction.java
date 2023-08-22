package com.ttmsoft.lms.admin.site;

import java.util.ArrayList;
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
@RequestMapping ("/admin")
public class MenuAction extends BaseAct{
	
	@Autowired
	private MenuService menuService;
	
	@Value ("${siteid}")
	private String siteid;
		
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 7
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴관리페이지이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/menu.do")
	public ModelAndView doMenu(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/admin/site/menu/adminMenu.admin");
		paraMap.put("siteid", siteid);
		//메뉴 구분 리스트 조회
		mav.addObject("menuListPCD", menuService.doListMenuPCD(paraMap));
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 7
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴트리리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listTreemenu.do")
	public ModelAndView doListTreeMenu(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("locale", RequestContextUtils.getLocale(request).toString());
		try {
			//홈페이지 및 관리자 Menu Tree
			List<DataMap> adminMenuList = menuService.doListMenuTree(paraMap);	
			String strMenuTree = stringChange(adminMenuList);
			mav.addObject("strMenuTree", strMenuTree);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 7
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴정보가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/menuGetInfo.do")
	public ModelAndView doMenuGetInfo(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		try {
			mav.addObject("menuInfo", menuService.doGetMenuInfo(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 7
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴옵션
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/menuOption.do")
	public ModelAndView doMenuOption(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		try {
			logger.info("메뉴관련 데이터들 : " + paraMap.toString());
			System.out.println("mode : " + paraMap.get("mode"));
			if(paraMap.get("mode").equals("MI")) {
				List<DataMap> list = new ArrayList<DataMap>();
				List<DataMap> authAllList = menuService.doListAuth(paraMap);
				for(int i = 0; i < authAllList.size(); i++) {
					DataMap data = new DataMap();		
					data.put("menuauth_seq", (menuService.doGetMaxMenuAuthSeq(paraMap) + i));
					data.put("role_pcd", authAllList.get(i).get("commcd"));
					list.add(data);
				}
				paraMap.put("list", list);
				menuService.doInsertMainMenu(paraMap);
			}
			else if(paraMap.get("mode").equals("SI")) {
				List<DataMap> list = new ArrayList<DataMap>();
				List<DataMap> authAllList = menuService.doListAuth(paraMap);
				for(int i = 0; i < authAllList.size(); i++) {
					DataMap data = new DataMap();		
					data.put("menuauth_seq", (menuService.doGetMaxMenuAuthSeq(paraMap) + i));
					data.put("role_pcd", authAllList.get(i).get("commcd"));
					list.add(data);
				}
				paraMap.put("list", list);
				menuService.doInsertSubMenu(paraMap);
			}
			else if(paraMap.get("mode").equals("U")) {
				String[] str_menucdList = request.getParameterValues("menucdList");
				List<DataMap> list = new ArrayList<DataMap>();
				System.out.println(str_menucdList);
				if(str_menucdList != null) {
					for(int i = 0; i < str_menucdList.length; i++) {
						DataMap data = new DataMap();
						data.put("menucd", str_menucdList[i]);
						list.add(data);
					}
				}
				paraMap.put("list", list);
				menuService.doUpdateMenu(paraMap);
			}
			else if(paraMap.get("mode").equals("D")) {
				List<DataMap> list = new ArrayList<DataMap>();
				List<DataMap> authAllList = menuService.doListAuth(paraMap);
				for(int i = 0; i < authAllList.size(); i++) {
					DataMap data = new DataMap();		
					data.put("role_pcd", authAllList.get(i).get("commcd"));
					list.add(data);
				}
				List<DataMap> menucdList = new ArrayList<DataMap>();
				String[] str_menucdList = request.getParameterValues("menucdList");
				for(int i = 0; i < str_menucdList.length; i++) {
					DataMap data = new DataMap();
					data.put("menucd", str_menucdList[i]);
					menucdList.add(data);
				}
				System.out.println(menucdList);
				paraMap.put("cdlist", menucdList);
				paraMap.put("list", list);
				menuService.doDeleteMenu(paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : sgchoi
	 * @Date	 : 2020. 6. 3
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴이동처리
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/updateMoveMenu.do")
	public ModelAndView doUpdateMoveMenu(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {
			
			if(!("").equals(paraMap.get("subMenuList"))){
				
				List<DataMap> list = new ArrayList<DataMap>();
				String[] subMenusList = (String[])paraMap.get("subMenuList");

				for(int i = 0; i < subMenusList.length; i++) {
					DataMap data = new DataMap();
					data.put("menucd", subMenusList[i]);
					data.put("menu_idx", (i+1));
					list.add(data);
				}
				
				if(list.size() > 0) {
					paraMap.put("list", list);
					menuService.doUpdateMoveMenu(paraMap);
				}
			}		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}		
		return mav;
	}
	
	
	private String stringChange(List<DataMap> list) {
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).get("menu_lvl").toString().equals("1")) {
				sb.append("<li id='" + list.get(i).get("menucd") + "' value='" + list.get(i).get("menu_lvl") + "'><a href='#'>" + list.get(i).get("menunm") + "</a>");
				sb.append("<ul>");
					for(int j = i + 1; j < list.size(); j++) {
						if(list.get(j).get("menu_lvl").toString().equals("2") && list.get(i).get("menucd").equals(list.get(j).get("up_cd"))) {
							sb.append("<li id='" + list.get(j).get("menucd") + "' value='" + list.get(j).get("menu_lvl") + "'><a href='#'>" + list.get(j).get("menunm") + "</a>");
							sb.append("<ul>");
							for(int h = j + 1; h < list.size(); h++) {
								if(list.get(h).get("menu_lvl").toString().equals("3") && list.get(j).get("menucd").equals(list.get(h).get("up_cd"))) {
									sb.append("<li id='" + list.get(h).get("menucd") + "' value='" + list.get(h).get("menu_lvl") + "'><a href='#'>" + list.get(h).get("menunm") + "</a>");
								}
							}
							sb.append("</ul>");
						}
					}
					sb.append("</li>");
					sb.append("</ul>");
			}
			sb.append("</li>");
		}
		sb.append("</ul>");
		return sb.toString();
	}
}
