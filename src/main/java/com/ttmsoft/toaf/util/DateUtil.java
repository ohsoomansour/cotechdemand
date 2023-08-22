/*
 * Copyright 2008-2009 MOPAS(Ministry of Public Administration and Security).
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by
 * applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
 * OF ANY KIND, either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */
package com.ttmsoft.toaf.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
 * 
 * 기  능	: 날짜를 처리하는 유틸 클래스
 * 파일명	: DateUtil.java
 * 패키지	: ttmsoft.toaf.util
 * 설  명	: 전자정부프레임웍 참조
 * 변경이력	:
 * 2020.03.03	[PUDDING] - 최초작성
 *
 */
public class DateUtil {

	//private static final Log log = LogFactory.getLog(DateUtil.class);
	private static final Locale DEFAULT_LOCALE	= Locale.KOREA;

	protected DateUtil () {
	}


	/**
	 * Calendar 객체를 얻기
	 * 
	 * DateUtil.getCalendar(2004, 10, 30); // "20041101"
	 * 
	 * @param pyear - 년도
	 * @param pmon - 월
	 * @param pday - 일
	 * @return Calendar
	 */
	public static Calendar getCalendar (int pyear, int pmon, int pday) {
		return new GregorianCalendar(pyear, pmon-1, pday);
	}

	/**
	 * 해당 문자열이 "yyyyMMdd" 형식에 합당한지 여부를 판단하여 합당하면 Calendar 객체를 리턴한다.
	 * 
	 * DateUtil.getCalendar("20041101");
	 *
	 * @param src - 대상 문자열
	 * @return "yyyyMMdd" 형식에 맞는 Calendar 객체를 리턴한다.
	 */
	public static Calendar getCalendar (String src) {
		return getCalendar(src, formatStr(src));
	}

	/**
	 * 해당 문자열이 주어진 일자 형식을 준수하는지 여부를 검사한다.
	 * 
	 * DateUtil.getCalendar("20041101", "yyyyMMdd");
	 * 
	 * @param src - 날짜 문자열
	 * @param fmt - Date 형식의 표현 (yyyyMMddHHmmssSSS)
	 * @return 형식에 합당하는 경우 Calendar 객체를 리턴한다.
	 */
	public static Calendar getCalendar (String src, String fmt) {
		if (src == null || fmt == null) return null;
		SimpleDateFormat sdf = new SimpleDateFormat(fmt, DEFAULT_LOCALE);
		Date date;
		try {
			date = sdf.parse(src);
		}
		catch (ParseException e) {
//			e.printStackTrace();
			return null;
		}
		if (!sdf.format(date).equals(src)) return null;
		Calendar cd = Calendar.getInstance();
		cd.setTime(date);
		return cd;
	}

	/**
	 * 해당 문자열이 "yyyyMMdd" 형식에 합당한지 여부를 판단하여 합당하면 Date 객체를 리턴한다.
	 * 
	 * DateUtil.getDate("20041101");
	 * 
	 * @param src - 대상 문자열
	 * @return "yyyyMMdd" 형식에 맞는 Date 객체를 리턴한다.
	 */
	public static Date getDate (String src) {
		return getDate(src, formatStr(src));
	}

	/**
	 * 해당 문자열이 주어진 일자 형식을 준수하는지 여부를 검사한다.
	 * 
	 * DateUtil.getDate("20041101", "yyyyMMdd");
	 * 
	 * @param src - 날짜 문자열
	 * @param fmt - Date 형식의 표현 (yyyyMMddHHmmssSSS)
	 * @return 형식에 합당하는 경우 Date 객체를 리턴한다.
	 */
	public static Date getDate (String src, String fmt) {
		if (src == null || fmt == null) return null;
		SimpleDateFormat sdf = new SimpleDateFormat(fmt, DEFAULT_LOCALE);
		Date date;
		try {
			date = sdf.parse(src);
		}
		catch (ParseException e) {
//			e.printStackTrace();
			return null;
		}
		if (!sdf.format(date).equals(src)) return null;
		return date;
	}

	/**
	 * DATE 문자열을 이용한 format string을 생성
	 * @param day - Date 문자열
	 * @return Java.text.DateFormat 부분의 정규 표현 문자열
	 */
	public static String formatStr (String day) {
		String fmt = null;
		if (day.length() == 4) fmt = "yyyy";
		else if (day.length() == 6) fmt = "HHmmss";
		else if (day.length() == 8) fmt = "yyyyMMdd";
		else if (day.length() == 10) fmt = "yyyyMMddHH";
		else if (day.length() == 12) fmt = "yyyyMMddHHmm";
		else if (day.length() == 14) fmt = "yyyyMMddHHmmss";
		else if (day.length() == 17) fmt = "yyyyMMddHHmmssSSS";

		return fmt;
	}

	/**
	 * Date에 대한 날짜 format 문자열 생성
	 * 
	 * DateUtil.format(new Date(), "yyyyMMddHHmmssSSS")
	 *
	 * @param pdate
	 * @param fmt
	 * @return
	 */
	public static String format (Date pdate, String fmt) {
		SimpleDateFormat sdf = new SimpleDateFormat(fmt, DEFAULT_LOCALE);
		return sdf.format(pdate);
	}

	/**
	 * Calendar에 대한 날짜 format 문자열 생성
	 * 
	 * DateUtil.format(new GregorianCalendar(DEFAULT_LOCALE), "yyyyMMddHHmmssSSS")
	 * 
	 * @param pdate
	 * @param fmt
	 * @return
	 */
	public static String format (Calendar pdate, String fmt) {
		SimpleDateFormat sdf = new SimpleDateFormat(fmt, DEFAULT_LOCALE);
		return sdf.format(pdate.getTime());
	}

	/**
	 * 특정 날짜를 인자로 받아 그 일자로부터 주어진 기간만큼 추가한 날을 계산하여 문자열로 리턴한다.
	 *
	 * DateUtil.add("20041030", 2, "d", ""); // "20041101"
	 * DateUtil.add("20041030", -2, "d", "-"); // "2004-10-28"
	 *
	 * @param pdate - 날짜
	 * @param term - 변경기간
	 * @param opt - 구분 ("d":일, "m":월, "y":년)
	 * @param sep - 구분자
	 * @return "년+월+일"
	 */
	public static String add (String pdate, int term, String opt, String sep) {
		Calendar cd = getCalendar(pdate);

		if ("d".equalsIgnoreCase(opt)) cd.add(Calendar.DATE, term);
		else if ("m".equalsIgnoreCase(opt)) cd.add(Calendar.MONTH, term);
		else if ("y".equalsIgnoreCase(opt)) cd.add(Calendar.YEAR, term);

		return YYYY(cd) + sep + MM(cd) + sep + DD(cd);
	}

	/**
	 * 특정 날짜를 인자로 받아 그 일자로부터 주어진 기간만큼 추가한 날을 계산하여 문자열로 리턴한다.
	 *
	 * DateUtil.add(2004, 10, 30, 2, "d", ""); // "20041101"
	 * DateUtil.add(2004, 10, 30, -2, "d", "-"); // "2004-10-28"
	 *
	 * @param pyear - 년도
	 * @param pmon - 월
	 * @param pday - 일
	 * @param term - 변경기간
	 * @param opt - 구분 ("d":일, "m":월, "y":년)
	 * @param sep - 구분자
	 * @return "년+월+일"
	 */
	public static String add (int pyear, int pmon, int pday, int term, String opt, String sep) {
		Calendar cd = new GregorianCalendar(pyear, pmon-1, pday);

		if ("d".equalsIgnoreCase(opt)) cd.add(Calendar.DATE, term);
		else if ("m".equalsIgnoreCase(opt)) cd.add(Calendar.MONTH, term);
		else if ("y".equalsIgnoreCase(opt)) cd.add(Calendar.YEAR, term);

		return YYYY(cd) + sep + MM(cd) + sep + DD(cd);
	}

	/**
	 * 특정 날짜를 인자로 받아 그 일자로부터 주어진 기간만큼 추가한 날을 계산하여 문자열로 리턴한다.
	 *
	 * DateUtil.add("2004", "10", "30", 2, "d", ""); // "20041101"
	 * DateUtil.add("2004", "10", "30", -2, "d", "-"); // "2004-10-28"
	 * 
	 * @param pyear - 년도
	 * @param pmon - 월
	 * @param pday - 일
	 * @param term - 변경기간
	 * @param opt - 구분 ("d":일, "m":월, "y":년)
	 * @param sep - 구분자
	 * @return "년+월+일"
	 */
	public static String add (String pyear, String pmon, String pday, int term, String opt, String sep) {
		return add(Integer.parseInt(pyear), Integer.parseInt(pmon)-1, Integer.parseInt(pday), term, opt, sep);
	}

	/**
	 * 해당 년의 특정월의 일자를 구한다.
	 * @param pyear - 년도4자리
	 * @param pmon - 월 1자리 또는 2자리
	 * @return 특정월의 일자
	 */
	public static int daysMonth (int pyear, int pmon) {
		int[] yearmon = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; // 평년
		int[] leapmon = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; // 윤년
		if ((pyear % 4) == 0) {
			if ((pyear % 100) == 0 && (pyear % 400) != 0) { return yearmon[pmon - 1]; }
			return leapmon[pmon - 1];
		}
		else {
			return yearmon[pmon - 1];
		}
	}

	/**
	 * 8자리로된(yyyyMMdd) 시작일자와 종료일자 사이의 일수를 구함.
	 * @param sday - 8자리로된(yyyyMMdd)시작일자
	 * @param eday - 8자리로된(yyyyMMdd)종료일자
	 * @return 날짜 형식이 맞고, 존재하는 날짜일 때 2개 일자 사이의 일수 리턴
	 */
	public static int dateDiff (String sday, String eday) {
		return dateDiff(sday, eday, "yyyyMMdd");
	}

	/**
	 * 정해진 일자 형식을 기반으로 시작일자와 종료일자 사이의 일자를 구한다.
	 * @param sday - 시작 일자
	 * @param eday - 종료 일자
	 * @param fmt - 날짜 포맷
	 * @return 날짜 형식이 맞고, 존재하는 날짜일 때 2개 일자 사이의 일수를 리턴
	 * @see #timeDiff(String, String, String)
	 */
	public static int dateDiff (String sday, String eday, String fmt) {
		long duration = timeDiff(sday, eday, fmt);
		return (int) (duration / (1000 * 60 * 60 * 24));
	}

	/**
	 * <code>yyyyMMddHHmmssSSS</code>Format 기반으로 시작일자시간, 끝일자시간 사이의 밀리초를 구한다.
	 * 
	 * DateUtil.timeDiff("20170310110000000", "20170310110000005");
	 * 
	 * @param stime - 시작일자시간
	 * @param etime - 종료일자시간
	 * @return 두 일자 간의 차의 밀리초(long)값
	 * @see #formatStr(String)
	 */
	public static long timeDiff (String stime, String etime) {
		String fmt = formatStr(stime);
		return timeDiff(stime, etime, fmt);
	}

	/**
	 * 정해진 일자형식을 기반으로 시작일자와 종료일자 사이의 밀리초를 구한다.
	 * 
	 * DateUtil.timeDiff("20170310110000000", "20170310110000005", "yyyyMMddHHmmssSSS");
	 * 
	 * @param stime - 시작일자시간
	 * @param etime - 종료일자시간
	 * @param fmt - 날짜 포맷
	 * @return 두 일자 간의 차의 밀리초(long)값
	 * @see #formatStr(String)
	 */
	public static long timeDiff (String stime, String etime, String fmt) {
		Date d1 = getDate(stime, fmt);
		Date d2 = getDate(etime, fmt);
		long duration = d2.getTime() - d1.getTime();
		return duration;
	}

	/**
	 * 시작일자와 종료일자 사이의 해당 요일이 몇번 있는지 계산한다.
	 *
	 * @param sday - 시작 일자
	 * @param eday - 종료 일자
	 * @param yoil - 요일
	 * @return 날짜 형식이 맞고, 존재하는 날짜일 때 2개 일자 사이의 일자 리턴
	 */
	public static int weekDiff (String sday, String eday, String yoil) {
		int first = 0; // sday 날짜로 부터 며칠 후에 해당 요일인지에 대한
		int count = 0; // 해당 요일이 반복된 횟수
		String[] weekarr = { "일", "월", "화", "수", "목", "금", "토" };

		int days = dateDiff(sday, eday);	// 두 일자 사이의 날 수
		Calendar cd = getCalendar(sday);	// 첫번째 일자에 대한 요일
		int widx = cd.get(Calendar.DAY_OF_WEEK);

		yoil = yoil.substring(0, 1);
		while (!weekarr[(widx-1) % 7].equals(yoil)) {
			widx += 1; first++;
		}

		if ((days - first) < 0) return 0;
		else count++;
		
		count += (days - first) / 7;

		return count;
	}

	/**
	 * 주민번호로 기준일기준 만나이를 구한다.
	 * 
	 * DateUtil.getFullAge("7701011", "20041021"); // 27
	 * 
	 * @param sno - 주민번호 7자리
	 * @param pday - 기준일자 8자리
	 * @return 만 나이
	 */
	public static int age (String sno, String pday) {
		String birth = null;
		// 주민번호 7번째 자리가 0 또는 9 라면 1800년도 출생이다.
		if ("0".equals(sno.substring(6, 7)) || "9".equals(sno.substring(6, 7))) birth = "18" + sno.substring(0, 6);
		// 주민번호 7번째 자리가 1 또는 2 라면 1900년도 출생이다.
		else if ("1".equals(sno.substring(6, 7)) || "2".equals(sno.substring(6, 7))) birth = "19" + sno.substring(0, 6);
		// 주민번호 7번째 자리가 3 또는 4 라면 2000년도 출생이다.
		else if ("3".equals(sno.substring(6, 7)) || "4".equals(sno.substring(6, 7))) birth = "20" + sno.substring(0, 6);

		// 생일이 안지났을때 기준일자 년에서 생일년을 빼고 1년을 더뺀다.
		if (Integer.parseInt(pday.substring(4, 8)) < Integer.parseInt(birth.substring(4, 8))) {
			return Integer.parseInt(pday.substring(0, 4)) - Integer.parseInt(birth.substring(0, 4)) - 1;
		}
		else {	// 생일이 지났을때 기준일자 년에서 생일년을 뺀다.
			return Integer.parseInt(pday.substring(0, 4)) - Integer.parseInt(birth.substring(0, 4));
		}
	}

	/**
	 * 주민번호로 현재 만나이를 구한다.
	 * @param sno - 주민번호 6자리
	 * @return 만 나이
	 */
	public static int age (String sno) {
		return age(sno, YYYY() + MM() + DD());
	}

	/**
	 * 현재 연도값을 리턴
	 * @return 년(年)
	 */
	public static int yyyy () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.YEAR);
	}

	/**
	 * 현재 월을 리턴
	 * @return 월(月)
	 */
	public static int mm () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.MONTH) + 1;
	}

	/**
	 * 현재 일을 리턴
	 * @return 일(日)
	 */
	public static int dd () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 현재 시간을 리턴
	 * @return 시(時)
	 */
	public static int hh () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.HOUR_OF_DAY);
	}

	/**
	 * 현재 분을 리턴
	 * @return 분(分)
	 */
	public static int mi () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.MINUTE);
	}

	/**
	 * 현재 초를 리턴
	 * @return 초
	 */
	public static int ss () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.SECOND);
	}

	/**
	 * 현재 밀리초를 리턴
	 * @return 밀리초
	 */
	public static int ff3 () {
		return (new GregorianCalendar(DEFAULT_LOCALE)).get(Calendar.MILLISECOND);
	}

	/**
	 * 현재 년도를 YYYY 형태로 리턴
	 * @return 년도(YYYY)
	 */
	public static String YYYY () {
		return YYYY(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 월을 MM 형태로 리턴
	 * @return 월(MM)
	 */
	public static String MM () {
		return MM(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 일을 DD 형태로 리턴
	 * @return 일(DD)
	 */
	public static String DD () {
		return DD(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 시간을 HH24 형태로 리턴
	 * @return 시간(HH24)
	 */
	public static String HH () {
		return HH(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 분을 MI 형태로 리턴
	 * @return 분(MI)
	 */
	public static String MI () {
		return MI(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 초를 SS 형태로 리턴
	 * @return 초(SS)
	 */
	public static String SS () {
		return SS(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 밀리초를 FF3 형태로 리턴
	 * @return 밀리초(FF3)
	 */
	public static String FF3 () {
		return FF3(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 요일 DY 형태로 리턴
	 * @return 요일(DY)
	 */
	public static String DY () {
		return DY(new GregorianCalendar(DEFAULT_LOCALE));
	}

	/**
	 * 현재 날짜를 년월일을 합쳐서 String으로 리턴하는 메소드
	 * @return 년+월+일 값 (YYYYMMDD)
	 */
	public static String sdate () {
		Calendar cd = new GregorianCalendar(DEFAULT_LOCALE);
		return YYYY(cd) + MM(cd) + DD(cd);
	}

	/**
	 * 현재 시간을 시분초를 합쳐서 String으로 리턴하는 메소드
	 * @return 시+분+초 값 (HH24MISS)
	 */
	public static String stime () {
		Calendar cd = new GregorianCalendar(DEFAULT_LOCALE);
		return HH(cd) + MI(cd) + SS(cd);
	}

	/**
	 * 현재 날짜와 시간을 년월일시분초를 합쳐서 String으로 리턴하는 메소드
	 * @return 년+월+일+시+분+초 값 (YYYYMMDDHH24MISS)
	 */
	public static String sdatetime () {
		Calendar cd = new GregorianCalendar(DEFAULT_LOCALE);
		return YYYY(cd) + MM(cd) + DD(cd) + HH(cd) + MI(cd) + SS(cd);
	}

	/**
	 * 해당 년,월,일을 받아 요일을 리턴하는 메소드
	 * @param pyear - 년도
	 * @param pmon - 월
	 * @param pday - 일
	 * @return 요일(한글)
	 */
	public static String sweek (String pyear, String pmon, String pday) {
		SimpleDateFormat sdf = new SimpleDateFormat("EEE", DEFAULT_LOCALE); // "EEE"
		Date tm = (new GregorianCalendar(Integer.parseInt(pyear), Integer.parseInt(pmon)-1, Integer.parseInt(pday))).getTime();
		return sdf.format(tm);
	}

	/**
	 * 년도 문자열
	 * @param cd - Calendar
	 * @return 년도 (YYYY)
	 */
	public static String YYYY (Calendar cd) {	// 년도
		return String.format("%04d", cd.get(Calendar.YEAR));
	}

	/**
	 * 월 문자열
	 * @param cd - Calendar
	 * @return 월 (MM)
	 */
	public static String MM (Calendar cd) {	// 월
		return String.format("%02d", cd.get(Calendar.MONTH) + 1);
	}

	/**
	 * 일 문자열
	 * @param cd - Calendar
	 * @return 일 (DD)
	 */
	public static String DD (Calendar cd) {	// 일
		return String.format("%02d", cd.get(Calendar.DAY_OF_MONTH));
	}

	/**
	 * 시 문자열
	 * @param cd - Calendar
	 * @return 시 (HH)
	 */
	public static String HH (Calendar cd) {	// 시
		return String.format("%02d", cd.get(Calendar.HOUR_OF_DAY));
	}

	/**
	 * 분 문자열
	 * @param cd - Calendar
	 * @return 분 (MI)
	 */
	public static String MI (Calendar cd) {	// 분
		return String.format("%02d", cd.get(Calendar.MINUTE));
	}

	/**
	 * 초 문자열
	 * @param cd - Calendar
	 * @return 초 (SS)
	 */
	public static String SS (Calendar cd) {	// 초
		return String.format("%02d", cd.get(Calendar.SECOND));
	}

	/**
	 * 밀리초 문자열
	 * @param cd - Calendar
	 * @return 밀리초 (FF3)
	 */
	public static String FF3 (Calendar cd) {	// 밀리초
		return String.format("%03d", cd.get(Calendar.MILLISECOND));
	}

	/**
	 * 요일 문자열
	 * @param cd - Calendar
	 * @return 요일 (DY)
	 */
	public static String DY (Calendar cd) {	// 요일
		SimpleDateFormat sdf = new SimpleDateFormat("EEE", DEFAULT_LOCALE); // "EEE"
		return sdf.format(cd.getTime());
	}

	/**
	 * Date -> String
	 *
	 * @param date - Date which you want to change.
	 * @return String The Date string. Type, yyyy-MM-dd HH:mm:ss.
	 */
	public static String toString (Date date, String fmt, Locale locale) {
		if (StringUtil.isNull(fmt)) {
			fmt = "yyyy-MM-dd HH:mm:ss";
		}

		if (ObjectUtil.isNull(locale)) {
			locale = DEFAULT_LOCALE;
		}

		SimpleDateFormat sdf = new SimpleDateFormat(fmt, locale);

		String tmp = sdf.format(date);

		return tmp;
	}
}
