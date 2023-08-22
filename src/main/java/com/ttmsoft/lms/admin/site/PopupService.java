package com.ttmsoft.lms.admin.site;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class PopupService extends BaseSvc<DataMap>{
	/* 팝업 리스트 - 2020/05/25 박인정  */
	public List<DataMap>doListPopup(DataMap paraMap){
		return this.dao.dolistQuery("PopupSQL.doListPopup", paraMap);
	}	
	/* 팝업 카운트 - 2020/05/25 박인정  */
	public int doCountPopup(DataMap paraMap) {
		return this.dao.countQuery("PopupSQL.doCountPopup", paraMap);
	}	
	/* 팝업 등록 - 2020/05/   박인정  */
	public void doInsertPopup(DataMap paraMap) {
		this.dao.insertQuery("PopupSQL.doInsertPopup", paraMap);
	}
	/* 단일 팝업 정보 - 2020/05/ 박인정  */
	public DataMap doGetPopup(DataMap paraMap) { 
		return this.dao.selectQuery("PopupSQL.doGetPopup", paraMap); 
	}	
	/* 팝업 수정 - 2020/05/25  박인정  */
	public void doUpdatePopup(DataMap paraMap) {
		this.dao.updateQuery("PopupSQL.doUpdatePopup", paraMap);
	}
	/* 팝업 삭제 - 2020/05   박인정  */
	public void doDeletePopup(DataMap paraMap) {
		this.dao.deleteQuery("PopupSQL.doDeletePopup", paraMap);
	}
	/* 팝업 이미지 삭제 - 2020/06/05 박인정  */
	public void doDeletePopupView(DataMap paraMap){
		this.dao.updateQuery("PopupSQL.doDeletePopupView", paraMap);
	}
	/* 메인 팝업 리스트 - 2020/05/26 박인정  */
	public List<DataMap>doListMainPopup(DataMap paraMap){
		return this.dao.dolistQuery("PopupSQL.doListMainPopup", paraMap);
	}		
	/* 팝업 코드 정보 가져오기- 2020/06/17 박인정  */
	public List<DataMap> doListPopupCode(DataMap paraMap){
		return this.dao.dolistQuery("PopupSQL.doListPopupCode", paraMap);
	}
}
