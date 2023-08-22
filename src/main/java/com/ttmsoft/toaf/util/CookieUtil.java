package com.ttmsoft.toaf.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CookieUtil {
//	private static String	cookieDomain	= ".do.co.kr";

	public CookieUtil () {}

	public static String getCookieByName (HttpServletRequest request, String name) throws UnsupportedEncodingException {
		Cookie info = null;
		Cookie cookies[] = request.getCookies();

		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				info = cookies[i];
				if (name.equals(info.getName())) return URLDecoder.decode(info.getValue(), "UTF-8");
			}
		}

		return "";
	}

	public static void setCookieByName (HttpServletResponse response, String name, String value) throws UnsupportedEncodingException {
		String str = URLEncoder.encode(value, "UTF-8");
		Cookie cookie = new Cookie(name, str);
		cookie.setMaxAge(-1);
		// cookie.setDomain(cookieDomain);
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	public static void delCookies (HttpServletRequest request, HttpServletResponse response) {
		if (request.getCookies() != null) {
			Cookie cookiess[] = request.getCookies();
			for (int i = 0; i < cookiess.length; i++) {
				Cookie thisCookie = cookiess[i];
				// thisCookie.setDomain(cookieDomain);
				thisCookie.setPath("/");
				thisCookie.setMaxAge(0);
				response.addCookie(thisCookie);
			}
		}
	}

	public static void setCookieByExam (HttpServletResponse response, String name, String value, String path, String cookieDomain, int time) throws UnsupportedEncodingException {
		String str = URLEncoder.encode(value, "UTF-8");
		Cookie cookie = new Cookie(name, str);
		cookie.setMaxAge(time);
		cookie.setDomain(cookieDomain);
		cookie.setPath(path);
		response.addCookie(cookie);
	}

	public static void setCookieByExam (HttpServletResponse response, String name, String value, int time) throws UnsupportedEncodingException {
		String str = URLEncoder.encode(value, "UTF-8");
		Cookie cookie = new Cookie(name, str);
		cookie.setMaxAge(time);
		response.addCookie(cookie);

	}

}
