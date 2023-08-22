package com.ttmsoft.toaf.object;

import java.io.File;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * <PRE>
 * 기  능	: 기본 파일 정보
 * 파일명	: FileObject.java
 * 패키지	: com.ttmsoft.lms.object
 * 설  명	: 업로드/다운로드에 대한 파일정보를 관리한다.
 * 변경이력	: 
 * 2020.03.03	[PUDDING] - 최초작성
 * 
 * </PRE>
 */
public class FileObject implements Serializable {

	private static final long	serialVersionUID	= -2451686149651102814L;

	/** 원본파일명 */
	private String				fileName	= "";
	/** 임시파일명 */
	private String				realName	= "";
	/** contentType */
	private String				contentType	= "";
	/** 파일일련번호 */
	private long				fileSeq		= 0;
	/** 파일확장자 */
	private String				fileExt		= "";
	/** 파일크기 */
	private long				fileSize	= 0;
	/** 파일경로 */
	private String				filePath	= "";

	/**
	 * @return fileName - 확장자없는 원본파일명 Getter
	 */
	public String getName () {
		return ("".equals(fileName))? "" : fileName.substring(0, fileName.lastIndexOf("."));
	}

	/**
	 * @return fileName - 원본파일명 Getter
	 */
	public String getFileName () {
		return fileName;
	}

	/**
	 * @param fileName - 원본(논리)파일명 Setter
	 */
	public void setFileName (String fileName) {
		this.fileName = (fileName == null || "".equals(fileName.trim()))? "" : fileName;
		if ("".equals(this.realName)) {
			this.realName = fileName;
		}
	}

	/**
	 * @return realName - 임시(물리)파일명 Getter
	 */
	public String getRealName () {
		return realName;
	}

	/**
	 * @param realName - 임시파일명 Setter
	 */
	public void setRealName (String realName) {
		if (realName == null || "".equals(realName.trim())) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
			this.realName = "_imsifile_"+sdf.format(new Date())+"."+getFileExt();
		}
		else {
			this.realName = realName;
		}
	}

	/**
	 * @return contentType - contentType Getter
	 */
	public String getContentType () {
		return contentType;
	}

	/**
	 * @param contentType - contentType Setter
	 */
	public void setContentType (String contentType) {
		this.contentType = contentType;
	}

	/**
	 * @return fileSeq - 파일일련번호 Getter
	 */
	public long getFileSeq () {
		return fileSeq;
	}

	/**
	 * @param fileSeq - 파일일련번호 Setter
	 */
	public void setFileSeq (long fileSeq) {
		this.fileSeq = fileSeq;
	}

	/**
	 * 파일확장자를 구한다.
	 * - 미설정시 원본파일명의 확장자를 반환한다.
	 * @return fileExt - 파일확장자 Getter
	 */
	public String getFileExt () {
		if ("".equals(fileExt) && !"".equals(fileName)) {
			fileExt = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length());
		}
		return fileExt.toLowerCase();
	}

	/**
	 * @param fileExt - 파일확장자 Setter
	 */
	public void setFileExt (String fileExt) {		
		this.fileExt = (null == fileExt || "".equals(fileExt.trim()))? "" : fileExt.toLowerCase();
	}

	/**
	 * 파일크기를 구한다. 
	 * - 미설정시 getPathFile()의 실제 사이즈를 반환한다.
	 * @return fileSize - 파일크기 Getter
	 */
	public long getFileSize () {
		if (fileSize == 0 && !"".equals(getPathFile())) {
			File objFile = new File(getPathFile()); 
			fileSize = objFile.length();
		}
		return fileSize;
	}

	/**
	 * @param fileSize - 파일크기 Setter
	 */
	public void setFileSize (long fileSize) {
		this.fileSize = fileSize;
	}

	/**
	 * @return filePath - 파일경로 Getter
	 */
	public String getFilePath () {
		return filePath;
	}

	/**
	 * @param filePath - 파일경로 Setter
	 */
	public void setFilePath (String filePath) {
		this.filePath = (null == filePath || "".equals(filePath.trim()))? "" : filePath.replace('\\', '/');
	}

	/**
	 * @return pathFile - 전체 파일경로 Getter
	 */
	public String getPathFile () {
		return ("".equals(filePath) || "".equals(realName))? "" : (filePath + "/" + realName).replace('\\', '/');
	}	
	
	public String toString() {
		return "[" + getFileName() + "] " + getPathFile();
	}
	
	public DataMap toDataMap() {
		DataMap dataMap = new DataMap();		
		dataMap.put("content_type", getContentType());
		dataMap.put("name", getName());
		dataMap.put("file_ext", getFileExt());
		dataMap.put("file_name", getFileName());
		dataMap.put("real_name", getRealName());
		dataMap.put("file_path", getFilePath());
		dataMap.put("file_seq", getFileSeq());
		dataMap.put("file_size", getFileSize());
		dataMap.put("path_file", getPathFile());		
		return dataMap;
	}

}
