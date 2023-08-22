package com.ttmsoft.toaf.interceptor;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import com.ttmsoft.toaf.object.DataMap;


/**
 * 
 * @Package	 : com.ttmsoft.toaf.interceptor
 * @File	 : RequestInterceptor.java
 * 
 * @Author   : choi
 * @Date	 : 2020. 3. 18.
 * @Explain  : 요청 인터셉터
 *
 */
@Component
public class RequestInterceptor implements MethodInterceptor {
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());

	public Object invoke (MethodInvocation invocation) throws Throwable {

		logger.info("RequestInterceptor start");
		
		if (invocation.getMethod().getReturnType().equals(ModelAndView.class) ||
			invocation.getMethod().getReturnType().equals(String.class) ||
			invocation.getMethod().getReturnType().equals(Object.class)) {

			Class<?>[] params = invocation.getMethod().getParameterTypes();

			int mapIndex = -1;
			int reqIndex = -1;
			for (int idx = 0; idx < params.length; idx++) {
//				System.out.println("===> ["+idx+"]"+params[idx]);
				if (params[idx].equals(DataMap.class)) mapIndex = idx;
				if (params[idx].equals(HttpServletRequest.class)) reqIndex = idx;
			}

			if (mapIndex >= 0 && reqIndex >= 0) {
				HttpServletRequest request = (HttpServletRequest) invocation.getArguments()[reqIndex];
				DataMap dataMap = new DataMap();

				Enumeration<String> enumeration = request.getParameterNames();
				while (enumeration.hasMoreElements()) {
					String name = enumeration.nextElement();
					String[] vals = request.getParameterValues(name);

					if (vals == null) continue;
					if ("models".equals(name)) {
						JSONArray jsonList = (JSONArray) JSONSerializer.toJSON(request.getParameter(name));
						List<DataMap> gridList = new ArrayList<DataMap>();
						int idx = 0;
						for (Object obj : jsonList) {
							JSONObject jsonObj = (JSONObject) obj;
							gridList.add((DataMap) JSONObject.toBean(jsonObj, DataMap.class));
							if (logger.isDebugEnabled()) logger.debug("GRID models [" + idx + "]\t: " + jsonObj.toString());
							idx++;
						}
						dataMap.putorg(name, gridList);
					}
					else {
						dataMap.putorg(name.replaceAll("[\\[\\] ]", ""), (vals.length > 1 || name.indexOf("[") > 0) ? vals : request.getParameter(name));

						if (logger.isDebugEnabled()) {
							logger.debug("param [ " +	name.replaceAll("[\\[\\] ]", "") + " ]\t: { " +
								(vals.length > 1 || name.indexOf("[") > 0 ? "[" + StringUtils.join(vals, ", ") + "]" : request.getParameter(name)) + " }");
						}
					}
				}

				if (request instanceof MultipartHttpServletRequest) {
					MultipartHttpServletRequest mprequest = (MultipartHttpServletRequest) request;

					Iterator<String> iterator = mprequest.getFileNames();
					while (iterator.hasNext()) {
						String name = iterator.next();
						List<MultipartFile> values = mprequest.getFiles(name);
						if (values == null || values.isEmpty()) continue;

						dataMap.putorg(name.replaceAll("[\\[\\] ]", ""), values);

						if (logger.isDebugEnabled()) {
							String names = "{ ";
							for (int idx = 0; idx < values.size(); idx++) {
								names += (idx == 0 ? "" : ", ") + values.get(idx).getOriginalFilename();
							}
							names += " }";
							logger.debug("upload [ " + name + " ]\t: " + names);
						}
					}
				}
				logger.debug("paraMap : " + dataMap);
				invocation.getArguments()[mapIndex] = dataMap;
			}
		}

		return invocation.proceed();
	}
}
