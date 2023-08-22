package com.ttmsoft.lms.front.projectapply;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileUtil;
import com.ttmsoft.toaf.util.StringUtil;

/**
 * 
 * @Package : com.ttmsoft.lms.cmm.site
 * @File : FileAction.java
 *
 * @Author : yjcheon
 * @Date : 2021. 4. 20.
 * @Explain : 파일관리
 *
 */
@Controller
@RequestMapping("/file")
public class FileAction extends BaseAct {

	@Autowired
	private FileService fileService;

	@Value("${siteid}")
	private String siteid;

	@Value("${upload.path}")
	private String rootPath;

	/**
	 *
	 * @Author : yjc
	 * @Date : 2021. 4. 21.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 파일 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/list.do", method = RequestMethod.POST)
	public ModelAndView dolistFile(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");

		try {

			mav.addObject("list", this.fileService.getFileList(paraMap));

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	/**
	 *
	 * @Author : yjc
	 * @Date : 2021. 4. 21.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 파일 수정
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/modify.do", method = RequestMethod.POST)
	public ModelAndView doModifyFile(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", request.getSession().getAttribute("member_seqno"));

		try {

			mav.addObject("updateCnt", this.fileService.modifyFile(paraMap));

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	/**
	 *
	 * @Author : yjc
	 * @Date : 2021. 4. 21.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 파일 삭제
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	public ModelAndView doDeleteFile(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", request.getSession().getAttribute("member_seqno"));

		try {

			mav.addObject("updateCnt", this.fileService.deleteFile(paraMap));

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	/**
	 *
	 * @Author   : yjc
	 * @Date	 : 2021. 4. 21.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 파일 다운로드
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/download.do")
	public ResponseEntity<Resource> doDownloadFile (@RequestParam Map<String, Object> params, HttpServletRequest request) {	
		ResponseEntity<Resource> result = null;
		
		try {
			
			DataMap paraMap = new DataMap();
			paraMap.put("fmst_seq", params.get("fmst_seq"));
			paraMap.put("fslv_seq", params.get("fslv_seq"));
			
			// 파일 데이터 조회
			DataMap fileMap = this.fileService.getFile(paraMap);
			
			//String filePath = fileMap.getstr("fmst_path") + File.separator + fileMap.getstr("fmst_topic");
			String filePath = rootPath + File.separator + fileMap.getstr("fmst_topic");		
			filePath += File.separator + params.get("fmst_seq") + File.separator + fileMap.getstr("f_srv_nm");
			
			System.out.println("filepath는요"+filePath);
			File file = new File(filePath);
			
			if(file.exists()) {
				InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
				String orgnm = "";
				orgnm = new String( fileMap.getstr("f_org_nm").getBytes("UTF-8"),"UTF-8");
				
				result = ResponseEntity.ok()
						.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + orgnm + "\"")
						.contentLength(Long.parseLong(fileMap.getstr("f_size").toString()))
						.contentType(MediaType.parseMediaType(fileMap.getstr("f_cont_type")))
						.body(resource);
				
				
			}else {
				result = ResponseEntity.status(HttpStatus.NOT_FOUND).build();
			}
			
		} catch(Exception e) {			
			e.printStackTrace();			
			result = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
		
		return result;
	}

	/**
	 *
	 * @Author : ycjo
	 * @Date : 2020. 3. 19.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 게시판 관리 폼
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/upload.do", method = RequestMethod.POST)
	public ModelAndView doUploadFile(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");

		// sql로 전달 할 기본변수 세팅
		DataMap paraMap = new DataMap();
		paraMap.put("siteid", siteid);
		paraMap.put("userid", request.getSession().getAttribute("member_seqno"));

		try {

			String topic = params.get("topic").toString();
			MultipartFile file = request.getFile("file");

			// 마스터 시퀀스
			long fmstSeq = StringUtil.toLong(params.get("fmstSeq").toString());

			// 파일타입
			String fType = params.get("fType").toString();

			fmstSeq = this.createFile(topic, fmstSeq, fType, file, paraMap);

			mav.addObject("fmstSeq", fmstSeq);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	private long createFile(String topic, long fmstSeq, String fType, MultipartFile file, DataMap paraMap)
			throws IllegalStateException, IOException {
		// 신규 파일일 때 마스터 데이터 생성
		if (fmstSeq == 0) {
			paraMap.put("fmst_path", rootPath);
			paraMap.put("fmst_topic", topic);
			fmstSeq = fileService.createFileMst(paraMap);
		}

		// 타겟 디렉토리 생성
		String path = FileUtil.mkdirWithId(rootPath, topic, Long.toString(fmstSeq));

		// 파일 저장
		DataMap fileDataMap = FileUtil.writeFile(path, file);

		fileDataMap.put("fmst_seq", fmstSeq);
		fileDataMap.put("f_type", fType);
		fileDataMap.put("f_cont_type", file.getContentType());
		fileDataMap.put("userid", paraMap.get("userid"));
		fileDataMap.put("siteid", paraMap.get("siteid"));
		fileDataMap.put("useyn", "Y");

		// DB에 파일정보 저장
		fileService.saveFileSvl(fileDataMap);

		return fmstSeq;
	}
	/**
	 *
	 * @Author   : yjc
	 * @Date	 : 2021. 4. 21.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : zip 압축후 다운로드
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/zipDownload.do")
	public ResponseEntity<Resource> doZipDownloadFile (@RequestParam Map<String, Object> params, HttpServletRequest request,HttpServletResponse response) {	
		ResponseEntity<Resource> result = null;
		
		try {
			
			DataMap paraMap = new DataMap();
			paraMap.put("fmst_seq", params.get("fmst_seq"));

			String FileName = rootPath + "/test.zip";
		    // ZipOutputStream을 FileOutputStream 으로 감쌈
		    FileOutputStream fout = new FileOutputStream(FileName);
		    ZipOutputStream zout = new ZipOutputStream(fout);


			// 파일 데이터 조회
			List<DataMap> fileMap = this.fileService.getFileListToZip(paraMap);
			for(int i=0; i<fileMap.size();i++) {
				//본래 파일명 유지, 경로제외 파일압축을 위해 new File로 
		        //ZipEntry zipEntry = new ZipEntry(new File(fileMap.get(i).getstr("f_srv_nm")).getName()+"."+fileMap.get(i).getstr("f_ext"));
				ZipEntry zipEntry = new ZipEntry(new File(fileMap.get(i).getstr("f_org_nm")).getName());
		        zout.putNextEntry(zipEntry);

		        //경로포함 압축
		        String filePath = rootPath + File.separator + fileMap.get(i).getstr("fmst_topic");
		        //String filePath = fileMap.get(i).getstr("fmst_path") + File.separator + fileMap.get(i).getstr("fmst_topic");			
				filePath += File.separator + params.get("fmst_seq") + File.separator + fileMap.get(i).getstr("f_srv_nm");
				System.out.println("rootpath는요?"+filePath);
		        FileInputStream fin = new FileInputStream(filePath);
		        byte[] buffer = new byte[1024];
		        int length;

		        // input file을 1024바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){
		            zout.write(buffer, 0, length);
		        }
		        zout.closeEntry();
		        fin.close();
			}
			 zout.close();

			    response.setContentType("application/zip");
			    response.addHeader("Content-Disposition", "attachment; filename=" + "download" + ".zip");

			    FileInputStream fis=new FileInputStream(FileName);
			    BufferedInputStream bis=new BufferedInputStream(fis);
			    ServletOutputStream so=response.getOutputStream();
			    BufferedOutputStream bos=new BufferedOutputStream(so);

			    byte[] data=new byte[2048];
			    int input=0;

			    while((input=bis.read(data))!=-1){
			        bos.write(data,0,input);
			        bos.flush();
			    }

			    if(bos!=null) bos.close();
			    if(bis!=null) bis.close();
			    if(so!=null) so.close();
			    if(fis!=null) fis.close();
			
		} catch(Exception e) {			
			e.printStackTrace();			
			result = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
		
		return result;
	}

}
