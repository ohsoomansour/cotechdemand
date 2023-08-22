package com.ttmsoft.lms.cmm.login;


import java.util.List;
import org.springframework.stereotype.Service;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class LoginService extends BaseSvc<DataMap> {

	public DataMap getoneUserCount (DataMap paraMap) {
		return this.dao.selectQuery("LoginSQL.getoneUserCount", paraMap);
	}

	public int countUserInfo (DataMap paraMap) {
		return this.dao.countQuery("LoginSQL.countUserInfo", paraMap);
	}

	public DataMap getoneUserInfo (DataMap paraMap) {
		return this.dao.selectQuery("LoginSQL.getoneUserInfo", paraMap);
	}

	public List<DataMap> dolistUserInfo (DataMap paraMap) {
		return this.dao.dolistQuery("LoginSQL.dolistUserInfo", paraMap);
	}

	public int appendLogConnect (DataMap paraMap) {
		return this.dao.insertQuery("LoginSQL.appendLogConnect", paraMap);
	}
	
	public int modifyLogin (DataMap paraMap) {
		return this.dao.updateQuery("LoginSQL.modifyLogin", paraMap);
	}
	
	public int doCountAdminMenuAuth (DataMap dataMap) {
		return this.dao.countQuery("LoginSQL.doCountAdminMenuAuth", dataMap);
	}
	
	/*		바우처 로그인		*/
	
	public int doCountUserInfo(DataMap paraMap) {
		return this.dao.countQuery("LoginSQL.doCountUserInfo", paraMap);
	}
	
	public DataMap doGetOneUserInfo(DataMap paraMap) {
		return this.dao.selectQuery("LoginSQL.doGetOneUserInfo", paraMap);
	}
}
