package com.ttmsoft.lms.front.api;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.springframework.beans.factory.annotation.Value;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ttmsoft.toaf.object.DataMap;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

@Component
public class SignOkApi {
	@Value("${upload.path}")
	private String rootPath;
	
	private static final String clientId = "compa";
	private static final String clientSecret = "f8f9fe89c9de401d81cb4361a725bac8";
	private static final String hostUrl = "https://dev-doc.signok.com/";
	private static final String auth = clientId + ":" + clientSecret;
	private static final String authentication = Base64.getEncoder().encodeToString(auth.getBytes());
	
	//사업신청시 signok문서만들기
	public String applySubmit(DataMap paraMap) throws JSONException{
		String result = "";
		String token = "Bearer "+getToken();
		paraMap.put("token", token);
		System.out.println(token);
		try {
			String dataid = getTemplate(paraMap);
			System.out.println("dataid번호야"+dataid);
			paraMap.put("dataid", dataid);
			//Map<String,Object> getTempl = getTemplateId(paraMap);
			
			String documentid = createDocument(paraMap);
			paraMap.put("documentid", documentid);
			if(!documentid.equals("")) {
				result = documentid;
			}
			//boolean checkSend = sendDocument(paraMap);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	//signok서명정보 가져오기
	public DataMap getSign(DataMap paraMap) {
		DataMap result = new DataMap();
		String token = "Bearer "+getToken();
		paraMap.put("token", token);
		try {
			result = getDocumentHistory(paraMap);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}
	
	//signok문서 다운로드
	public DataMap doDownload(DataMap paraMap) {
		DataMap result = new DataMap();
		String token = "Bearer "+getToken();
		paraMap.put("token", token);
		try {
			result = downloadDocument(paraMap);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 템플릿 목록 조회
	 * @return
	 * @throws IOException
	 */
	public String getTemplate(DataMap paraMap) throws IOException, JSONException {
		String requestData = "{\"page\":1,\"per_page\":10}";
		String url = "https://dev-doc.signok.com/api/v1/template/";
		
		paraMap.put("requestdata", requestData);
		paraMap.put("url", url);
		Response response = signokRequestBody(paraMap);
		
		Map<String,Object> result = new HashMap<>();
		result.put("result", response);
		ResponseBody responseBody = response.body();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = mapper.readValue(responseBody.string(), Map.class);
		ArrayList<Map> list = (ArrayList) map.get("template");
		System.out.println("list"+list);
		Map data = list.get(0);
		String dataId = data.get("id").toString();
		System.out.println("dataId야"+dataId);
		
		return dataId;
	}
	
	/**
	 * 템플릿 조회
	 * @param response
	 * @return
	 * @throws IOException
	 */
	public Map<String,Object> getTemplateId(DataMap paraMap) throws IOException {
		String url = "https://dev-doc.signok.com/api/v1/template/"+paraMap.getstr("dataid");
		paraMap.put("url", url);
		Response response = signokRequest(paraMap);
		System.out.println(response.body());
		Map<String,Object> result = new HashMap<>();
		result.put("result", response);
		String resBodyToString = response.body().string();
		try {
			JSONObject jsonObject = new JSONObject(resBodyToString);
			JSONObject template = (JSONObject) jsonObject.get("template");
			System.out.println("template"+template);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	/**
	 * 문서생성
	 * @param response
	 * @return
	 * @throws IOException
	 */
	public String createDocument(DataMap paraMap) throws IOException {
		String documentid="";
		String requestData = "{\"document\":{\"template_id\":\""+paraMap.getstr("dataid")+"\",\"title\":\""+"test"+"\",\"auto_send\":true,\"auto_confirm\":true,"
				+ "\"signer\":[{\"index\":1,\"name\":\""+paraMap.getstr("dc_pic1_name")+"\",\"email\":\""+paraMap.getstr("dc_pic1_email")+"\"},{\"index\":2,\"name\":\""+paraMap.getstr("sc_pic1_name")+"\",\"email\":\""+paraMap.getstr("sc_pic1_email")+"\"}"
				+ ",{\"index\":3,\"name\":\""+paraMap.getstr("admin_name")+"\",\"email\":\""+paraMap.getstr("admin_email")+"\"}],\"item\":[{\"key\":\"텍스트 박스 1\",\"value\":\"항목 값1\"}"
				+ ",{\"key\":\"텍스트 박스 2\",\"value\":\"항목 값2\"}]}}";
		String url = "https://dev-doc.signok.com/api/v1/document/create/";
		paraMap.put("requestdata", requestData);
		paraMap.put("url", url);
		Response response = signokRequestBody(paraMap);
		String resBodyToString = response.body().string();
		System.out.println("결과나옴"+resBodyToString);
		try {
			JSONObject jsonObject = new JSONObject(resBodyToString);
			JSONObject document = (JSONObject) jsonObject.get("document");
			documentid = (String) document.get("id");
			
			System.out.println("생성되니"+jsonObject);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return documentid;
	}
	
	
	/**
	 * 문서발송
	 * @param response
	 * @return
	 * @throws IOException
	 */
	public boolean sendDocument(DataMap paraMap) throws IOException {
		boolean result = false;
		String requestData = "{\"document\":{\"id\":\""+paraMap.getstr("documentid")+"\"}}";
		String url = "https://doc.signok.com/api/v1/document/send/";
		paraMap.put("requestdata", requestData);
		paraMap.put("url", url);
		Response response = signokRequestBody(paraMap);
		String resBodyToString = response.body().string();
		System.out.println("결과나옴"+resBodyToString);
		try {
			JSONObject jsonObject = new JSONObject(resBodyToString);
			JSONObject documnet = jsonObject.getJSONObject("document");
			String status = documnet.getString("status");
			if(status.equals("success")) {
				result = true;
			}
			System.out.println("발송했니"+jsonObject);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 문서 목록조회
	 * @return
	 * @throws IOException
	 */
	public Map<String,Object> getDocument(DataMap paraMap) throws IOException {
		String requestData = "{\"page\":1,\"per_page\":10,\"title\":\"계약서샘플\"}";
		String token = paraMap.getstr("token");
		paraMap.put("requestdata", requestData);
		OkHttpClient client = new OkHttpClient().newBuilder()
		  .build();

		MediaType mediaType = MediaType.parse("application/json");

		RequestBody body = RequestBody.create(mediaType, requestData);

		Request request = new Request.Builder()
		  .url("https://dev-doc.signok.com/api/v1/document/")
		  .method("POST", body)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();

		Response response = client.newCall(request).execute();
		try {
			JSONObject jsonObject = new JSONObject(response.body().toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 문서 이력 조회
	 * @param response
	 * @return
	 * @throws IOException
	 */
	public DataMap getDocumentHistory(DataMap paraMap) throws IOException {
		DataMap result = new DataMap();
		String url = "https://dev-doc.signok.com/api/v1/document/"+paraMap.getstr("documentid");
		paraMap.put("url", url);
		System.out.println(url);
		Response response = signokRequest(paraMap);
		String resBodyToString = response.body().string();
		System.out.println("결과"+resBodyToString);
		JSONArray newHistory = new JSONArray();
		try {
			JSONObject jsonObject = new JSONObject(resBodyToString);
			JSONObject document = (JSONObject) jsonObject.get("document");
			JSONArray history = document.getJSONArray("history");
			for(int i=0; i<history.length();i++) {
				JSONObject historyData = history.getJSONObject(i);
				String status = historyData.getString("status_description");
				if(status.equals("서명완료")) {
					newHistory.put(historyData);
				}
			}
			result.put("document_history",newHistory);
			System.out.println("history"+newHistory);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public DataMap downloadDocument(DataMap paraMap) throws IOException {
		DataMap result = new DataMap();
		/*
		
		paraMap.put("url", url);
		System.out.println(url);
		Response response = signokRequest(paraMap);
		String result = response.body().string();
		return result;
		*/
		
		int responseCode = 0;
		String urlString = "https://dev-doc.signok.com/api/v1/document/"+paraMap.getstr("documentid")+"/download";
		System.out.println("check url: " + urlString);
        String token = paraMap.getstr("token");
        InputStream is = null;
        FileOutputStream os = null;
        try{
            URL url = new URL(urlString);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setDoOutput(true);

			// 3. Rest API Request Header
            conn.setRequestProperty("Authorization", token);
            conn.setRequestProperty("Content-Type", "application/json");
            responseCode = conn.getResponseCode();
            result.put("response_code", responseCode);

            System.out.println("responseCode " + responseCode);

            // Status 가 200 일 때
            if (responseCode == HttpsURLConnection.HTTP_OK) {
                String fileName = "";
                String disposition = conn.getHeaderField("Content-Disposition");
                String contentType = conn.getContentType();
                int contentLength = conn.getContentLength();
                result.put("content_length", contentLength);
                result.put("content_type", contentType);
                
                // 일반적으로 Content-Disposition 헤더에 있지만 
                // 없을 경우 url 에서 추출해 내면 된다.
                if (disposition != null) {
                    String target = "filename=";
                    int index = disposition.indexOf(target);
                    if (index != -1) {
                        fileName = disposition.substring(index + target.length() + 1);
                        fileName = URLDecoder.decode(fileName, "UTF-8");
                        fileName = fileName.replace("\";", "");
                        result.put("file_name",fileName);
                    }
                } else {
                    fileName = urlString.substring(urlString.lastIndexOf("/") + 1);
                    fileName = URLDecoder.decode(fileName, "UTF-8");
                    fileName = fileName.replace("\";", "");
                    result.put("file_name",fileName);
                }

                System.out.println("Content-Type = " + contentType);
                System.out.println("Content-Disposition = " + disposition);
                System.out.println("fileName = " + fileName);

                is = conn.getInputStream();
                os = new FileOutputStream(new File(rootPath+"\\"+"협약서.pdf"));
 
                final int BUFFER_SIZE = 4096;
                int bytesRead;
                byte[] buffer = new byte[BUFFER_SIZE];
                while ((bytesRead = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.close();
                is.close();
                System.out.println("File downloaded");
                
                
            } else {
                System.out.println("No file to download. Server replied HTTP code: " + responseCode);
            }
            conn.disconnect();
        } catch (Exception e){
            System.out.println("An error occurred while trying to download a file.");
            e.printStackTrace();
            try {
                if (is != null){
                    is.close();
                }
                if (os != null){
                    os.close();
                }
            } catch (IOException e1){
                e1.printStackTrace();
            }
        }
        
        return result;
	}
	
	//공통request get
	public Response signokRequest(DataMap paraMap) throws IOException {
		Response response = null;
		try {
		String token = paraMap.getstr("token");
		String url = paraMap.getstr("url");
		OkHttpClient client = new OkHttpClient().newBuilder().build();
		Request request = new Request.Builder()
		  .url(url)
		  .method("GET", null)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();
		
		response = client.newCall(request).execute();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return response;
	}
	
	//공통request post
	public Response signokRequestBody(DataMap paraMap) {
		Response response = null;
		try {
		String requestData = paraMap.getstr("requestdata");
		String url = paraMap.getstr("url");
		String token = paraMap.getstr("token");
		
		System.out.println("requestData"+requestData+"url="+url+"token="+token);

		OkHttpClient client = new OkHttpClient().newBuilder().build();
		MediaType mediaType = MediaType.parse("application/json");
		RequestBody body = RequestBody.create(mediaType, requestData);
		Request request = new Request.Builder()
		  .url(url)
		  .method("POST", body)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();

		response = client.newCall(request).execute();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return response;
	}
	
	/**
	 * 인증토큰 발급
	 * @return
	 */
	public String getToken() {
		 
		String content = "grant_type=password&username=api&password=nopassword";
		
		BufferedReader reader = null;
		HttpsURLConnection connection = null;
		String returnValue = "";
		String token ="";
		try {
			
			URL url = new URL(hostUrl+"oauth/token");
			connection = (HttpsURLConnection) url.openConnection();
			
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);

			connection.setRequestProperty("Authorization", "Basic " + authentication);
			connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			connection.setRequestProperty("Accept", "application/json");

			PrintStream os = new PrintStream(connection.getOutputStream());
			os.print(content);
			os.close();

			reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String line = null;
			StringWriter out = new StringWriter(
					connection.getContentLength() > 0 ? connection.getContentLength() : 2048);
			while ((line = reader.readLine()) != null) {
				out.append(line);
			}

			String response = out.toString();
			returnValue = response;
			ObjectMapper mapper = new ObjectMapper();

			Map<String, String> map = mapper.readValue(returnValue, Map.class);
			token= map.get("access_token");
		} catch (Exception e) {

			System.out.println("Error : " + e.getMessage());

		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
				}
			}
			connection.disconnect();
		}
		
		return token;
	}


	
}
