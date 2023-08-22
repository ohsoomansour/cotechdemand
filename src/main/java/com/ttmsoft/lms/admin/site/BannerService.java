package com.ttmsoft.lms.admin.site;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class BannerService extends BaseSvc<DataMap>{
	/* 배너 카운트 - 2020/05/12 박인정  */
	public int doCountBanner(DataMap paraMap) {
		return this.dao.countQuery("BannerSQL.doCountBanner", paraMap);
	}
	/* 배너 순번 체크 - 2020/05/12 박인정  */
	public int doCheckBanner(DataMap paraMap){
		return this.dao.countQuery("BannerSQL.doCheckBanner", paraMap);
	}
	/* 배너 리스트 - 2020/05/18 박인정  */
	public List<DataMap>doListBanner(DataMap paraMap){
		return this.dao.dolistQuery("BannerSQL.doListBanner", paraMap);
	}	
	/* 배너 순번 수정 - 2020/05/13 박인정  */
	public void doUpdateBannerIdx(DataMap paraMap) {
		this.dao.updateQuery("BannerSQL.doUpdateBannerIdx", paraMap);
	}
	/* 배너 정보 - 2020/05/12 박인정  */
	public DataMap doGetBanner(DataMap paraMap) { 
		return this.dao.selectQuery("BannerSQL.doGetBanner", paraMap); 
	}
	/* 배너 수정 - 2020/05/12 박인정  */
	public void doUpdateBanner(DataMap paraMap) {
		this.dao.updateQuery("BannerSQL.doUpdateBanner", paraMap);
	}
	/* 배너 등록 - 2020/05/   박인정  */
	public void doInsertBanner(DataMap paraMap) {	
		this.dao.insertQuery("BannerSQL.doInsertBanner", paraMap);
	}
	/* 배너 삭제 - 2020/05/  박인정  */
	public void doDeleteBanner(DataMap paraMap) {
		this.dao.deleteQuery("BannerSQL.doDeleteBanner", paraMap);
	}
	/* 배너 코드 리스트Pcd - 2020/05/20 박인정  */
	public List<DataMap>doListBannerPcd(DataMap paraMap){
		return this.dao.dolistQuery("BannerSQL.doListBannerPcd", paraMap);
	}	
	/* 배너 코드 리스트Tcd - 2020/05/20 박인정  */
	public List<DataMap>doListBannerTcd(DataMap paraMap){
		return this.dao.dolistQuery("BannerSQL.doListBannerTcd", paraMap);
	}	
	/* 배너 코드 리스트Tcd - 2020/05/20 박인정  */
	public void doDeleteBannerView(DataMap paraMap){
		this.dao.updateQuery("BannerSQL.doDeleteBannerView", paraMap);
	}
	/* 메인 배너 리스트 - 2020/05/25 박인정  */
	public List<DataMap>doListMainBanner(DataMap paraMap){
		return this.dao.dolistQuery("BannerSQL.doListMainBanner", paraMap);
	}		
}
