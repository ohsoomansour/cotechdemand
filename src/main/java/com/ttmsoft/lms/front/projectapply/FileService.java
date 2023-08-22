package com.ttmsoft.lms.front.projectapply;

import java.text.DecimalFormat;
import java.util.List;

import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class FileService extends BaseSvc<DataMap>{
	
	/* 파일 마스터 생성 */
	public long createFileMst(DataMap paraMap) {
		this.dao.insertQuery("FileSQL.createFmst",paraMap);
		
		return Long.parseLong(paraMap.get("fmst_seq").toString());
	}

	public int saveFileSvl(DataMap paraMap) {
		return this.dao.insertQuery("FileSQL.createFsvl", paraMap);
	}

	public List<DataMap> getFileList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("FileSQL.getFileList", paraMap);
		List<DataMap> transResult = trnasFileSize(result);
		return  transResult;
	}
	
	public DataMap getFile(DataMap paraMap) {
		return this.dao.selectQuery("FileSQL.getFile", paraMap);
	}

	public int modifyFile(DataMap paraMap) {
		return this.dao.updateQuery("FileSQL.modifyFile",paraMap);		
	}
	
	public int deleteFile(DataMap paraMap) {
		return this.dao.updateQuery("FileSQL.deleteFile",paraMap);
	}
	
	public List<DataMap> getFileListToZip(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("FileSQL.getFileSlv", paraMap);
		List<DataMap> transResult = trnasFileSize(result);
		return  transResult;
		//return this.dao.dolistQuery("FileSQL.getFileSlv", paraMap);
	}
	
	public List<DataMap> trnasFileSize(List<DataMap> paraMap){
		String[] s = { "bytes", "KB", "MB", "GB", "TB", "PB" };
		for(int i=0; i<paraMap.size();i++) {
			String bytes = paraMap.get(i).getstr("f_size");
			String retFormat = "0";
			Double size = Double.parseDouble(bytes);
			if (bytes != "0") {
                int idx = (int) Math.floor(Math.log(size) / Math.log(1024));
                DecimalFormat df = new DecimalFormat("#,###.##");
                double ret = ((size / Math.pow(1024, Math.floor(idx))));
                retFormat = df.format(ret) +  s[idx];
           } else {
                retFormat += " " + s[0];
           }
			paraMap.get(i).put("trans_size", retFormat);
		}
		
		return paraMap;
	}
	public List<DataMap> getFileCode(DataMap paraMap){
		List<DataMap> list = this.dao.dolistQuery("FileSQL.getFileCode",paraMap);
		return list;
	}
}
