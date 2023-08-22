package com.ttmsoft.toaf.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.JsonObject;
import com.ttmsoft.toaf.object.DataMap;

@Component
public class FileUtil {

	private static String rootPath;
	
	@Value("${upload.path}")
	public void setUploadPath(String path) {
		path = path.replaceAll("\\\\", "/");
		rootPath = path;
	}
	 //특정 폴더에서 고유한 파일 이름을 만드는 메서드 
	 //파일이름이 중복되면 뒤에 .1, .2와 같은 접미사 추가
	public static String makeUniqueFileName(String path, String fileName)
   {	
       String name = fileName.substring(0, fileName.lastIndexOf("."));
       String ext = fileName.substring(fileName.lastIndexOf("."));
       
       int index = 1;
       while (true) {
       	File file = new File(path + "\\" + name + "_" + index + ext);
       	if (file.exists())
       		index++;
       	else
       		break;
       }

       return name + "_" + index + ext;
   }
	

	//고유한 파일 이름을 만드는 메서드  (20.05.08 조예찬)
	public static String makeUniqueFileName(String fileName)
   {   
       String ext = fileName.substring(fileName.lastIndexOf("."));
       
       String name = UUID.randomUUID().toString();

       return name + ext;
   }
	
	///////////////////////////////////////////////////
	
	public static String makeQueryString(
		String queryString, String toAdd, String[] toRemove, String encoding)
		throws UnsupportedEncodingException {
		
		if (queryString == null || queryString.length() == 0) {
			return null;
		}
		if (encoding == null || encoding.length() == 0) {
			encoding = "utf-8";
		}
		queryString = queryString.replace("?", "");
		String[] ar = queryString.split("&");
		HashMap<String, String> result = new HashMap();
		for (String q : ar) {
			String[] ar2 = q.split("=");
			if (ar2.length != 2) {
				throw new RuntimeException("Invalid Format");
			}
			result.put(ar2[0], 
				new String(ar2[1].getBytes(encoding), "ISO-8859-1"));
		}
		
		if(toRemove != null && toRemove.length > 0) {
			for (String d : toRemove) {
				result.remove(d);
			}
		}
		
		if (toAdd != null && toAdd.length() > 0) {
			ar = toAdd.trim().split("&");
			for (String a : ar) {
				String[] ar2 = a.split("=");
				if (ar2.length != 2) {
					throw new RuntimeException("Invalid Format");
				}
				result.replace(ar2[0], 
					new String(ar2[1].getBytes(encoding), "ISO-8859-1"));
			}
		}
		
		Set<String> keys = result.keySet();
		StringBuilder sb = new StringBuilder();
		for (String key : keys) {
			sb.append(String.format("&%s=%s", key, result.get(key)));
		}
		sb = sb.replace(0, 1, "?");
		
		return sb.toString();
	}
	
	/**
	 *
	 * @throws Exception 
	 * @Author   : ycjo
	 * @Date	 : 2020. 05. 08. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 파일업로드 
	 * @Explain  : 
	 *
	 */	
	public static DataMap fileUpload(MultipartFile multipartFile, HttpServletRequest req, String somePath) throws IllegalStateException, IOException {

		if (multipartFile != null && !("").equals(org.apache.commons.io.FilenameUtils.getName(multipartFile.getOriginalFilename()))) {
			Calendar cal = Calendar.getInstance();  

			String yStr = ""+cal.get(Calendar.YEAR); //년도
			String mStr = ""+(cal.get(Calendar.MONTH) + 1); //월(+1일)
			
			if((cal.get(Calendar.MONTH)+1) < 10 ) {
				mStr = "0"+mStr;  
			}  	  
	  	
			String dStr = ""+cal.get(Calendar.DATE); //일	    	  
	  
			ServletContext application = req.getServletContext();
			String file_path = "/upload/"+yStr+"/"+mStr+"/"+dStr+"/"+somePath;  //파일 저장경로
			String path = application.getRealPath(file_path); //파일 확장 저장경로	
			System.out.println("path : " + path);
       	         
			File targetDir = new File(path);
			
			if(!targetDir.exists()) {  
	           targetDir.mkdirs();
			}	  			

			String file_name = org.apache.commons.io.FilenameUtils.getName(multipartFile.getOriginalFilename());

			if (file_name.contains("\\")) {
				file_name = file_name.substring(file_name.lastIndexOf("\\") + 1);
			}
			
	        String real_name = FileUtil.makeUniqueFileName(file_name); //임시파일 이름
	        long file_size = multipartFile.getSize(); //파일 사이즈
	        int posCheck = file_name.lastIndexOf( "." );//파일 확장자( . 앞까지 자르기)
	        String file_ext = file_name.substring( posCheck + 1 ).toLowerCase(); // (문자열 추출 / 대문자 소문자로 변환)
	         
	        OutputStream out = null;
	        try {
	        	byte[] bytes = multipartFile.getBytes();
		        out = new FileOutputStream(new File(path, real_name));
				out.write(bytes);
	        }catch(Exception e) {
	        	e.printStackTrace();
	        }finally {
	        	 if(out != null){
			        	out.close();
			        }
	        }
	            
	        DataMap data = new DataMap();	
	        data.put("file_name", file_name);
	        data.put("real_name", real_name);
	        data.put("file_size", file_size);
	        data.put("file_path", file_path);
	        data.put("file_ext", file_ext);		            		
			return data;
		}
		return null;
	}
	
	/**
	 *
	 * @throws Exception 
	 * @Author   : ycjo
	 * @Date	 : 2020. 05. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 에디터 이미지 업로드
	 * @Explain  : 
	 * 2021.04.15 PrintWriter sevletoutputstream으로 수정 -psm
	 *
	 */	
public static void uploadEditorImg(HttpServletRequest req, HttpServletResponse resp, MultipartHttpServletRequest multiFile) throws Exception {
		
		
		
		Calendar cal = Calendar.getInstance();  

		String yStr = ""+cal.get(Calendar.YEAR); //년도
		String mStr = ""+(cal.get(Calendar.MONTH) + 1); //월(+1일)
		
		if((cal.get(Calendar.MONTH)+1) < 10 ) {
			mStr = "0"+mStr;  
		}  	
		
		String dStr = ""+cal.get(Calendar.DATE); //일	    	  
		
	   	JsonObject json = new JsonObject();
	   	//PrintWriter printWriter = null;
	   	ServletOutputStream printWriter = null;
	   	OutputStream out = null;
	   	MultipartFile file = multiFile.getFile("upload");
	   	String fileName = org.apache.commons.io.FilenameUtils.getName(file.getOriginalFilename());
	   	
		if(file != null && !("").equals(fileName) 
				&& file.getContentType().toLowerCase().startsWith("image/")){
			try {
				byte[] bytes = file.getBytes();
				//String uploadPath = req.getServletContext().getRealPath("/upload/" + yStr + "/" + mStr + "/" + dStr + "/editor/");
				String uploadPath = rootPath+"/"+yStr + "/" + mStr + "/" + dStr + "/editor/";
	
				File targetDir = new File(uploadPath);
		    	
				if(!targetDir.exists()) {  
		    		targetDir.mkdirs();
			    }	
				
		        fileName = FileUtil.makeUniqueFileName(fileName);
				uploadPath = uploadPath + "/" + fileName;
				out = new FileOutputStream(new File(uploadPath));
				out.write(bytes);
             
				//String fileUrl = req.getContextPath() + "/upload/" + yStr + "/" + mStr + "/" + dStr + "/editor/" + fileName;
				String fileUrl = "/img/"+ yStr + "/" + mStr + "/" + dStr + "/editor/" + fileName;
             
	            
				//printWriter = resp.getWriter();
	            printWriter = resp.getOutputStream();
	            resp.setContentType("text/html");               
	            json.addProperty("uploaded", 1);
	            json.addProperty("fileName", fileName);
	            json.addProperty("url", fileUrl);              
	            //printWriter.println(json);
	            printWriter.println(json.toString()); 
                 
	        } finally{
	          	
		        if(out != null){
		        	out.close();
		        }
		          
		        if(printWriter != null){
		        	 printWriter.close();
		        }	
	        }
		}
	}	
	
	//단일 이미지 업로드 (20.05.21 최상규)
	public static String viewUpload(DataMap paraMap, HttpServletRequest request, String somePath) throws IllegalStateException, IOException {
	
		List<?> fileList = (List<?>) paraMap.get("view");
		MultipartFile ci = (MultipartFile)fileList.get(0);

		if (ci != null && !("").equals(org.apache.commons.io.FilenameUtils.getName(ci.getOriginalFilename()))) {
			Calendar cal = Calendar.getInstance();  
	
			String yStr = ""+cal.get(Calendar.YEAR); //년도
			String mStr = ""+(cal.get(Calendar.MONTH) + 1); //월(+1일)
			
			if((cal.get(Calendar.MONTH)+1) < 10 ) {
				mStr = "0"+mStr;  
			}  	  
	  	
			String dStr = ""+cal.get(Calendar.DATE); //일	    	  
	  
			ServletContext application = request.getServletContext();
			
			String file_path = "/upload/"+yStr+"/"+mStr+"/"+dStr+"/"+somePath;  //파일 저장경로
			String path = application.getRealPath(file_path); //파일 확장 저장경로
				         
			File targetDir = new File(path);
			
			if(!targetDir.exists()) {  
	           targetDir.mkdirs();
			}	  
			
			String file_name = org.apache.commons.io.FilenameUtils.getName(ci.getOriginalFilename()); //파일 이름
	        OutputStream out = null;
	        try {
	        	byte[] bytes = ci.getBytes();
		        out = new FileOutputStream(new File(path, file_name));
				out.write(bytes);
	        }finally {
	        	 if(out != null){
			        	out.close();
			        }
	        }
	        
	        return file_path + "/" + file_name;
		}
		return null;
	}  
	//파일 삭제
	public static void removeFile(HttpServletRequest request, String path) throws IOException{		
		
		ServletContext application = request.getServletContext();
		
		File file = new File(application.getRealPath(path));
		if (file.exists() && file.isFile()) {
			file.delete();
		}			
	}
	//디렉토리 삭제
	public static void removeDir(HttpServletRequest request, String path) throws IOException{		
		
		ServletContext application = request.getServletContext();
		
		File file = new File(application.getRealPath(path));
		if (file.exists() && file.isDirectory()) {
			file.delete();
		}
	}
	
	public static String getFileName(HttpServletRequest request, String path) throws IOException{		
		
		ServletContext application = request.getServletContext();
		
		File file = new File(application.getRealPath(path));
		if (file.exists() && file.isFile()) {
			return file.getName();
		}	
		return null;
	}
	
	public static String mkdirWithId(String rootPath, String topic, String dirId) {
		
		String path = String.join("/", new String[] {rootPath, topic, dirId});
		
		File dir = new File(path);
		if(!dir.exists()){
			dir.mkdirs();
		}
		
		return path;
	}
	
	public static DataMap writeFile(String path, MultipartFile mpFile) throws IllegalStateException, IOException {
		DataMap result = new DataMap();
		String orgNm = mpFile.getOriginalFilename();
		String ext = orgNm.substring(orgNm.lastIndexOf(".") + 1);
		String svrNm = UUID.randomUUID().toString();
		
		File file = new File( path + "/" + svrNm);
		
		// 파일 저징
        OutputStream out = null;
        try {
        	byte[] bytes = mpFile.getBytes();
	        out = new FileOutputStream(new File(path + "/" + svrNm));
			out.write(bytes);
        }catch(Exception e) {
        	e.printStackTrace();
        }finally {
        	 if(out != null){
		        	out.close();
		        }
        }
		
		result.put("f_org_nm", orgNm);
		result.put("f_size", mpFile.getSize());
		result.put("f_ext", ext.toLowerCase());
		result.put("f_srv_nm", svrNm);
		
		return result;
	}
}
