package com.ttmsoft.toaf.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ttmsoft.toaf.object.FileObject;

/**
 * <PRE>
 * 기  능	: 
 * 파일명	: FileUploadUtil.java
 * 패키지	: ttmsoft.toaf.file
 * 설  명	: 
 * 변경이력	: 
 * 2017. 3. 12.	[pudding] - 최초작성
 * </PRE>
 */
public class UploadUtil {

	/**
	 * 별도 물리파일생성 업로드
	 * <PRE>
	 * 함수명	: doFileUpload
	 * 설  명	: 별도 물리파일생성 업로드 수행
	 * 물리파일명 - [년월일시분초]_[파일크기]_[UUID8].확장자
	 * 
	 * FileUploadUtil.doFileUpload(request, "/upload/board");
	 * </PRE>
	 * 
	 * @param request - HttpServletRequest
	 * @param filePath - 파일경로 (/upload/file)
	 * @return - 업로드 FileObject List
	 */
	public static List<FileObject> doFileUpload (HttpServletRequest request, String filePath) {
		List<FileObject> uploadList = new ArrayList<FileObject>();
		try {
			MultipartHttpServletRequest mpRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = mpRequest.getFileNames();
			
			while (iterator.hasNext()) {
				MultipartFile mpFile = mpRequest.getFile(iterator.next());
				long fileSize = mpFile.getSize();

				if (fileSize > 0) {
					makeFilePath(filePath);

					FileObject fileObj = new FileObject();
					fileObj.setFilePath(filePath);
					fileObj.setFileName(mpFile.getOriginalFilename());
					fileObj.setRealName(getRandomName(fileSize) + "." + fileObj.getFileExt());
					fileObj.setContentType(mpRequest.getContentType());
					fileObj.setFileSize(fileSize);

					File copyFile = new File(fileObj.getPathFile());
					mpFile.transferTo(copyFile);
					copyFile.setExecutable(true);

					uploadList.add(fileObj);
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	/**
	 * 별도 물리파일생성 업로드
	 * <PRE>
	 * 함수명	: doFileUpload
	 * 설  명	: 접두어 기반의 별도 물리파일생성 업로드 수행
	 * 물리파일명 - [접두어]_[년월일시분초]_[파일크기]_[UUID8].확장자
	 * 
	 * FileUploadUtil.doFileUpload(request, "/upload/board", "prefix");
	 * </PRE>
	 * 
	 * @param request - HttpServletRequest
	 * @param filePath - 파일경로 (/upload/file)
	 * @param prefixName - 물리파일명 접두어
	 * @return - 업로드 FileObject List
	 */
	public static List<FileObject> doFileUpload (HttpServletRequest request, String filePath, String prefixName) {
		List<FileObject> uploadList = new ArrayList<FileObject>();
		try {
			MultipartHttpServletRequest mpRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = mpRequest.getFileNames();

			while (iterator.hasNext()) {
				MultipartFile mpFile = mpRequest.getFile(iterator.next());
				long fileSize = mpFile.getSize();

				if (fileSize > 0) {
					makeFilePath(filePath);

					FileObject fileObj = new FileObject();
					fileObj.setFilePath(filePath);
					fileObj.setFileName(mpFile.getOriginalFilename());
					fileObj.setRealName(prefixName + "_" + getRandomName(fileSize) + "." + fileObj.getFileExt());	// 물리파일명 : {접두어}_[01..99]
					fileObj.setContentType(mpRequest.getContentType());
					fileObj.setFileSize(fileSize);

					File copyFile = new File(fileObj.getPathFile());
					mpFile.transferTo(copyFile);
					copyFile.setExecutable(true);

					uploadList.add(fileObj);
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	/**
	 * 원본파일 유지 업로드
	 * <PRE>
	 * 함수명	: doFileSimpleUpload
	 * 설  명	: 원본파일 유지 업로드 (원본파일명과 물리파일명 동일)
	 * 물리파일명 - [원본파일명]_[년월일시분초].확장자
	 * 
	 * FileUploadUtil.doFileSimpleUpload(request, "/upload/board");
	 * </PRE>
	 * @param request - HttpServletRequest
	 * @param filePath - 파일경로 (/upload/file)
	 * @return - 업로드 FileObject List
	 */
	public static List<FileObject> doFileSimpleUpload (HttpServletRequest request, String filePath) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
		List<FileObject> uploadList = new ArrayList<FileObject>();

		try {
			MultipartHttpServletRequest mpRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = mpRequest.getFileNames();

			while (iterator.hasNext()) {
				MultipartFile mpFile = mpRequest.getFile(iterator.next());
				long fileSize = mpFile.getSize();

				if (fileSize > 0) {
					makeFilePath(filePath);

					FileObject fileObj = new FileObject();
					fileObj.setFilePath(filePath);
					fileObj.setFileName(mpFile.getOriginalFilename());

					if ((new File(fileObj.getPathFile())).exists()) {	// 동일 파일명 존재여부 확인
						fileObj.setRealName(fileObj.getName() + "_" + sdf.format(new Date()) + "." + fileObj.getFileExt());
						fileObj.setFileName(fileObj.getRealName());
					}
					fileObj.setContentType(mpRequest.getContentType());
					fileObj.setFileSize(fileSize);

					File copyFile = new File(fileObj.getPathFile());
					mpFile.transferTo(copyFile);
					copyFile.setExecutable(true);

					uploadList.add(fileObj);
				}
			}

		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	/**
	 * 별도 물리파일생성 DataMap 업로드
	 * <PRE>
	 * 함수명	: doFileUpload
	 * 설  명	: 별도 물리파일생성 DataMap 업로드 수행
	 * 물리파일명 - [년월일시분초]_[파일크기]_[UUID8].확장자
	 * 
	 * FileUploadUtil.doFileUpload(dataMap.get("Filedata"), "/upload/board");
	 * </PRE>
	 * @param mpFileList - dataMap.get(업로드폼명)
	 * @param filePath - 파일경로 (/upload/file)
	 * @return - 업로드 FileObject List
	 */
	public static List<FileObject> doFileUpload (Object mpFileList, String filePath) {
		List<FileObject> uploadList = new ArrayList<FileObject>();
		try {
			if (mpFileList instanceof List) {
				List<?> list = (List<?>) mpFileList;
				for (Object item : list) {					
					if (item instanceof MultipartFile) {
						MultipartFile mpFile = (MultipartFile) item;
						long fileSize = mpFile.getSize();
			
						if (fileSize > 0) {
							makeFilePath(filePath);
			
							FileObject fileObj = new FileObject();
							fileObj.setFilePath(filePath);
							fileObj.setFileName(mpFile.getOriginalFilename());
							fileObj.setRealName(getRandomName(fileSize) + "." + fileObj.getFileExt());	// 물리파일명 : real_[yyyyMMddHHmmssSSS]
							fileObj.setFileSize(fileSize);
			
							File copyFile = new File(fileObj.getPathFile());
							mpFile.transferTo(copyFile);
							copyFile.setExecutable(true);
							
							uploadList.add(fileObj);
						}
					}
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	/**
	 * 특정 물리파일생성 DataMap 업로드
	 * <PRE>
	 * 함수명	: doFileUpload
	 * 설  명	: 특정 물리파일생성 DataMap 업로드 수행 (rename)
	 * 물리파일명 - [changeName].확장자
	 * 
	 * FileUploadUtil.doFileUpload(dataMap.get("Filedata"), "/upload/board", "board_1_347");
	 * </PRE>
	 * @param mpFileList - dataMap.get(업로드폼명)
	 * @param filePath - 파일경로 (/upload/file)
	 * @param changeName - 변경할 물리파일명
	 * @return - 업로드 FileObject
	 */
	public static List<FileObject> doFileUpload (Object mpFileList, String filePath, String changeName) {
		List<FileObject> uploadList = new ArrayList<FileObject>();
		try {
			if (mpFileList instanceof List) {
				List<?> list = (List<?>) mpFileList;
				for (Object item : list) {					
					if (item instanceof MultipartFile) {
						MultipartFile mpFile = (MultipartFile) item;
						long fileSize = mpFile.getSize();
		
						if (fileSize > 0) {
							makeFilePath(filePath);
			
							FileObject fileObj = new FileObject();
							fileObj.setFilePath(filePath);
							fileObj.setFileName(mpFile.getOriginalFilename());
							fileObj.setRealName(changeName + "." + fileObj.getFileExt());	// 물리파일명 : changeName
							fileObj.setFileSize(fileSize);
			
							File copyFile = new File(fileObj.getPathFile());
							mpFile.transferTo(copyFile);
							copyFile.setExecutable(true);
							
							uploadList.add(fileObj);
						}
					}
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	/**
	 * 원본파일 유지 DataMap 업로드
	 * <PRE>
	 * 함수명	: doFileSimpleUpload
	 * 설  명	: 원본파일 유지 DataMap 업로드 (원본파일명과 물리파일명 동일)
	 * 물리파일명 - [원본파일명]_[년월일시분초].확장자
	 * 
	 * FileUploadUtil.doFileSimpleUpload(dataMap.get("Filedata"), "/upload/board");
	 * </PRE>
	 * @param mpFileList - dataMap.get(업로드폼명)
	 * @param filePath - 파일경로 (/upload/file)
	 * @return - 업로드 FileObject List
	 */
	public static List<FileObject> doFileSimpleUpload (Object mpFileList, String filePath) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
		List<FileObject> uploadList = new ArrayList<FileObject>();
		try {
			if (mpFileList instanceof List) {
				List<?> list = (List<?>) mpFileList;
				for (Object item : list) {					
					if (item instanceof MultipartFile) {
						MultipartFile mpFile = (MultipartFile) item;
						long fileSize = mpFile.getSize();
		
						if (fileSize > 0) {
							makeFilePath(filePath);
			
							FileObject fileObj = new FileObject();
							fileObj.setFilePath(filePath);
							fileObj.setFileName(mpFile.getOriginalFilename());
			
							if ((new File(fileObj.getPathFile())).exists()) {	// 동일 파일명 존재여부 확인
								fileObj.setRealName(fileObj.getName() + "_" + sdf.format(new Date()) + "." + fileObj.getFileExt());
								fileObj.setFileName(fileObj.getRealName());
							}
							fileObj.setFileSize(fileSize);					
							//System.out.println("==> " + fileObj.toString());
			
							File copyFile = new File(fileObj.getPathFile());
							mpFile.transferTo(copyFile);
							copyFile.setExecutable(true);
							
							uploadList.add(fileObj);
						}
					}
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			uploadList = null;
		}
		return uploadList;
	}

	//---------------------------------------------------------------
	// 폴더만들기
	//---------------------------------------------------------------
	public static String makeFilePath (String path) {
		if ((null == path) || "".equals(path)) return "";
		path = path.replace('\\', '/');

		String result = "";
		String filePath = "";
		String[] fileList = path.split("/", -1);
		if (null != fileList) {
			for (int idx = 0; idx < fileList.length; idx++) {
				if (fileList[idx] == null || "".equals(fileList[idx].trim())) continue;
				filePath = filePath + fileList[idx] + "/";

				File file = new File(filePath);
				if (!file.exists()) file.mkdir();
				file.setExecutable(true);
				result = file.getPath();
			}
		}

		return result.replace('\\', '/');
	}
	
	//---------------------------------------------------------------
	// 랜덤파일명 : [년월일시분초]_[파일크기]_[UUID8]
	//---------------------------------------------------------------
	public static String getRandomName(long len) {
		String str = UUID.randomUUID().toString().toUpperCase();
		if (str.length() > 8) str = str.substring(0, 8);
		
		return new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + "_" + len + "_" + str;
	}

	//---------------------------------------------------------------
	// 디렉토리내 유사 파일명 번호부여
	//---------------------------------------------------------------
	public static String seqFile (String path, String file) {
		if ((null == path) || "".equals(path)) return "";
		if ((null == file) || "".equals(file)) return "";
		path = path.replace('\\', '/');

		File srcPath = new File(path);
		if (!srcPath.isDirectory()) return "";

		File[] subFiles = srcPath.listFiles();
		int seq = 0;
		for (int idx = 0; idx < subFiles.length; idx++) {
			File srcFile = subFiles[idx];
			if (srcFile.isDirectory()) continue;
			if (srcFile.getName().toLowerCase().indexOf(file.toLowerCase()) == 0) seq++;
		}

		return (seq == 0) ? "" : "" + ((++seq) < 10 ? "0" + seq : seq);
	}

}
