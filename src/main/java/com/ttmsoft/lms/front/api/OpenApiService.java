package com.ttmsoft.lms.front.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.StringWriter;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.JSONArray;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class OpenApiService extends BaseSvc<DataMap> {
	
	private static final String clientId = "compa";
	private static final String clientSecret = "f8f9fe89c9de401d81cb4361a725bac8";

	private static final String hostUrl = "https://dev-doc.signok.com/";
	private static final String auth = clientId + ":" + clientSecret;
	private static final String authentication = Base64.getEncoder().encodeToString(auth.getBytes()); 
	
	public List<DataMap> doFrontBusiness(DataMap userMap) {
		return this.dao.dolistQuery("ProjectFrontSQL.doFrontBusiness", userMap);
	}
	
	public List<DataMap> doFrontBusiness2(DataMap userMap) {
		return this.dao.dolistQuery("ProjectFrontSQL.doFrontBusiness2", userMap);
	}
	public JSONObject request(String url) {
		JSONObject result = new JSONObject();
		try {
			HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			httpRequestFactory.setConnectTimeout(30000); // 연결시간 초과
			// Rest template setting
			RestTemplate restTpl = new RestTemplate(httpRequestFactory);
			HttpHeaders headers = new HttpHeaders(); // 담아줄 header
			headers.set("x-ibm-client-id", "a4b8257d-a2a2-4842-ba3c-26e646684b9e");
			headers.set("x-ibm-client-secret", "vJ3gQ1dN7tE5wS5xE1oT7sV2lA6dV3gS6sR8cP2vQ7gX7hW1nE");
			headers.set("accept", "application/json");
			HttpEntity entity = new HttpEntity<>(headers); // http entity에 header 담아줌
			ResponseEntity<JSONObject> responseEntity = restTpl.exchange(url, HttpMethod.GET, entity, JSONObject.class);
			result = responseEntity.getBody();
			
		} catch (HttpClientErrorException e) {
			
			String httpCode= e.getResponseBodyAsString();
			System.out.println("e:"+e.getResponseBodyAsString());
			String httpCodeSub = httpCode.substring(14, 17);
			if(httpCodeSub.equals("400")) {
				System.out.println("400??dddd");
			};
			if(httpCodeSub.equals("401")) {
				System.out.println("401??dddd");
			};
			System.out.println(httpCode.substring(14, 17));
		}
		return result;
	}
	
	public Response okRequest(String url) throws IOException {
		OkHttpClient client = new OkHttpClient();

		Request request = new Request.Builder()
		  .url(url)
		  .get()
		  .addHeader("x-ibm-client-id", "a4b8257d-a2a2-4842-ba3c-26e646684b9e")
		  .addHeader("x-ibm-client-secret", "vJ3gQ1dN7tE5wS5xE1oT7sV2lA6dV3gS6sR8cP2vQ7gX7hW1nE")
		  .addHeader("accept", "application/json")
		  .build();

		Response response = client.newCall(request).execute();
		return response;
	}
	
	/**
	 * 휴폐업조회
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public int bizApiCheck(String biz_regno) throws Exception {
		String url = "https://api.kisline.com/nice/sb/api/compa/emEprCrIfoSbqc/sbqcStatus?bizno="+biz_regno;
		System.out.println("url : " + url);
		JSONObject result = request(url);
		int count = 0;
		
		Map<String,Object> data = (Map<String, Object>) result.get("items");
		ArrayList<Map> list = (ArrayList<Map>) data.get("item");
		Map list2 = list.get(0);
		if(list2.get("sbqc_date") == "" ) {
			count = 0;
		}else {
			count = Integer.parseInt(list2.get("sbqc_date").toString());
		}
		System.out.println("휴폐업count:"+count);
		return count;
	}
	
	/**
	 * 신용도판단정보
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public int bizBusibbCnt(String biz_regno) throws Exception {
		String url = "https://api.kisline.com/nice/sb/api/compa/kcisTxIfo/creditJudgeKfb?business="+biz_regno;
		System.out.println("url : " + url);
		JSONObject result = request(url);
		int count = 0;
		
		Map<String,Object> data = (Map<String, Object>) result.get("items");
		count =Integer.parseInt(data.get("count").toString());
		System.out.println("신용도count:"+count);
		return count;
	}
	
	/**
	 * 민원증명
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public JSONArray taxCertificationList(String biz_regno) throws Exception {
		JSONArray result = new JSONArray();
		boolean tempA1 = false;
		boolean tempA5 = false;
		boolean tempN3 = false;
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	    String toDay = date.format(today);
	    Calendar mon = Calendar.getInstance();
	    mon.add(Calendar.MONTH , -1);
	    String beforeMonth = new java.text.SimpleDateFormat("yyyy-MM-dd").format(mon.getTime());
	    
	    String url = "https://api.kisline.com/nice/sb/api/compa/faSubmitListPublic/tax/taxCertificationSubmitList?enc_cporcd=RW3NaZoYJ9KaJbPW%2BZHJxA%3D%3D"+"&st_date="+beforeMonth+"&end_date="+toDay+"&bizno="+biz_regno;
	    System.out.println("==>url : " + url);
		Response response = okRequest(url);
		String resBodyToString = response.body().string();
		int count = 0;
		try {
			org.springframework.boot.configurationprocessor.json.JSONObject jsonObject = new org.springframework.boot.configurationprocessor.json.JSONObject(resBodyToString);
			org.springframework.boot.configurationprocessor.json.JSONObject items = (org.springframework.boot.configurationprocessor.json.JSONObject) jsonObject.get("items");
			if(items.getInt("count") != 0) {
			org.springframework.boot.configurationprocessor.json.JSONArray taxlist =  items.getJSONArray("item");
			JSONArray a2List = new JSONArray();
			int a1 = 0;
			String taxA1 = null;
			for(int i=0; i< taxlist.length(); i++) {
				org.springframework.boot.configurationprocessor.json.JSONObject object = taxlist.getJSONObject(i);
				taxA1 = object.getString("txvscfwdivcd");
				//System.out.println("taxA1:"+taxA1);
				
				//사업자등록증명
				if(tempA1==false &&object.getString("txvscfwdivcd").equals("A1")) {
					result.put(object);
					tempA1 = true;
				}
				//표준재무제표증명
				else if(object.getString("txvscfwdivcd").equals("A2") && object.getString("txvsacqsdatstsnm").equals("검증완료")) {
					a2List.put(object);
				}
				//납세증명
				else if(tempA5==false &&object.getString("txvscfwdivcd").equals("A5")) {
					result.put(object);
					tempA5=true;
				}
				//지방세 납세증명
				else if(tempN3==false &&object.getString("txvscfwdivcd").equals("N3")) {
					result.put(object);
					tempN3=true;
				}
			}
			if(tempA1 == false) {
				org.springframework.boot.configurationprocessor.json.JSONObject object = new org.springframework.boot.configurationprocessor.json.JSONObject();
				object.put("txvscfwnm", "사업자등록증명");
				object.put("txvsacqsdatstsnm", "");
				object.put("pdf_file_pth", "");
				object.put("bizno", "");
				object.put("cfw_req_end_yymm", "");
				object.put("cfw_req_st_yymm", "");
				object.put("entrnm", "");
				object.put("inunm", "");
				object.put("regcono", "");
				object.put("repr", "");
				object.put("rgs_dtm", "");
				object.put("smt_ofcrnm", "");
				object.put("txvscfwdivcd", "A1");
				object.put("txvscfwissno", "");
				object.put("txvssndpcsstsnm", "");
				
				result.put(object);
				tempA1=true;
			}
			if(tempA5 == false) {
				org.springframework.boot.configurationprocessor.json.JSONObject object = new org.springframework.boot.configurationprocessor.json.JSONObject();
				object.put("txvscfwnm", "납세증명");
				object.put("txvsacqsdatstsnm", "");
				object.put("pdf_file_pth", "");
				object.put("bizno", "");
				object.put("cfw_req_end_yymm", "");
				object.put("cfw_req_st_yymm", "");
				object.put("entrnm", "");
				object.put("inunm", "");
				object.put("regcono", "");
				object.put("repr", "");
				object.put("rgs_dtm", "");
				object.put("smt_ofcrnm", "");
				object.put("txvscfwdivcd", "A5");
				object.put("txvscfwissno", "");
				object.put("txvssndpcsstsnm", "");
				result.put(object);
				tempA5=true;
			}
			if(tempN3 == false) {
				org.springframework.boot.configurationprocessor.json.JSONObject object = new org.springframework.boot.configurationprocessor.json.JSONObject();
				object.put("txvscfwnm", "지방세 납세증명");
				object.put("txvsacqsdatstsnm", "");
				object.put("pdf_file_pth", "");
				object.put("bizno", "");
				object.put("cfw_req_end_yymm", "");
				object.put("cfw_req_st_yymm", "");
				object.put("entrnm", "");
				object.put("inunm", "");
				object.put("regcono", "");
				object.put("repr", "");
				object.put("rgs_dtm", "");
				object.put("smt_ofcrnm", "");
				object.put("txvscfwdivcd", "N3");
				object.put("txvscfwissno", "");
				object.put("txvssndpcsstsnm", "");
				result.put(object);
				tempN3=true;
			}
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd");
			Date checkDate = dateFormat.parse("1900-01-01");
			int checkI = 0;
			
			for(int i=0;i<a2List.length();i++) {
				org.json.JSONObject a2check =  a2List.getJSONObject(i);
				String date_reg_dtm = (String) a2check.get("rgs_dtm");
				Date checkDate2 =  dateFormat.parse(date_reg_dtm);
				int compare = checkDate.compareTo(checkDate2);
				if(compare < 0) {
					checkDate = checkDate2;
					checkI = i;
				}
			}
			result.put(a2List.get(checkI));
			
			}else {
				
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	    
		return result;
	}
	
	/**
	 * 표준재무제표증명
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public int taxCertificationList2(String biz_regno) throws Exception {
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	    String toDay = date.format(today);
	    Calendar mon = Calendar.getInstance();
	    mon.add(Calendar.MONTH , -1);
	    String beforeMonth = new java.text.SimpleDateFormat("yyyy-MM-dd").format(mon.getTime());
	    
	    String url = "https://api.kisline.com/nice/sb/api/compa/faSubmitListPublic/tax/taxCertificationSubmitList?enc_cporcd=RW3NaZoYJ9KaJbPW%2BZHJxA%3D%3D"+"&st_date="+beforeMonth+"&end_date="+toDay+"&bizno=2108163047";
	    System.out.println("==>url : " + url);
		Response response = okRequest(url);
		String resBodyToString = response.body().string();
		int count = 0;
		try {
			org.springframework.boot.configurationprocessor.json.JSONObject jsonObject = new org.springframework.boot.configurationprocessor.json.JSONObject(resBodyToString);
			org.springframework.boot.configurationprocessor.json.JSONObject items = (org.springframework.boot.configurationprocessor.json.JSONObject) jsonObject.get("items");
			org.springframework.boot.configurationprocessor.json.JSONArray taxlist =  items.getJSONArray("item");
			System.out.println("taxlist:"+taxlist);
			
			int a2 = 0;
			String taxA2 = null;
			for(int i=0; i< taxlist.length(); i++) {
				org.springframework.boot.configurationprocessor.json.JSONObject list = taxlist.getJSONObject(i);
				taxA2 = list.getString("txvscfwdivcd");
				System.out.println("taxA2:"+taxA2);
				if(taxA2.length() == '3') {
					a2 = 1;
				}else {
					a2 = 0;
				}
			}
				
				System.out.println("==>taxA2:"+taxA2);
			
			count = a2;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return count;
	}
	
	/**
	 * 납세증명
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public int taxCertificationList3(String biz_regno) throws Exception {
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	    String toDay = date.format(today);
	    Calendar mon = Calendar.getInstance();
	    mon.add(Calendar.MONTH , -1);
	    String beforeMonth = new java.text.SimpleDateFormat("yyyy-MM-dd").format(mon.getTime());
	    
	    String url = "https://api.kisline.com/nice/sb/api/compa/faSubmitListPublic/tax/taxCertificationSubmitList?enc_cporcd=RW3NaZoYJ9KaJbPW%2BZHJxA%3D%3D"+"&st_date="+beforeMonth+"&end_date="+toDay+"&bizno=2108163047";
	    System.out.println("==>url : " + url);
		Response response = okRequest(url);
		String resBodyToString = response.body().string();
		int count = 0;
		try {
			org.springframework.boot.configurationprocessor.json.JSONObject jsonObject = new org.springframework.boot.configurationprocessor.json.JSONObject(resBodyToString);
			org.springframework.boot.configurationprocessor.json.JSONObject items = (org.springframework.boot.configurationprocessor.json.JSONObject) jsonObject.get("items");
			org.springframework.boot.configurationprocessor.json.JSONArray taxlist =  items.getJSONArray("item");
			
			int a5 = 0;
			String taxA5 = null;
			for(int i=0; i< taxlist.length(); i++) {
				org.springframework.boot.configurationprocessor.json.JSONObject list = taxlist.getJSONObject(i);
				taxA5 = list.getString("txvscfwdivcd");
				if(taxA5.equals("A5")) {
					a5 = 1;
					break;
				}else  {
					a5 = 0;
				}
			}
				
				
			
			count = a5;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return count;
	}
	
	/**
	 * 지방세 납세증명
	 * @param biz_regno
	 * @return
	 * @throws Exception
	 */
	public int taxCertificationList4(String biz_regno) throws Exception {
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	    String toDay = date.format(today);
	    Calendar mon = Calendar.getInstance();
	    mon.add(Calendar.MONTH , -1);
	    String beforeMonth = new java.text.SimpleDateFormat("yyyy-MM-dd").format(mon.getTime());
	    
	    String url = "https://api.kisline.com/nice/sb/api/compa/faSubmitListPublic/tax/taxCertificationSubmitList?enc_cporcd=RW3NaZoYJ9KaJbPW%2BZHJxA%3D%3D"+"&st_date="+beforeMonth+"&end_date="+toDay+"&bizno=2108163047";
	    System.out.println("==>url : " + url);
		Response response = okRequest(url);
		String resBodyToString = response.body().string();
		int count = 0;
		try {
			org.springframework.boot.configurationprocessor.json.JSONObject jsonObject = new org.springframework.boot.configurationprocessor.json.JSONObject(resBodyToString);
			org.springframework.boot.configurationprocessor.json.JSONObject items = (org.springframework.boot.configurationprocessor.json.JSONObject) jsonObject.get("items");
			org.springframework.boot.configurationprocessor.json.JSONArray taxlist =  items.getJSONArray("item");
			
			int n3 = 0;
			String taxN3 = null;
			for(int i=0; i< taxlist.length(); i++) {
				org.springframework.boot.configurationprocessor.json.JSONObject list = taxlist.getJSONObject(i);
				taxN3 = list.getString("txvscfwdivcd");
			}
				
				if(taxN3.equals("N3")) {
					n3 = 0;
				}else  {
					n3 = 1;
				}
			
			count = n3;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return count;
	}

	public static void main(String[] args) {
		String tmp = TokenIssuance_prd.getRequestData();
	}

	/**
	 * 인증토큰 발급
	 * @return
	 */
	static String getToken() {
		 
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
	
	/**
	 * 템플릿 목록 조회
	 * @return
	 * @throws IOException
	 */
	static String getTemplate() throws IOException {
		String token = "Bearer "+getToken();
		String requestData = "{\"page\":1,\"per_page\":10}";

		OkHttpClient client = new OkHttpClient().newBuilder()
		  .build();

		MediaType mediaType = MediaType.parse("application/json");

		RequestBody body = RequestBody.create(mediaType, requestData);

		Request request = new Request.Builder()
		  .url("https://dev-doc.signok.com/api/v1/template/")
		  .method("POST", body)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();

		Response response = client.newCall(request).execute();
		Map<String,Object> result = new HashMap<>();
		result.put("result", response);
		ResponseBody responseBody = response.body();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = mapper.readValue(responseBody.string(), Map.class);
		ArrayList<Map> list = (ArrayList) map.get("template");
		Map data = list.get(0);
		String dataId = data.get("id").toString();
		getTemplateId(dataId);
		return dataId;
	}
	
	/**
	 * 템플릿 조회
	 * @param response
	 * @return
	 * @throws IOException
	 */
	static Map<String,Object> getTemplateId(String dataId) throws IOException {
		String token = "Bearer "+getToken();
		String requestData = "{\"page\":1,\"per_page\":10}";

		OkHttpClient client = new OkHttpClient().newBuilder()
		  .build();

		Request request = new Request.Builder()
		  .url("https://dev-doc.signok.com/api/v1/template/"+dataId)
		  .method("GET", null)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();

		Response response = client.newCall(request).execute();
		Map<String,Object> result = new HashMap<>();
		result.put("result", response);
		ResponseBody responseBody = response.body();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = mapper.readValue(responseBody.string(), Map.class);
		createDocument(map);
		return result;
	}
	
	static Response createDocument(Map<String, Object> map) throws IOException {
		String token = "Bearer "+getToken();
		System.out.println("=>"+map);
		System.out.println("=>"+map.get(0));
		String requestData = "{\"document\":{\"template_id\":\"20742\",\"title\":\"계약서샘플\",\"auto_send\":true,\"auto_confirm\":true,"
				+ "\"signer\":[{\"index\":1,\"name\":\"과학기술일자리진흥원[신용수]\",\"email\":\"esign@compa.re.kr\"},{\"index\":2,\"name\":\"대상자 이름\",\"email\":\"대상자 이메일\"}"
				+ ",{\"index\":3,\"name\":\"대상자 이름\",\"email\":\"대상자 이메일\"}],\"item\":[{\"key\":\"항목 API Key\",\"value\":\"항목 값\"},"
				+ "{\"key\":\"항목 API Key\",\"value\":\"항목 값\"},{\"key\":\"항목 API Key\",\"value\":\"항목 값\"}]}}";

		OkHttpClient client = new OkHttpClient().newBuilder()
		  .build();

		MediaType mediaType = MediaType.parse("application/json");

		RequestBody body = RequestBody.create(mediaType, requestData);

		Request request = new Request.Builder()
		  .url("https://dev-doc.signok.com/api/v1/document/create/")
		  .method("POST", body)
		  .addHeader("Content-Type", "application/json")
		  .addHeader("Authorization", token)
		  .build();

		Response response = client.newCall(request).execute();
		return response;
	}
	/**
	 * 문서 생성
	 * @return
	 */
	/*static String createDocument(Map<String, Object> result) {
		String token = "Bearer "+getToken();
		Map<String, Object> requestData = result;
		BufferedReader reader = null;
		HttpsURLConnection connection = null;
		String returnValue = "";
		try {
			
			URL url = new URL("https://dev-doc.signok.com/api/v1/document/create/");
			connection = (HttpsURLConnection) url.openConnection();
			
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);

			connection.setRequestProperty("Authorization", token);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Accept", "application/json");

			PrintStream os = new PrintStream(connection.getOutputStream());
			os.print(requestData);
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
			System.out.println("map:"+map);

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
	}*/
	
	/**
	 * 문서 목록조회
	 * @return
	 * @throws IOException
	 */
	static Map<String,Object> getDocument() throws IOException {
		String token = "Bearer "+getToken();
		String requestData = "{\"page\":1,\"per_page\":10,\"title\":\"계약서샘플\"}";

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
		Map<String,Object> result = new HashMap<>();
		result.put("result", response);
		return result;
	}
	
	
}
