package com.ttmsoft.toaf.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import com.ttmsoft.toaf.object.FileObject;
import com.ttmsoft.toaf.util.ZipUtil;

@SuppressWarnings ({"unchecked"})
public class DownView extends AbstractView {

	public DownView () {
		setContentType("application/octet-stream");
	}

	
	@Override
	protected void renderMergedOutputModel (Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) 
		throws Exception {

		FileObject fileObj = new FileObject();
		fileObj.setFileName((String) model.get("fileName"));	// 파일명
		fileObj.setRealName((String) model.get("realName"));	// 실제 파일명
		fileObj.setFilePath((String) model.get("filePath"));	// 파일 경로 

		// 리스트형 자료일 경우 : Zip으로 압축전송		
		List<FileObject> fileList = (List<FileObject>) model.get("fileList");
		
		try {
			if (fileList != null && fileList.size() > 0 && !"zip".equals(fileObj.getFileExt())) {
				writeDownloadZip(request, response, fileObj, fileList);
			}
			else {
				writeDownloadFile(request, response, fileObj);
			}
		}
		catch (IOException ie) {
			ie.printStackTrace();
			response.getWriter().println("<script>alert('파일 다운로드에 오류가 발생하였습니다.');history.back();</script>");
		}
	}

	/**
	 * @param request : http request
	 * @param response : http response
	 * @param fileInfo : 파일정보
	 * @throws IOException : 파일 전송 실패
	 * @throws FileNotFoundException : 파일 찾기 실패
	 */
	private void writeDownloadFile (HttpServletRequest request, HttpServletResponse response, FileObject fileInfo) 
		throws IOException, FileNotFoundException {

		File downFile = null;
		try {
			downFile = new File(fileInfo.getPathFile());

			response.setCharacterEncoding("UTF-8");
			response.setContentType(getContentType());
			response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileInfo.getFileName(), "UTF-8"));
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");
		}
		catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("<script>alert('파일이 존재하지 않습니다.');history.back();</script>");
			return;
		}

		OutputStream out = response.getOutputStream();
		FileInputStream fis = new FileInputStream(downFile);
		try {			
			FileCopyUtils.copy(fis, out);
		}
		finally {
			if (fis != null) fis.close();
		}
		out.flush();
	}

	
	/**
	 * @param request : http request
	 * @param response : http response
	 * @param fileInfo : 파일정보
	 * @throws IOException : 파일 전송 실패
	 * @throws FileNotFoundException : 파일 찾기 실패
	 */
	private void writeDownloadZip (HttpServletRequest request, HttpServletResponse response, FileObject fileInfo, List<FileObject> fileList) 
		throws IOException, FileNotFoundException {

		File downFile = null;
		try {
			// ZIP 파일 생성
			ZipUtil.zipFile(fileList, fileInfo.getPathFile());
			
			downFile = new File(fileInfo.getPathFile());

			response.setCharacterEncoding("UTF-8");
			response.setContentType("Content-type: application/zip");
			response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileInfo.getFileName(), "UTF-8"));
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");
		}
		catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("<script>alert('파일이 존재하지 않습니다.');history.back();</script>");
			return;
		}

		OutputStream out = response.getOutputStream();
		FileInputStream fis = new FileInputStream(downFile);
		try {			
			FileCopyUtils.copy(fis, out);
		}
		finally {
			if (fis != null) fis.close();
			if (downFile.isFile()) downFile.delete();	// 임시ZIP파일 삭제
		}
		out.flush();
	}

}
