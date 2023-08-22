package com.ttmsoft.lms.cmm.intercept;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import net.sf.json.JSONSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.StringUtil;

@Service
public class DefaultCheckService extends BaseSvc<DataMap> {

	private Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/* 권한에 대한 전체 메뉴 정보 조회 */
	public String getMenuListJson (HttpServletRequest request, DataMap paraMap) {
		
		paraMap = getMenuPart(request, paraMap);				
		List<DataMap> menuList = this.dao.dolistQuery("DefaultCheckSQL.dolistMenu", paraMap);
		DataMap results = new DataMap();

		String lvl = "";	// 깊이
		String key = "";	// JSON KEY
		String upk = "";	// 상위 메뉴CD

		List<DataMap> currList = new ArrayList<DataMap>();
		for (int idx = 0; idx < menuList.size(); idx++) {
			DataMap item = menuList.get(idx);
			DataMap imsi = new DataMap();

			if (!"".equals(key) && !upk.equals(item.get("up_cd")) && !"1".equals(lvl)) {	// 이전결과 등록 및 초기화
				//logger.debug("\n\n[  "+key+"  ] :\n"+ JSONSerializer.toJSON(currList.toArray()).toString());
				results.put(key, currList.toArray());
				currList.clear();
			}

			lvl = item.get("menu_lvl").toString();
			upk = item.get("up_cd").toString();
			key = "menuinfo_" + upk;
			imsi.put("menucd"	, item.get("menucd"));
			imsi.put("upcd"		, item.get("up_cd"));
			imsi.put("menunm"	, String.valueOf(item.get("menunm" + getLanguageCode(request))));
			imsi.put("menucss"	, item.get("menu_css"));
			imsi.put("menuicon"	, item.get("menu_icon"));
			imsi.put("menuurl"	, item.get("menu_url"));
			imsi.put("menulvl"	, item.get("menu_lvl"));
			currList.add(imsi);
		}
		results.put(key, currList.toArray());

		return JSONSerializer.toJSON(results).toString();
	}

	/* 메뉴 단건 정보 조회 */
	public String getoneMenuInfoJson (HttpServletRequest request, DataMap paraMap) {
		paraMap.put("parent_uri", request.getParameter("parent_uri"));
		DataMap result = this.dao.selectQuery("DefaultCheckSQL.getoneMenu", paraMap);		
		if (result != null) {	
			request.setAttribute("menucd", result.get("menucd"));
			result.put("menunm", String.valueOf(result.get("menunm" + getLanguageCode(request))));		
		}
		return JSONSerializer.toJSON(result).toString();
	}
	
	/* 사용권한(등록, 수정, 삭제) 조회 */
	public String getUseAuthJson (HttpServletRequest request, DataMap paraMap) {
		//단건 메뉴정보가 있는 경우
		if(null != request.getAttribute("menucd")) { 
			paraMap.put("menucd", request.getAttribute("menucd"));
		//단건 메뉴	정보가 없는 경우(메뉴 권한 정보가 필요한 경우)
		}else if(null != request.getParameter("menucd")) {
			paraMap.put("menucd", request.getParameter("menucd"));
		}
		
		DataMap result = this.dao.selectQuery("DefaultCheckSQL.getUseAuth", paraMap);
		return JSONSerializer.toJSON(result).toString();
	}

	/* 쪽지 정보 조회 */
	public DataMap getMessageMap (DataMap paraMap) {
		DataMap result = new DataMap();
		if (paraMap.get("userno") != null) {
			result.put("new_message", this.dao.countQuery("DefatulCheckSQL.countNewMessage", paraMap));
			result.put("total_message", this.dao.countQuery("DefatulCheckSQL.countTotalMessage", paraMap));
		}
		return result;
	}

	/* 메뉴 대상 구분 메소드 */
	private DataMap getMenuPart (HttpServletRequest request, DataMap paraMap) {

		String reqUri = request.getRequestURI();

		if (reqUri.indexOf("/master/") > -1) {
			paraMap.put("menu_tcd", "MENU_T003");
		}
		else if (reqUri.indexOf("/admin/") > -1) {
			paraMap.put("menu_pcd", "MENU_P006");		// 메인메뉴
			paraMap.put("menu_tcd", "MENU_T004");		// 관리자메뉴		
		}
		else if (reqUri.indexOf("/front/") > -1) {
			paraMap.put("menu_pcd", "MENU_P006");		// 메인메뉴
			paraMap.put("menu_tcd", "MENU_T001");		// 관리자메뉴		
		}
		else {
			paraMap.put("menu_tcd", "MENU_T006");
		}
		return paraMap;
	}

	/* 언어코드 추출 메소드 */
	private String getLanguageCode (HttpServletRequest request) {

		String langCd = StringUtil.nchk((String) request.getSession().getAttribute("sess_lang"));
		String result = "";

		if (!langCd.equals("ko") && !langCd.equals("")) {
			result += "_" + langCd;
		}
		return result;
	}

	public void doInsertActionLog (DataMap dataMap) {
		this.dao.insertQuery("DefatulCheckSQL.doInsertActionLog", dataMap);
	}
	
	public int doCountAdminMenuAuth (DataMap dataMap) {
		return this.dao.countQuery("DefatulCheckSQL.doCountAdminMenuAuth", dataMap);
	}
}
