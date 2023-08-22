/*
 * Copyright 2008-2009 MOPAS(Ministry of Public Administration and Security). Licensed under the Apache License, Version
 * 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the
 * License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language governing permissions and limitations
 * under the License.
 */
package com.ttmsoft.toaf.util;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 
 * 기  능	: 객체의 로딩을 지원하는 유틸 클래스
 * 파일명	: ObjectUtil.java
 * 패키지	: com.ttmsoft.toaf.util
 * 설  명	: 전자정부프레임웍 참조
 * 변경이력	: 
 * 2020.03.03	[PUDDING] - 최초작성
 * 
 */

public class ObjectUtil {

	private static Log log = LogFactory.getLog(ObjectUtil.class);

	private ObjectUtil () {}

	/**
	 * 클래스명으로 객체를 로딩한다.
	 * 
	 * @param className
	 * @return
	 * @throws ClassNotFoundException
	 * @throws Exception
	 */
	public static Class<?> loadClass (String className) throws ClassNotFoundException, Exception {

		Class<?> clazz = null;
		try {
			clazz = Thread.currentThread().getContextClassLoader().loadClass(className);
		}
		catch (ClassNotFoundException e) {
			throw new ClassNotFoundException();
		}
		catch (Exception e) {
			throw new Exception(e);
		}

		if (clazz == null) {
			clazz = Class.forName(className);
		}

		return clazz;

	}

	/**
	 * 클래스명으로 객체를 로드한 후 인스턴스화 한다.
	 * 
	 * @param className
	 * @return
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	public static Object instantiate (String className) throws ClassNotFoundException, InstantiationException, IllegalAccessException, Exception {
		Class<?> clazz;

		try {
			clazz = loadClass(className);
			return clazz.newInstance();
		}
		catch (ClassNotFoundException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is can not instantialized.");
			throw new ClassNotFoundException();
		}
		catch (InstantiationException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is can not instantialized.");
			throw new InstantiationException();
		}
		catch (IllegalAccessException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is not accessed.");
			throw new IllegalAccessException();
		}
		catch (Exception e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is not accessed.");
			throw new Exception(e);
		}
	}

	/**
	 * 클래스명으로 파라매터가 있는 클래스의 생성자를 인스턴스화 한다.
	 * 
	 * <pre>
	 * 예) Class <?> clazz = ObjectUtil.loadClass(this.mapClass); 
	 * Constructor <?> constructor = clazz.getConstructor(new Class []{DataSource.class, String.class});
	 * Object [] params = new Object []{getDataSource(), getUsersByUsernameQuery()}; 
	 * this.usersByUsernameMapping = (EgovUsersByUsernameMapping) constructor.newInstance(params);
	 * </pre>
	 * 
	 * @param className
	 * @return
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	public static Object instantiate (	String className,
										String[] types,
										Object[] values) throws ClassNotFoundException, InstantiationException, IllegalAccessException, Exception {
		Class<?> clazz;
		Class<?>[] classParams = new Class[values.length];
		Object[] objectParams = new Object[values.length];

		try {
			clazz = loadClass(className);

			for (int i = 0; i < values.length; i++) {
				classParams[i] = loadClass(types[i]);
				objectParams[i] = values[i];
			}

			Constructor<?> constructor = clazz.getConstructor(classParams);
			return constructor.newInstance(values);

		}
		catch (ClassNotFoundException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is can not instantialized.");
			throw new ClassNotFoundException();
		}
		catch (InstantiationException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is can not instantialized.");
			throw new InstantiationException();
		}
		catch (IllegalAccessException e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is not accessed.");
			throw new IllegalAccessException();
		}
		catch (Exception e) {
			if (log.isErrorEnabled()) log.error(className + " : Class is not accessed.");
			throw new Exception(e);
		}
	}

	/**
	 * 객체가 Null 인지 확인한다.
	 * 
	 * @param object
	 * @return Null인경우 true / Null이 아닌경우 false
	 */
	public static boolean isNull (Object object) {
		return ((object == null) || object.equals(null));
	}

	/**
	 * <PRE>
	 * 기  능	: 필드명으로 Getter함수명 생성
	 * 기능명	: getGetterName
	 * 설  명	: 
	 * 변경이력	: 
	 * 2015. 7. 19.	[PUDDING] - 최초작성
	 * </PRE>
	 * 
	 * @param fieldName
	 * @return
	 */
	public static String getGetterName (String fieldName) {
		if (!StringUtil.isNull(fieldName)) {
			if (fieldName.length() > 1) {
				return "get" + ("" + fieldName.charAt(0)).toUpperCase() + fieldName.substring(1);
			}
			else {
				return "get" + ("" + fieldName.charAt(0)).toUpperCase();
			}
		}

		return "";
	}

	public static Method getGetterMethod (Class<?> clazz, String fieldName) {
		try {
			return clazz.getMethod(getGetterName(fieldName));
		}
		catch (NoSuchMethodException ex) {
			log.error(ex.getMessage(), ex);
		}

		return null;
	}

	/**
	 * <PRE>
	 * 기  능	: 주어진 객체 복사본을 생성한다.
	 * 기능명	: copyOf
	 * 설  명	: 
	 * 변경이력	: 
	 * 2015. 7. 19.	[PUDDING] - 최초작성
	 * </PRE>
	 * 
	 * @param from
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NoSuchMethodException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
/*	
	public static <T> T copyOf (T from) throws InstantiationException, IllegalAccessException, NoSuchMethodException, IllegalArgumentException, InvocationTargetException {
		if (null == from) return null;

		Class<T> clazz = (Class<T>) from.getClass();
		T newObject = clazz.newInstance();
		if (null == newObject) return null;

		Method[] methods = clazz.getDeclaredMethods();
		if (null != methods) {
			for (int i = 0; i < methods.length; i++) {
				Method getterMethod = methods[i];
				final String name = getterMethod.getName();

				if (name.startsWith("get")) {
					String setter = "set" + name.substring(name.indexOf("get") + "get".length());
					Method setterMethod = clazz.getMethod(setter, getterMethod.getReturnType());
					setterMethod.invoke(newObject, getterMethod.invoke(from, null));
				}
			}
		}
		return newObject;
	}
*/
	public static Map<String, Object> convertObjToMap (Object obj) {
		try {
			Field[] fields = obj.getClass().getDeclaredFields();
			Map<String, Object> resultMap = new HashMap<String, Object>();
			for (int i = 0; i < fields.length; i++) {
				fields[i].setAccessible(true);
				resultMap.put(fields[i].getName(), fields[i].get(obj));
			}
			return resultMap;
		}
		catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static Object convertMapToObj (Map<String, Object> map, Object obj) {
		String keyAttr = null;
		String setFunc = null;
		Iterator<String> itr = map.keySet().iterator();
		while (itr.hasNext()) {
			keyAttr = (String) itr.next();
			setFunc = "set" + keyAttr.substring(0, 1).toUpperCase() + keyAttr.substring(1);
			try {
				Method[] methods = obj.getClass().getDeclaredMethods();
				for (int i = 0; i < methods.length; i++) {
					if (setFunc.equals(methods[i].getName())) {
//						System.out.println("invoke : " + setFunc);
						methods[i].invoke(obj, map.get(keyAttr));
					}
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}

		return obj;
	}

}
